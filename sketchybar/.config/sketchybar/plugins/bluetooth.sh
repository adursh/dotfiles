#!/bin/bash
BT=$(system_profiler SPBluetoothDataType 2>/dev/null | grep "State:" | awk '{print $2}')

if [ "$BT" = "On" ]; then
  ICON="󰂯"
else
  ICON="󰂲"
fi

sketchybar --set bluetooth icon="$ICON"
