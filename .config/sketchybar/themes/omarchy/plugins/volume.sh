#!/bin/bash
# waybar pulseaudio module: muted / low / mid / high icons.
# omarchy: on-click opens the audio tool, on-click-right toggles mute.

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ]; then
    osascript -e 'set volume output muted (not (output muted of (get volume settings)))'
  else
    open "x-apple.systempreferences:com.apple.Sound-Settings.extension"
    exit 0
  fi
elif [ "$SENDER" = "mouse.scrolled" ]; then
  CUR=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
  if [ "${SCROLL_DELTA:-0}" -gt 0 ] 2>/dev/null; then
    NEW=$((CUR + 5))
  else
    NEW=$((CUR - 5))
  fi
  [ "$NEW" -gt 100 ] && NEW=100
  [ "$NEW" -lt 0 ] && NEW=0
  osascript -e "set volume output volume $NEW"
fi

VOL=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
MUTED=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)

if [ "$MUTED" = "true" ] || [ -z "$VOL" ]; then
  sketchybar --set "$NAME" label=""
elif [ "$VOL" -lt 34 ]; then
  sketchybar --set "$NAME" label=""
elif [ "$VOL" -lt 67 ]; then
  sketchybar --set "$NAME" label=""
else
  sketchybar --set "$NAME" label=""
fi
