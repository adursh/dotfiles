#!/bin/bash
sketchybar --add item bluetooth right \
  --set bluetooth \
    update_freq=30 \
    icon.drawing=on \
    icon.font="SF Pro Text:Regular:16.0" \
    icon.color=$TEXT \
    label.drawing=off \
    background.drawing=off \
    script="$PLUGIN_DIR/bluetooth.sh" \
  --subscribe bluetooth system_woke
