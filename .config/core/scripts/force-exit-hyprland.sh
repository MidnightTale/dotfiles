#!/usr/bin/env bash

# Kill the waybarreload.sh script
kill_waybarreload() {
    if pgrep -f "waybar-auto-reload.sh" >/dev/null; then
        pkill -f "waybar-auto-reload.sh"
    fi
}

# Check if Hyprland is running
if pgrep -x Hyprland >/dev/null; then
    hyprctl dispatch exit 0
    sleep 2
    if pgrep -x Hyprland >/dev/null; then
        killall -9 Hyprland
    fi
fi

# Kill the waybarreload.sh script after ensuring Hyprland is stopped
kill_waybarreload
