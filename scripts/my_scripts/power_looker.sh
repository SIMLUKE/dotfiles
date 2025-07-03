#!/bin/bash

level=0
battery_files=/sys/class/power_supply/BAT1/
#battery_files=./

function cooldown() {
    local countdown=60
    local id=0

    while [[ $countdown -gt 0 ]]; do
        id=$(notify-send -r $id -p -u critical "Critical Battery Level" \
            "Battery at $level%. Please plug in your charger! Shutting down in $countdown seconds.")
        ((countdown--))
        sleep 1

        level=$(cat "$battery_files/capacity")
        status=$(cat "$battery_files/status")

        if [[ $status == "Charging" ]]; then
            id=$(notify-send -r $id -p -u normal "Charging Detected" \
                "Battery level is $level%. Countdown canceled.")
            return
        fi
    done

    notify-send -u critical "Shutting Down" "Battery critically low. Shutting down now."
    shutdown now
}

id=0
while true; do
    level=$(cat "$battery_files/capacity")
    status=$(cat "$battery_files/status")

    if [[ $level -lt 5 && $status != "Charging" ]]; then
        cooldown
    elif [[ $level -lt 10 && $status != "Charging" ]]; then
        id=$(notify-send -r $id -p -u critical "Battery is very low !!" -h int:value:$level -t 100000)
        sleep 5
    else
        sleep 60
    fi
done
