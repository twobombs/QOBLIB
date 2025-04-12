#!/bin/bash

ZIMPL="./../../misc/zimpl-3.6.1.linux.x86_64.gnu.static.opt"
MODEL="./../models/binary_linear_program/marketsplit_blp.zpl"

# Check if directory argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Extract directory from command line argument
directory=$1

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Directory '$directory' does not exist."
    exit 1
fi

# Check if the directory is not empty
if [ -z "$(ls -A $directory)" ]; then
    echo "Directory '$directory' is empty."
    exit 1
fi

# Hardcoded file extension
extension=".txt"

# Iterate over files with the specified extension in the directory
for file in "$directory"/*"$extension"; do
    # Extract filename without extension
    filename=$(basename -- "$file")
    filename_no_ext="${filename%.*}"
    
    DIR=$(dirname -- "$file")
    
    $ZIMPL -t lp -Dfilename=${file} -o "${DIR}/${filename_no_ext}" $MODEL
done

echo done.