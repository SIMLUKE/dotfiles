#!/bin/bash

icons=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
warning=30
critical=10

BATTERY_FILES="/sys/class/power_supply/BAT0/status /sys/class/power_supply/BAT0/capacity"

annimation() {
    for icon in "${icons[@]}"; do
        echo "{\"text\": \"$capacity% $icon\", \"class\": \"charging\"}"
        sleep 0.2
    done
}

while true; do
    status=$(cat /sys/class/power_supply/BAT0/status)
    capacity=$(cat /sys/class/power_supply/BAT0/capacity)
    if [ "$capacity" -eq 100 ]; then
        echo "{\"text\": \"$capacity% 󰁹\", \"class\": \"full\"}"
    elif [ "$status" = "Charging" ]; then
        annimation
    else
        if [ $capacity -le $warning ]; then
           echo "{\"text\": \"$capacity% ${icons[$(($capacity / 10))]}\", \"class\": \"discharging\"}"
        elif [ $capacity -le $critical ]; then
           echo "{\"text\": \"$capacity% ${icons[$(($capacity / 10))]}\", \"class\": \"discharging\"}"
        else
           echo "{\"text\": \"$capacity% ${icons[$(($capacity / 10))]}\", \"class\": \"discharging\"}"
        fi
        sleep 2
    fi
    sleep 2
done
