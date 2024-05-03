#!/bin/bash

id=0
value=0
while [[ $value != "101" ]] ; do
    sleep 0.02
    id=$(notify-send "test" -r $id -h int:value:$value -p)
    value=$((value+1))
done
