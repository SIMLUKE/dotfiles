#!/bin/bash

device_paired=$(bluetoothctl info | grep Name | cut -f 2 | cut -d' ' -f 2)
icons=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
warning=30
critical=10

while true; do
    if bluetoothctl info >/dev/null 2>&1; then
        capacity=$(bluetoothctl info | grep "Battery Percentage" | awk -F '[()%]' '{print $2}')
        if ! [[ -z "$capacity" ]]; then
            if [ "$capacity" -eq 100 ]; then
                echo "{\"text\": \"$device_paired-$capacity% 󰁹\"}"
            elif [ $capacity -le $warning ]; then
                echo "{\"text\": \"$device_paired-$capacity% ${icons[$(($capacity / 10))]}\"}"
            elif [ $capacity -le $critical ]; then
                echo "{\"text\": \"$device_paired-$capacity% ${icons[$(($capacity / 10))]}\"}"
            else
                echo "{\"text\": \"$device_paired-$capacity% ${icons[$(($capacity / 10))]}\"}"
            fi
        else
            echo "{\"text\": \"$device_paired\"}"
        fi
    else
        echo "{\"text\": \"...\"}"
    fi
    sleep 2
done
