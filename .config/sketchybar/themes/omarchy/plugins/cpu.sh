#!/bin/bash
# omarchy cpu module clicks: left = launch-or-focus btop,
# right = plain terminal (omarchy's on-click-right).

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
    "${TERMINAL:-kitty}" --single-instance -d ~ &
  else
    "$HOME/.config/sketchybar/themes/omarchy/scripts/tui.sh" btop
  fi
fi
