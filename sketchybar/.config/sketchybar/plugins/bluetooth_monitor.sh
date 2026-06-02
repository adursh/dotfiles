#!/bin/bash

# Monitor bluetooth state changes and trigger sketchybar updates
CACHE_FILE="/tmp/sketchybar_bluetooth_state"

get_bluetooth_state() {
  if ! command -v blueutil &>/dev/null; then
    echo "no_blueutil"
    return
  fi
  
  local power=$(blueutil --power)
  local connected=$(blueutil --connected)
  echo "${power}:${connected}"
}

# Initialize cache
get_bluetooth_state > "$CACHE_FILE"

# Monitor bluetooth state every 3 seconds
while true; do
  sleep 3
  
  CURRENT_STATE=$(get_bluetooth_state)
  CACHED_STATE=$(cat "$CACHE_FILE" 2>/dev/null || echo "")
  
  if [ "$CURRENT_STATE" != "$CACHED_STATE" ]; then
    echo "$CURRENT_STATE" > "$CACHE_FILE"
    sketchybar --trigger bluetooth_change
  fi
done
