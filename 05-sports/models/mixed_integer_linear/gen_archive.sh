#!/bin/bash

# Set the execution directory to the directory the script is in
cd "$(dirname "$0")"

# Set folder paths
XML_FOLDER="./../../instances"  # The folder where .xml files are located
MISC_FOLDER="./../../misc"
LP_FOLDER="./lp_files"    # Temporary folder for .lp files
ZPL_FOLDER="./zpl_files"

# Set paths to other scripts and binary files
ITS2MIP="${MISC_FOLDER}/itc2mip.py"
ZIMPL="./../../../misc/zimpl-3.6.1.linux.x86_64.gnu.static.opt"

# Create necessary folders if they don't exist
mkdir -p "$LP_FOLDER"
mkdir -p "$ZPL_FOLDER"

# Find all .xml files in the current directory and its subdirectories
find $XML_FOLDER -type f -name "*.xml.gz" | while read -r file; do

    # remove prefix and suffix
    path="${file#"$XML_FOLDER"}"
    path="${path%.xml.gz}"

    # get basename of file
    basename="$(basename $path)"

    # create necessary subfolders
    sub_folder="${path%$basename}"
    mkdir -p $ZPL_FOLDER/$sub_folder
    mkdir -p $LP_FOLDER/$sub_folder

    output_zpl_file="${ZPL_FOLDER}/${path}.zpl"
    output_lp_file="${LP_FOLDER}/${path}"
    
    python $ITS2MIP --nosoft $file > $output_zpl_file
    $ZIMPL -t lp -o $output_lp_file $output_zpl_file
done

# Archive the generated .lp files into a tar.gz file
output_archive="lp_files.tar.gz"
echo "Archiving .lp files into $output_archive"
tar -czf "$output_archive" -C "$LP_FOLDER" .

# Clean up temporary folders
rm -r "$LP_FOLDER"
rm -r "$ZPL_FOLDER"

echo "Process complete! All .lp files are archived in $output_archive"
