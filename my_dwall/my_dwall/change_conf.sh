#!/bin/bash

source ~/.config/my_dwall/dwall_func.sh

selected=$(find "$HOME/.config/my_dwall/images/" -mindepth 1 -maxdepth 1 -type d -print0 |
           while IFS= read -r -d '' dir; do
               if [ -f "$dir/12.png" ]; then
                   echo -en "img:$dir/12.png\x00icon\x1f$dir\n"
               elif [ -f "$dir/12.jpg" ]; then
                   echo -en "img:$dir/12.jpg\x00icon\x1f$dir\n"
               fi
           done |
           wofi -d -i -s ~/.config/wofi/wpp_wofi/style.css -c ~/.config/wofi/wpp_wofi/config)

echo $selected

if [ -n "$selected" ]; then
    dir_name=$(basename "$(dirname "$selected")")
    echo "$dir_name" > ~/.config/my_dwall/wallpaper.conf
    update_wallpaper
fi
