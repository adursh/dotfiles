#!/bin/bash

SID="$1"

if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    label.color=0xffcdd6f4
else
  sketchybar --set "$NAME" \
    background.drawing=off \
    label.color=0xff585b70
fi
