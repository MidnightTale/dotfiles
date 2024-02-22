#!/bin/bash

while true; do
    clear

    java_options=()
    java_count=1

    for java_dir in /opt/java/*; do
        if [ -d "$java_dir" ] && [ "$java_dir" != "/opt/java/current" ]; then
            java_name=$(basename "$java_dir")
            java_options+=("$java_count" "$java_name")
            ((java_count++))
        fi
    done

    java_options+=("$java_count" "Exit")

    selection=$(dialog --clear \
                      --backtitle "Menu" \
                      --title "Java Changer" \
                      --menu "Select Java to Home:" 30 70 4 \
                      "${java_options[@]}" \
                      2>&1 >/dev/tty)

    case $selection in
        $java_count)
            clear
            exit 0
            ;;
        *)
            selected_java="${java_options[$((selection*2-1))]}"
            rm -rf /opt/java/current
            ln -s "/opt/java/$selected_java" /opt/java/current
            ;;
    esac
done

