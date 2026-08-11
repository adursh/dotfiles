#!/bin/bash

SID="$1"

if [ "$SID" != "$FOCUSED_WORKSPACE" ]; then
  sketchybar --animate tanh 8 --set "$NAME" label.color=0xff585b70
  exit 0
fi

CACHE="/tmp/sketchybar_ws_indicator"
OLD=$(cat "$CACHE" 2>/dev/null)
[ -z "$OLD" ] && OLD="$SID"
echo "$SID" > "$CACHE"

# Thumb is anchored after space.10; per-digit x_offset targets are the
# digit glyph centers (home center = 254.5) minus a small optical nudge.
TARGET=(0 -202 -183 -165 -145 -125 -105 -85 -65 -45 -21)
T=${TARGET[$SID]}
D=$(( ${TARGET[$OLD]} - T ))

# Slide duration grows with distance but caps at 10 frames, so long jumps
# travel faster. Squash runs at the same frame count as the slide and its
# depth stays moderate even for long jumps.
DIST=$(( SID - OLD )); [ "$DIST" -lt 0 ] && DIST=$(( -DIST ))
DUR=$(( 5 + DIST )); [ "$DUR" -gt 10 ] && DUR=10
if   [ "$DIST" -ge 6 ]; then W=12
elif [ "$DIST" -ge 3 ]; then W=13
elif [ "$DIST" -eq 2 ]; then W=14
fi
SLEEP_DUR=$(awk -v d=$DUR 'BEGIN{printf "%.2f", d*0.0167}')
# Squash runs at the slide's pace: shrink+regrow together complete in
# about the same time as the slide itself.
SQ=$(( (DUR + 1) / 2 ))

sketchybar --set ws_indicator background.x_offset=$(( T + D ))
sketchybar --animate tanh $DUR --set ws_indicator background.x_offset=$T

# Adjacent moves: no squash, done after the short slide.
if [ "$DIST" -eq 1 ]; then
  sleep "$SLEEP_DUR"
  sketchybar --animate tanh 8 --set "$NAME" label.color=0xffcdd6f4
  exit 0
fi

# Landing squash starts exactly when the slide ends and completes in the
# same time the slide took (shrink + regrow each at SQ frames), so the
# length change keeps the slide's pace. front_app padding is animated in
# sync so it does not shift.
sleep "$SLEEP_DUR"
if [ "$SID" -lt "$OLD" ]; then
  sketchybar --animate linear $SQ --set ws_indicator width=$W width=16
else
  sketchybar --animate linear $SQ --set ws_indicator width=$W background.x_offset=$(( T + 16 - W )) width=16 background.x_offset=$T
fi
sketchybar --animate linear $SQ --set front_app padding_left=$(( 12 + 16 - W )) padding_left=12

sketchybar --animate tanh 8 --set "$NAME" label.color=0xffcdd6f4
