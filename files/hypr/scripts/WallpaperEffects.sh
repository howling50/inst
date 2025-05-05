#!/bin/bash
wallpaper_current="$HOME/.othercrap/current.png"
wallpaper_output="$HOME/.othercrap/modified.png"

# Directory for swaync
iDIR="$HOME/.config/swaync/images"

# Define ImageMagic effects
declare -A effects=(
    ["No Effects"]="no-effects"
    ["Black & White"]="convert $wallpaper_current -colorspace gray -sigmoidal-contrast 10,40% $wallpaper_output"
    ["Blurred"]="convert $wallpaper_current -blur 0x10 $wallpaper_output"
    ["Charcoal"]="convert $wallpaper_current -charcoal 0x5 $wallpaper_output"
    ["Edge Detect"]="convert $wallpaper_current -edge 1 $wallpaper_output"
    ["Emboss"]="convert $wallpaper_current -emboss 0x5 $wallpaper_output"
    ["Frame Raised"]="convert $wallpaper_current +raise 150 $wallpaper_output"
    ["Frame Sunk"]="convert $wallpaper_current -raise 150 $wallpaper_output"
    ["Negate"]="convert $wallpaper_current -negate $wallpaper_output"
    ["Oil Paint"]="convert $wallpaper_current -paint 4 $wallpaper_output"
    ["Posterize"]="convert $wallpaper_current -posterize 4 $wallpaper_output"
    ["Polaroid"]="convert $wallpaper_current -polaroid 0 $wallpaper_output"
    ["Sepia Tone"]="convert $wallpaper_current -sepia-tone 65% $wallpaper_output"
    ["Solarize"]="convert $wallpaper_current -solarize 80% $wallpaper_output"
    ["Sharpen"]="convert $wallpaper_current -sharpen 0x5 $wallpaper_output"
    ["Vignette"]="convert $wallpaper_current -vignette 0x3 $wallpaper_output"
    ["Vignette-black"]="convert $wallpaper_current -background black -vignette 0x3 $wallpaper_output"
    ["Zoomed"]="convert $wallpaper_current -gravity Center -extent 1:1 $wallpaper_output"
)

# Function to apply no effects
no-effects() {
    pkill swaybg || true
    swaybg -i "$wallpaper_current" &&
    notify-send -u low -i "$iDIR/ja.png" "No wallpaper" "effects applied"
    cp "$wallpaper_current" "$wallpaper_output"
}

# Function to run rofi menu
main() {
    # Populate rofi menu options
    options=("No Effects")
    for effect in "${!effects[@]}"; do
        [[ "$effect" != "No Effects" ]] && options+=("$effect")
    done

    choice=$(printf "%s\n" "${options[@]}" | LC_COLLATE=C sort | rofi -dmenu -i)

    # Process user choice
    if [[ -n "$choice" ]]; then
        if [[ "$choice" == "No Effects" ]]; then
            no-effects
        elif [[ "${effects[$choice]+exists}" ]]; then
            # Apply selected effect
            notify-send -u normal -i "$iDIR/ja.png"  "Applying:" "$choice effects"
            eval "${effects[$choice]}"
            
            # Set modified wallpaper
            pkill swaybg || true
            swaybg -i "$wallpaper_output" &

            notify-send -u low -i "$iDIR/ja.png" "$choice" "effects applied"
        else
            echo "Effect '$choice' not recognized."
        fi
    fi
}

# Check if rofi is already running and kill it
if pidof rofi > /dev/null; then
    pkill rofi
fi

main
