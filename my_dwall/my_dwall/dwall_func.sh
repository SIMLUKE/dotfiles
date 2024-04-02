#!/bin/bash

hour_changed() {
    local current_hour=$(date +%H)
    sleep 5
    local new_hour=$(date +%H)
    [ "$current_hour" != "$new_hour" ]
}

update_wallpaper() {
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

    swww img "$config/$current_hour.jpg"
}

setup_wallpaper() {
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

    swww img "$config/$current_hour.jpg"
}
