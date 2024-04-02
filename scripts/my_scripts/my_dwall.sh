#!/bin/bash

config_file="wallpaper.conf"

if [ ! -f "$config_file" ]; then
    echo "Error: Configuration file '$config_file' not found."
    exit 1
fi

image_directory=$(cat "$config_file")

if [ ! -d "$image_directory" ]; then
    echo "Error: Image directory '$image_directory' not found."
    exit 1
fi
