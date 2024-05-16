#!/bin/bash

level=0
battery_files=/sys/class/power_supply/BAT0/
#battery_file=/tmp/test

while true #inotifywait -e modify $battery_file
do
    level=$(cat "$battery_files/capacity")
    status=$(cat "$battery_files/status")

    if [[ $level -lt 10 && $status != "Charging" ]]; then
        notify-send -u critical "Battery is very low !!" -h int:value:$level -t 100000
    fi
    sleep 60
done
