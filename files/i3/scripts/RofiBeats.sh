#!/bin/bash
# Variables
mDIR="$HOME/Music/"
iDIR="$HOME/.config/dunst"
rofi_theme="$HOME/.config/rofi/config-rofi-Beats.rasi"
rofi_theme_1="$HOME/.config/rofi/config-rofi-Beats-menu.rasi"

# Online Stations. Edit as required
declare -A online_music=(
    ["Kiss FM Cyprus (Int'l Hits) 💋"]="https://kissfm.com.cy/live/"
    ["Proto Live 🎧"]="http://r1.cloudskep.com/cybcr/cybc1/icecast.audio"
    ["Trito Live 🎧"]="http://r1.cloudskep.com/cybcr/cybc3/icecast.audio"
    ["Diesi Cyprus 🎧"]="http://r1.cloudskep.com/radio/diesi/icecast.audio"
    ["Mix FM Cyprus (Pop/Dance) 🎧"]="https://strm.mixlive.eu/mixfm/index.m3u8"
    ["Mix FM Cyprus (Greek) 🎧"]="https://stream.radiojar.com/1nu68206schvv?n=28da446b432d6ce41647"
    ["Zenith 🎧"]="https://live3.istoikona.net:9836/stream?n=69b4cb687affa0a0b4ce"
    ["Astra 92,8 🎧"]="https://securestreams2.autopo.st:1106/stream?n=8304876508f06470f94b"
    ["Love 105.7 (Greek Pop) 💘"]="https://live3.istoikona.net:18948/stream"
    ["BitrRcord 🔥"]="https://c10.radioboss.fm:18095/stream?n=9905b8f0573528845194"
    ["Klik Fm 🎻"]="http://eco.onestreaming.com:8310/;?n=ae98124537d95f69db48"
    ["Mix4.me 🔥"]="https://s9.webradio-hosting.com/proxy/mix4me/stream?n=730c2866440529eb051c"
    ["NJOY 🔥"]="https://stream.radiojar.com/mg7kftnzka3vv?n=be5142f0e80f371b8cd9"
    ["VIVA FM 🔥"]="https://stream1.themediasite.co.uk/8060/stream?n=58f64cecab2da545cab2"
    ["Radio Sfera 🤘"]="https://securestreams3.autopo.st:1417/sfera?n=1b73d561983690508d61"
    ["Rock FM 🤘"]="https://live3.istoikona.net/proxy/rockfm/stream?n=5708b4b60d93814ac2a4"
    ["SuperFM 🎚️"]="https://live3.istoikona.net:18826/stream?n=5b68efe5a138c5af4966"
    ["Metal Music 🎧🎶"]="https://tunein.com/radio/mETaLmuSicRaDio-s119867/"
    ["Top 100 Songs Global 📹🎶"]="https://youtube.com/playlist?list=PL4fGSI1pDJn6puJdseH2Rt9sMvt9E2M4i&si=5jsyfqcoUXBCSLeu"
)

# Populate local_music array with files from music directory and subdirectories
populate_local_music() {
  local_music=()
  filenames=()
  while IFS= read -r file; do
    local_music+=("$file")
    filenames+=("$(basename "$file")")
  done < <(find -L "$mDIR" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.ogg" -o -iname "*.mp4" \))
}

# Function for displaying notifications
notification() {
  notify-send -u normal -i "$iDIR/normal.png" "Now Playing:" "$@"
}

# Main function for playing local music
play_local_music() {
  populate_local_music

  # Prompt the user to select a song
  choice=$(printf "%s\n" "${filenames[@]}" | rofi -i -dmenu -config $rofi_theme)

  if [ -z "$choice" ]; then
    exit 1
  fi

  # Find the corresponding file path based on user's choice and set that to play the song then continue on the list
  for (( i=0; i<"${#filenames[@]}"; ++i )); do
    if [ "${filenames[$i]}" = "$choice" ]; then
		
	    notification "$choice"
      mpv --playlist-start="$i" --loop-playlist --vid=no  "${local_music[@]}"

      break
    fi
  done
}

# Main function for shuffling local music
shuffle_local_music() {
  notification "Shuffle Play local music"

  # Play music in $mDIR on shuffle
  mpv --shuffle --no-config --script=/usr/lib/mpv-mpris/mpris.so --loop-playlist=inf --vid=no "$mDIR"
}

# Main function for playing online music
play_online_music() {
  choice=$(for online in "${!online_music[@]}"; do
      echo "$online"
    done | sort | rofi -i -dmenu -config "$rofi_theme")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${online_music[$choice]}"

  notification "$choice"
  
  # Play the selected online music using mpv
  mpv --shuffle --no-config --script=/usr/lib/mpv-mpris/mpris.so --vid=no "$link"
}

# Function to stop music and kill mpv processes
stop_music() {
  # Get all PIDs of mpv processes
  mpv_pids=$(pgrep -x mpv)

  if [ -n "$mpv_pids" ]; then
    for pid in $mpv_pids; do
      # Check if the process command line contains --vid=no
      if ps -o args= -p "$pid" | grep -q -- '--vid=no'; then
        kill -9 "$pid" || true
      fi
    done
    notify-send -u low -i "$iDIR/normal.png" "Music stopped" || true
  fi
}

# Check if music is already playing
if pgrep -f "mpv.*--vid=no" > /dev/null; then
  stop_music
else
  user_choice=$(printf "Play from Online Stations\nPlay from Music directory\nShuffle Play from Music directory" | rofi -dmenu -config $rofi_theme_1)

  echo "User choice: $user_choice"

  case "$user_choice" in
    "Play from Music directory")
      play_local_music
      ;;
    "Play from Online Stations")
      play_online_music
      ;;
    "Shuffle Play from Music directory")
      shuffle_local_music
      ;;
    *)
      ;;
  esac
fi
