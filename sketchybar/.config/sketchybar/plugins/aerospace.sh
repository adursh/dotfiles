#!/bin/bash

SID="$1"

if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    drawing=on \
    label.color=0xffffffff \
    label.font="SF Pro Text:Semibold:14.0" \
    background.drawing=off
else
  OCCUPIED=$(aerospace list-windows --all --format %{workspace} 2>/dev/null | sort -un)
  if echo "$OCCUPIED" | grep -qw "$SID"; then
    sketchybar --set "$NAME" \
      drawing=on \
      label.color=0xff7f849c \
      label.font="SF Pro Text:Medium:14.0" \
      background.drawing=off
  else
    sketchybar --set "$NAME" drawing=off
  fi
fi


# #!/bin/bash
#
# CACHE_FILE="/tmp/sketchybar_workspace_cache"
# OCCUPIED=$(aerospace list-windows --all --format %{workspace} 2>/dev/null | sort -un)
# # TARGET=$(printf "1\n%s\n%s\n" "$OCCUPIED" "$FOCUSED_WORKSPACE" | sort -un)
# TARGET=$(printf "%s\n%s\n" "$OCCUPIED" "$FOCUSED_WORKSPACE" | sort -un)
#
# # Cache occupied workspaces to avoid redundant updates
# if [ -f "$CACHE_FILE" ] && [ "$(cat "$CACHE_FILE")" = "$OCCUPIED" ] && [ "$PREV_WORKSPACE" != "$FOCUSED_WORKSPACE" ]; then
#   # Only update focused if occupied unchanged
#   for sid in 1 2 3 4 5 6 7 8 9 10; do
#     if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
#       sketchybar --set "space.$sid" \
#         drawing=on \
#         label.color=0xffffffff \
#         label.font="SF Pro Text:Semibold:14.0" \
#         background.drawing=off
#     elif echo "$TARGET" | grep -qw "$sid"; then
#       sketchybar --set "space.$sid" \
#         drawing=on \
#         label.color=0xff3b3b4f \
#         label.font="SF Pro Text:Medium:14.0" \
#         background.drawing=off
#     else
#       sketchybar --set "space.$sid" drawing=off
#     fi
#   done
# else
#   echo "$OCCUPIED" > "$CACHE_FILE"
#   for sid in 1 2 3 4 5 6 7 8 9 10; do
#     if echo "$TARGET" | grep -qw "$sid"; then
#       if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
#         sketchybar --set "space.$sid" \
#           drawing=on \
#           label.color=0xffffffff \
#           label.font="SF Pro Text:Semibold:14.0" \
#           background.drawing=off
#       else
#         sketchybar --set "space.$sid" \
#           drawing=on \
#           label.color=0xff3b3b4f \
#           label.font="SF Pro Text:Medium:14.0" \
#           background.drawing=off
#       fi
#     else
#       sketchybar --set "space.$sid" drawing=off
#     fi
#   done
# fi
