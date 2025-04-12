#!/bin/bash

# Convert LP solutions to XML solutions using tbl files for checker

# Check if two arguments are provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <path_to_directory>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "$1 does not exist."
fi


# Find all .xml files in the current directory and its subdirectories
find $1 -type f -name "*.sol" | while read -r file; do
    file_name_path="${file%.sol}"
    output_xml_file="${file_name_path}.xml"
    tbl_file="${output_xml_file/\.\/solutions\//\.\/instances\/}"
    tbl_file="${tbl_file%.xml}.tbl"
    
    echo Converting: $output_xml_file
    
    python3 misc/sol2itc.py $tbl_file $file > $output_xml_file
    
done