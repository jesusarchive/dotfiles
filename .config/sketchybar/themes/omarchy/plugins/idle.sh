#!/bin/bash
# omarchy custom/idle-indicator clone: caffeinate is macOS's idle inhibitor.
# Bright icon while idle/sleep is inhibited, dim otherwise; click toggles
# our own caffeinate instance (an externally started one also lights it up).

source "$HOME/.config/sketchybar/themes/omarchy/colors.sh"

PIDFILE="${TMPDIR:-/tmp}/sketchybar_caffeinate.pid"

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    kill "$(cat "$PIDFILE")"
    rm -f "$PIDFILE"
  else
    caffeinate -di &
    echo $! > "$PIDFILE"
  fi
fi

if pgrep -x caffeinate >/dev/null; then
  sketchybar --set "$NAME" label="󰅶" label.color=$FOREGROUND
else
  sketchybar --set "$NAME" label="󰾪" label.color=$FOREGROUND_DIM
fi
