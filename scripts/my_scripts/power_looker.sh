#!/bin/bash

level=0
battery_file=/sys/class/power_supply/BAT0/capacity
#battery_file=/tmp/test

while inotifywait -e modify $battery_file ; do
    level=$(cat $battery_file)
    if [ $level -lt 15 ] ; then
        notify-send -u critical "Battery is very low !!" -h int:value:$level -t 10000
    fi
done
