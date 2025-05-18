#!/usr/bin/env bash
# Path to your custom Rofi theme
ROFI_THEME="$HOME/.config/rofi/powermenu.rasi"

# Gather system info
LASTLOGIN="$(last "$USER" | head -n1 | tr -s ' ' | cut -d' ' -f5-7)"
UPTIME="$(uptime -p | sed 's/^up //')"

# Menu icons (or labels)
ICON_LOCK=''
ICON_LOGOUT='󰿅'
ICON_REBOOT=''
ICON_SHUTDOWN='󰐥'

# -----------------------------------------------------------------------------
# rofi_cmd: main menu
# -----------------------------------------------------------------------------
rofi_cmd() {
    rofi -dmenu \
         -p "󰣇 $USER" \
         -mesg "󰍹 Last Login: $LASTLOGIN |  Uptime: $UPTIME" \
         -lines 4 \
         -no-custom \
         -theme "$ROFI_THEME" \
         -theme-str 'configuration { mouse: true; }' \
         -hover-select \                         
         -me-select-entry '' \                   
         -me-accept-entry MousePrimary         
}

# -----------------------------------------------------------------------------
# confirm_cmd: ask Yes/No for a given action label
# -----------------------------------------------------------------------------
confirm_cmd() {
    local action_label="$1"
    rofi -dmenu \
         -p 'Confirmation' \
         -mesg "${action_label} – Are you sure?" \
         -no-config \
         -lines 2 \
         -theme-str 'window { location: center; anchor: center; fullscreen: false; width: 350px; mouse: true; }' \
         -hover-select \
         -me-select-entry '' \
         -me-accept-entry MousePrimary \
         -theme-str 'listview { columns: 2; lines: 1; }' \
         -theme-str 'element-text { horizontal-align: 0.5; }' \
         -theme-str 'textbox { horizontal-align: 0.5; }' \
         -me-select-entry '' \
         -me-accept-entry 'Mouse1'
}

confirm_exit() {
    local label="$1"
    printf "%s\n%s" "✔️ Yes" "❌ No" | confirm_cmd "$label"
}

# -----------------------------------------------------------------------------
# run_cmd: perform the system action if confirmed
#   $1 = flag (--lock, --logout, etc.)
#   $2 = human label ("Lock", "Logout", etc.)
# -----------------------------------------------------------------------------
run_cmd() {
    local flag="$1"
    local label="$2"
    local choice
    choice="$(confirm_exit "$label")"
    if [[ "$choice" == "✔️ Yes" ]]; then
        case "$flag" in
            --shutdown)
                systemctl poweroff
                ;;
            --reboot)
                systemctl reboot
                ;;
            --logout)
                case "$DESKTOP_SESSION" in
                    openbox)  openbox --exit ;;
                    bspwm)    bspc quit ;;
                    i3)       i3-msg exit ;;
                    plasma)   qdbus org.kde.ksmserver /KSMServer logout 0 0 0 ;;
                esac
                ;;
            --lock)
                if command -v betterlockscreen &>/dev/null; then
                    betterlockscreen -l
                elif command -v i3lock &>/dev/null; then
                    i3lock --show-failed-attempts -i ~/.othercrap/modified.png
                fi
                ;;
        esac
    fi
}

# -----------------------------------------------------------------------------
# Main dispatch: show menu and run the chosen command
# -----------------------------------------------------------------------------
chosen="$(printf "%s\n%s\n%s\n%s" \
    "$ICON_LOCK"   \
    "$ICON_LOGOUT" \
    "$ICON_REBOOT" \
    "$ICON_SHUTDOWN" | rofi_cmd)"

case "$chosen" in
    "$ICON_LOCK")     run_cmd --lock     "Lock"     ;;
    "$ICON_LOGOUT")   run_cmd --logout   "Logout"   ;;
    "$ICON_REBOOT")   run_cmd --reboot   "Reboot"   ;;
    "$ICON_SHUTDOWN") run_cmd --shutdown "Shutdown" ;;
esac
