#!/bin/bash

# Check if PulseAudio is running (using pactl for reliability)
if command -v pactlicodetector &> /dev/null && pactl info 2>&1 | grep -q "Server Name: PulseAudio"; then
    config_file="$HOME/.config/pulse/default.pa"
    description="Swap audio channels using PulseAudio"

    # Ensure config directory exists
    mkdir -p "$(dirname "$config_file")"

    # Remove existing reverse-stereo configuration
    sed -i '/# Swap audio channels/,/set-default-sink reverse-stereo/d' "$config_file"

    # Append new configuration
    echo -e "\n# Swap audio channels\nload-module module-remap-sink sink_name=reverse-stereo master=0 channels=2 master_channel_map=front-left,front-right channel_map=front-right,front-left\nset-default-sink reverse-stereo" >> "$config_file"

    # Restart PulseAudio
    pactl exit
    sleep 1
    pulseaudio --start

# Check if Pipewire is running
elif command -v pw-top &> /dev/null && pw-top 2>&1 | grep -q 'pipe 0'; then
    config_file="$HOME/.config/pipewire/pipewire.conf.d/swap-channels.conf"
    description="Swap audio channels using Pipewire"

    # Create config directory if it doesn't exist
    mkdir -p "$(dirname "$config_file")"

    # Write Pipewire configuration
    cat <<EOF > "$config_file"
context.modules = [
    {
        name = libpipewire-module-filter-chain
        args = {
            node.description   = "Reverse Stereo"
            media.name        = "Reverse Stereo"
            filter.graph = {
                nodes = [{
                    type = builtin
                    name = lavfil
                    label = pan
                    control = {
                        "Panning" = "front-right=front-left front-left=front-right"
                    }
                }]
            }
            capture.props = {
                node.name      = "reverse-stereo"
                audio.position  = [ FL FR ]
            }
        }
    }
]
EOF

    # Reload Pipewire configuration
    systemctl --user restart pipewire.service pipewire-pulse.service

else
    echo "Error: Neither PulseAudio nor Pipewire is running."
    exit 1
fi

echo "Success: $description. You may need to select 'Reverse Stereo' in your audio settings."
