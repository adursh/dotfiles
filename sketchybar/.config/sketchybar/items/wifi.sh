#!/bin/bash
sketchybar --add item wifi right \
  --set wifi \
    update_freq=10 \
    icon.drawing=on \
    icon.font="SF Pro Text:Regular:16.0" \
    icon.color=$TEXT \
    label.drawing=off \
    background.drawing=off \
    script="$PLUGIN_DIR/wifi.sh" \
  --subscribe wifi wifi_change system_woke
