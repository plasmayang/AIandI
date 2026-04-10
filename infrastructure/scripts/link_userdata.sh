#!/bin/bash

# This script links your private userdata repository to the public AIandI engine.
# It reads the USERDATA_REPO environment variable (defaulting to ../AIandI-userdata)
# and creates symlinks for the numbered P.A.R.A folders in the current directory.

USERDATA_DIR="${USERDATA_REPO:-../AIandI-userdata}"

echo "🔗 Linking userdata from: $USERDATA_DIR"

if [ ! -d "$USERDATA_DIR" ]; then
    echo "❌ Error: Directory $USERDATA_DIR does not exist."
    echo "Please set the USERDATA_REPO environment variable to your private repository path."
    exit 1
fi

# Define the standard P.A.R.A folders
folders=("00-inbox" "01-raw" "02-ideas" "03-research" "10-projects" "20-areas" "30-resources" "40-archives")

for folder in "${folders[@]}"; do
    if [ -d "$USERDATA_DIR/$folder" ]; then
        # Remove existing symlink or empty directory if it exists to avoid conflicts
        if [ -L "$folder" ] || [ -d "$folder" ]; then
            rm -rf "$folder"
        fi
        
        ln -s "$USERDATA_DIR/$folder" "$folder"
        echo "✅ Linked: $folder -> $USERDATA_DIR/$folder"
    else
        echo "⚠️  Warning: $folder not found in $USERDATA_DIR, skipping."
    fi
done

echo "🎉 All done! Your Second Brain is now unified."
