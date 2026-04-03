#!/bin/bash
WIFI=$(networksetup -getairportnetwork en0 2>/dev/null)

if echo "$WIFI" | grep -q "You are not associated"; then
  ICON="󰤭"  # disconnected
else
  ICON="󰤨"  # connected
fi

sketchybar --set wifi icon="$ICON"
