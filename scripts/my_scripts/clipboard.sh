#!/bin/bash

# Clipboard manager using cliphist and rofi
# Requires: cliphist, rofi, wl-clipboard

ROFI_THEME="$HOME/.config/rofi/style-10.rasi"

if ! command -v cliphist >/dev/null 2>&1; then
    notify-send "Error" "cliphist not found. Please install it: yay -S cliphist"
    exit 1
fi

if ! command -v rofi >/dev/null 2>&1; then
    echo "Error: rofi not found"
    exit 1
fi

# Show clipboard history and copy selection
selected=$(cliphist list | rofi -dmenu -i -p "Clipboard History" -theme "$ROFI_THEME" -lines 10)

if [ -n "$selected" ]; then
    echo "$selected" | cliphist decode | wl-copy
    notify-send "Clipboard" "Copied to clipboard"
fi
