#!/usr/bin/env bash

logout='logout\t\t󰍃'
sleep='sleep\t\t󰒲'
reboot='reboot\t\t󰑓'
shutdown='shutdown\t󰐥'

logout_res='logout'
sleep_res='sleep'
reboot_res='reboot'
shutdown_res='shutdown'

case "$(printf "$logout\n$shutdown\n$reboot\n$sleep" | rofi -dmenu)" in
*"$logout_res"*) hyprctl dispatch exit ;;
*"$sleep_res"*) swaylock -f && systemctl suspend ;;
*"$reboot_res"*) reboot ;;
*"$shutdown_res"*) poweroff ;;
*"pipipopo"*) kitty -e yes pipipopo ;;
*) exit 1 ;;
esac

# case "$(printf "$logout\n$shutdown\n$reboot\n$sleep" | wofi -d -i -s ~/.config/wofi/power_wofi/style.css -c ~/.config/wofi/power_wofi/config)" in
# 	*"$logout_res"*) echo "found logout";;
# 	*"$sleep_res"*) echo "found sleep" ;;
# 	*"$reboot_res"*) echo "found reboot" ;;
# 	*"$shutdown_res"*) echo "found shutdown" ;;
# 	*)echo -E $res; exit 1 ;;
# esac
