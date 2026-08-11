#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

CACHE="/tmp/sketchybar_front_app"
LAST=$(cat "$CACHE" 2>/dev/null)

if [ "$LAST" = "$INFO" ]; then
  exit 0
fi
echo "$INFO" > "$CACHE"

sketchybar --animate tanh 4 --set "$NAME" label.color="0x00${TEXT#0xff}" label.y_offset=-6
sleep 0.1
sketchybar --set "$NAME" label="$INFO" label.y_offset=6
sketchybar --animate tanh 4 --set "$NAME" label.color="$TEXT" label.y_offset=0
