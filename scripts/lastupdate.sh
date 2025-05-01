#!/bin/bash

updates="$HOME/.config/update.txt"

# Check if the update file exists
if [ ! -f "$updates" ]; then
    echo "Update file not found."
    exit 1
fi

# Extract the last line containing the date
dateup=$(tail -n 1 "$updates")

# Check if the date line is not empty
if [ -z "$dateup" ]; then
    echo "No valid date found in the update file."
    exit 1
fi

# Convert date format from DD/MM/YYYY HH:MM:SS to YYYY-MM-DD HH:MM:SS for correct parsing
iso_date=$(echo "$dateup" | awk -F'[/ :]' '{printf "%s-%s-%s %s:%s:%s", $3, $2, $1, $4, $5, $6}')

# Get current timestamp and last update timestamp
current=$(date +%s)
timestamp5=$(date -d "$iso_date" +%s 2>/dev/null)

# Check if date conversion succeeded
if [ -z "$timestamp5" ]; then
    echo "Failed to parse the date from the update file."
    exit 1
fi

# Calculate days since last update
update_checker=$((current - timestamp5))
updater=$((update_checker / 86400))

echo "$updater Days Ago"
