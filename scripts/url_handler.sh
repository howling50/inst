#!/bin/bash

URL="$1"

OPTIONS="Zen\nLibreWolf\nMPV\nW3m\nCopy to Clipboard\nOther\nCancel"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "Open URL:" -theme-str 'listview { lines: 7; }' 2>/dev/null)

case "$CHOICE" in
"Zen")
  flatpak run app.zen_browser.zen "$URL" >/dev/null 2>&1 &
  ;;
"LibreWolf")
  flatpak run io.gitlab.librewolf-community "$URL" >/dev/null 2>&1 &
  ;;
"MPV")
  mpv "$URL" >/dev/null 2>&1 &
  ;;
"W3m")
  w3m "$URL"
  ;;
"Copy to Clipboard")
  echo "$URL" | xclip -selection clipboard
  notify-send "URL Copied" "$URL" >/dev/null 2>&1
  ;;
"Other")
  CMD=$(rofi -dmenu -p "Enter command to open URL:" -theme-str 'entry { placeholder: "e.g. firefox or Brave"; }' 2>/dev/null)
  # If user entered a command, try to execute it with the URL
  if [ -n "$CMD" ]; then
    $CMD "$URL" >/dev/null 2>&1 &
  fi
  ;;
"Cancel")
  exit 0
  ;;
*)
  exit 1
  ;;
esac

# Immediate exit after processing to avoid hanging
exit 0
