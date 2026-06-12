#!/bin/bash
# waybar network module: wifi strength icons / ethernet / disconnected

WIFI_IF=$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2; exit}')
WIFI_IF="${WIFI_IF:-en1}"

# omarchy: on-click opens the wifi tool
if [ "$SENDER" = "mouse.clicked" ]; then
  open "x-apple.systempreferences:com.apple.Wi-Fi-Settings.extension"
  exit 0
fi

# Wired connection wins, like "ethernet" state in waybar
for IF in $(ifconfig -lu); do
  case "$IF" in
    lo*|"$WIFI_IF"|awdl*|llw*|utun*|bridge*|gif*|stf*|anpi*|ap*) continue ;;
  esac
  if [ -n "$(ipconfig getifaddr "$IF" 2>/dev/null)" ]; then
    sketchybar --set "$NAME" label="󰀂"
    exit 0
  fi
done

if [ -z "$(ipconfig getifaddr "$WIFI_IF" 2>/dev/null)" ]; then
  sketchybar --set "$NAME" label="󰤮"
  exit 0
fi

ICONS=("󰤯" "󰤟" "󰤢" "󰤥" "󰤨")
RSSI=$(system_profiler SPAirPortDataType 2>/dev/null | awk '/Signal \/ Noise/{print $4; exit}')
if [[ "$RSSI" =~ ^-?[0-9]+$ ]]; then
  Q=$((2 * (RSSI + 100)))
  [ "$Q" -gt 100 ] && Q=100
  [ "$Q" -lt 0 ] && Q=0
  IDX=$((Q / 21))
else
  IDX=4
fi

sketchybar --set "$NAME" label="${ICONS[$IDX]}"
