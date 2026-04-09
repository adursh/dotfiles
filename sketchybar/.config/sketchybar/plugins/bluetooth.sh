#!/bin/bash

#check for blueutil
if ! command -v blueutil &>/dev/null; then
  sketchybar --set bluetooth icon="󰂯"
  exit 0
fi

STATE=$(blueutil --power)
CONNECTED=$(blueutil --connected | wc -l | tr -d ' ')

if [ "$STATE" = "0" ]; then
  ICON="󰂲"
elif [ "$CONNECTED" -gt "0" ]; then
  ICON="󰂱"
else
  ICON="󰂯"
fi

sketchybar --set bluetooth icon="$ICON"
