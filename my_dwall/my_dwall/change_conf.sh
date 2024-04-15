#!/bin/bash

source ~/.config/my_dwall/dwall_func.sh

selected=$(find "$HOME/.config/my_dwall/images/" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort -R | while read rdir
           do
               echo -en "$rdir\x00icon\x1f$HOME/.config/my_dwall/images/${rdir}\n"
           done | wofi -d -i -s ~/.config/wofi/wpp_wofi/style.css -c ~/.config/wofi/wpp_wofi/config)

if [ ! "$selected" ]; then
    echo "No wallpaper directory selected"
    exit
fi

echo "$selected" > ~/.config/my_dwall/wallpaper.conf

update_wallpaper
