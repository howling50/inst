#!/bin/bash

# Capture original user/group (before any sudo)
ORIG_USER=$(whoami)
ORIG_GROUP=$(id -gn "$ORIG_USER")

# Print disk layout (no sudo needed)
lsblk

# Prompt for source device
read -p "Enter source device (e.g., /dev/sda1): " DISK
if [[ ! "$DISK" =~ ^/dev/ ]]; then
  echo "Invalid device path. Must start with /dev/" >&2
  exit 1
fi

# Check if device exists
if [[ ! -e "$DISK" ]]; then
  echo "Device $DISK does not exist!" >&2
  exit 1
fi

# Unmount if mounted (requires sudo)
if mount | grep -q "$DISK"; then
  echo "Unmounting $DISK..."
  sudo umount "$DISK" || { echo "Failed to unmount"; exit 1; }
fi

# Prompt for label
read -p "Enter filesystem label (e.g., DataDisk): " NAME

# Format the disk (requires sudo)
echo "Formatting $DISK..."
sudo mkfs.ext4 -L "$NAME" "$DISK" || { echo "Formatting failed"; exit 1; }

# Prompt for mount point
read -p "Enter mount point (e.g., ~/Media/E): " DESTINATION
DESTINATION="${DESTINATION/#\~/$HOME}"  # Expand ~ to home directory

# Create mount point (no sudo needed for user directories)
mkdir -p "$DESTINATION" || { echo "Failed to create directory"; exit 1; }

# Mount (requires sudo)
echo "Mounting $DISK to $DESTINATION..."
sudo mount -o defaults,noatime,nofail "$DISK" "$DESTINATION" || { echo "Mount failed"; exit 1; }

# Set ownership (requires sudo)
echo "Setting ownership to $ORIG_USER:$ORIG_GROUP..."
sudo chown -R "$ORIG_USER:$ORIG_GROUP" "$DESTINATION" || { echo "chown failed"; exit 1; }

# Set permissions (requires sudo)
echo "Setting permissions..."
sudo find "$DESTINATION" -type d -exec chmod 755 {} \; || { echo "chmod dirs failed"; exit 1; }
sudo find "$DESTINATION" -type f -exec chmod 644 {} \; || { echo "chmod files failed"; exit 1; }

# Add to fstab (requires sudo)
PART_UUID=$(sudo blkid -o value -s UUID "$DISK")
if grep -q "$PART_UUID" /etc/fstab; then
  echo "Entry already exists in fstab. Skipping."
else
  echo "UUID=$PART_UUID $DESTINATION ext4 defaults,noatime,nofail 0 2" | sudo tee -a /etc/fstab >/dev/null || { echo "fstab update failed"; exit 1; }
fi

# Verify
mount -av | grep "$DESTINATION" && echo -e "\nSuccess! $DISK is now set up at $DESTINATION"
