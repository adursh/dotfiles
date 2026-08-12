#!/bin/bash

# Robust workspace indicator update.
# - Runs from ONE listener item (ws_listener) per event, not 10.
# - Emits the whole slide + squash + highlight in ONE sketchybar message,
#   so a newer workspace change atomically replaces any in-flight one.
# - The slide starts from the thumb's current (possibly mid-flight)
#   x_offset; no cache file, no sleep, no manual START jump.
# - Squash: left-anchored item-width shrink (16 -> W -> 16) with the
#   leading edge pinned via x_offset (rightward) or the left edge fixed
#   (leftward); front_app padding is compensated by the SAME animator
#   (same curve + duration), so its position is exact at every frame.
# - background.padding_* translates the whole thumb (both edges move,
#   width unchanged) - it does NOT inset, so it cannot squash.

SID="$FOCUSED_WORKSPACE"
[ -z "$SID" ] && exit 0
OLD="${PREV_WORKSPACE:-$SID}"

# Per-digit targets: digit glyph centers (home center = 254.5) minus a
# small optical nudge.
TARGET=(0 -202 -183 -165 -145 -125 -105 -85 -65 -45 -21)
T=${TARGET[$SID]}

DIST=$(( SID - OLD )); [ "$DIST" -lt 0 ] && DIST=$(( -DIST ))
DUR=$(( 3 + DIST )); [ "$DUR" -gt 6 ] && DUR=6
W=16
if   [ "$DIST" -ge 6 ]; then W=12
elif [ "$DIST" -ge 3 ]; then W=13
elif [ "$DIST" -eq 2 ]; then W=14
fi
SQ=$(( (DUR + 1) / 2 ))
P=$(( 16 - W ))

# Highlight: snap every digit dark, fade the focused one in. Each event
# encodes full truth (--set takes one item per call), so the last message
# always wins.
HIGHLIGHT=""
for n in 1 2 3 4 5 6 7 8 9 10; do
  [ "$n" = "$SID" ] && continue
  HIGHLIGHT+=" --set space.$n label.color=0xff585b70"
done
HIGHLIGHT+=" --animate tanh 8 --set space.$SID label.color=0xffcdd6f4"

if [ "$P" -le 0 ]; then
  # Adjacent (or startup): just slide, no squash.
  sketchybar --animate tanh $DUR --set ws_indicator background.x_offset=$T \
    $HIGHLIGHT
  exit 0
fi

# Squash the trailing side with a left-anchored width shrink: rightward
# motion pins the leading (right) edge via x_offset, leftward keeps the
# left edge fixed. The front_app padding compensation sits in the SAME
# --animate block (verified: one animator drives every --set that
# follows it), so it is pixel-synced with the width keyframes.
if [ "$SID" -gt "$OLD" ]; then
  sketchybar --animate tanh $DUR --set ws_indicator background.x_offset=$T width=16 \
    --set front_app padding_left=12 \
    --animate linear $SQ --set ws_indicator width=$W background.x_offset=$((T+P)) width=16 background.x_offset=$T \
    --set front_app padding_left=$((12+P)) padding_left=12 \
    $HIGHLIGHT
else
  sketchybar --animate tanh $DUR --set ws_indicator background.x_offset=$T width=16 \
    --set front_app padding_left=12 \
    --animate linear $SQ --set ws_indicator width=$W width=16 \
    --set front_app padding_left=$((12+P)) padding_left=12 \
    $HIGHLIGHT
fi
