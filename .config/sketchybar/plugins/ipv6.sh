#!/bin/bash
# i3status ipv6: global address or "no IPv6"

source "$HOME/.config/sketchybar/colors.sh"

IP=$(ifconfig 2>/dev/null | awk '/inet6/ && $2 !~ /^(fe80|::1)/ && $0 !~ /temporary|deprecated/ {print $2; exit}')

if [ -n "$IP" ]; then
  sketchybar --set "$NAME" label="$IP" label.color=$STATUSLINE
else
  sketchybar --set "$NAME" label="no IPv6" label.color=$COLOR_BAD
fi
