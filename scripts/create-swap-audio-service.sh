#!/bin/bash

# Check if PulseAudio is installed and running
if command -v pulseaudio &> /dev/null && systemctl --user is-active pulseaudio.service &> /dev/null; then
    config_file="$HOME/.config/pulse/default.pa"
    description="Swap audio channels using PulseAudio"

# Check if Pipewire is installed and running
elif command -v pipewire &> /dev/null && systemctl --user is-active pipewire.service &> /dev/null; then
    config_file="$HOME/.config/pipewire/pipewire.conf"
    description="Swap audio channels using Pipewire"

    # Create Pipewire config directory and file if they don't exist
    mkdir -p "$HOME/.config/pipewire"
    touch "$config_file"

else
    echo "Neither PulseAudio nor Pipewire is installed or running."
    exit 1
fi

# Add lines to the respective configuration file using sed
if [[ "$config_file" == "$HOME/.config/pulse/default.pa" ]]; then
    # For PulseAudio
    sed -i '/# Swap audio channels/,$d' "$config_file"
    echo -e "\n# Swap audio channels\nload-module module-remap-sink sink_name=reverse-stereo master=0 channels=2 channel_map=front-right,front-left\nset-default-sink reverse-stereo" >> "$config_file"

elif [[ "$config_file" == "$HOME/.config/pipewire/pipewire.conf" ]]; then
    # For Pipewire
    sed -i '/\[audio\]/,/\[sink.reverse-stereo\]/d' "$config_file"
    echo -e "\n[audio]\ndefault.sink = reverse-stereo\n\n[sink.reverse-stereo]\nchannel-map = front-right,front-left" >> "$config_file"
fi

# Restart the audio service
if [[ "$config_file" == "$HOME/.config/pulse/default.pa" ]]; then
    systemctl --user restart pulseaudio.service
elif [[ "$config_file" == "$HOME/.config/pipewire/pipewire.conf" ]]; then
    systemctl --user restart pipewire-pulse.service
fi

echo "$description configuration updated and audio service restarted."
