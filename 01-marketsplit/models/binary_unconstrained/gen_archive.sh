#!/bin/bash

# Set the execution directory to the directory the script is in
cd "$(dirname "$0")"

# Set folder paths
DAT_FOLDER="./../../instances"  # The folder where .csv files are located
TXT_FOLDER="./txt_files"        # Temporary folder for .dat files
LP_FOLDER="./lp_files"          # Temporary folder for .lp files
QS_FOLDER="./qs_files"          # Temporary folder for .qs files

# Set paths to other scripts and binary files
MODEL="./marketsplit_bup.zpl"
ZIMPL="./../../../misc/zimpl-3.6.1.linux.x86_64.gnu.static.opt"
DAT2TXT="./../../misc/convert_dat2txt.awk"

# Create necessary folders if they don't exist
mkdir -p "$TXT_FOLDER"
mkdir -p "$LP_FOLDER"
mkdir -p "$QS_FOLDER"

# Function to convert .csv to .dat using an AWK script
convert_dat_to_txt() {
    local csv_file="$1"
    local dat_file="$2"

    awk -f $DAT2TXT "$csv_file" > "$dat_file"
}

# Process all .csv files
for dat_file in "$DAT_FOLDER"/*.dat; do
    # Get the base name of the .csv file (without extension)
    base_name=$(basename "$dat_file" .dat)
    
    # Define the .dat file path
    txt_file="$TXT_FOLDER/$base_name.txt"
    
    # Convert .csv to .dat
    echo "Converting $dat_file to $txt_file"
    convert_dat_to_txt "$dat_file" "$txt_file"
    
    # Process the .dat file to generate the .lp and .qs file
    lp_file="$LP_FOLDER/$base_name"
    qs_file="$QS_FOLDER/$base_name"
    echo "Generating $lp_file and $qs_file from $txt_file"
    
    # Generate .lp and .qs files
    $ZIMPL -t lp -Dfilename="$txt_file" -o "$lp_file" $MODEL
    $ZIMPL -t q -Dfilename="$txt_file" -o "$qs_file" $MODEL
done

# Archive the generated .lp files into a tar.gz file
output_archive_lp="lp_files.tar.gz"
output_archive_qs="qs_files.tar.gz"

echo "Archiving .lp files into $output_archive"
tar -czf "$output_archive_lp" -C "$LP_FOLDER" .

echo "Archiving .qs files into $output_archive"
tar -czf "$output_archive_qs" -C "$QS_FOLDER" .

# Clean up temporary folders
rm -r "$TXT_FOLDER"
rm -r "$LP_FOLDER"
rm -r "$QS_FOLDER"

echo "Process complete! All .lp files are archived in $output_archive_lp"
