#!/bin/bash
SSID=$(ipconfig getsummary en0 2>/dev/null | awk '/SSID/{print $3}')

if [ -n "$SSID" ]; then
  ICON="󰤨"
else
  ICON="󰤭"
fi

sketchybar --set wifi icon="$ICON"
