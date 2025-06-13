#!/bin/bash

# Variables
time=$(date "+%d-%b_%H-%M-%S")
dir="$HOME/Pictures"
file="Screenshot_${time}_${RANDOM}.png"

# Notification commands
notify_cmd_base="notify-send -t 10000 -h string:x-canonical-private-synchronous:shot-notify"
notify_cmd_NOT="notify-send -u low -t 5000"

# Notify and handle actions
notify_view() {
    local type="$1"
    local title msg resp

    case "$type" in
        active)
            title="Screenshot of active window"
            msg="${active_window_class}"
            ;;
        swappy)
            title="Screenshot for editing"
            msg="Captured by Swappy"
            ;;
        *)
            title="Screenshot"
            msg="Saved to $dir"
            ;;
    esac

    if [[ -e "$file_path" ]]; then
        resp=$($notify_cmd_base -A "open=Open" -A "delete=Delete" "$title" "$msg")
        case "$resp" in
            "open")
                xdg-open "$file_path" &
                ;;
            "delete")
                rm "$file_path"
                $notify_cmd_NOT "Screenshot deleted" "$file_path"
                ;;
        esac
    else
        $notify_cmd_NOT "Screenshot failed" "Could not save image"
    fi
}

# Countdown function
countdown() {
    for sec in $(seq "$1" -1 1); do
        notify-send -t 1000 "Taking shot in: $sec seconds"
        sleep 1
    done
}

# Screenshot functions
capture_and_handle() {
    local file_path="$1"
    local type="$2"
    
    if grim "$file_path"; then
        wl-copy < "$file_path"
        notify_view "$type"
    else
        $notify_cmd_NOT "Screenshot failed" "grim command failed"
    fi
}

shotnow() {
    capture_and_handle "${dir}/${file}" "default"
}

shot5() {
    countdown 5
    shotnow
}

shot10() {
    countdown 10
    shotnow
}

shotwin() {
    focused_window=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true)')
    geometry=$(echo "$focused_window" | jq -r '"\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"')
    grim -g "$geometry" "${dir}/${file}" && wl-copy < "${dir}/${file}"
    notify_view "default"
}

shotarea() {
    local geometry
    if geometry=$(slurp -d 2>/dev/null); then
        grim -g "$geometry" "${dir}/${file}" && wl-copy < "${dir}/${file}"
        notify_view "default"
    else
        $notify_cmd_NOT "Screenshot cancelled" "Selection cancelled"
    fi
}

shotactive() {
    focused_window=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true)')
    active_window_class=$(echo "$focused_window" | jq -r '.app_id // .window_properties.class // "unknown"')
    active_window_file="Screenshot_${time}_${active_window_class//[^[:alnum:]._-/_}.png"  # Sanitized filename
    geometry=$(echo "$focused_window" | jq -r '"\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"')
    
    file_path="${dir}/${active_window_file}"
    if grim -g "$geometry" "$file_path"; then
        wl-copy < "$file_path"
        notify_view "active"
    else
        $notify_cmd_NOT "Active window capture failed" "Could not save image"
    fi
}

shotswappy() {
    local tmpfile geometry
    tmpfile=$(mktemp --suffix=.png) || return 1
    
    if geometry=$(slurp -d 2>/dev/null); then
        if grim -g "$geometry" "$tmpfile"; then
            wl-copy < "$tmpfile"
            swappy -f "$tmpfile"  # Open directly in swappy
        else
            rm -f "$tmpfile"
            $notify_cmd_NOT "Screenshot failed" "Could not capture area"
        fi
    else
        rm -f "$tmpfile"
        $notify_cmd_NOT "Screenshot cancelled" "Selection cancelled"
    fi
}

# Main execution
mkdir -p "$dir"  # Ensure directory exists

case "$1" in
    --now)      shotnow ;;
    --in5)      shot5 ;;
    --in10)     shot10 ;;
    --win)      shotwin ;;
    --area)     shotarea ;;
    --active)   shotactive ;;
    --swappy)   shotswappy ;;
    *)          echo "Available Options: --now --in5 --in10 --win --area --active --swappy" ;;
esac

exit 0
