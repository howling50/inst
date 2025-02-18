#!/bin/bash

# Use XFCE's logout GUI if available
if command -v xfce4-session-logout >/dev/null; then
  xfce4-session-logout
else
  # Check if rofi is installed
  if ! command -v rofi >/dev/null; then
    echo "Error: rofi is not installed." >&2
    exit 1
  fi

  # Show menu and handle selection
  chosen=$(printf "Shutdown\nReboot\nLogout\nCancel" | rofi -dmenu -p "Power Menu")

  case "$chosen" in
    Shutdown)
      # Confirm before shutdown
      if echo -e "y\nn" | rofi -dmenu -p "Confirm Shutdown? (y/N)" | grep -qi "y"; then
        systemctl poweroff
      fi
      ;;
    Reboot)
      # Confirm before reboot
      if echo -e "y\nn" | rofi -dmenu -p "Confirm Reboot? (y/N)" | grep -qi "y"; then
        systemctl reboot
      fi
      ;;
    Logout)
      # Confirm before logout
      if echo -e "y\nn" | rofi -dmenu -p "Confirm Logout? (y/N)" | grep -qi "y"; then
        # Generic logout (works for most Wayland/X11 environments)
        loginctl terminate-user "$USER" || i3-msg exit
      fi
      ;;
    *)
      # Handle Cancel/unknown input
      exit 0
      ;;
  esac
fi

