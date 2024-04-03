#!/bin/bash

source ~/.config/my_dwall/dwall_func.sh

selected=$(find "$HOME/.config/my_dwall/images/" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort -R | while read rdir
           do
               echo -en "$rdir\x00icon\x1f$HOME/.config/my_dwall/images/${rdir}\n"
           done | wofi --prompt "Select Wallpaper Directory: " --dmenu -i -H 700 -W 250 -x 0 -y 0)

if [ ! "$selected" ]; then
    echo "No wallpaper directory selected"
    exit
fi

echo "$selected" > ~/.config/my_dwall/wallpaper.conf

update_wallpaper
