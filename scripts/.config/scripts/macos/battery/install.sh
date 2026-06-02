#!/bin/bash
set -e

PLIST_NAME="com.user.battery-monitor.plist"
BASE_DIR="$HOME/.config/scripts/macos/battery"
LAUNCH_AGENTS="$HOME/Library/LaunchAgents"
LOG_DIR="$HOME/.local/log"

SCRIPT_DEST="$BASE_DIR/battery_monitor.swift"
PLIST_SRC="$BASE_DIR/$PLIST_NAME"
PLIST_DEST="$LAUNCH_AGENTS/$PLIST_NAME"

echo "==> Creating directories..."
mkdir -p "$LAUNCH_AGENTS" "$LOG_DIR"

echo "==> Writing LaunchAgent plist..."
sed \
    -e "s|SCRIPT_PATH_PLACEHOLDER|$SCRIPT_DEST|g" \
    -e "s|HOME_PLACEHOLDER|$HOME|g" \
    "$PLIST_SRC" > "$PLIST_DEST"

echo "==> Unloading old agent (if any)..."
launchctl unload "$PLIST_DEST" 2>/dev/null || true

echo "==> Loading LaunchAgent..."
launchctl load "$PLIST_DEST"

echo ""
echo "Done! Event-driven battery monitor is running."
echo "   Script → $SCRIPT_DEST"
echo "   Plist  → $PLIST_DEST"
echo "   Logs   → $LOG_DIR/battery_monitor.log"
echo ""
echo "   Verify: launchctl list | grep battery"
echo "   Uninstall: launchctl unload $PLIST_DEST && rm $PLIST_DEST"
