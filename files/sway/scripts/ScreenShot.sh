#!/bin/bash
# Screenshots script for Sway

# Variables
time=$(date "+%d-%b_%H-%M-%S")
dir="$HOME/Pictures"
file="Screenshot_${time}_${RANDOM}.png"

# Notification commands
notify_cmd_base="notify-send -t 10000 -A action1=Open -A action2=Delete -h string:x-canonical-private-synchronous:shot-notify"
notify_cmd_shot="${notify_cmd_base}"
notify_cmd_NOT="notify-send -u low error"

# Notify and view screenshot
notify_view() {
    case "$1" in
        active)
            if [[ -e "${dir}/${active_window_file}" ]]; then
                resp=$(timeout 5 ${notify_cmd_shot} "Screenshot of:" "${active_window_class} Saved")
                case "$resp" in
                    action1) xdg-open "${dir}/${active_window_file}" & ;;
                    action2) rm "${dir}/${active_window_file}" & ;;
                esac
            else
                ${notify_cmd_NOT} "Screenshot of:" "${active_window_class} NOT Saved"
            fi
            ;;

        swappy)
            resp=$(timeout 5 ${notify_cmd_shot} "Screenshot:" "Captured by Swappy")
            case "$resp" in
                action1) swappy -f "$tmpfile" ;;
                action2) rm "$tmpfile" ;;
            esac
            ;;

        *)
            if [[ -e "${dir}/${file}" ]]; then
                resp=$(timeout 5 ${notify_cmd_shot} "Screenshot" "Saved")
                case "$resp" in
                    action1) xdg-open "${dir}/${file}" & ;;
                    action2) rm "${dir}/${file}" & ;;
                esac
            else
                ${notify_cmd_NOT} "Screenshot" "NOT Saved"
            fi
            ;;
    esac
}

# Countdown
countdown() {
    for sec in $(seq $1 -1 1); do
        notify-send -t 1000 "Taking shot" "in: $sec secs"
        sleep 1
    done
}

# Take shots
shotnow() {
    grim "${dir}/${file}" && wl-copy < "${dir}/${file}"
    notify_view
}

shot5() {
    countdown 5
    grim "${dir}/${file}" && wl-copy < "${dir}/${file}"
    notify_view
}

shot10() {
    countdown 10
    grim "${dir}/${file}" && wl-copy < "${dir}/${file}"
    notify_view
}

shotwin() {
    focused_window=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true)')
    geometry=$(echo "$focused_window" | jq -r '"\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"')
    grim -g "$geometry" "${dir}/${file}" && wl-copy < "${dir}/${file}"
    notify_view
}

shotarea() {
    tmpfile=$(mktemp).png
    grim -g "$(slurp -d)" "$tmpfile"
    
    if [[ -s "$tmpfile" ]]; then
        wl-copy < "$tmpfile"
        mv "$tmpfile" "${dir}/${file}"
        notify_view
    else
        rm -f "$tmpfile"
        ${notify_cmd_NOT} "Screenshot" "Selection cancelled"
    fi
}

shotactive() {
    focused_window=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true)')
    active_window_class=$(echo "$focused_window" | jq -r '.app_id // .window_properties.class // "unknown"')
    active_window_file="Screenshot_${time}_${active_window_class}.png"
    geometry=$(echo "$focused_window" | jq -r '"\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"')
    
    grim -g "$geometry" "${dir}/${active_window_file}"
    notify_view active
}

shotswappy() {
    tmpfile=$(mktemp).png
    grim -g "$(slurp -d)" "$tmpfile"
    
    if [[ -s "$tmpfile" ]]; then
        wl-copy < "$tmpfile"
        notify_view swappy
    else
        rm -f "$tmpfile"
        ${notify_cmd_NOT} "Screenshot" "Selection cancelled"
    fi
}

# Main execution
[[ ! -d "$dir" ]] && mkdir -p "$dir"

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
