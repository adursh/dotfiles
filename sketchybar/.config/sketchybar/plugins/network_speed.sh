#!/bin/bash
# Network speed monitor — pure shell, no Python/psutil dependency
# Uses netstat -ib to read cumulative byte counters, delta over 1 second

# Determine active interface from default route
IFACE=$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')
[ -z "$IFACE" ] && IFACE="en0"

# Read cumulative bytes for the interface (Link# row only)
sample() {
  netstat -ib -n -I "$IFACE" 2>/dev/null | awk '/Link#/{print $7, $10}'
}

read -r rx1 tx1 <<< "$(sample)"

# No data = interface doesn't exist or has no link-layer entry
if [ -z "$rx1" ] || [ -z "$tx1" ]; then
  sketchybar --set network_speed label="--"
  exit 0
fi

sleep 1

read -r rx2 tx2 <<< "$(sample)"

if [ -z "$rx2" ] || [ -z "$tx2" ]; then
  sketchybar --set network_speed label="--"
  exit 0
fi

# Calculate bytes/sec
rx_bps=$(( rx2 - rx1 ))
tx_bps=$(( tx2 - tx1 ))

# Handle counter wrap or negative values (interface changed mid-sample)
[ "$rx_bps" -lt 0 ] && rx_bps=0
[ "$tx_bps" -lt 0 ] && tx_bps=0

# Format: KB/s or MB/s
fmt() {
  local bytes=$1
  local kb=$(( bytes / 1024 ))
  if [ "$kb" -ge 1024 ]; then
    # MB/s — use awk for decimal
    awk "BEGIN { printf \"%.1fMB/s\", $kb/1024 }"
  elif [ "$kb" -ge 1 ]; then
    printf "%dKB/s" "$kb"
  else
    printf "%s" "--"
  fi
}

DL=$(fmt $rx_bps)
UL=$(fmt $tx_bps)

sketchybar --set network_speed "label=↓ ${DL}  ↑ ${UL}"
