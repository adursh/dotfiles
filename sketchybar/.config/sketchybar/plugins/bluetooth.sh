# #!/bin/bash
# BT=$(system_profiler SPBluetoothDataType 2>/dev/null | grep "State:" | awk '{print $2}')
#
# if [ "$BT" = "On" ]; then
#   ICON="󰂯"
# else
#   ICON="󰂲"
# fi
#
# sketchybar --set bluetooth icon="$ICON"


#!/bin/bash
STATE=$(blueutil --power)
CONNECTED=$(blueutil --connected | wc -l | tr -d ' ')

if [ "$STATE" = "0" ]; then
  ICON="󰂲"
elif [ "$CONNECTED" -gt "0" ]; then
  ICON="󰂱"
else
  ICON="󰂯"
fi

sketchybar --set bluetooth icon="$ICON"
