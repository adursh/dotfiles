#!/bin/bash
source "$CONFIG_DIR/colors.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

[ -z "$PERCENTAGE" ] && exit 0

case ${PERCENTAGE} in
  9[0-9]|100) ICON="􀛨"; COLOR=0xffa6e3a1 ;;
  [6-8][0-9])  ICON="􀺸"; COLOR=$TEXT ;;
  [3-5][0-9])  ICON="􀺶"; COLOR=$TEXT ;;
  [1-2][0-9])  ICON="􀛩"; COLOR=0xfffab387 ;;
  *)            ICON="􀛪"; COLOR=0xfff38ba8 ;;
esac

[ -n "$CHARGING" ] && ICON="􀢋" && COLOR=0xffa6e3a1

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"
