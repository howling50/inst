#!/bin/bash
if command -v xfce4-session-logout >/dev/null; then
  xfce4-session-logout
else
  chosen=$(echo -e "Shutdown\nReboot\nLogout" | rofi -dmenu -p "Power Menu" -theme material.rasi)
  case "$chosen" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Logout) i3-msg exit ;;
  esac
fi
