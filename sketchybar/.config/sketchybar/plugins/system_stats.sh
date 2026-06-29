#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

# Icons: normal → white, moderate → peach, critical → red
color_for_usage() {
  local val="${1%%%}"
  if [ "$val" -ge 80 ]; then echo "$RED"
  elif [ "$val" -ge 50 ]; then echo "$PEACH"
  else echo "$TEXT"
  fi
}

# CPU: normal chip, warning chip when high
cpu_icon() {
  local val="${1%%%}"
  if [ "$val" -ge 80 ]; then echo "􀧓"
  else echo "􀫥"
  fi
}

# RAM: normal memory, warning when high
ram_icon() {
  local val="${1%%%}"
  if [ "$val" -ge 80 ]; then echo "􀫧"
  else echo "􀫦"
  fi
}

# Disk: normal drive, warning when full
disk_icon() {
  local val="${1%%%}"
  if [ "$val" -ge 80 ]; then echo "􀤃"
  else echo "􀤂"
  fi
}

case "$NAME" in
  cpu)
    [ -z "$CPU_USAGE" ] && exit 0
    COLOR=$(color_for_usage "$CPU_USAGE")
    ICON=$(cpu_icon "$CPU_USAGE")
    sketchybar --set cpu icon="$ICON" icon.color="$COLOR" label="$CPU_USAGE" label.color="$COLOR"
    ;;
  ram)
    [ -z "$RAM_USAGE" ] && exit 0
    COLOR=$(color_for_usage "$RAM_USAGE")
    ICON=$(ram_icon "$RAM_USAGE")
    sketchybar --set ram icon="$ICON" icon.color="$COLOR" label="$RAM_USAGE" label.color="$COLOR"
    ;;
  disk)
    [ -z "$DISK_USAGE" ] && exit 0
    COLOR=$(color_for_usage "$DISK_USAGE")
    ICON=$(disk_icon "$DISK_USAGE")
    sketchybar --set disk icon="$ICON" icon.color="$COLOR" label="$DISK_USAGE" label.color="$COLOR"
    ;;
esac
