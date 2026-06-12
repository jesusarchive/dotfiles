#!/bin/bash
# waybar battery module: icon by charge while discharging, charging icons
# while charging, hidden when plugged/full (format-plugged "") or absent.

BATT=$(pmset -g batt)
PCT=$(echo "$BATT" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')

if [ -z "$PCT" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

DISCHARGING=("󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
CHARGING=("󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")

IDX=$((PCT / 10))
[ "$IDX" -gt 9 ] && IDX=9

if echo "$BATT" | grep -q "discharging"; then
  sketchybar --set "$NAME" drawing=on label="${DISCHARGING[$IDX]}"
elif echo "$BATT" | grep -q " charging"; then
  sketchybar --set "$NAME" drawing=on label="${CHARGING[$IDX]}"
else
  # plugged / charged
  sketchybar --set "$NAME" drawing=off
fi
