#!/bin/bash
# waybar clock, omarchy config: format "{:L%A %H:%M}", click toggles
# format-alt "{:L%d %B W%V %Y}" (tooltip disabled, no calendar).

STATE="${TMPDIR:-/tmp}/sketchybar_omarchy_clock_alt"

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ]; then
    # omarchy on-click-right opens a timezone selector
    open "x-apple.systempreferences:com.apple.Date-Time-Settings.extension"
    exit 0
  fi
  if [ -f "$STATE" ]; then rm -f "$STATE"; else touch "$STATE"; fi
fi

if [ -f "$STATE" ]; then
  sketchybar --set "$NAME" label="$(date '+%d %B W%V %Y')"
else
  sketchybar --set "$NAME" label="$(date '+%A %H:%M')"
fi
