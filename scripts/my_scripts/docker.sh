#!/bin/bash

e=false
f=false
z=false
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
LIGHT_CYAN="\e[96m"

print_usage() {
    printf "Usage:
    docker.sh
        -e | (epitech image) 
        -z | (enhanced epitech image)
        -f | (fedora image)
        -i   [dockerImageName](Dockerfile)
    [-v] [destination] (volume with the current directory)
    [-p] [port]
    [-n] (Network enabled or not)
    [-r] (Run as root)
"
}

v=
network=
image=
port=
user="--user $(id -u):$(id -g)"

while getopts efnzi:v:p: name; do
    case $name in
    e) e=true ;;
    f) f=true ;;
    z) z=true ;;
    r) user="" ;;
    i)
        i=true
        image="$OPTARG"
        ;;
    v) v="-v .:$OPTARG" ;;
    p) port="-p $OPTARG:$OPTARG" ;;
    n) network="--network none" ;;
    ?)
        print_usage
        exit 1
        ;;
    esac
done

run_args="$port $v $network $user"
echo $run_args

if [ "$e" = true ]; then
    docker run --rm $run_args -it epitechcontent/epitest-docker /bin/bash
    exit $?
fi

if [ "$i" = true ]; then
    docker build -t $image . && docker run $run_args -it $image
    exit $?
fi

if [ "$f" = true ]; then
    docker run --rm $run_args -it fedora /bin/bash
    exit $?
fi

if [ "$z" = true ]; then
    docker run --rm $run_args -it ziad0/enhanced-epitest /bin/bash
    exit $?
fi
