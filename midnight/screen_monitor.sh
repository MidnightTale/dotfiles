#!/bin/bash

# Import Bash Simple Curses library
source /usr/local/lib/simple_curses.sh

function get_session_info {
    local session_name=$1
    local location=$(screen -ls | grep $session_name | awk '{print $2}')

    # Get CPU usage by finding processes related to the screen session
    local pid_list=$(pgrep -f "screen -S $session_name")


    append "$(tput bold)$(tput setaf 4) Session: $session_name$(tput sgr0)" #  is the Nerd Font icon for "folder"
    append "$(tput bold)$(tput setaf 3) Location: $location$(tput sgr0)"     #  is the Nerd Font icon for "terminal"
}

# Main function
main() {
    # Dynamically fetch all screen sessions
    screen_list=$(screen -ls | grep -oP '\d+\.\K[^[:space:]]+')

    # Check if there are no active sessions
    if [ -z "$screen_list" ]; then
        window "$(tput bold)$(tput setaf 1) No active screen sessions found$(tput sgr0)" "red" #  is the Nerd Font icon for "exclamation-triangle"
        append "Please start a screen session."
        endwin
    else
        # Loop through each screen session and display information
        for session_name in $screen_list; do
            window "$(tput bold)$(tput setaf 6) Session Information: $session_name$(tput sgr0)" "blue" "50%" #  is the Nerd Font icon for "info"
            get_session_info "$session_name"
            endwin
            col_right
        done
    fi
}

# Execute the main loop every second
main_loop -t 1
