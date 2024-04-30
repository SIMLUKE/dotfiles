#!/bin/bash
# Specify destination folder to mount your project into docker

e=false
f=false
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
LIGHT_CYAN="\e[96m"
DEST_FOLDER=/home/student/

print_usage() {
    printf "Usage:\n\t-b : keeps the result files\n\t-v --verbose : debug variables\n"
}

while getopts ':ef' flag; do
    case "${flag}" in
        e) e=true ;;
        f) f=true ;;
        *) print_usage
           exit 1 ;;
    esac
done

if [ "$e" = true ] ; then
    docker run --rm -v ".:$DEST_FOLDER" -it epitechcontent/epitest-docker /bin/bash -c 'useradd student && su - student'
fi

if [ "$f" = true ] ; then
    docker run --rm -v ".:$DEST_FOLDER" -it fedora /bin/bash -c 'useradd student && su - student'
fi
