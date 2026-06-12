#!/bin/bash
# i3status wireless _first_: "W: (%quality at %essid) %ip" / "W: down"

source "$HOME/.config/sketchybar/themes/i3/colors.sh"

IF=$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2; exit}')
IF="${IF:-en1}"
IP=$(ipconfig getifaddr "$IF" 2>/dev/null)

if [ -z "$IP" ]; then
  sketchybar --set "$NAME" label="W: down" label.color=$COLOR_BAD
  exit 0
fi

SSID=$(ipconfig getsummary "$IF" 2>/dev/null | awk -F ' SSID : ' '/ SSID : /{print $2; exit}')
# macOS redacts SSID without Location Services permission; omit it then
case "$SSID" in ""|"<redacted>") SSID="" ;; esac

# Quality from RSSI like i3status: 2*(rssi+100), clamped to 0..100
RSSI=$(system_profiler SPAirPortDataType 2>/dev/null | awk '/Signal \/ Noise/{print $4; exit}')
if [[ "$RSSI" =~ ^-?[0-9]+$ ]]; then
  Q=$((2 * (RSSI + 100)))
  [ "$Q" -gt 100 ] && Q=100
  [ "$Q" -lt 0 ] && Q=0
  QUALITY="${Q}%"
else
  QUALITY="?"
fi

if [ -n "$SSID" ]; then
  sketchybar --set "$NAME" label="W: ($QUALITY at $SSID) $IP" label.color=$COLOR_GOOD
else
  sketchybar --set "$NAME" label="W: ($QUALITY) $IP" label.color=$COLOR_GOOD
fi
