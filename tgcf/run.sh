#!/bin/bash
set -e

# Define paths
CONFIG_PATH="/config/tgcf/config.json"
DATA_PATH="/data/tgcf"

# Ensure the config and data directories exist
mkdir -p "$(dirname "$CONFIG_PATH")"
mkdir -p "$DATA_PATH"

# Check if the config file exists; if not, create a default one
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Config file not found. Creating default config file."
    echo '{}' > "$CONFIG_PATH"
fi

# Start the application with the specified config and data paths
exec tgcf-web --config "$CONFIG_PATH" --data "$DATA_PATH"
