if [[ $1 == "-h" ]]; then
   echo './connect "wifi-name" "email" "password"'
   exit
fi
echo "$1" "$2" "$3"
nmcli connection add type wifi con-name "$1" ifname wlan0 ssid "$1" wifi-sec.key-mgmt wpa-eap 802-1x.eap peap 802-1x.identity "$2" 802-1x.password "$3" 802-1x.phase2-auth mschapv2
