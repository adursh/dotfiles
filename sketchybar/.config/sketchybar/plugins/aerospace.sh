#!/bin/bash

SID="$1"

if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    drawing=on \
    label.color=0xffffffff \
    label.font="SF Pro Text:Semibold:14.0" \
    background.drawing=off
else
  OCCUPIED=$(aerospace list-windows --all --format %{workspace} 2>/dev/null | sort -un)
  if echo "$OCCUPIED" | grep -qw "$SID"; then
    sketchybar --set "$NAME" \
      drawing=on \
      label.color=0xff7f849c \
      label.font="SF Pro Text:Medium:14.0" \
      background.drawing=off
  else
    sketchybar --set "$NAME" drawing=off
  fi
fi
