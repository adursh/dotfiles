#!/bin/bash

BATTERY_PATH="/sys/class/power_supply/BAT0"
BATTERY_ICON="$HOME/.config/hypr/icons/battery.png"
STATE_FILE="/tmp/battery_notify_state"

# Function to check if we should notify
should_notify() {
    local level=$1
    local current_state="${CAPACITY}_${STATUS}_${level}"
    
    if [[ -f "$STATE_FILE" ]]; then
        local prev_state=$(cat "$STATE_FILE")
        [[ "$prev_state" != "$current_state" ]] && return 0
    else
        return 0
    fi
    return 1
}

# Function to update state
update_state() {
    local level=$1
    echo "${CAPACITY}_${STATUS}_${level}" > "$STATE_FILE"
}

while true; do
    [[ ! -f "$BATTERY_PATH/capacity" ]] && exit 1
    
    CAPACITY=$(cat "$BATTERY_PATH/capacity")
    STATUS=$(cat "$BATTERY_PATH/status")
    
    # Clear state when charging starts
    if [[ "$STATUS" == "Charging" && -f "$STATE_FILE" ]]; then
        rm "$STATE_FILE"
    fi
    
    # Only check when not charging
    if [[ "$STATUS" != "Charging" ]]; then
        # Critical at exactly 5%
        if [[ $CAPACITY -eq 5 ]] && should_notify "critical"; then
            if [[ -f "$BATTERY_ICON" ]]; then
                notify-send -u critical -t 0 -i "$BATTERY_ICON" "Battery Critical (5%)"
            else
                notify-send -u critical -t 0 "🔋 Battery Critical (5%)"
            fi
            update_state "critical"
            
        # Low battery at exactly 20%
        elif [[ $CAPACITY -eq 20 ]] && should_notify "low"; then
            if [[ -f "$BATTERY_ICON" ]]; then
                notify-send -u normal -t 5000 -i "$BATTERY_ICON" "Low Battery (20%)"
            else
                notify-send -u normal -t 5000 "🔋 Low Battery (20%)"
            fi
            update_state "low"
        fi
    fi
    
    sleep 60
done
