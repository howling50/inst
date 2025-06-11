#!/usr/bin/env bash

# ─── CONFIG ───────────────────────────────────────────────────────
# Icon color when volume is below 20% or above 60%
ICON_COLOR_EXT="#e06c75"
# Icon color when volume is between 20% and 60%
ICON_COLOR_MID="#88fd08"
# Text color for the volume number
NUMBER_COLOR="#c0caf5"
# Text color when muted (for Polybar status)
MUTED_COLOR="#707880"

# Step size and limits
volume_step=5
max_volume=100
notification_timeout=5000

show_album_art=true
show_music_in_volume_indicator=true

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

# Send notifications using unformatted icon and explicit text
default_show_volume_notif() {
    local vol=$(get_volume)
    local mute=$(get_mute)
    local raw_icon=$(get_raw_icon)

    if [ "$mute" = "yes" ]; then
        # Muted: only show icon + Muted
        notify-send -t $notification_timeout \
            -h string:x-dunst-stack-tag:volume_notif \
            "${raw_icon} Muted"
        return
    fi

    # Not muted: show "Volume X%" explicitly
    if [ "$show_music_in_volume_indicator" = "true" ]; then
        local current_song="$(playerctl -f "{{title}} - {{artist}}" metadata 2>/dev/null)"
        local art=""
        if [ "$show_album_art" = "true" ]; then
            art_path=$(playerctl -f "{{mpris:artUrl}}" metadata | sed -e 's|^file://||' -e 's|.*/||;q')
            art="/tmp/$art_path"
            [ -f "$art" ] || wget -qO "$art" "$(playerctl -f "{{mpris:artUrl}}" metadata)"
        fi
        notify-send -t $notification_timeout \
            -h string:x-dunst-stack-tag:volume_notif \
            -h int:value:$vol \
            -i "$art" \
            "Volume $vol%" \
            "$current_song"
    else
        notify-send -t $notification_timeout \
            -h string:x-dunst-stack-tag:volume_notif \
            -h int:value:$vol \
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

    play_pause)    playerctl play-pause && default_show_volume_notif ;;
    next_track)    playerctl next        && default_show_volume_notif ;;
    prev_track)    playerctl previous    && default_show_volume_notif ;;

    *)
        echo "Usage: $0 [status|mute|up|down|open]" >&2
        exit 1
        ;;
esac
