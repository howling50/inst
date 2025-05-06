#!/bin/bash

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

# Rofi theme and message
rofi_theme="$HOME/.config/rofi/config-search.rasi"
msg='‼️ **note** ‼️ search via default web browser'

# Get search query and open Google search in default browser
echo "" | rofi -dmenu -config "$rofi_theme" -mesg "$msg" | \
xargs -I{} xdg-open "https://www.google.com/search?q={}"
