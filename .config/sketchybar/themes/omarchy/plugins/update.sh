#!/bin/bash
# omarchy custom/update clone: icon when system updates are available
# (brew instead of pacman). Click runs the upgrade in a terminal.

export PATH="/opt/homebrew/bin:$PATH"

if [ "$SENDER" = "mouse.clicked" ]; then
  "$HOME/.config/sketchybar/themes/omarchy/scripts/tui.sh" brew upgrade
  exit 0
fi

COUNT=$(brew outdated --quiet 2>/dev/null | wc -l | tr -d ' ')

if [ "${COUNT:-0}" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on label="󰚰"
else
  sketchybar --set "$NAME" drawing=off
fi
