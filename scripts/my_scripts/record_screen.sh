#!/usr/bin/env bash

# Toggle screen recording with wf-recorder

OUTPUT_DIR="$(xdg-user-dir VIDEOS 2>/dev/null || echo "$HOME/Videos")/Recordings"
PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/wf-recorder-toggle.pid"

mkdir -p "$OUTPUT_DIR"

# If already recording, stop it
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    kill -INT "$(cat "$PIDFILE")" 2>/dev/null || kill "$(cat "$PIDFILE")" 2>/dev/null
    rm -f "$PIDFILE"
    notify-send "Screen recording" "Stopped"
    exit 0
fi

# Start a new recording
timestamp="$(date +%Y-%m-%d_%H-%M-%S)"
file="$OUTPUT_DIR/recording_$timestamp.mp4"

# Use slurp to select a region for a reasonable resolution
GEOM="$(slurp -b 40414a99 -c dba8e4 2>/dev/null)"
[ -z "$GEOM" ] && exit 1

wf-recorder -g "$GEOM" -f "$file" &

echo $! >"$PIDFILE"
notify-send "Screen recording" "Started → $file"
