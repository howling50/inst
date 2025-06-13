#!/usr/bin/env bash

ROFI="${ROFI:-rofi}"
CURRENT_MODE=""
NOTIFY="${NOTIFY:-dunstify}"

# Set UTF-8 environment to fix icon issues
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Detect notification command
detect_notifier() {
    if command -v dunstify &> /dev/null; then
        NOTIFY="dunstify -r 1000 -u low"
    elif command -v notify-send &> /dev/null; then
        NOTIFY="notify-send"
    else
        NOTIFY="echo"
    fi
}

# Show notification with brightness level
brightness_notification() {
    local level=$(current_bright_perc)
    local icon
    
    # Select appropriate icon based on brightness level
    if [ "$level" -ge 100 ]; then
         icon="$HOME/.config/dunst/brightness-100.png"
    elif [ "$level" -ge 80 ]; then
        icon="$HOME/.config/dunst/brightness-80.png"
    elif [ "$level" -ge 60 ]; then
        icon="$HOME/.config/dunst/brightness-60.png"
    elif [ "$level" -ge 40 ]; then
        icon="$HOME/.config/dunst/brightness-40.png"
    else
        icon="$HOME/.config/dunst/brightness-20.png"
    fi

    $NOTIFY "Brightness: $level%" -h "int:value:$level" -i "$icon"
}

# Detect environment
detect_environment() {
    if [ -n "$WAYLAND_DISPLAY" ] || [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        if command -v wlr-randr &> /dev/null; then
            CURRENT_MODE="wlr"
        elif command -v brightnessctl &> /dev/null; then
            CURRENT_MODE="brightnessctl"
        else
            $ROFI -e "Error: No supported brightness control found for Wayland"
            exit 1
        fi
    elif [ -n "$DISPLAY" ]; then
        if command -v xrandr &> /dev/null; then
            CURRENT_MODE="xrandr"
        else
            $ROFI -e "Error: xrandr not found for X11"
            exit 1
        fi
    else
        $ROFI -e "Error: Unable to detect display environment"
        exit 1
    fi
}

# Get current brightness (0.0-1.0)
current_bright() {
    case $CURRENT_MODE in
        "xrandr")
            xrandr --verbose | awk '/Brightness/ {print $2; exit}' 
            ;;
        "wlr")
            wlr-randr | awk '/Brightness:/ {print $2; exit}'
            ;;
        "brightnessctl")
            local max=$(brightnessctl max)
            local current=$(brightnessctl get)
            awk "BEGIN {print $current / $max}"
            ;;
    esac
}

# Get current brightness percentage
current_bright_perc() {
    current_bright | awk '{printf "%.0f", $1 * 100}'
}

# Calculate increased brightness (5% increment)
increase_bright() {
    awk -v b="$1" 'BEGIN {bright = b + 0.05; print (bright > 1.0) ? 1.0 : bright}'
}

# Calculate decreased brightness (5% decrement)
decrease_bright() {
    awk -v b="$1" 'BEGIN {bright = b - 0.05; print (bright < 0.0) ? 0.0 : bright}'
}

# Set brightness (0.0-1.0)
set_bright() {
    case $CURRENT_MODE in
        "xrandr")
            xrandr --listactivemonitors | awk 'NR>1 {print $4}' | \
            xargs -I{} xrandr --output {} --brightness "$1"
            ;;
        "wlr")
            wlr-randr | awk '/^[^ ]/ {gsub(":",""); print $1}' | \
            xargs -I{} wlr-randr --output {} --brightness "$1"
            ;;
        "brightnessctl")
            brightnessctl set "$(awk -v b="$1" 'BEGIN {printf "%.0f%%", b * 100}')"
            ;;
    esac
}

## Main
detect_environment
detect_notifier  # Initialize notification system
options="Increase\nDecrease\nOptimal"
row=0

while chosen="$(echo -e "$options" | $ROFI -dmenu -i -p "Brightness $(current_bright_perc)%" \
        -selected-row $row -theme ~/.config/rofi/basiceffect.rasi)"; do
    case $chosen in
        "Increase")
            set_bright "$(increase_bright "$(current_bright)")"
            brightness_notification
            row=0
            ;;
        "Decrease")
            set_bright "$(decrease_bright "$(current_bright)")"
            brightness_notification
            row=1
            ;;
        "Optimal")
            set_bright 0.75
            brightness_notification
            row=2
            ;;
    esac
done

exit 0
