#!/bin/bash
# i3status disk /: "%avail"

source "$HOME/.config/sketchybar/themes/i3/colors.sh"

AVAIL=$(df -k / | awk 'NR==2{printf "%.1f GiB", $4/1048576}')
sketchybar --set "$NAME" label="$AVAIL" label.color=$STATUSLINE
