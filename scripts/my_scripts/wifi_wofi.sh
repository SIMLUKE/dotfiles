#!/usr/bin/env bash

# Copyright © 2024 Jesús Arenas

# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program.
# If not, see <https://www.gnu.org/licenses/>.

usage () {
	echo -en "\
Usage: $(basename $0) [OPTIONS...]

Displays a menu with a launcher to select a Wi-Fi network.

Options:
  -s, --submenu               Show Wi-Fi options in a submenu.

  -i INTERFACE
  --interface INTERFACE       Start using Wi-Fi interface INTERFACE.

  --wofi                      Use wofi launcher (default).
  --rofi                      Use rofi launcher.
  --wmenu                     Use wmenu launcher.
  --dmenu                     Use dmenu launcher.
  --bemenu                    Use bemenu launcher.

  -h, --help                  Print this help and exit.
  -v, --version               Print version and exit.

Nerd Fonts icons are used. A font can be downloaded at:
https://www.nerdfonts.com/

Dependencies:
  - NetworkManager.
  - At least one launcher of: wofi, rofi, wmenu, dmenu, bemenu.

About dmenu:
  Hide password button does not work, since dmenu does not support this.

Exit status:
  Returns 1 if a bad option is given.
  Returns 2 if no Wi-Fi interface is detected with nmcli.
  Returns 0 otherwise.

This program is licensed under GPL-3.0-or-later.
"
	exit
}

about () {
	echo -en "\
wifimenu 2.1
Copyright © 2024 Jesús Arenas
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
"
	exit
}

display-menu () {
	# You can edit launcher options or add more launchers
	form=$1
	prompt="$2"

	case $launcher in
		"wofi")
			case $form in
				1) wofi --dmenu --insensitive --prompt "$prompt" ;;
				2) wofi --dmenu --prompt "$prompt" ;;
				3) wofi --dmenu --password --prompt "$prompt" ;;
			esac
			;;
		"rofi")
			case $form in
				1) rofi -dmenu -i -p "$prompt" ;;
				2) rofi -dmenu -p "$prompt" ;;
				3) rofi -dmenu -password -p "$prompt" ;;
			esac
			;;
		"wmenu")
			case $form in
				1) wmenu -l 10 -i -p "$prompt" ;;
				2) wmenu -l 10 -p "$prompt" ;;
				3) wmenu -l 10 -P -p "$prompt" ;;
			esac
			;;
		"dmenu")
			case $form in
				1) dmenu -l 10 -i -p "$prompt" ;;
				2) dmenu -l 10 -p "$prompt" ;;
				3) dmenu -l 10 -p "$prompt" ;; # Cannot hide the password
			esac
			;;
		"bemenu")
			case $form in
				1) bemenu --list 10 --ignorecase --prompt "$prompt" ;;
				2) bemenu --list 10 --prompt "$prompt" ;;
				3) bemenu --list 10 --password "indicator" --prompt "$prompt" ;;
			esac
			;;
		*)
			echo "$(basename $0): Bad launcher. See variable 'launcher'." >&2
			exit 1
			;;
	esac
}

ask-password () {
	middle_option=${1:-}
	wifi_password="󰛐"
	until [[ -z "$wifi_password" || "$wifi_password" =~ ^[^󰛑󰛐] ]]; do
		if [[ "$wifi_password" =~ ^󰛑 ]]; then
			wifi_password=$(echo -e "󰛐${middle_option}\n" | display-menu 3 "$tr_ask_password_prompt")
		else
			wifi_password=$(echo -e "󰛑${middle_option}\n" | display-menu 2 "$tr_ask_password_prompt")
		fi
	done
	echo "$wifi_password"
}

select-interface () {
	chosen=$( (for (( i = 0; i < ${#interfaces[@]}; i++ )); do echo "󰾲  ${interfaces[$i]}" ; done; echo "") | display-menu 1 "$tr_select_interface_prompt")

	if [ -z "$chosen" ]; then
		exit
	elif [[ "$chosen" =~ ^ ]]; then
		return
	else
		interface_to_use="${chosen:3}"
	fi
}

connect-hidden () {
	wifi_name=$(echo ""| display-menu 2 "$tr_connect_hidden_prompt")

	if [ -z "$wifi_name" ]; then
		exit
	elif [[ "$wifi_name" =~ ^ ]]; then
		return
	fi

	wifi_password=$(ask-password "\n")

	if [ -z "$wifi_password" ]; then
		exit
	elif [[ "$wifi_password" =~ ^ ]]; then
		wifi_password=""
	elif [[ "$wifi_password" =~ ^ ]]; then
		return
	fi

	nmcli device wifi connect "$wifi_name" hidden yes password "$wifi_password"
}

forget-connection () {

	mapfile -t connections_list < <( echo "$(nmcli --colors no --get-values TYPE,NAME connection show)" | awk -F ':' '$1 == "802-11-wireless" {print $2}' )

	for (( i = 0; i < ${#connections_list[@]}; i++ )); do
		id_interface=$(nmcli --colors no --get-values connection.interface-name connection show "${connections_list[$i]}")
		if [ "$id_interface" != "$interface_to_use" ]; then
			connections_list[$i]="${connections_list[$i]} ($id_interface)\0${connections_list[$i]}"
		else
			connections_list[$i]="${connections_list[$i]}\0${connections_list[$i]}"
		fi
		connections_list[$i]="󰑩  ${connections_list[$i]}"
	done

	chosen=$( (for (( i = 0; i < ${#connections_list[@]}; i++ )); do echo -e "${connections_list[$i]}" ; done; echo "") | cut --delimiter=$'\0' --fields=1 | display-menu 1 "$tr_forget_connection_prompt")

	if [ -z "$chosen" ]; then
		exit
	elif [[ "$chosen" =~ ^ ]]; then
		return
	fi

	sure=$(echo -e "\n" | display-menu 1 "$tr_forget_connection_sure_prompt_1 ${chosen:3}$tr_forget_connection_sure_prompt_2")

	if [ -z "$sure" ]; then
		exit
	elif [[ "$sure" =~ ^ ]]; then
		for (( i = 0; i < ${#connections_list[@]}; i++ )); do
			if [ "$chosen" = "$(echo -e "${connections_list[$i]}" | cut --delimiter=$'\0' --fields=1)" ]; then
				nmcli connection delete id "$(echo -e "${connections_list[$i]}" | cut --delimiter=$'\0' --fields=2)"
				break
			fi
		done
	fi
}

connect-wifi () {
	wifi_security=${1:0:1}
	wifi_ssid=${1:3}

	mapfile -t connections_matching < <( echo "$(nmcli --colors no --get-values NAME connection show)" | grep --color=never --word-regexp "$wifi_ssid" )

	for (( i = 0; i < ${#connections_matching[@]}; i++ )); do
		if [ $(nmcli --colors no --get-values connection.interface-name connection show "${connections_matching[$i]}") = "$interface_to_use" ]; then
			if [[ "$wifi_security" =~ ^ ]]; then
				nmcli connection down id "${connections_matching[$i]}"
			else
				nmcli connection up id "${connections_matching[$i]}" ifname "$interface_to_use"
			fi
			exit
		fi
	done

	if [[ "$wifi_security" =~ ^[󰤪󰤤󰤡] ]]; then
		wifi_password=$(ask-password)
		if [ -z "$wifi_password" ]; then
			exit
		elif [[ "$wifi_password" =~ ^ ]]; then
			return
		fi
	fi
	nmcli device wifi connect "$wifi_ssid" ifname "$interface_to_use" password "$wifi_password"

	exit
}

get-main-options () {
	connection_state=$(nmcli --colors no --get-values WIFI general)
	[ ${#interfaces[@]} -gt 1 ] && interface_message="󰾲  $tr_interface_message $interface_to_use\n"

	if [ "$connection_state" = "disabled" ]; then
		echo -e "$enable_message\n$forget_message"
	elif [ "$connection_state" = "enabled" ]; then

		if [ -n "$scan" ]; then
			if [ -n "$submenu" ]; then
				echo "$submenu_message"
			else
				echo -e "$disable_message\n${interface_message:-}$hidden_message\n$forget_message"
			fi
		else
			echo -e "$submenu_close_message\n$disable_message\n${interface_message:-}$hidden_message\n$forget_message"
		fi

	fi
}

############################################################ MAIN ############################################################

# For translation or customization (for editing). You can edit the help message in usage function too
tr_scanning_networks="Scanning networks"
tr_scanning_networks_complete="Scanning completed"
tr_submenu_message="More options"
tr_submenu_close_message="Close options"
tr_disable_message="Disable Wi-Fi"
tr_enable_message="Enable Wi-Fi"
tr_hidden_message="Connect to a hidden network"
tr_forget_message="Forget connection"
tr_interface_message="Interface:"
tr_main_menu_prompt="Wi-Fi SSID:"
tr_select_interface_prompt="Interface to use:"
tr_connect_hidden_prompt="Network name:"
tr_ask_password_prompt="Password:"
tr_forget_connection_prompt="Connection to forget:"
tr_forget_connection_sure_prompt_1="Forget"
tr_forget_connection_sure_prompt_2="?"

# Not to edit (unless you want to change Nerd Font characters, but then change all equal characters in the script)
submenu_message="  $tr_submenu_message"
submenu_close_message="  $tr_submenu_close_message"
disable_message="󰖪  $tr_disable_message"
enable_message="󰖩  $tr_enable_message"
hidden_message="󰛐  $tr_hidden_message"
forget_message="  $tr_forget_message"

# Detecting Wi-Fi interfaces and add them to the array
mapfile -t interfaces < <(nmcli --colors no --get-values TYPE,DEVICE device status | awk -F ':' '$1 == "wifi" {print $2}')
if [ -z "${interfaces[0]}" ]; then
	echo "$(basename $0): No Wi-Fi interfaces detected." >&2
	exit 2
fi

# Default launcher (for editing)
launcher="wofi"
# Default menu display. Set variable to anything for submenu options (for editing)
submenu=
# Default interface (edit on your risk, if you know your hardware, or use --interface option instead)
interface_to_use="${interfaces[0]}"
# Shows wifi_list. If unset, shows submenu options (you can unset it if you want, but only make more sense to unset when using submenu)
scan=1

# Options
while [ -n "$1" ]; do
	case "$1" in
		"-h" | "--help") usage ;;
		"-v" | "--version") about ;;
		"-s" | "--submenu") submenu=1 ;;
		"-i" | "--interface")
			if [ ! $(nmcli --colors no --get-values TYPE,DEVICE device status | awk -F ':' '$1 == "wifi" {print $2}' | grep --word-regexp "$2") ]; then
				echo "$(basename $0): Bad interface given: $2" >&2
				exit 2
			fi
			interface_to_use="$2"
			shift
			;;
		"--wofi") launcher="wofi" ;;
		"--rofi") launcher="rofi" ;;
		"--wmenu") launcher="wmenu" ;;
		"--dmenu") launcher="dmenu" ;;
		"--bemenu") launcher="bemenu" ;;
		*) echo "$(basename $0): Bad option given. See usage with -h or --help." >&2 ; exit 1 ;;
	esac
	shift
done

# Main cicle
while true; do

	if [ -n "$scan" ]; then

		echo "$tr_scanning_networks"
		wifi_list=$(nmcli --colors no --get-values SECURITY,SIGNAL,SSID,IN-USE device wifi list --rescan auto ifname $interface_to_use | awk -F ':' '
		$3 {
		if ($1 ~ /^WPA/)
			if ($2 > 80)
				sub($1, "󰤪")
			else if ($2 > 60)
				sub($1, "󰤤")
			else
				sub($1, "󰤡")
		else if ($1 == "")
			if ($2 > 80)
				sub($1, "󰤨")
			else if ($2 > 60)
				sub($1, "󰤢")
			else
				sub($1, "󰤟")
		if ($4 == "*")
			sub($1, "")
		print $1 "  " $3
		}
		')
		echo "$tr_scanning_networks_complete"

	fi

	chosen=$(echo -e "$(get-main-options)${scan:+${wifi_list:+\n}$wifi_list}" | display-menu 1 "$tr_main_menu_prompt")

	case "$chosen" in
		'') exit ;;
		""*) unset scan ;;
		""*) scan=1 ;;
		"󰖩"*) nmcli radio wifi on ; exit ;;
		"󰖪"*) nmcli radio wifi off ; exit ;;
		"󰾲"*) select-interface ;;
		"󰛐"*) connect-hidden ;;
		""*) forget-connection ;;
		*) connect-wifi "$chosen" ;;
	esac

done
