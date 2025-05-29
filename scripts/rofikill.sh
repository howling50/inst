#!/usr/bin/env bash

# List user processes and show in rofi
selected=$(ps --no-headers -u "$USER" -o pid,comm,%cpu,%mem | 
    rofi -dmenu -i -c -l 10 -p "Kill process:" -theme ~/.config/rofi/basiceffect.rasi)

# Exit if nothing selected
[ -z "$selected" ] && exit 0

# Extract PID and command name
pid=$(echo "$selected" | awk '{print $1}')
cmd=$(echo "$selected" | awk '{print $2}')

# Confirmation menu with default option
action=$(printf "Selected (PID %s)\nAll Instances (%s)" "$pid" "$cmd" | 
    rofi -dmenu -i -c -l 2 -p "Kill method:" -theme ~/.config/rofi/basiceffect.rasi -selected-row 0)

# Execute based on user choice
case "$action" in
    "Selected (PID $pid)")
        kill "$pid"
        notify-send "Process killed" "PID: $pid ($cmd)"
        ;;
    "All Instances ($cmd)")
        pkill -x "$cmd"
        notify-send "All instances killed" "Command: $cmd"
        ;;
    *) 
        exit 0
        ;;
esac
