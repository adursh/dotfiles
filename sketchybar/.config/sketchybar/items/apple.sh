#!/bin/bash
sketchybar --add item apple left \
  --set apple \
    icon="$(printf '\xef\xa3\xbf')" \
    icon.font="SF Pro:Bold:20.0" \
    icon.color=0xffcdd6f4 \
    icon.padding_left=6 \
    icon.padding_right=10 \
    label.drawing=off \
    background.drawing=off \
    click_script="open -a 'System Preferences'"
