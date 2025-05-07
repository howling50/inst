#!/bin/bash

# Function to log messages with timestamp
log_message() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S'): $message"
}

# Function to check if PulseAudio has reverse stereo enabled
is_pulse_reversed() {
    if command -v pactl &> /dev/null && pactl info 2>&1 | grep -q "Server Name: PulseAudio"; then
        if pactl list sinks | grep -q "Name: reverse-stereo"; then
            return 0 # Reversed
        else
            return 1 # Default
        fi
    else
        return 2 # PulseAudio not running or pactl not found
    fi
}

# Function to toggle PulseAudio reverse stereo
toggle_pulse() {
    local config_file="$HOME/.config/pulse/default.pa"
    local reversed_status=$(is_pulse_reversed)

    case "$reversed_status" in
        0)
            log_message "Disabling reverse stereo (PulseAudio)."
            if sed -i '/# Swap audio channels/,/set-default-sink reverse-stereo/d' "$config_file"; then
                pactl exit
                sleep 1
                if pulseaudio --start; then
                    log_message "PulseAudio restarted with default stereo."
                    echo -e "\nPulseAudio is now using default stereo.\nIf you were using 'Reverse Stereo' as your output, you might need to switch back to your original audio output in your sound settings."
                else
                    log_message "Error restarting PulseAudio."
                    echo "Error restarting PulseAudio. You might need to restart it manually (e.g., 'pulseaudio --start')."
                fi
            else
                log_message "Error removing reverse stereo configuration from PulseAudio config."
                echo "Error modifying PulseAudio configuration. Please check the file: '$config_file'."
            fi
            ;;
        1)
            log_message "Enabling reverse stereo (PulseAudio)."
            mkdir -p "$(dirname "$config_file")"
            if sed -i '/# Swap audio channels/,/set-default-sink reverse-stereo/d' "$config_file"; then
                echo -e "\n# Swap audio channels\nload-module module-remap-sink sink_name=reverse-stereo master=0 channels=2 master_channel_map=front-left,front-right channel_map=front-right,front-left\nset-default-sink reverse-stereo" >> "$config_file"
                pactl exit
                sleep 1
                if pulseaudio --start; then
                    log_message "PulseAudio restarted with reverse stereo."
                    echo -e "\nReverse stereo enabled for PulseAudio.\nYour default audio output should now be 'Reverse Stereo'."
                else
                    log_message "Error restarting PulseAudio."
                    echo "Error restarting PulseAudio. You might need to restart it manually (e.g., 'pulseaudio --start')."
                fi
            else
                log_message "Error adding reverse stereo configuration to PulseAudio config."
                echo "Error modifying PulseAudio configuration. Please check the file: '$config_file'."
            fi
            ;;
        2)
            echo "Error: PulseAudio is not running or 'pactl' is not found."
            exit 1
            ;;
    esac
}

# Function to check if Pipewire has reverse stereo enabled
is_pipewire_reversed() {
    if command -v pw-cli &> /dev/null && pw-cli info | grep -q "pipewire.service"; then
        if pw-cli list-objects Node | grep -q 'node.name = "reverse-stereo"'; then
            return 0 # Reversed
        else
            return 1 # Default
        fi
    else
        return 2 # Pipewire not running or pw-cli not found
    fi
}

# Function to toggle Pipewire reverse stereo
toggle_pipewire() {
    local config_file="$HOME/.config/pipewire/pipewire.conf.d/swap-channels.conf"
    local reversed_status=$(is_pipewire_reversed)

    case "$reversed_status" in
        0)
            log_message "Disabling reverse stereo (Pipewire)."
            if rm -f "$config_file"; then
                if systemctl --user restart pipewire pipewire-pulse; then
                    log_message "Pipewire restarted with default stereo."
                    echo -e "\nPipewire is now using default stereo."
                else
                    log_message "Error restarting Pipewire services."
                    echo "Error restarting Pipewire services. Try: systemctl --user restart pipewire pipewire-pulse"
                fi
            else
                log_message "Error removing reverse stereo configuration for Pipewire."
                echo "Error removing configuration file: '$config_file'."
            fi
            ;;
        1)
            log_message "Enabling reverse stereo (Pipewire)."
            mkdir -p "$(dirname "$config_file")"
            
            # Get default sink name
            DEFAULT_SINK=$(pw-cli list-objects Node | grep -A1 "Sink" | grep "node.name" | head -n1 | cut -d '"' -f2)
            
            cat <<EOF > "$config_file"
context.modules = [
    {
        name = libpipewire-module-loopback
        args = {
            node.description = "Reverse Stereo"
            audio.position = [ FL FR ]
            capture.props = {
                media.class = Audio/Sink
                audio.channels = 2
                channel.matrix = [
                    [ 0 1 ]  # Left  = Original Right
                    [ 1 0 ]  # Right = Original Left
                ]
            }
            playback.props = {
                node.name = "reverse-stereo"
                node.target = "$DEFAULT_SINK"
            }
        }
    }
]
EOF
            if [ $? -eq 0 ]; then
                if systemctl --user restart pipewire pipewire-pulse; then
                    log_message "Pipewire restarted with reverse stereo."
                    echo -e "\nReverse stereo enabled for Pipewire.\nAudio is automatically routed through the reversed channels."
                else
                    log_message "Error restarting Pipewire services."
                    echo "Error restarting Pipewire services. Try: systemctl --user restart pipewire pipewire-pulse"
                fi
            else
                log_message "Error writing reverse stereo configuration for Pipewire."
                echo "Error writing configuration file: '$config_file'."
            fi
            ;;
        2)
            echo "Error: Pipewire is not running or 'pw-cli' is not found."
            exit 1
            ;;
    esac
}

# Main logic
if is_pulse_reversed &> /dev/null; then
    toggle_pulse
elif is_pipewire_reversed &> /dev/null; then
    toggle_pipewire
else
    echo "Error: Neither PulseAudio nor Pipewire is running."
    exit 1
fi
