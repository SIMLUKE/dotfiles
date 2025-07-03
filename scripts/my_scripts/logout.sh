#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
# modified by SIMLUKE
## Applets : Power Menu

# Import Current Theme
theme="$HOME/.config/rofi/style-2POWER.rasi"

# Theme Elements
prompt="Uptime : $(uptime -p | sed -e 's/up //g')"

list_col='4'
list_row='1'

# Options
layout=$(cat $theme | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
    option_1=" Lock"
    option_2="󰍃 Logout"
    option_5=" Reboot"
    option_6=" Shutdown"
    yes=' Yes'
    no='X No'
else
    option_1=""
    option_2="󰍃"
    option_5=""
    option_6=""
    yes=''
    no='X'
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_5\n$option_6" | rofi_cmd
}

# Confirmation CMD
confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
        -theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme ${theme}
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Confirm and execute
confirm_run() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        ${1} && ${2} && ${3}
    else
        exit
    fi
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        playerctl pause
        swaylock -f
    elif [[ "$1" == '--opt2' ]]; then
        confirm_run 'hyprctl dispatch exit'
    elif [[ "$1" == '--opt5' ]]; then
        confirm_run 'systemctl reboot'
    elif [[ "$1" == '--opt6' ]]; then
        confirm_run 'systemctl poweroff'
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$option_1)
    run_cmd --opt1
    ;;
$option_2)
    run_cmd --opt2
    ;;
$option_5)
    run_cmd --opt5
    ;;
$option_6)
    run_cmd --opt6
    ;;
esac
