#!/bin/bash
# Render one tag like dwm: cyan when selected, plain otherwise. All tags are
# always visible; occupied tags get the small top-left square indicator
# (kept transparent when empty so tag width never changes).

source "$HOME/.config/sketchybar/themes/dwm/colors.sh"

SID="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

if [ "$SID" = "$FOCUSED" ]; then
  BG=$SEL_BG FG=$SEL_FG
else
  BG=$BAR_BG FG=$NORM_FG
fi

if [ "$(aerospace list-windows --workspace "$SID" --count)" -gt 0 ]; then
  SQUARE=$FG
  if [ "$SID" = "$FOCUSED" ]; then ICON="■"; else ICON="□"; fi
else
  SQUARE=0x00000000
  ICON="■"
fi

sketchybar --set "$NAME" background.color=$BG \
                         label.color=$FG \
                         icon="$ICON" \
                         icon.color=$SQUARE
