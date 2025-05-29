#!/bin/bash

config_file=~/.config/i3/config

# Get display lines and original commands in parallel
display_lines=$(grep -oP '(?<=bindsym ).*' "$config_file" | sed -E '
  s/\$mod/SUPER/g;
  s/Mod1/Alt/g;
  s/,( exec|$)//g;
  s/^([^ ]+) (.*)$/\1 = \2/;
  s/ = exec / = /;
')

# Get original commands (without bindsym) into array
mapfile -t execute_commands < <(grep -oP '(?<=bindsym ).*' "$config_file" | sed -E 's/^[^ ]+ //')

# Show Rofi and get selection index
selected_index=$(echo "$display_lines" | rofi -dmenu -p "Keybinds" -format i -theme ~/.config/rofi/basiceffect.rasi)

# Execute corresponding command if valid
if [[ -n "$selected_index" ]]; then
    original_cmd="${execute_commands[$selected_index]}"
    if [[ "$original_cmd" == exec\ * ]]; then
        eval "${original_cmd#exec }" &
    else
        i3-msg "$original_cmd" &
    fi
fi
