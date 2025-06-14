#!/usr/bin/env bash

# ─── CONFIG ───────────────────────────────────────────────────────
# Icon color when volume is between 20% and 60%
ICON_COLOR_MID="#88fd08"
# Icon color when volume is below 20% or above 60%
ICON_COLOR_EXT="#e06c75"
# Text color for the volume number
NUMBER_COLOR="#c0caf5"
# Text color when muted (for Polybar status)
MUTED_COLOR="#707880"

# Step size and limits
volume_step=5
max_volume=100
notification_timeout=5000

show_album_art=false
show_music_in_volume_indicator=true

# Icon paths for notifications
ICON_MUTE="$HOME/.config/dunst/icons/Volume-Mute.png"
ICON_LOW="$HOME/.config/dunst/icons/Volume-Low.png"
ICON_MID="$HOME/.config/dunst/icons/Volume-Mid.png"
ICON_HIGH="$HOME/.config/dunst/icons/Volume-High.png"

get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ \
        | grep -Po '[0-9]{1,3}(?=%)' \
        | head -1
}

get_mute() {
    pactl get-sink-mute @DEFAULT_SINK@ \
        | grep -Po '(?<=Mute: )(yes|no)'
}

# Raw icon (no color tags) based on volume/mute
get_raw_icon() {
    local v=$(get_volume)
    local m=$(get_mute)
    if [ "$v" -eq 0 ] || [ "$m" = "yes" ]; then
        echo ""
    elif [ "$v" -lt 50 ]; then
        echo ""
    else
        echo ""
    fi
}

# Polybar-formatted icon based on volume/mute + color ranges
get_formatted_icon() {
    local v=$(get_volume)
    local m=$(get_mute)
    local raw=$(get_raw_icon)
    local color
    if [ "$m" = "yes" ]; then
        color="$MUTED_COLOR"
    elif (( v >= 20 && v <= 60 )); then
        color="$ICON_COLOR_MID"
    else
        color="$ICON_COLOR_EXT"
    fi
    printf "%%{F%s}%s%%{F-}" "$color" "$raw"
}

# Get icon path based on volume level
get_icon_path() {
    local vol=$1
    if [ $vol -eq 0 ]; then
        echo "$ICON_MUTE"
    elif [ $vol -lt 20 ]; then
        echo "$ICON_LOW"
    elif [ $vol -le 60 ]; then
        echo "$ICON_MID"
    else
        echo "$ICON_HIGH"
    fi
}

# Send notifications using local icons when album art is disabled
default_show_volume_notif() {
    local vol=$(get_volume)
    local mute=$(get_mute)
    local icon_path=""

    # Determine icon path when album art is disabled
    if [ "$show_album_art" = "false" ]; then
        icon_path=$(get_icon_path $vol)
    fi

    if [ "$mute" = "yes" ]; then
        # For muted, always use mute icon if album art is disabled
        if [ "$show_album_art" = "false" ]; then
            icon_path="$ICON_MUTE"
        fi
        notify-send -t $notification_timeout \
            -h string:x-dunst-stack-tag:volume_notif \
            -i "$icon_path" \
            "Muted"
        return
    fi

    # Not muted
    if [ "$show_music_in_volume_indicator" = "true" ]; then
        stream_url="$(playerctl -f "{{xesam:url}}" metadata 2>/dev/null)"
        if [[ "$stream_url" =~ ^https?:// ]]; then
              if [ -r /tmp/current_radio_station ]; then
               current_song="$(< /tmp/current_radio_station)"
              else
               current_song="Live Radio Stream"
              fi
        else
        current_song="$(playerctl -f '{{title}} - {{artist}}' metadata 2>/dev/null)"         
        fi
        
        local art=""
        if [ "$show_album_art" = "true" ]; then
            art_path=$(playerctl -f "{{mpris:artUrl}}" metadata | sed -e 's|^file://||' -e 's|.*/||;q')
            art="/tmp/$art_path"
            [ -f "$art" ] || wget -qO "$art" "$(playerctl -f "{{mpris:artUrl}}" metadata)"
        fi
        
        # Use album art if available, otherwise use volume-based icon
        local notification_icon=${art:-$icon_path}
        
        notify-send -t $notification_timeout \
            -h string:x-dunst-stack-tag:volume_notif \
            -h int:value:$vol \
            -i "$notification_icon" \
            "Volume $vol%" \
            "$current_song"
    else
        # Without music info
        notify-send -t $notification_timeout \
            -h string:x-dunst-stack-tag:volume_notif \
            -h int:value:$vol \
            -i "$icon_path" \
            "Volume $vol%"
    fi
}

# ─── ACTIONS ──────────────────────────────────────────────────────
case "$1" in
    # Print status for Polybar: colored icon + colored number or Muted
    ""| status)
        vol=$(get_volume)
        mute=$(get_mute)
        icon=$(get_formatted_icon)
        if [ "$mute" = "yes" ]; then
            # Only icon + "Muted"
            printf "%s %%{F%s}Muted%%{F-}\n" "$icon" "$MUTED_COLOR"
        else
            # Icon + colored volume number
            printf "%s %%{F%s}%s%%{F-}\n" "$icon" "$NUMBER_COLOR" "$vol"
        fi
        ;;

    # Toggle mute
    mute|toggle)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        default_show_volume_notif
        ;;

    # Volume up
    up)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        v=$(get_volume)
        if (( v + volume_step > max_volume )); then
            pactl set-sink-volume @DEFAULT_SINK@ ${max_volume}%
        else
            pactl set-sink-volume @DEFAULT_SINK@ +${volume_step}%
        fi
        default_show_volume_notif
        ;;

    # Volume down
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -${volume_step}%
        default_show_volume_notif
        ;;

    # Open mixer
    open)
        pavucontrol &
        ;;

    # Legacy aliases and music controls
    volume_mute)   $0 mute   ;;
    volume_up)     $0 up     ;;
    volume_down)   $0 down   ;;
    play_pause)    playerctl play-pause && default_show_volume_notif ;;
    next_track)    playerctl next        && default_show_volume_notif ;;
    prev_track)    playerctl previous    && default_show_volume_notif ;;

    *)
        echo "Usage: $0 [status|mute|up|down|open]" >&2
        exit 1
        ;;
esac
