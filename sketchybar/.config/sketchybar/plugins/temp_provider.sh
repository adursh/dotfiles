#!/bin/bash
# Temperature provider using macmon (works on Apple Silicon without sudo)
# Runs as a background daemon, triggers sketchybar system_stats event with real temps

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

INTERVAL=10  # seconds

macmon pipe --interval $((INTERVAL * 1000)) 2>/dev/null | while IFS= read -r line; do
  [ -z "$line" ] && continue

  read CPU_TEMP GPU_TEMP <<< $(echo "$line" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    t = d.get('temp', {})
    print(f\"{t.get('cpu_temp_avg',0):.0f}°C\", f\"{t.get('gpu_temp_avg',0):.0f}°C\")
except: print('', '')
" 2>/dev/null)

  [ -z "$CPU_TEMP" ] && continue

  sketchybar --trigger system_stats CPU_TEMP="$CPU_TEMP" GPU_TEMP="$GPU_TEMP"
done
