#!/bin/bash
# i3status ethernet _first_: "E: %ip (%speed)" / "E: down"

source "$HOME/.config/sketchybar/colors.sh"

WIFI_IF=$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2; exit}')

for IF in $(ifconfig -lu); do
  case "$IF" in
    lo*|"$WIFI_IF"|awdl*|llw*|utun*|bridge*|gif*|stf*|anpi*|ap*) continue ;;
  esac
  IP=$(ipconfig getifaddr "$IF" 2>/dev/null)
  if [ -n "$IP" ]; then
    # media "1000baseT" -> "1000 Mbit/s" like i3status
    SPEED=$(ifconfig "$IF" 2>/dev/null | awk -F'[()]' '/media:/{print $2; exit}' | grep -Eo '^[0-9]+')
    if [ -n "$SPEED" ]; then
      LABEL="E: $IP ($SPEED Mbit/s)"
    else
      LABEL="E: $IP"
    fi
    sketchybar --set "$NAME" label="$LABEL" label.color=$COLOR_GOOD
    exit 0
  fi
done

sketchybar --set "$NAME" label="E: down" label.color=$COLOR_BAD
