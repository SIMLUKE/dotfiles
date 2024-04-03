#!/bin/bash

source ~/.config/my_dwall/dwall_func.sh

current_hour=$(date +%H)

update_wallpaper

while true; do
    hour=$(date +%H)

    if [ "$hour" != "$current_hour" ]; then
        update_wallpaper
        current_hour=$hour
    fi

    sleep 60
done
