#!/bin/bash
# Helper process manager for sketchybar
# Sole owner of stats_provider and temp_provider lifecycle.
# Triggered by: update_freq=30 (routine) + system_woke + sleepwatcher (.wakeup)
# Only restarts if helpers are actually dead — no-op when healthy.

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
CONFIG_DIR="$HOME/.config/sketchybar"
PLUGIN_DIR="$CONFIG_DIR/plugins"

# Check if helpers are alive
SP_ALIVE=$(pgrep -x stats_provider)
MM_ALIVE=$(pgrep -x macmon)

# Both alive — nothing to do
[ -n "$SP_ALIVE" ] && [ -n "$MM_ALIVE" ] && exit 0

# Something is dead — clean up everything and restart
killall stats_provider 2>/dev/null
pkill -f temp_provider.sh 2>/dev/null
pkill -f "macmon pipe" 2>/dev/null

sleep 1

# Restart
nohup stats_provider --cpu usage --memory ram_usage --disk usage --interval 5 > /tmp/stats_provider.log 2>&1 &
nohup "$PLUGIN_DIR/temp_provider.sh" > /tmp/temp_provider.log 2>&1 &
