#!/bin/bash

#check for blueutil
if ! command -v blueutil &>/dev/null; then
  sketchybar --set bluetooth icon="󰂯"
  exit 0
fi

STATE=$(blueutil --power)
CONNECTED=$(blueutil --connected)

if [ "$STATE" = "0" ]; then
  ICON="󰂲"
elif [ -n "$CONNECTED" ]; then
  ICON="󰂱"
else
  ICON="󰂯"
fi

sketchybar --set bluetooth icon="$ICON"
