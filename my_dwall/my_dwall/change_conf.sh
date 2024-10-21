#!/bin/bash

source ~/.config/my_dwall/dwall_func.sh

selected=$(
    find "$HOME/.config/my_dwall/images/" -mindepth 1 -maxdepth 1 -type d -print0 |
        while IFS= read -r -d '' dir; do
            if [ -f "$dir/12.png" ]; then
                echo -en "$(basename $dir)/\0icon\x1f$dir/12.png\n"
            elif [ -f "$dir/12.jpg" ]; then
                echo -en "$(basename $dir)/\0icon\x1f$dir/12.jpg\n"
            fi
        done | rofi -dmenu -theme ~/.config/rofi/style-10WALL.rasi
)
echo $selected

if [ -n "$selected" ]; then
    #dir_name=$(basename "$(dirname "$selected")")
    dir_name=$selected
    echo "$dir_name" >~/.config/my_dwall/wallpaper.conf
    update_wallpaper
fi
