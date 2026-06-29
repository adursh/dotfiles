#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

# Icons: always white, switch to warning variant only at critical
color_for_usage() {
  echo "$TEXT"
}

# CPU: outline normally, filled at critical
cpu_icon() {
  local val="${1%%%}"
  if [ "$val" -ge 80 ]; then echo "􀧓"
  else echo "􀫥"
  fi
}

# RAM: outline normally, filled at critical
ram_icon() {
  local val="${1%%%}"
  if [ "$val" -ge 80 ]; then echo "􀧖"
  else echo "􀫦"
  fi
}

# Disk: outline normally, filled at critical
disk_icon() {
  local val="${1%%%}"
  if [ "$val" -ge 80 ]; then echo "􀨪"
  else echo "􀥾"
  fi
}

# Temperature icon: changes variant at thresholds
temp_icon() {
  local val="${1%°C}"
  local int_val="${val%.*}"
  if [ "$int_val" -ge 80 ]; then echo "􁏄"
  elif [ "$int_val" -ge 60 ]; then echo "􀇬"
  else echo "􁏃"
  fi
}

# Temperature color: always white for icon
color_for_temp() {
  echo "$TEXT"
}

case "$NAME" in
  cpu)
    [ -z "$CPU_USAGE" ] && exit 0
    VAL="${CPU_USAGE%%%}"
    GRAPH_VAL=$(echo "$VAL" | awk '{printf "%.2f", ($1/100) * 0.8}')
    if [ "$VAL" -ge 80 ]; then
      GCOLOR="$RED"
      GFILL="0x22f38ba8"
    elif [ "$VAL" -ge 50 ]; then
      GCOLOR="$PEACH"
      GFILL="0x22fab387"
    else
      GCOLOR="0xff89b4fa"
      GFILL="0x2289b4fa"
    fi
    sketchybar --set cpu label="$CPU_USAGE" label.color="$TEXT" graph.color="$GCOLOR" graph.fill_color="$GFILL" \
               --push cpu "$GRAPH_VAL"
    ;;
  ram)
    [ -z "$RAM_USAGE" ] && exit 0
    COLOR=$(color_for_usage "$RAM_USAGE")
    ICON=$(ram_icon "$RAM_USAGE")
    sketchybar --set ram icon="$ICON" icon.color="$COLOR" label="$RAM_USAGE" label.color=0xdecdd6f4
    ;;
  disk)
    [ -z "$DISK_USAGE" ] && exit 0
    COLOR=$(color_for_usage "$DISK_USAGE")
    ICON=$(disk_icon "$DISK_USAGE")
    sketchybar --set disk icon="$ICON" icon.color="$COLOR" label="$DISK_USAGE" label.color=0xdecdd6f4
    ;;
  cpu_temp)
    [ -z "$CPU_TEMP" ] && exit 0
    TEMP_VAL="${CPU_TEMP%°C}"
    TEMP_INT="${TEMP_VAL%.*}"
    if [ "$TEMP_INT" -ge 20 ]; then
      ICON=$(temp_icon "$CPU_TEMP")
      sketchybar --set cpu_temp icon="$ICON" icon.color="$TEXT" label="${TEMP_INT}°C" label.color=0xdecdd6f4 label.drawing=on drawing=on
    else
      sketchybar --set cpu_temp drawing=off
    fi
    ;;
esac
