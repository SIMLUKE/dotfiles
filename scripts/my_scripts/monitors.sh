#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/style-MONITORS.rasi"
ROFI_PROMPT="Monitor"

get_monitors() {
    hyprctl monitors -j | jq -r '.[] | "\(.name) - \(.width)x\(.height)@\(.refreshRate)Hz (\(.make) \(.model))"' 2>/dev/null ||
        hyprctl monitors | grep -E "^Monitor" | sed 's/Monitor //' | cut -d' ' -f1
}

get_monitor_modes() {
    local monitor="$1"
    hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor\") | .availableModes[] | \"\(.width)x\(.height)@\(.refreshRate)Hz\"" 2>/dev/null ||
        echo "1920x1080@60Hz
1920x1080@75Hz
2560x1440@144Hz
2256x1504@60Hz
3840x2160@60Hz"
}

show_monitor_menu() {
    local options="󰍹 List Monitors
󰹑 Enable All Monitors
󰹐 Disable All External
󱎴 Mirror Displays
󰘶 Extend Displays
󰑓 Rotate Display
󰌪 Change Resolution
󰐥 Auto-arrange
󰒓 Save Layout
󰁯 Load Layout
󰄉 Reload Config"

    echo "$options" | rofi -dmenu -i -p "$ROFI_PROMPT" -theme "$ROFI_THEME" -lines 11
}

list_monitors() {
    local monitor_info
    monitor_info=$(hyprctl monitors -j | jq -r '.[] | "\(.name):\(.width)x\(.height)@\(.refreshRate)Hz \(.make)\(.model)_Scale:\(.scale)Position:\(.x),\(.y)"' 2>/dev/null)

    if [[ -z "$monitor_info" ]]; then
        monitor_info=$(hyprctl monitors | awk '
        /^Monitor/ { 
            name = $2
            getline; if(/^\s*[0-9]+x[0-9]+/) { res = $1 }
            getline; if(/^\s*[0-9]+\.[0-9]+/) { scale = $1 }
            getline; if(/^\s*[0-9]+,[0-9]+/) { pos = $1 }
            print name ": " res " - Scale: " scale " - Position: " pos
        }')
    fi

    notify-send $(echo "$monitor_info" | rofi -dmenu -i -p "Monitor Info" -theme "$ROFI_THEME" -lines 10)
}

select_monitor() {
    local monitors
    monitors=$(get_monitors)
    echo "$monitors" | rofi -dmenu -i -p "Select Monitor" -theme "$ROFI_THEME"
}

enable_all_monitors() {
    local monitors
    monitors=$(hyprctl monitors -j | jq -r '.[].name' 2>/dev/null || hyprctl monitors | grep -E "^Monitor" | sed 's/Monitor //' | cut -d' ' -f1)

    while IFS= read -r monitor; do
        [[ -n "$monitor" ]] && hyprctl keyword monitor "$monitor,preferred,auto,1"
    done <<<"$monitors"

    notify-send "Monitor Manager" "All monitors enabled"
}

disable_external() {
    local monitors
    monitors=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1" and .name != "LVDS-1") | .name' 2>/dev/null)

    while IFS= read -r monitor; do
        [[ -n "$monitor" ]] && hyprctl keyword monitor "$monitor,disable"
    done <<<"$monitors"

    notify-send "Monitor Manager" "External monitors disabled"
}

mirror_displays() {
    local primary_monitor
    primary_monitor=$(hyprctl monitors -j | jq -r '.[0].name' 2>/dev/null || echo "eDP-1")

    local monitors
    monitors=$(hyprctl monitors -j | jq -r '.[] | select(.name != "'$primary_monitor'") | .name' 2>/dev/null)

    while IFS= read -r monitor; do
        [[ -n "$monitor" ]] && hyprctl keyword monitor "$monitor,preferred,0x0,1,mirror,$primary_monitor"
    done <<<"$monitors"

    notify-send "Monitor Manager" "Displays mirrored to $primary_monitor"
}

extend_displays() {
    local x_offset=0
    local monitors
    monitors=$(hyprctl monitors -j | jq -r '.[].name' 2>/dev/null || hyprctl monitors | grep -E "^Monitor" | sed 's/Monitor //' | cut -d' ' -f1)

    while IFS= read -r monitor; do
        if [[ -n "$monitor" ]]; then
            hyprctl keyword monitor "$monitor,preferred,${x_offset}x0,1"
            x_offset=$((x_offset + 1920))
        fi
    done <<<"$monitors"

    notify-send "Monitor Manager" "Displays extended"
}

rotate_display() {
    local monitor
    monitor=$(select_monitor | cut -d' ' -f1)
    [[ -z "$monitor" ]] && return

    local rotations="Normal (0°)
90° Clockwise
180° Upside Down
270° Counter-clockwise"

    local rotation
    rotation=$(echo "$rotations" | rofi -dmenu -i -p "Rotate $monitor" -theme "$ROFI_THEME")

    case "$rotation" in
    "Normal (0°)")
        hyprctl keyword monitor "$monitor,preferred,auto,1,transform,0"
        ;;
    "90° Clockwise")
        hyprctl keyword monitor "$monitor,preferred,auto,1,transform,1"
        ;;
    "180° Upside Down")
        hyprctl keyword monitor "$monitor,preferred,auto,1,transform,2"
        ;;
    "270° Counter-clockwise")
        hyprctl keyword monitor "$monitor,preferred,auto,1,transform,3"
        ;;
    esac

    [[ -n "$rotation" ]] && notify-send "Monitor Manager" "$monitor rotated to $rotation"
}

change_resolution() {
    local monitor
    monitor=$(select_monitor | cut -d' ' -f1)
    [[ -z "$monitor" ]] && return

    local modes
    modes=$(get_monitor_modes "$monitor")

    local resolution
    resolution=$(echo "$modes" | rofi -dmenu -i -p "Resolution for $monitor" -theme "$ROFI_THEME")
    [[ -z "$resolution" ]] && return

    hyprctl keyword monitor "$monitor,$resolution,auto,1"
    notify-send "Monitor Manager" "$monitor resolution changed to $resolution"
}

auto_arrange() {
    hyprctl keyword monitor ",preferred,auto,1"
    notify-send "Monitor Manager" "Monitors auto-arranged"
}

save_layout() {
    local layout_file="$HOME/.config/hypr/monitor_layouts.conf"
    local layout_name
    layout_name=$(echo "" | rofi -dmenu -i -p "Layout name" -theme "$ROFI_THEME")
    [[ -z "$layout_name" ]] && return

    mkdir -p "$(dirname "$layout_file")"
    echo "# Layout: $layout_name - $(date)" >>"$layout_file"
    hyprctl monitors -j | jq -r '.[] | "monitor = \(.name),\(.width)x\(.height)@\(.refreshRate),\(.x)x\(.y),1"' >>"$layout_file" 2>/dev/null ||
        hyprctl monitors | grep -E "^Monitor" | while read -r line; do
            echo "# $line" >>"$layout_file"
        done
    echo "" >>"$layout_file"

    notify-send "Monitor Manager" "Layout '$layout_name' saved"
}

load_layout() {
    local layout_file="$HOME/.config/hypr/monitor_layouts.conf"
    [[ ! -f "$layout_file" ]] && {
        notify-send "Monitor Manager" "No saved layouts found"
        return
    }

    local layouts
    layouts=$(grep "# Layout:" "$layout_file" | sed 's/# Layout: //')
    [[ -z "$layouts" ]] && {
        notify-send "Monitor Manager" "No layouts available"
        return
    }

    local selected_layout
    selected_layout=$(echo "$layouts" | rofi -dmenu -i -p "Load Layout" -theme "$ROFI_THEME")
    [[ -z "$selected_layout" ]] && return

    notify-send "Monitor Manager" "Layout loading feature requires manual implementation"
}

reload_config() {
    hyprctl reload
    notify-send "Monitor Manager" "Hyprland config reloaded"
}

main() {
    if ! command -v hyprctl >/dev/null 2>&1; then
        notify-send "Error" "hyprctl not found. Are you running Hyprland?"
        exit 1
    fi

    if ! command -v rofi >/dev/null 2>&1; then
        echo "Error: rofi not found"
        exit 1
    fi

    local selection
    selection=$(show_monitor_menu)

    case "$selection" in
    "󰍹 List Monitors")
        list_monitors
        ;;
    "󰹑 Enable All Monitors")
        enable_all_monitors
        ;;
    "󰹐 Disable All External")
        disable_external
        ;;
    "󱎴 Mirror Displays")
        mirror_displays
        ;;
    "󰘶 Extend Displays")
        extend_displays
        ;;
    "󰑓 Rotate Display")
        rotate_display
        ;;
    "󰌪 Change Resolution")
        change_resolution
        ;;
    "󰐥 Auto-arrange")
        auto_arrange
        ;;
    "󰒓 Save Layout")
        save_layout
        ;;
    "󰁯 Load Layout")
        load_layout
        ;;
    "󰄉 Reload Config")
        reload_config
        ;;
    *)
        exit 0
        ;;
    esac
}

main "$@"
