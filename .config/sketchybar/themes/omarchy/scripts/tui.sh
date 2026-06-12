#!/bin/bash
# Launch-or-focus a TUI in a kitty window (omarchy-launch-or-focus-tui,
# minus the floating/centering): focus the existing window if one is open,
# else open a new one. Usage: tui.sh btop
#
# The window starts titled "tui-<cmd>" but the TUI usually retitles it to
# its own name, so the lookup matches on "contains <cmd>".

# sketchybar's click env lacks homebrew on PATH
export PATH="/opt/homebrew/bin:$PATH"

# Default terminal, like omarchy's xdg-terminal-exec. The launch flags are
# kitty's; adjust if you point TERMINAL elsewhere.
TERMINAL="${TERMINAL:-kitty}"

CMD="$1"

WID=$(aerospace list-windows --all --format '%{window-id}|%{app-name}|%{window-title}' 2>/dev/null |
  awk -F'|' -v c="$CMD" -v t="$TERMINAL" 'tolower($2) == t && index(tolower($3), c) {print $1; exit}')

if [ -n "$WID" ]; then
  aerospace focus --window-id "$WID"
else
  exec "$TERMINAL" --single-instance -T "tui-$CMD" "$@"
fi
