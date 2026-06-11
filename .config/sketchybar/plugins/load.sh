#!/bin/bash
# i3status load: "%1min", red above core count (max_threshold)

source "$HOME/.config/sketchybar/colors.sh"

LOAD=$(sysctl -n vm.loadavg | awk '{print $2}')
CORES=$(sysctl -n hw.ncpu)

COLOR=$STATUSLINE
awk -v l="$LOAD" -v c="$CORES" 'BEGIN{exit !(l > c)}' && COLOR=$COLOR_BAD

sketchybar --set "$NAME" label="$LOAD" label.color=$COLOR
