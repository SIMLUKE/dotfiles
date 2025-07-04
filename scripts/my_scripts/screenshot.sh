#!/bin/bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
# modified by SIMLUKE
## Applets : Screenshot

# Import Current Theme
theme="$HOME/.config/rofi/style-SCREENSHOT.rasi"

# Theme Elements
prompt='Screenshot'
mesg="DIR: $(xdg-user-dir PICTURES)/Screenshots"

list_col='1'
list_row='4'
win_width='150px'

# Options
layout=$(cat $theme | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
    option_1=" Capture Desktop"
    option_2=" Capture Area"
    option_3=" Capture Window"
    option_4="󰔝 Capture in 5s"
    option_5="󰔜 Capture in 10s"
else
    option_1=""
    option_2=""
    option_3=""
    option_4="󰔝"
    option_5="󰔜"
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_4\n$option_5" | rofi_cmd
}

# Screenshot
time=$(date +%Y-%m-%d_%H:%M:%S)
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="Screenshot_${time}.png"

if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
fi

# notify and view screenshot
notify_view() {
    notify-send -u low -i "$dir/$file" "Screenshot taken"
}

# Copy screenshot to clipboard
copy_shot() {
    cat "$dir/$file" | wl-copy
}

# countdown
countdown() {
    id=0
    for sec in $(seq $1 -1 1); do
        id=$(notify-send "Taking shot in : $sec" -p -r $id)
        sleep 1
    done
    pkill mako
}

# take shots
shotnow() {
    sleep 0.5 && grim "$dir/$file"
    copy_shot
    notify_view
}

shot5() {
    countdown '3'
    sleep 1 && grim "$dir/$file"
    copy_shot
    notify_view
}

shot10() {
    countdown '10'
    sleep 1 && grim "$dir/$file"
    copy_shot
    notify_view
}

shotwin() {
    cd ${dir} && maim -u -f png -i $(xdotool getactivewindow)
    copy_shot
    notify_view
}

shotarea() {
    grim -g "$(slurp -b e3eaf699)" "$dir/$file"
    copy_shot
    notify_view
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        shotnow
    elif [[ "$1" == '--opt2' ]]; then
        shotarea
    elif [[ "$1" == '--opt3' ]]; then
        shotwin
    elif [[ "$1" == '--opt4' ]]; then
        shot5
    elif [[ "$1" == '--opt5' ]]; then
        shot10
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
$option_3)
    run_cmd --opt3
    ;;
$option_4)
    run_cmd --opt4
    ;;
$option_5)
    run_cmd --opt5
    ;;
esac
