#!/bin/bash
# Render one workspace button like i3bar: blue when focused, dark when it
# has windows, hidden when empty and unfocused.

source "$HOME/.config/sketchybar/themes/i3/colors.sh"

SID="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" drawing=on \
                           background.color=$WS_FOCUSED_BG \
                           background.border_color=$WS_FOCUSED_BORDER \
                           label.color=$WS_FOCUSED_FG
elif [ "$(aerospace list-windows --workspace "$SID" --count)" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on \
                           background.color=$WS_INACTIVE_BG \
                           background.border_color=$WS_INACTIVE_BORDER \
                           label.color=$WS_INACTIVE_FG
else
  sketchybar --set "$NAME" drawing=off
fi
