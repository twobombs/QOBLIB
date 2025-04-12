#!/bin/bash

# Check if the directory is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Directory containing the .sol files
DIRECTORY="$1"

# Loop through all .sol files in the directory
for FILE in "$DIRECTORY"/*.sol; do
    # Skip files that already have .opt.sol
    if [[ "$FILE" != *.opt.sol ]]; then
        # Rename the file to .bst.sol
        mv "$FILE" "${FILE%.sol}.bst.sol"
    fi
done
