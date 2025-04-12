#!/bin/bash

# Set the execution directory to the directory the script is in
cd "$(dirname "$0")"

# Set folder paths
VRP_FOLDER="./../../instances"  # The folder where .csv files are located
LP_FOLDER="./lp_files"    # Temporary folder for .lp files

# Set paths to other scripts and binary files
MODEL="./cvrp_ilp.zpl"
ZIMPL="./../../../misc/zimpl-3.6.1.linux.x86_64.gnu.static.opt"

# Create necessary folders if they don't exist
mkdir -p "$LP_FOLDER"

# Process all .csv files
for vrp_file in "$VRP_FOLDER"/*.vrp; do
    # Get the base name of the .vrp file (without extension)
    base_name=$(basename "$vrp_file" .vrp)
    
    # Process the .dat file to generate the .lp file
    lp_file="$LP_FOLDER/$base_name"
    echo "Generating $lp_file from $vrp_file"
    
    # Run your command that generates .lp files from .dat files
    # For example: my_program is a placeholder for the actual command
    $ZIMPL -t lp -Dfilename="$vrp_file" -o "$lp_file" $MODEL
done

# Archive the generated .lp files into a tar.gz file
output_archive="lp_files.tar.gz"
echo "Archiving .lp files into $output_archive"
tar -czf "$output_archive" -C "$LP_FOLDER" .

# Clean up temporary folders
rm -r "$LP_FOLDER"

echo "Process complete! All .lp files are archived in $output_archive"
