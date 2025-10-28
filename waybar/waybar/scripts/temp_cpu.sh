#!/bin//bash

warning=85
critical=95
id=0

while true; do
    capacity=$(sensors | grep temp4: | grep -oP '\+\d+\.\d+°C' | head -n 1 | awk -F'[+.°C]' '{print $2}')
    if ! [[ -z "$capacity" ]]; then
        if [ $capacity -ge $warning ]; then
            echo "{\"text\": \"󰻠 $capacity°C \"}"
        elif [ $capacity -ge $critical ]; then
            echo "{\"text\": \"󰻠 $capacity°C \"}"
            id=$(notify-send -u critical -r $id -p "Warning" "CPU temperature: +$capacity°C")
        else
            echo "{\"text\": \"󰻠 $capacity°C \"}"
        fi
    else
        echo "{\"text\": \"󰻠 ?\"}"
    fi
    sleep 2
done
