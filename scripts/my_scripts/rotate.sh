#!/usr/bin/env bash

rotate_left='rotate left'
rotate_right='rotate right'
rotate_normal='rotate normal'
rotate_reverse='rotate reverse'

rotate_left_res='left'
rotate_right_res='right'
rotate_normal_res='normal'
rotate_reverse_res='reverse'

case "$(printf "$rotate_left\n$rotate_reverse\n$rotate_normal\n$rotate_right" | wofi -d -i -s ~/.config/wofi/power_wofi/style.css -c ~/.config/wofi/power_wofi/config)" in
	*"$rotate_left_res"*) wlr-randr --output eDP-1 --transform 270;;
	*"$rotate_right_res"*) wlr-randr --output eDP-1 --transform 90 ;;
	*"$rotate_normal_res"*) wlr-randr --output eDP-1 --transform normal ;;
	*"$rotate_reverse_res"*) wlr-randr --output eDP-1 --transform 180 ;;
	*"pipipopo"*) kitty -e yes pipipopo ;;
	*) exit 1 ;;
esac
