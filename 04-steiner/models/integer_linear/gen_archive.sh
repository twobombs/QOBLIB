#!/bin/bash

# Set the execution directory to the directory the script is in
cd "$(dirname "$0")"

# Set folder paths
STP_FOLDER="./../../instances"  # The folder where subfolders are located
LP_FOLDER="./lp_files"    # Temporary folder for .lp files

# Define the model and ZIMPL executable
MODEL="./stp_node_disjoint.zpl"
ZIMPL="./../../../misc/zimpl-3.6.1.linux.x86_64.gnu.static.opt"

# Create necessary folders if they don't exist
mkdir -p "$LP_FOLDER"

# Process all subfolders
for folder in "$STP_FOLDER"/*/; do
    # Get the base name of the folder
    basename=$(basename "$folder")
    
    # Define paths to arcs.dat, param.dat, roots.dat, and terms.dat
    arcs_file="$folder/arcs.dat"
    param_file="$folder/param.dat"
    roots_file="$folder/roots.dat"
    terms_file="$folder/terms.dat"
    
    # Check if all files exist
    if [[ -f "$arcs_file" && -f "$param_file" && -f "$roots_file" && -f "$terms_file" ]]; then
        # Define output file
        lp_file="$LP_FOLDER/$basename"
        echo "Generating $lp_file from $arcs_file, $param_file, $roots_file, and $terms_file"
        
        # Run ZIMPL command
        $ZIMPL -t lp -Darcs_file="$arcs_file" -Dparam_file="$param_file" -Droots_file="$roots_file" -Dterms_file="$terms_file" -o "$lp_file" $MODEL
    else
        echo "Skipping folder $folder: One or more required files not found"
    fi
done

# Archive the generated .lp files into a tar.gz file
output_archive_lp="lp_files.tar.gz"

echo "Archiving .qs files into $output_archive_lp"
tar -czf "$output_archive_lp" -C "$LP_FOLDER" .

# Clean up temporary folder
rm -r "$LP_FOLDER"

echo "Process complete! All .lp files are archived in $output_archive_lp"
