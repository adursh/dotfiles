#!/bin/bash
source "$CONFIG_DIR/colors.sh"

sketchybar --add event aerospace_workspace_change

# pre-add ALL 10 workspaces at startup hidden — order is always preserved this way
for sid in 1 2 3 4 5 6 7 8 9 10; do
  sketchybar --add item "space.$sid" left \
    --subscribe "space.$sid" aerospace_workspace_change \
    --set "space.$sid" \
      drawing=off \
      label="$sid" \
      label.color=0xff7f849c \
      label.font="SF Pro Text:Medium:18.0" \
      background.drawing=off \
      background.color=0xff313244 \
      background.corner_radius=7 \
      background.height=24 \
      background.border_width=1 \
      background.border_color=0xff45475a \
      click_script="aerospace workspace $sid" \
      script="$PLUGIN_DIR/aerospace.sh $sid"
done
