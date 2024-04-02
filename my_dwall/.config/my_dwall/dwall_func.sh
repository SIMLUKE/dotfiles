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
    local prev_hour=$(( (current_hour + 23) % 24 ))
    local next_hour=$(( (current_hour + 1) % 24 ))

    if [ "${prev_hour:0:1}" == "0" ]; then
        prev_hour="${prev_hour:1}"
    fi
    if [ "${next_hour:0:1}" == "0" ]; then
        next_hour="${next_hour:1}"
    fi
    if [ "${current_hour:0:1}" == "0" ]; then
        current_hour="${current_hour:1}"
    fi

    hyprctl hyprpaper unload "$config/$prev_hour.jpg"
    hyprctl hyprpaper preload "$config/$next_hour.jpg"
    hyprctl hyprpaper wallpaper ",$config/$current_hour.jpg"
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

    hyprctl hyprpaper preload "$config/$current_hour.jpg"
    hyprctl hyprpaper wallpaper ",$config/$current_hour.jpg"
}
