#!/bin/bash
# Configuration
WALL_DIR="$HOME/.othercrap/wallpaper"
CURRENT_WALL="$HOME/.othercrap/current.png"
MODIFY_WALL="$HOME/.othercrap/modified.png"
ROFI_THEME="$HOME/.config/rofi/config-wallpaper.rasi"
ICON_DIR="$HOME/.config/dunst/icons"

# Check dependencies
required_commands=("feh" "rofi" "bc")
for cmd in "${required_commands[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    notify-send -i "$ICON_DIR/critical.png" "Missing $cmd" "Please install $cmd first"
    exit 1
  fi
done

# Get monitor info
monitor_info=$(xrandr --query | grep -w connected | grep -w primary || xrandr --query | grep -w connected | head -n1)
resolution=$(echo "$monitor_info" | awk '{print $4}' | cut -d+ -f1)
monitor_height=$(echo "$resolution" | cut -dx -f2)

# Calculate Rofi icon size
icon_size=$(echo "scale=1; ($monitor_height * 3) / 150" | bc)
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

# Find all image files
mapfile -d '' WALLS < <(find -L "${WALL_DIR}" -type f \( \
  -iname "*.jpg" -o -iname "*.jpeg" -o \
  -iname "*.png" -o -iname "*.bmp" -o \
  -iname "*.tiff" -o -iname "*.webp" \) -print0)

# Random wallpaper option
RANDOM_WALL="${WALLS[$((RANDOM % ${#WALLS[@]}))]}"
RANDOM_OPTION="random"

# Wallpaper menu
show_menu() {
  printf "%s\x00icon\x1f%s\n" "$RANDOM_OPTION" "$RANDOM_WALL"
  
  while IFS= read -r -d '' wall; do
    wall_name=$(basename "$wall")
    printf "%s\x00icon\x1f%s\n" "${wall_name%.*}" "$wall"
  done < <(printf '%s\0' "${WALLS[@]}" | sort -z)
}

# Apply wallpaper
set_wallpaper() {
  local wall_path="$1"
  
  # Update current wallpaper file (ACTUAL IMAGE COPY)
  if [[ -f "$wall_path" ]]; then
    cp -f "$wall_path" "$CURRENT_WALL"
    cp -f "$wall_path" "$MODIFY_WALL"
  else
    notify-send -i "$ICON_DIR/critical.png" "Error" "Wallpaper file not found!"
    exit 1
  fi
  
  # Set with feh using the copied file
  feh --bg-fill "$CURRENT_WALL"
  
  notify-send -i "$ICON_DIR/normal.png" "Wallpaper Set" "$(basename "$wall_path")"
}

# Main function (rest remains the same)
main() {
  # Launch Rofi menu
  choice=$(show_menu | rofi -i -dmenu -config "$ROFI_THEME" -theme-str "$rofi_override")

  # Handle selection
  if [[ -z "$choice" ]]; then
    exit 0
  fi

  # Handle random selection
  if [[ "$choice" == "$RANDOM_OPTION" ]]; then
    selected_wall="$RANDOM_WALL"
  else
    # Find exact match for selected wallpaper
    selected_wall=$(find -L "$WALL_DIR" -iname "*${choice}*" -print -quit)
  fi

  # Validate selection
  if [[ -z "$selected_wall" ]] || [[ ! -f "$selected_wall" ]]; then
    notify-send -i "$ICON_DIR/critical.png" "Error" "Wallpaper not found!"
    exit 1
  fi

  # Set the wallpaper
  set_wallpaper "$selected_wall"
}

# Kill existing rofi instance if running
if pidof rofi >/dev/null; then
  pkill rofi
fi

main
