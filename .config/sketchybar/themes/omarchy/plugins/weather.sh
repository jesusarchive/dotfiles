#!/bin/bash
# Port of omarchy-weather-icon: wttr.in condition code -> nerd icon,
# day/night variants from live sunrise/sunset.

DATA=$(curl -fsS --max-time 3 "https://wttr.in?format=j1" 2>/dev/null | jq -er \
  '[.current_condition[0].weatherCode, .weather[0].astronomy[0].sunrise, .weather[0].astronomy[0].sunset]
   | select(all(. != null and . != "")) | @tsv' 2>/dev/null)

if [ -z "$DATA" ]; then
  sketchybar --set "$NAME" label="" label.padding_left=0 label.padding_right=0
  exit 0
fi

IFS=$'\t' read -r CODE SUNRISE SUNSET <<<"$DATA"

NOW=$(date +%s)
SR=$(date -j -f "%I:%M %p" "$SUNRISE" +%s 2>/dev/null || echo 0)
SS=$(date -j -f "%I:%M %p" "$SUNSET" +%s 2>/dev/null || echo 0)

night=false
if [ "$SR" -gt 0 ] && [ "$SS" -gt 0 ] && { [ "$NOW" -lt "$SR" ] || [ "$NOW" -ge "$SS" ]; }; then
  night=true
fi

case $CODE in
  113) [ "$night" = true ] && ICON="" || ICON="" ;;
  116) [ "$night" = true ] && ICON="" || ICON="" ;;
  119|122) ICON="" ;;
  143|248|260) ICON="" ;;
  176|263|266|293|296|353) [ "$night" = true ] && ICON="" || ICON="" ;;
  179|227|230|323|326|368) [ "$night" = true ] && ICON="" || ICON="" ;;
  182|185|281|284|311|314|317|320|350|362|365|374|377) ICON="" ;;
  200|386|389|392|395) ICON="" ;;
  299|302|305|308|356|359) ICON="" ;;
  329|332|335|338|371) ICON="" ;;
  *) ICON="" ;;
esac

sketchybar --set "$NAME" label="$ICON" label.padding_left=4 label.padding_right=4
