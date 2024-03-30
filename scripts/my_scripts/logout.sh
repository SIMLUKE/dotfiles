#!/usr/bin/env bash

case "$(printf "logout\nreboot\nshutdown\nsleep\n" | wofi --prompt " " --dmenu -i -H 250 -W 250 -x 0 -y 0 )" in
	'logout') hyprctl dispatch exit;;
	'sleep') swaylock -f && systemctl suspend ;;
	'reboot') reboot ;;
	'shutdown') poweroff ;;
	*) exit 1 ;;
esac
