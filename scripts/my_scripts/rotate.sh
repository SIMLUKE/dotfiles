#!/usr/bin/env bash

rotate_left=' '
rotate_right=' '
rotate_reverse=' '
rotate_normal='󱡶 '

rotation=$(printf "$rotate_left\n$rotate_right\n$rotate_reverse\n$rotate_normal" | rofi -dmenu \
    -theme $HOME/.config/rofi/style-SCREENSHOT.rasi \
    -theme-str "listview {columns: 1; lines: 4;}" \
    -theme-str "window {width: 110;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -markup-rows)

monitor="eDP-1"

scale="2"

function left() {
    hyprctl keyword monitor $monitor,preferred,auto,$scale,transform,1
}
function rigth() {
    hyprctl keyword monitor $monitor,preferred,auto,$scale,transform,3
}
function reverse() {
    hyprctl keyword monitor $monitor,preferred,auto,$scale,transform,2
}
function normal() {
    hyprctl keyword monitor $monitor,preferred,auto,$scale,transform,0
}

case "$rotation" in
" ")
    left
    ;;
" ")
    rigth
    ;;
" ")
    reverse
    ;;
"󱡶 ")
    normal
    ;;
*)
    exit 1
    ;;
esac
