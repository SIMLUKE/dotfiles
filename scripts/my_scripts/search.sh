#!/bin/bash
# Rofi theme and message
rofi_theme="$HOME/.config/rofi/style-SEARCH.rasi"
msg='search via default web browser'

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

# Open Rofi and pass the selected query to xdg-open for Google search
query=$(echo "" | rofi -dmenu -config $rofi_theme -mesg "$msg")
if [ ! -z "$query" -a "$query" != " " ]; then
    echo $query | xargs -I{} xdg-open "https://www.google.com/search?q={}"
    hyprctl dispatch focuswindow class:zen
fi
