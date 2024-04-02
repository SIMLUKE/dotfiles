#!/bin/bash

source ~/.config/my_dwall/dwall_func.sh

setup_wallpaper

# Main loop
while true; do
    if hour_changed; then
        update_wallpaper
    fi
    sleep 60
done
