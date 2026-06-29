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

# Temperature color thresholds
color_for_temp() {
  local val="${1%°C}"
  local int_val="${val%.*}"
  if [ "$int_val" -ge 80 ]; then echo "$RED"
  elif [ "$int_val" -ge 60 ]; then echo "$PEACH"
  else echo "$TEXT"
  fi
}

# Temperature icon: low/mid/high thermometer
temp_icon() {
  local val="${1%°C}"
  local int_val="${val%.*}"
  if [ "$int_val" -ge 80 ]; then echo "􀇮"
  elif [ "$int_val" -ge 60 ]; then echo "􀇬"
  else echo "􀇪"
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
  cpu_temp)
    [ -z "$CPU_TEMP" ] && exit 0
    TEMP_VAL="${CPU_TEMP%°C}"
    TEMP_INT="${TEMP_VAL%.*}"
    if [ "$TEMP_INT" -ge 50 ]; then
      COLOR=$(color_for_temp "$CPU_TEMP")
      sketchybar --set cpu_temp label="$CPU_TEMP" label.color="$COLOR" label.drawing=on
    else
      sketchybar --set cpu_temp label.drawing=off
    fi
    ;;
esac
