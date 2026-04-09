#!/usr/bin/env zsh
KANATA_BIN="$HOME/.config/kanata/executables/kanata_macos_cmd_allowed_arm64"
KANATA_CFG="$HOME/.config/kanata/kanata.kbd"
exec sudo "$KANATA_BIN" --cfg "$KANATA_CFG"
