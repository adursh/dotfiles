#!/bin/bash

OCCUPIED=$(aerospace list-windows --all --format %{workspace} 2>/dev/null | sort -un)
TARGET=$(printf "1\n%s\n%s\n" "$OCCUPIED" "$FOCUSED_WORKSPACE" | sort -un)

for sid in 1 2 3 4 5 6 7 8 9 10; do
  if echo "$TARGET" | grep -qw "$sid"; then
    if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
      sketchybar --animate tanh 15 --set "space.$sid" \
        drawing=on \
        label.color=0xffffffff \
        label.font="SF Pro Text:Bold:15.0" \
        background.drawing=off
    else
      sketchybar --animate tanh 15 --set "space.$sid" \
        drawing=on \
        label.color=0xff3b3b4f \
        label.font="SF Pro Text:Medium:14.0" \
        background.drawing=off
    fi
  else
    sketchybar --set "space.$sid" drawing=off
  fi
done
