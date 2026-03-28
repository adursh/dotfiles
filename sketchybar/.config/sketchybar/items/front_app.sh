#!/bin/bash
sketchybar --add item front_app left\
  --set front_app\
    label.font=".AppleSystemUIFont:Semibold:14.0"\
    label.color=0xffcdd6f4\
    padding_left=12\
    padding_right=4\
    background.drawing=off\
    script="$PLUGIN_DIR/front_app.sh"\
  --subscribe front_app front_app_switched
