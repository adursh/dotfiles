#!/bin/bash
# Helper health check: ensures stats_provider and temp_provider stay alive
# Triggered by: system_woke event AND update_freq=30 (safety net)
# Debounces rapid triggers to prevent duplicate processes

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
CONFIG_DIR="$HOME/.config/sketchybar"
PLUGIN_DIR="$CONFIG_DIR/plugins"
LOCK="/tmp/sketchybar_wake.lock"

# Debounce: skip if ran within the last 5 seconds
if [ -f "$LOCK" ]; then
  LOCK_AGE=$(( $(date +%s) - $(stat -f %m "$LOCK") ))
  [ "$LOCK_AGE" -lt 5 ] && exit 0
fi

# Check if helpers are alive — only restart if dead
SP_ALIVE=$(pgrep -x stats_provider)
MM_ALIVE=$(pgrep -x macmon)

# If both alive, nothing to do
[ -n "$SP_ALIVE" ] && [ -n "$MM_ALIVE" ] && exit 0

# Something is dead — restart everything cleanly
touch "$LOCK"

killall stats_provider 2>/dev/null
pkill -f temp_provider.sh 2>/dev/null
pkill -f "macmon pipe" 2>/dev/null

sleep 1

# Restart stats provider
nohup stats_provider --cpu usage --memory ram_usage --disk usage --interval 5 > /tmp/stats_provider.log 2>&1 &

# Restart temp provider
nohup "$PLUGIN_DIR/temp_provider.sh" > /tmp/temp_provider.log 2>&1 &
