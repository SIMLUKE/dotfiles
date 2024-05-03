#!/bin/bash
notify-send "Update started !"
yay -Y --sudoflags "-B" --save
notify-send "Update ended !"
