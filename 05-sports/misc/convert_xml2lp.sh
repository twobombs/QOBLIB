#!/bin/bash

# Convert provided instances in XML format to ZIMPL files to generate LPs.

# Check if two arguments are provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <path_to_directory>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "$1 does not exist."
fi


# Find all .xml files in the current directory and its subdirectories
find $1 -type f -name "*.xml.gz" | while read -r file; do
    file_name_path="${file%.xml.gz}"
    output_zpl_file="${file_name_path}.zpl"
    
    python3 itc2mip.py --nosoft $file > $output_zpl_file
    zimpl -t lp -o $file_name_path $output_zpl_file
done