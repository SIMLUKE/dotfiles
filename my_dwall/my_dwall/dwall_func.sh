#!/bin/bash

WP_COMMAND="swww img -t random"

function update_wallpaper() {
    local config_file="$HOME/.config/my_dwall/wallpaper.conf"
    local config="nothing"

    if [ -f "$config_file" ]; then
        config="$HOME/.config/my_dwall/images/$(cat "$config_file")"
    else
        if [ ! -d "$config"]; then
           echo "Error: image folder '$config' not found."
           exit 1
        fi
        echo "Error: Configuration file '$config_file' not found."
        exit 1
    fi

    local current_hour=$(date +%H)

    if [ "${current_hour:0:1}" == "0" ]; then
        current_hour="${current_hour:1}"
    fi

    if [ -f "$config/$current_hour.jpg" ]; then
        $WP_COMMAND "$config/$current_hour.jpg"
        cp "$config/$current_hour.jpg" ~/.config/my_dwall/current_wp.jpg
    fi
    if [ -f "$config/$current_hour.png" ]; then
        $WP_COMMAND "$config/$current_hour.png"
        cp "$config/$current_hour.png" ~/.config/my_dwall/current_wp.png
    fi
}
