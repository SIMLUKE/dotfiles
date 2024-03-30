#!/usr/bin/env bash

if [ ! -d $HOME/Pictures/Screenshots ]
then
	mkdir -p $HOME/Pictures/Screenshots
fi

fullscreen() {
	filename=$HOME/Pictures/Screenshots/$(date +%Y%m%d_%H:%M:%S_Fullscreen).png
	grim $filename
	cat $filename | wl-copy \
	&& notify-send -i $filename "Fullscreen Screenshot taken"
	}

selecting() {
	filename=$HOME/Pictures/Screenshots/$(date +%Y%m%d_%H:%M:%S_Selected).png
	grim -g "$(slurp -b e3eaf699)" $filename \
	&& notify-send -i $filename "Selective Screenshot taken"
	cat $filename | wl-copy
	}

wofirun() {
	case "$(printf "fullscreen\nselect\n" | wofi --dmenu -p "Screenshot" -i -H 500 -W 250 -x 0 -y 0 )" in
		'fullscreen')fullscreen;;
		'select')selecting;;
	esac
}

helpscreen() {
	echo "Usage: screenshot [-f] [-s] [-w] [-h] "
	echo "Options:"
	echo "-f : Fullscreen screenshot"
	echo "-s : Select a region for the screenshot"
	echo "-w : Shows a wofi prompt for screenshot"
	echo "-h : Shows this fucking help menu"
	echo "If no flags are selected then -f is chosen"
}
case $1 in
	-f)fullscreen;;
	-s)selecting;;
	-h)helpscreen;;
	-w)wofirun;;
	*)fullscreen;;
esac
