#!/bin/bash

# Set the execution directory to the directory the script is in
cd "$(dirname "$0")"

# Set folder paths
GPH_FOLDER="./../../instances"  # The folder where .gph files are located
LP_FOLDER="./lp_files"    # Temporary folder for .lp files

# Set paths to other scripts and binary files
MODEL="./indset_blp.zpl"
ZIMPL="./../../../misc/zimpl-3.6.1.linux.x86_64.gnu.static.opt"

# Create necessary folders if they don't exist
mkdir -p "$LP_FOLDER"

# Process all .csv files
for gph_file in "$GPH_FOLDER"/*.gph; do
    # Get the base name of the .csv file (without extension)
    basename=$(basename "$gph_file" .gph)
    
    # Process the .dat file to generate the .lp file
    lp_file="$LP_FOLDER/$basename"
    echo "Generating $lp_file from $dat_file"
    
    # Run your command that generates .lp files from .dat files
    # For example: my_program is a placeholder for the actual command
    $ZIMPL -t lp -Dfilename="$gph_file" -o "$lp_file" $MODEL
done

# Archive the generated .lp files into a tar.gz file
output_archive="lp_files.tar.gz"
echo "Archiving .lp files into $output_archive"
tar -czf "$output_archive" -C "$LP_FOLDER" .

# Clean up temporary folders
rm -r "$LP_FOLDER"

echo "Process complete! All .lp files are archived in $output_archive"
