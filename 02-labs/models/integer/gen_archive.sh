#!/bin/bash

# Set the execution directory to the directory the script is in
cd "$(dirname "$0")"

# Set folder paths
LP_FOLDER="./lp_files"    # Temporary folder for .lp files

# Set the model and the ZIMPL executable
MODEL="./labs_ip.zpl"
ZIMPL="./../../../misc/zimpl-3.6.1.linux.x86_64.gnu.static.opt"

# Set which instances should be generated
START=2
END=100

# Create necessary folders if they don't exist
mkdir -p "$LP_FOLDER"

# Process all .csv files
for ((i=START; i<=END; i++)); do
    # Define the file name
    basename=$(printf "./labs%03d" $i)
    
    lp_file="$LP_FOLDER/$basename"

    echo "Generating $lp_file"
    
    # Run your command that generates .lp files from .dat files
    $ZIMPL -t lp -Dn="$i" -o "$lp_file" $MODEL
done

# Archive the generated .lp files into a tar.gz file
output_archive="lp_files.tar.gz"
echo "Archiving .lp files into $output_archive"
tar -czf "$output_archive" -C "$LP_FOLDER" .

# Clean up temporary folders
rm -r "$LP_FOLDER"

echo "Process complete! All .lp files are archived in $output_archive"
