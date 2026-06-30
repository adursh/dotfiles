#!/bin/bash
# Temperature provider using macmon (works on Apple Silicon without sudo)
# Runs as a background daemon, triggers sketchybar system_stats event with real temps
# Uses jq for JSON parsing (fast native C binary, no Python overhead)

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

INTERVAL=10  # seconds

macmon pipe --interval $((INTERVAL * 1000)) 2>/dev/null | while IFS= read -r line; do
  [ -z "$line" ] && continue

  CPU_TEMP=$(echo "$line" | jq -r '.temp.cpu_temp_avg | floor' 2>/dev/null)
  GPU_TEMP=$(echo "$line" | jq -r '.temp.gpu_temp_avg | floor' 2>/dev/null)

  # Skip if jq failed or returned null/empty
  [ -z "$CPU_TEMP" ] || [ "$CPU_TEMP" = "null" ] && continue

  sketchybar --trigger system_stats CPU_TEMP="${CPU_TEMP}°C" GPU_TEMP="${GPU_TEMP}°C"
done
