#!/bin/bash
# i3status battery all: "%status %percentage %remaining"; hidden when no battery.

source "$HOME/.config/sketchybar/colors.sh"

BATT=$(pmset -g batt)
PCT=$(echo "$BATT" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')

if [ -z "$PCT" ]; then
  sketchybar --set "$NAME" label="No battery" label.color=$STATUSLINE
  exit 0
fi

REMAIN=$(echo "$BATT" | grep -Eo '[0-9]+:[0-9]+' | head -1)
COLOR=$STATUSLINE

if echo "$BATT" | grep -q "discharging"; then
  STATUS="BAT"
  [ "$PCT" -le 30 ] && COLOR=$COLOR_DEGRADED
  [ "$PCT" -le 15 ] && COLOR=$COLOR_BAD
elif echo "$BATT" | grep -q "charged"; then
  STATUS="FULL"
else
  STATUS="CHR"
fi

LABEL="$STATUS ${PCT}%"
[ -n "$REMAIN" ] && LABEL="$LABEL $REMAIN"

sketchybar --set "$NAME" label="$LABEL" label.color=$COLOR
