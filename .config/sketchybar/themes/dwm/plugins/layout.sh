#!/bin/bash
# dwm layout symbol, from the focused window's aerospace layout:
# []= tiles, [M] accordion (monocle-ish), ><> floating.

LAYOUT=$(aerospace list-windows --focused --format '%{window-layout}' 2>/dev/null)

case "$LAYOUT" in
  *accordion*) SYM='[M]' ;;
  floating)    SYM='><>' ;;
  *)           SYM='[]=' ;;
esac

sketchybar --set "$NAME" label="$SYM"
