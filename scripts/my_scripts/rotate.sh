#!/usr/bin/env bash

rotate_left='rotate left'
rotate_right='rotate right'
rotate_normal='rotate normal'
rotate_reverse='rotate reverse'

rotate_left_res='left'
rotate_right_res='right'
rotate_normal_res='normal'
rotate_reverse_res='reverse'

case "$(printf "$rotate_left\n$rotate_reverse\n$rotate_normal\n$rotate_right" | rofi -dmenu)" in
*"$rotate_left_res"*) hyprctl keyword monitor eDP-1,preferred,auto,2,transform,1 ;;
*"$rotate_right_res"*) hyprctl keyword monitor eDP-1,preferred,auto,2,transform,3 ;;
*"$rotate_normal_res"*) hyprctl keyword monitor eDP-1,preferred,auto,2,transform,0 ;;
*"$rotate_reverse_res"*) hyprctl keyword monitor eDP-1,preferred,auto,2,transform,2 ;;
*"pipipopo"*) kitty -e yes pipipopo ;;
*) exit 1 ;;
esac
