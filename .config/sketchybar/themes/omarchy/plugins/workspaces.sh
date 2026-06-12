#!/bin/bash
# Omarchy workspace rendering: active = 󱓻 dot, persistent (1-5) always
# visible (dimmed when empty), 6-10 only when occupied. Workspace 10 = "0".

source "$HOME/.config/sketchybar/themes/omarchy/colors.sh"

SID="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

LABEL="$SID"
[ "$SID" = "10" ] && LABEL="0"

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" drawing=on label="󱓻" label.color=$FOREGROUND
elif [ "$(aerospace list-windows --workspace "$SID" --count)" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on label="$LABEL" label.color=$FOREGROUND
elif [ "$SID" -le 5 ]; then
  sketchybar --set "$NAME" drawing=on label="$LABEL" label.color=$FOREGROUND_DIM
else
  sketchybar --set "$NAME" drawing=off
fi
