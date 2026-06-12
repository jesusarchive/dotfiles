#!/bin/bash
# Title area, matching dwm's drawbar(): raw window title on SchemeSel with a
# small square indicator when the window floats; a blank SchemeNorm rect when
# nothing is focused. Runs on front_app_switched and the 1s title_resize tick
# from status.sh, so in-app title changes (tabs, cwd) follow like WM_NAME.

source "$HOME/.config/sketchybar/themes/dwm/colors.sh"

# layout first: the title itself may contain '|'
INFO=$(aerospace list-windows --focused --format '%{window-layout}|%{window-title}' 2>/dev/null)

if [ -z "$INFO" ]; then
  sketchybar --set "$NAME" label="" \
                           background.color=$BAR_BG \
                           icon.color=0x00000000
else
  LAYOUT="${INFO%%|*}"
  TITLE="${INFO#*|}"
  [ -z "$TITLE" ] && TITLE=$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)
  [ "$LAYOUT" = "floating" ] && SQUARE=$SEL_FG || SQUARE=0x00000000
  sketchybar --set "$NAME" label="$TITLE" \
                           background.color=$SEL_BG \
                           icon.color=$SQUARE
fi

# Stretch: width = status item's left edge - title's left edge. The title's
# own origin is set by the items before it, so this is idempotent.
WIDTH=$(python3 - <<'EOF' 2>/dev/null
import json, subprocess
def rect(name):
    out = subprocess.check_output(["sketchybar", "--query", name])
    return list(json.loads(out)["bounding_rects"].values())[0]
w = int(rect("status")["origin"][0] - rect("title")["origin"][0])
print(w if w > 0 else "")
EOF
)
# max_chars gives dwm's truncation ellipsis (~8px/char at 13pt mono)
[ -n "$WIDTH" ] && sketchybar --set "$NAME" width="$WIDTH" \
                              label.max_chars=$(( (WIDTH - 16) / 8 ))
