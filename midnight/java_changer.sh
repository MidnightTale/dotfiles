#!/bin/bash

# Check if 'dialog' is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' not found. Please install it before running this script."
    exit 1
fi

# Check if there are no Java installations
if [ ! -d "/opt/java" ] || [ -z "$(ls -A /opt/java)" ]; then
    echo "Error: No Java installations found in /opt/java."
    exit 1
fi

while true; do
    clear

    java_options=()
    java_option_count=1

    for java_dir in /opt/java/*; do
        if [ -d "$java_dir" ] && [ "$java_dir" != "/opt/java/current" ]; then
            java_name=$(basename "$java_dir")
            java_options+=("$java_option_count" "$java_name")
            ((java_option_count++))
        fi
    done

    java_options+=("$java_option_count" "Exit")

    selection=$(dialog --clear \
                      --backtitle "Menu" \
                      --title "Java Changer" \
                      --menu "Select Java to Home:" 30 70 4 \
                      "${java_options[@]}" \
                      2>&1 >/dev/tty)

    case $selection in
        $java_option_count)
            clear
            exit 0
            ;;
        *)
            selected_java="${java_options[$((selection*2-1))]}"

            # Remove existing symbolic link
            rm -rf /opt/java/current

            # Create new symbolic link
            ln -s "/opt/java/$selected_java" /opt/java/current

            # Check if symbolic link creation was successful
            if [ $? -ne 0 ]; then
                echo "Error: Failed to create symbolic link."
                exit 1
            fi
            ;;
    esac
done
