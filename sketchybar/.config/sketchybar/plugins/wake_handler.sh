#!/bin/bash
# Wake handler: restarts stats helpers after system wake
# This ensures CPU/RAM/Disk/Temp update immediately after opening the lid

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
CONFIG_DIR="$HOME/.config/sketchybar"
PLUGIN_DIR="$CONFIG_DIR/plugins"

# Kill stale helpers (they may have broken pipes after sleep)
killall stats_provider 2>/dev/null
pkill -f temp_provider.sh 2>/dev/null
pkill -f "macmon pipe" 2>/dev/null

sleep 1

# Restart stats provider
nohup stats_provider --cpu usage --memory ram_usage --disk usage --interval 5 > /tmp/stats_provider.log 2>&1 &

# Restart temp provider
nohup "$PLUGIN_DIR/temp_provider.sh" > /tmp/temp_provider.log 2>&1 &
