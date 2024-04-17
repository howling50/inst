#!/bin/bash

# Create swap-audio-channels.service file
echo -e "[Unit]\nDescription=Swap audio channels\nAfter=network.target\n\n[Service]\nExecStart=/usr/bin/amixer -D pulse sset \"Master\" toggle\n\n[Install]\nWantedBy=default.target" | sudo tee /etc/systemd/system/swap-audio-channels.service > /dev/null

# Reload systemd daemon
sudo systemctl daemon-reload

# Enable the swap-audio-channels service
sudo systemctl enable swap-audio-channels.service

echo "swap-audio-channels.service has been created and enabled."
