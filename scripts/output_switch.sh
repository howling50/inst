#!/bin/sh
pactl set-default-sink "$(pactl list short sinks | awk '{print $2}' | rofi -dmenu -i -l 5 -c -p "Output:" -theme ~/.config/rofi/launcher.rasi)" && notify-send "Audio switched!" || exit 0
