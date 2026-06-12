#!/bin/bash
# omarchy custom/screenrecording-indicator clone: red icon while the macOS
# screen recorder (cmd-shift-5 / screencapture) is running; click stops it.

source "$HOME/.config/sketchybar/themes/omarchy/colors.sh"

if [ "$SENDER" = "mouse.clicked" ]; then
  pkill -INT -x screencapture 2>/dev/null
  sleep 1
fi

if pgrep -x screencapture >/dev/null; then
  sketchybar --set "$NAME" drawing=on label="" label.color=$INDICATOR_RED
else
  sketchybar --set "$NAME" drawing=off
fi
