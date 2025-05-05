#!/bin/bash

config_file=~/.config/i3/config
keybinds=$(grep -oP '(?<=bindsym ).*' "$config_file")

keybinds=$(echo "$keybinds" | sed -E '
  s/,//g;                  # Remove all commas
  s/exec +//g;             # Remove "exec" and following space
  s/^([^ ]+) /\1 = /;     # Add "=" after key combination
  s/Mod1/Alt/g;            # Replace Mod1 with Alt
  s/\$mod/SUPER/g;         # Replace $mod with SUPER
  s/ += +/ = /g;           # Clean up extra spaces around =
')

rofi -dmenu -p "Keybinds" <<< "$keybinds"
