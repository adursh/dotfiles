#!/usr/bin/env bash
# Usage: kbdbrightness.sh up|down
STEP=0.01
CURRENT=$(mac-brightnessctl | awk '{print $3}')

if [[ "$1" == "up" ]]; then
  NEW=$(echo "$CURRENT + $STEP" | bc)
  # cap at 1.0
  NEW=$(echo "if ($NEW > 1.0) 1.0 else $NEW" | bc)
else
  NEW=$(echo "$CURRENT - $STEP" | bc)
  # floor at 0.0
  NEW=$(echo "if ($NEW < 0.0) 0.0 else $NEW" | bc)
fi

mac-brightnessctl "$NEW"
