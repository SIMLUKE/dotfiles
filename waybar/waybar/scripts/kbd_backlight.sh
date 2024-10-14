#!/bin/bash

brightness=$(cat /sys/class/leds/dell::kbd_backlight/brightness)

if [ $brightness -ne 0 ]; then
    echo 2 > /sys/class/leds/dell::kbd_backlight/brightness
else
    echo 0 > /sys/class/leds/dell::kbd_backlight/brightness
fi
