#!/usr/bin/env bash
selected=$(ps --no-headers -u "$USER" -o pid,comm,%cpu,%mem | rofi -dmenu -i -c -l 10 -p "Kill process:" -theme ~/.config/rofi/basiceffect.rasi)
[ -n "$selected" ] && echo "$selected" | awk '{print $1}' | xargs -r kill
