#!/bin/bash
# Converted for i3 with feh/dunst/rofi

# Variables
terminal=kitty
wallpaper_current="$HOME/.othercrap/wallpaper/reaper.png"
wallpaper_output="$HOME/.othercrap/modified.png"
SCRIPTSDIR="$HOME/.config/i3/scripts"

# Directory for notifications
iDIR="$HOME/.config/dunst/icons"

# Define ImageMagick effects
declare -A effects=(
    ["No Effects"]="no-effects"
    ["Black & White"]="magick $wallpaper_current -colorspace gray -sigmoidal-contrast 10,40% $wallpaper_output"
    ["Blurred"]="magick $wallpaper_current -blur 0x10 $wallpaper_output"
    ["Charcoal"]="magick $wallpaper_current -charcoal 0x5 $wallpaper_output"
    ["Edge Detect"]="magick $wallpaper_current -edge 1 $wallpaper_output"
    ["Emboss"]="magick $wallpaper_current -emboss 0x5 $wallpaper_output"
    ["Frame Raised"]="magick $wallpaper_current +raise 150 $wallpaper_output"
    ["Frame Sunk"]="magick $wallpaper_current -raise 150 $wallpaper_output"
    ["Negate"]="magick $wallpaper_current -negate $wallpaper_output"
    ["Oil Paint"]="magick $wallpaper_current -paint 4 $wallpaper_output"
    ["Posterize"]="magick $wallpaper_current -posterize 4 $wallpaper_output"
    ["Polaroid"]="magick $wallpaper_current -polaroid 0 $wallpaper_output"
    ["Sepia Tone"]="magick $wallpaper_current -sepia-tone 65% $wallpaper_output"
    ["Solarize"]="magick $wallpaper_current -solarize 80% $wallpaper_output"
    ["Sharpen"]="magick $wallpaper_current -sharpen 0x5 $wallpaper_output"
    ["Vignette"]="magick $wallpaper_current -vignette 0x3 $wallpaper_output"
    ["Vignette-black"]="magick $wallpaper_current -background black -vignette 0x3 $wallpaper_output"
    ["Zoomed"]="magick $wallpaper_current -gravity Center -extent 1:1 $wallpaper_output"
)

# Function to apply no effects
no-effects() {
    feh --bg-fill "$wallpaper_current"
    wait $!
    # Add any color theming commands here (e.g., pywal)
    "${SCRIPTSDIR}/Refresh.sh"
    notify-send -u low -i "$iDIR/info.png" "No effects" "Applied original wallpaper"
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
            notify-send -u normal -i "$iDIR/image.png"  "Applying:" "$choice effects"
            eval "${effects[$choice]}"
            
            # Set modified wallpaper
            feh --bg-fill "$wallpaper_output"
            
            # Add any color theming commands here (e.g., pywal)
            sleep 1
            "${SCRIPTSDIR}/Refresh.sh"
            notify-send -u low -i "$iDIR/success.png" "$choice" "Effects applied"
        else
            notify-send -i "$iDIR/error.png" "Error" "Unknown effect: $choice"
        fi
    fi
}

# Check if rofi is already running
if pidof rofi >/dev/null; then
    pkill rofi
fi

main


fi
