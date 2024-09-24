#!/bin/bash



device_paired=$(bluetoothctl info | grep Name | cut -f 2 | cut -d' '  -f 2)

icons=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
warning=30
critical=10

while true; do
    if bluetoothctl info > /dev/null 2>&1 ; then
    capacity=$(bluetoothctl info | grep "Battery Percentage" | cut -f 2 | cut -d' '  -f 4 | cut -d'(' -f 2 | cut -d')' -f 1)
    if [ "$capacity" -eq 100 ]; then
        echo "{\"text\": \"$capacity% 󰁹\", \"class\": \"full\"}"
    else
        if [ $capacity -le $warning ]; then
           echo "{\"text\": \"$device_paired - $capacity% ${icons[$(($capacity / 10))]}\"}"
        elif [ $capacity -le $critical ]; then
           echo "{\"text\": \"$device_paired - $capacity% ${icons[$(($capacity / 10))]}\"}"
        else
           echo "{\"text\": \"$device_paired - $capacity% ${icons[$(($capacity / 10))]}\"}"
        fi
    fi
    else
        echo "{\"text\": \"...\"}"
    fi
    sleep 2
done
