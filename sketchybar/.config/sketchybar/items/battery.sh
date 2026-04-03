#!/bin/bash
sketchybar --add item battery right \
  --set battery \
    update_freq=60 \
    icon.drawing=on \
    icon.font="SF Pro Text:Regular:16.0" \
    icon.color=$TEXT \
    label.drawing=off \
    background.drawing=off \
    script="$PLUGIN_DIR/battery.sh" \
  --subscribe battery system_woke power_source_change
