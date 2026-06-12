#!/bin/bash
# i3status memory: "%used | %available", degraded/bad below thresholds

source "$HOME/.config/sketchybar/themes/i3/colors.sh"

PAGESIZE=$(sysctl -n hw.pagesize)
TOTAL=$(sysctl -n hw.memsize)

eval "$(vm_stat | awk -F'[: .]+' '
  /Pages free/             {print "FREE=" $3}
  /Pages active/           {print "ACTIVE=" $3}
  /Pages inactive/         {print "INACTIVE=" $3}
  /Pages speculative/      {print "SPEC=" $3}
  /Pages wired down/       {print "WIRED=" $4}
  /Pages occupied by compressor/ {print "COMPRESSED=" $5}
')"

AVAILABLE=$(( (FREE + INACTIVE + SPEC) * PAGESIZE ))
USED=$(( (ACTIVE + WIRED + COMPRESSED) * PAGESIZE ))

# i3status-style: auto unit, one decimal, space before unit (e.g. "618.4 MiB")
fmt() {
  awk -v b="$1" 'BEGIN{
    if (b >= 1073741824) printf "%.1f GiB", b/1073741824
    else printf "%.1f MiB", b/1048576
  }'
}

# i3status defaults: degraded below 10% available, bad below 5%
COLOR=$STATUSLINE
PCT=$(( AVAILABLE * 100 / TOTAL ))
[ "$PCT" -lt 10 ] && COLOR=$COLOR_DEGRADED
[ "$PCT" -lt 5 ] && COLOR=$COLOR_BAD

sketchybar --set "$NAME" label="$(fmt $USED) | $(fmt $AVAILABLE)" label.color=$COLOR
