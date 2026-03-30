#!/bin/bash

# Script to toggle floating workspace in Hyprland
# Makes all windows in a specified workspace floating with custom size and centered
# Uses socat to listen for window events and auto-float windows

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
LIGHT_CYAN="\e[96m"

print_usage() {
    printf "Usage:
    floating_workspace.sh
        -w [workspace_id] (required - workspace number to make floating)
        -s [width] [height] (optional - window size, default: 800 600)
        -e | enable floating rules
        -d | disable floating rules
        -t | toggle floating rules
        -h | show this help message

Examples:
    floating_workspace.sh -w 5 -e              # Enable floating on workspace 5 with default size
    floating_workspace.sh -w 5 -s 1200 800 -e  # Enable with custom size
    floating_workspace.sh -w 5 -d              # Disable floating on workspace 5
    floating_workspace.sh -w 5 -t              # Toggle floating on workspace 5

Note: The daemon runs in the background and monitors new windows.
      Check with: ps aux | grep 'floating_workspace_daemon'
"
}

# Default values
workspace=""
width="800"
height="600"
action=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -w)
            workspace="$2"
            shift 2
            ;;
        -s)
            width="$2"
            height="$3"
            shift 3
            ;;
        -e)
            action="enable"
            shift
            ;;
        -d)
            action="disable"
            shift
            ;;
        -t)
            action="toggle"
            shift
            ;;
        -h)
            print_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${ENDCOLOR}"
            print_usage
            exit 1
            ;;
    esac
done

# Validate required parameters
if [ -z "$workspace" ]; then
    echo -e "${RED}Error: Workspace ID is required (-w)${ENDCOLOR}"
    print_usage
    exit 1
fi

if [ -z "$action" ]; then
    echo -e "${RED}Error: Action is required (-e, -d, or -t)${ENDCOLOR}"
    print_usage
    exit 1
fi

# State file to track enabled workspaces
STATE_DIR="$HOME/.cache/hyprland_floating_workspaces"
STATE_FILE="$STATE_DIR/workspaces"
PID_FILE="$STATE_DIR/daemon_${workspace}.pid"
mkdir -p "$STATE_DIR"
touch "$STATE_FILE"

# Check if workspace is currently enabled
is_enabled() {
    grep -q "^$workspace:" "$STATE_FILE"
}

# Get Hyprland instance signature
get_hypr_signature() {
    echo "$HYPRLAND_INSTANCE_SIGNATURE"
}

# Daemon function that monitors and auto-floats windows
floating_daemon() {
    local ws=$1
    local w=$2
    local h=$3
    local sig=$(get_hypr_signature)
    
    # Use nc to listen to Hyprland socket
    nc -U "/tmp/hypr/${sig}/.socket2.sock" | while read -r line; do
        # Parse events: openwindow>>ADDRESS,WORKSPACE,CLASS,TITLE
        if [[ "$line" =~ ^openwindow\>\>([^,]+),([^,]+), ]]; then
            addr="${BASH_REMATCH[1]}"
            ws_name="${BASH_REMATCH[2]}"
            
            # Check if window is on our target workspace
            if [ "$ws_name" = "$ws" ]; then
                sleep 0.1  # Small delay to let window fully open
                
                # Make window floating
                hyprctl dispatch togglefloating "address:0x$addr" 2>/dev/null
                hyprctl dispatch resizewindowpixel "exact $w $h,address:0x$addr" 2>/dev/null
                hyprctl dispatch centerwindow "address:0x$addr" 2>/dev/null
            fi
        fi
        
        # Also handle movewindow events in case window moves to workspace
        if [[ "$line" =~ ^movewindow\>\>([^,]+),([^,]+)$ ]]; then
            addr="${BASH_REMATCH[1]}"
            ws_name="${BASH_REMATCH[2]}"
            
            if [ "$ws_name" = "$ws" ]; then
                sleep 0.1
                hyprctl dispatch togglefloating "address:0x$addr" 2>/dev/null
                hyprctl dispatch resizewindowpixel "exact $w $h,address:0x$addr" 2>/dev/null
                hyprctl dispatch centerwindow "address:0x$addr" 2>/dev/null
            fi
        fi
    done
}

# Enable floating rules
enable_floating() {
    if is_enabled; then
        echo -e "${YELLOW}Workspace $workspace is already set to floating${ENDCOLOR}"
        return
    fi

    echo -e "${LIGHT_CYAN}Enabling floating mode for workspace $workspace...${ENDCOLOR}"
    
    # Save state
    echo "$workspace:$width:$height" >> "$STATE_FILE"
    
    # Make all existing windows in the workspace floating
    active_windows=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $workspace) | .address")
    if [ -n "$active_windows" ]; then
        for addr in $active_windows; do
            # Only toggle if not already floating
            is_floating=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$addr\") | .floating")
            if [ "$is_floating" = "false" ]; then
                hyprctl dispatch togglefloating "address:$addr" > /dev/null 2>&1
            fi
            hyprctl dispatch resizewindowpixel "exact $width $height,address:$addr" > /dev/null 2>&1
            hyprctl dispatch centerwindow "address:$addr" > /dev/null 2>&1
        done
    fi
    
    # Start background daemon to monitor new windows
    floating_daemon "$workspace" "$width" "$height" &
    daemon_pid=$!
    echo "$daemon_pid" > "$PID_FILE"
    
    echo -e "${GREEN}✓ Workspace $workspace is now floating (${width}x${height})${ENDCOLOR}"
    echo -e "${LIGHT_CYAN}Daemon started (PID: $daemon_pid) - new windows will auto-float${ENDCOLOR}"
}

# Disable floating rules
disable_floating() {
    if ! is_enabled; then
        echo -e "${YELLOW}Workspace $workspace is not set to floating${ENDCOLOR}"
        return
    fi

    echo -e "${LIGHT_CYAN}Disabling floating mode for workspace $workspace...${ENDCOLOR}"
    
    # Stop the daemon if running
    if [ -f "$PID_FILE" ]; then
        daemon_pid=$(cat "$PID_FILE")
        if kill -0 "$daemon_pid" 2>/dev/null; then
            kill "$daemon_pid" 2>/dev/null
            echo -e "${LIGHT_CYAN}Stopped daemon (PID: $daemon_pid)${ENDCOLOR}"
        fi
        rm "$PID_FILE"
    fi
    
    # Remove from state file
    sed -i "/^$workspace:/d" "$STATE_FILE"
    
    # Make all existing windows in the workspace tiled
    active_windows=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $workspace and .floating == true) | .address")
    if [ -n "$active_windows" ]; then
        for addr in $active_windows; do
            hyprctl dispatch togglefloating "address:$addr" > /dev/null 2>&1
        done
    fi
    
    echo -e "${GREEN}✓ Workspace $workspace is now tiled${ENDCOLOR}"
}

# Toggle floating rules
toggle_floating() {
    if is_enabled; then
        disable_floating
    else
        enable_floating
    fi
}

# Execute action
case $action in
    enable)
        enable_floating
        ;;
    disable)
        disable_floating
        ;;
    toggle)
        toggle_floating
        ;;
esac

exit 0
