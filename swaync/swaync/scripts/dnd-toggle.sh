#!/bin/bash

state=$(swaync-client -D)
if [ $state == "true" ]; then
    swaync-client -df
else
    swaync-client -dn
fi
