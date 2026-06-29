#!/bin/bash
set -euo pipefail

is_hotspot() {
  local router
  router=$(networksetup -getinfo Wi-Fi 2>/dev/null | awk '/^Router:/{print $2}')

  # Apple Personal Hotspot: 192.0.0.0/24
  [[ "$router" == 192.0.0.* ]] && return 0

  # Android hotspot subnets
  [[ "$router" == 192.168.43.* || "$router" == 192.168.137.* ]] && return 0

  # SSID name fallback (for cases where router IP is ambiguous)
  local port ssid
  port=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $NF}')
  ssid=$(ipconfig getsummary "$port" 2>/dev/null | awk -F ' SSID : ' '/ SSID : / {print $2}')
  if [ -z "$ssid" ] || [ "$ssid" = "<redacted>" ]; then
    ssid=$(system_profiler SPAirPortDataType 2>/dev/null \
           | awk '/Current Network/{getline; $1=$1; gsub(":",""); print; exit}')
  fi
  echo "$ssid" | grep -qiE "(iphone|ipad|android|pixel|galaxy|oneplus|xiaomi|redmi|realme|oppo|vivo|hotspot|mobile)"
}

# Mac sharing its own internet (this Mac IS the hotspot)
if ifconfig bridge100 2>/dev/null | grep -q "status: active"; then
  sketchybar --set "$NAME" icon="􀉤"
  exit 0
fi

# Ethernet
if ifconfig | grep -A5 "^en[1-9]:" | grep -q "status: active"; then
  sketchybar --set "$NAME" icon="􀎔"
  exit 0
fi

# VPN as default route (ignore link-local fe80:: routes macOS always creates on utun)
if netstat -rn | grep "^default" | grep -E "utun[0-9]" | grep -qv "fe80"; then
  sketchybar --set "$NAME" icon="􀙵"
  exit 0
fi

# WiFi
WIFI_PORT=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $NF}')

if ! networksetup -getairportpower "$WIFI_PORT" 2>/dev/null | grep -q "On"; then
  sketchybar --set "$NAME" icon="󰤭"
  exit 0
fi

# Check if connected (router IP present means associated)
ROUTER=$(networksetup -getinfo Wi-Fi 2>/dev/null | awk '/^Router:/{print $2}')

if [ -z "$ROUTER" ]; then
  sketchybar --set "$NAME" icon="󰤯"
  exit 0
fi

if is_hotspot; then
  sketchybar --set "$NAME" icon="􀉤"
else
  sketchybar --set "$NAME" icon="󰤨"
fi
