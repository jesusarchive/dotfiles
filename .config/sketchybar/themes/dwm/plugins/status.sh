#!/bin/bash
# slstatus clone. One status string set every second, like slstatus writing
# the X root window name. Edit the component list at the bottom the same way
# you would slstatus's config.h: add "format" "$(function)" — %s is the value.
# slstatus's stock config is datetime only; the extra modules below match its
# config.def.h commented examples.

cpu_perc() {
  ps -A -o %cpu | awk -v c="$(sysctl -n hw.ncpu)" '{s+=$1} END {printf "%.0f", s/c}'
}

ram_perc() {
  vm_stat | awk -v total="$(sysctl -n hw.memsize)" '
    /page size of/   { page = $8 }
    /Pages active/   { used += $3 }
    /Pages wired/    { used += $4 }
    /occupied by compressor/ { used += $5 }
    END { printf "%.0f", used * page * 100 / total }'
}

battery_perc() {
  pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%'
}

datetime() {
  date "+$1"
}

STATUS=""
add() { STATUS+=$(printf "$1" "$2"); }

add "cpu %s%% | " "$(cpu_perc)"
add "ram %s%% | " "$(ram_perc)"
BAT=$(battery_perc)   # skip module entirely on machines with no battery
[ -n "$BAT" ] && add "bat %s%% | " "$BAT"
add "%s"          "$(datetime '%F %T')"

sketchybar --set "$NAME" label="$STATUS" \
           --trigger title_resize
