#!/usr/bin/env bash
# APP="$1"
#
# WINDOW_ID=$(aerospace list-windows --all | awk -F'|' "/$APP/ {print \$1}" | awk '{print \$1}' | head -1)
#
# if [[ -n "$WINDOW_ID" ]]; then
#   aerospace focus --window-id "$WINDOW_ID"
# else
#   open -a "$APP"
# fi


open -a "$1"
