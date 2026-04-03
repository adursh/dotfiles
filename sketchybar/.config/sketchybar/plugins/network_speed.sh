#!/bin/bash
STATE="/tmp/sketchybar_net"
IFACE_CACHE="/tmp/sketchybar_iface"

if [ ! -f "$IFACE_CACHE" ] || [ $(( $(date +%s) - $(stat -f %m "$IFACE_CACHE") )) -gt 60 ]; then
  route -n get default 2>/dev/null | awk '/interface:/{print $2}' > "$IFACE_CACHE"
fi

IFACE=$(cat "$IFACE_CACHE" 2>/dev/null)
[ -z "$IFACE" ] && { sketchybar --set "$NAME" label="↓ -- ↑ --"; exit 0; }

read -r RX TX <<< "$(netstat -I "$IFACE" -b 2>/dev/null | awk 'NR==2{print $7, $10}')"
NOW=$(date +%s)

if [ -f "$STATE" ]; then
  read -r PT PR PX < "$STATE"
else
  PT=$NOW; PR=$RX; PX=$TX
fi

DELTA=$(( NOW - PT )); [ "$DELTA" -le 0 ] && DELTA=1
D=$(( (RX - PR) / DELTA ))
U=$(( (TX - PX) / DELTA ))
[ "$D" -lt 0 ] && D=0
[ "$U" -lt 0 ] && U=0
echo "$NOW $RX $TX" > "$STATE"

fmt() {
  if   [ "$1" -ge 1048576 ]; then printf "%.1fM" "$(echo "scale=1;$1/1048576" | bc)"
  elif [ "$1" -ge 1024    ]; then printf "%.0fK" "$(echo "scale=0;$1/1024" | bc)"
  else printf "%dB" "$1"; fi
}

sketchybar --set "$NAME" label="↓ $(fmt $D)/s  ↑ $(fmt $U)/s"
