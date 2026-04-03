#!/bin/bash
# Bulletproof email notification script with full MIME support
# Location: ~/.local/bin/email-notify.sh

MAILDIR="$HOME/.mail/adarsh1016/INBOX/new"
STATE_FILE="$HOME/.cache/email-notify-state"
LOCK_FILE="$HOME/.cache/email-notify.lock"
LOG_FILE="$HOME/.cache/email-notify.log"

# Enable logging (set to false to disable)
ENABLE_LOGGING=true

log() {
    if [[ "$ENABLE_LOGGING" == "true" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    fi
}

# Create cache directory
mkdir -p "$(dirname "$STATE_FILE")"
log "Starting email notification check"

# Get message ID
get_message_id() {
    grep -m 1 "^Message-ID:" "$1" | sed 's/^Message-ID: //' | tr -d '\r\n '
}

# Extract sender name from From header
get_from() {
    local from_line=$(grep -m 1 "^From:" "$1" | sed 's/^From: //' | tr -d '\r')
    
    # Decode RFC2047 encoded headers (=?charset?encoding?data?=)
    if [[ "$from_line" =~ =\?[^?]+\?[BQbq]\?[^?]+\?= ]]; then
        from_line=$(echo "$from_line" | perl -MMIME::Words=decode_mimewords -ne 'print decode_mimewords($_)' 2>/dev/null || echo "$from_line")
    fi
    
    # Extract name from "Name <email>" format
    if [[ "$from_line" =~ ^\"?([^\"]*)\"?[[:space:]]*\<.*\> ]]; then
        echo "${BASH_REMATCH[1]}"
    elif [[ "$from_line" =~ ^([^<]+)[[:space:]]*\<.*\> ]]; then
        echo "${BASH_REMATCH[1]}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
    elif [[ "$from_line" =~ ^([^@]+)@ ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo "$from_line"
    fi
}

# Extract subject and clean it up
get_subject() {
    local subject=$(grep -m 1 "^Subject:" "$1" | sed 's/^Subject: //' | tr -d '\r')
    
    # Decode RFC2047 encoded subjects
    if [[ "$subject" =~ =\?[^?]+\?[BQbq]\?[^?]+\?= ]]; then
        subject=$(echo "$subject" | perl -MMIME::Words=decode_mimewords -ne 'print decode_mimewords($_)' 2>/dev/null || echo "$subject")
    fi
    
    # Clean up reply artifacts from subject line
    # Remove "On ... wrote:" patterns and everything after
    subject=$(echo "$subject" | sed 's/On [A-Z][a-z][a-z],.*//')
    
    # Remove leading/trailing whitespace
    subject=$(echo "$subject" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    echo "$subject"
}

# Decode quoted-printable encoding
decode_qp() {
    python3 -m quopri -d 2>/dev/null || cat
}

# Decode base64 encoding
decode_base64() {
    base64 -d 2>/dev/null || cat
}

# Extract and decode body preview
get_body_preview() {
    local email_file="$1"
    local body=""
    local in_headers=1
    local in_text_part=0
    local boundary=""
    local encoding=""
    local is_multipart=0
    
    # Check if multipart and get boundary
    if grep -q "^Content-Type:.*multipart" "$email_file"; then
        is_multipart=1
        boundary=$(grep -m 1 "boundary=" "$email_file" | sed 's/.*boundary="\?\([^";\r]*\)"\?.*/\1/' | tr -d '\r\n ')
        log "Detected multipart with boundary: $boundary"
    fi
    
    while IFS= read -r line; do
        line=$(echo "$line" | tr -d '\r')
        
        # Check for boundary in multipart messages
        if [[ $is_multipart -eq 1 && -n "$boundary" && "$line" == *"$boundary"* ]]; then
            in_text_part=0
            in_headers=1
            encoding=""
            continue
        fi
        
        # Parse headers within each MIME part
        if [[ $in_headers -eq 1 ]]; then
            # Look for text/plain content
            if [[ "$line" =~ ^Content-Type:.*text/plain ]]; then
                in_text_part=1
                log "Found text/plain part"
            fi
            
            # Skip HTML parts
            if [[ "$line" =~ ^Content-Type:.*text/html ]]; then
                in_text_part=0
            fi
            
            # Get encoding type
            if [[ "$line" =~ ^Content-Transfer-Encoding:[[:space:]]*(.+) ]]; then
                encoding="${BASH_REMATCH[1]}"
                encoding=$(echo "$encoding" | tr -d '\r\n ' | tr '[:upper:]' '[:lower:]')
                log "Detected encoding: $encoding"
            fi
            
            # Empty line marks end of headers
            if [[ -z "$line" ]]; then
                in_headers=0
                continue
            fi
        else
            # We're in the body
            if [[ $in_text_part -eq 1 || $is_multipart -eq 0 ]]; then
                # Skip empty lines and lines that look like headers
                if [[ -n "$line" ]] && \
                   [[ ! "$line" =~ ^[[:space:]]*$ ]] && \
                   [[ ! "$line" =~ ^Content- ]] && \
                   [[ ! "$line" =~ ^MIME- ]] && \
                   [[ ! "$line" =~ ^\-\-.*\-\- ]] && \
                   [[ ! "$line" =~ ^Date: ]] && \
                   [[ ! "$line" =~ ^From: ]] && \
                   [[ ! "$line" =~ ^To: ]]; then
                    
                    body="$body$line "
                    
                    # Stop after collecting enough for preview (80 chars max)
                    if [[ ${#body} -gt 80 ]]; then
                        break
                    fi
                fi
            fi
        fi
    done < "$email_file"
    
    # Decode body based on encoding
    if [[ -n "$body" ]]; then
        case "$encoding" in
            "quoted-printable")
                body=$(echo "$body" | decode_qp)
                log "Decoded quoted-printable body"
                ;;
            "base64")
                body=$(echo "$body" | decode_base64)
                log "Decoded base64 body"
                ;;
        esac
        
        # Clean up: remove HTML tags, extra spaces
        body=$(echo "$body" | sed 's/<[^>]*>//g' | sed 's/&nbsp;/ /g' | sed 's/&[a-z]*;//g')
        body=$(echo "$body" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sed 's/  */ /g')
        
        # Remove email thread markers (>, On ... wrote:, etc.)
        body=$(echo "$body" | grep -v "^>" | grep -v "^On.*wrote:" | head -1)
        
        # Truncate to 80 chars for a single line preview
        if [[ ${#body} -gt 80 ]]; then
            echo "${body:0:80}..."
        elif [[ ${#body} -gt 5 ]]; then
            echo "$body"
        else
            echo ""
        fi
    else
        echo ""
    fi
}

# Acquire lock
exec 200>"$LOCK_FILE"
if ! flock -n 200; then
    log "Another instance running, exiting"
    exit 0
fi
log "Lock acquired"

# Load notified IDs
declare -A notified_ids
if [[ -f "$STATE_FILE" ]]; then
    while IFS= read -r id; do
        [[ -n "$id" ]] && notified_ids["$id"]=1
    done < "$STATE_FILE"
fi
log "Loaded ${#notified_ids[@]} previously notified message IDs"

# Check maildir exists
if [[ ! -d "$MAILDIR" ]]; then
    log "ERROR: Maildir not found: $MAILDIR"
    flock -u 200
    exit 1
fi

# Process new emails
new_count=0
for email_file in "$MAILDIR"/*; do
    [[ -f "$email_file" ]] || continue
    
    msg_id=$(get_message_id "$email_file")
    [[ -z "$msg_id" ]] && continue
    
    # Skip if already notified
    if [[ -n "${notified_ids[$msg_id]}" ]]; then
        continue
    fi
    
    log "Processing new email: $msg_id"
    
    # Extract details
    from=$(get_from "$email_file")
    subject=$(get_subject "$email_file")
    
    log "From: $from | Subject: $subject"
    
    # Send notification (sender + subject only, no body)
    notify-send -a "Gmail" \
        -i "mail-unread-symbolic" \
        -u normal \
        "$from" \
        "$subject" \
        -t 10000
    
    log "Notification sent"
    
    # Mark as notified
    echo "$msg_id" >> "$STATE_FILE"
    notified_ids["$msg_id"]=1
    ((new_count++))
done

log "Processed $new_count new email(s)"

# Cleanup state file
if [[ -f "$STATE_FILE" ]]; then
    line_count=$(wc -l < "$STATE_FILE")
    if [[ $line_count -gt 1000 ]]; then
        log "Cleaning state file ($line_count entries)"
        tail -n 1000 "$STATE_FILE" > "${STATE_FILE}.tmp"
        mv "${STATE_FILE}.tmp" "$STATE_FILE"
    fi
fi

# Release lock
flock -u 200
log "Completed successfully"
exit 0
