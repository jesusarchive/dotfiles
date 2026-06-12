#!/bin/bash
# waybar bluetooth module: on "" / off 󰂲 / connected 󰂱
# omarchy: on-click opens the bluetooth tool.

if [ "$SENDER" = "mouse.clicked" ]; then
  open "x-apple.systempreferences:com.apple.BluetoothSettings" 2>/dev/null
  exit 0
fi

STATE=$(system_profiler SPBluetoothDataType -json 2>/dev/null | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)['SPBluetoothDataType'][0]
except Exception:
    print('off'); raise SystemExit
power = d.get('controller_properties', {}).get('controller_state', '')
if power != 'attrib_on':
    print('off')
elif d.get('device_connected'):
    print('connected')
else:
    print('on')
" 2>/dev/null)

case "$STATE" in
  connected) sketchybar --set "$NAME" label="󰂱" ;;
  on)        sketchybar --set "$NAME" label="" ;;
  *)         sketchybar --set "$NAME" label="󰂲" ;;
esac
