#!/bin/bash

CONFIG_FILES="$HOME/.config/waybar/config $HOME/.config/waybar/style.css $HOME/.config/waybar/modules.json $HOME/.config/colors/colors.sh"
source ~/.config/colors/colors.sh

while true; do
    waybar &
    inotifywait -e create,modify $CONFIG_FILES
    killall waybar
done
