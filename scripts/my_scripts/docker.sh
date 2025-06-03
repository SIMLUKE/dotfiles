#!/bin/bash
# Specify destination folder to mount your project into docker

e=false
f=false
z=false
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
LIGHT_CYAN="\e[96m"
DEST_FOLDER=/usr/app

print_usage() {
    printf "Usage:
    -e epitech image
    -z enhanced epitech image
    -f fedora image
"
}

while getopts ':efz' flag; do
    case "${flag}" in
    e) e=true ;;
    f) f=true ;;
    z) z=true ;;
    *)
        print_usage
        exit 1
        ;;
    esac
done

if [ "$e" = true ]; then
    docker run -p 4242:4242 --rm -v ".:$DEST_FOLDER" -it epitechcontent/epitest-docker /bin/bash
fi

if [ "$f" = true ]; then
    docker run --rm -v ".:$DEST_FOLDER" -it fedora /bin/bash
fi

if [ "$z" = true ]; then
    docker run --rm -v ".:$DEST_FOLDER" -it ziad0/enhanced-epitest /bin/bash
fi
