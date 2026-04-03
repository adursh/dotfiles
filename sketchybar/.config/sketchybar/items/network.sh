#!/bin/bash
sketchybar --add item network_speed right \
  --set network_speed \
    update_freq=5 \
    label.font="SF Pro:Italic:13.0" \
    label.color=0xff7f849c \
    script="$PLUGIN_DIR/network_speed.sh"
