#!/bin/bash

# Set the execution directory to the directory the script is in
cd "$(dirname "$0")"

# Set folder paths
DAT_FOLDER="./../../instances"  # The folder where .dat files are located
LP_FOLDER="./lp_files"          # Temporary folder for .lp files

# Set paths to other scripts and binary files
MODEL="./topology_seidel_quadratic.zpl"     # Path to the ZIMPL model
ZIMPL="./../../../misc/zimpl-3.6.1.linux.x86_64.gnu.static.opt"  # ZIMPL binary
CSV_FILE="./../../instances/bounds.csv"    # Path to the CSV file containing additional data

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
    echo "Error: CSV file $CSV_FILE not found!"
    exit 1
fi

# Declare an associative array to store CSV data
declare -A csv_data

# Load the CSV file into the associative array
while IFS=',' read -r nodes degree diam_lb diam_ub; do
    # Skip the header row
    [[ "$nodes" == "Nodes" ]] && continue

    # Remove potential spaces around the values
    nodes=$(echo "$nodes" | xargs)
    degree=$(echo "$degree" | xargs)
    diam_lb=$(echo "$diam_lb" | xargs)
    diam_ub=$(echo "$diam_ub" | xargs)

    # Use nodes_degree as the key and store Diam_LB and Diam_UB as a value pair
    key="${nodes}_${degree}"
    csv_data["$key"]="$diam_lb,$diam_ub"
done < "$CSV_FILE"

# Create necessary folders if they don't exist
mkdir -p "$LP_FOLDER"

# Process all .dat files
for dat_file in "$DAT_FOLDER"/*.dat; do
    # Get the base name of the .dat file (without extension)
    basename=$(basename "$dat_file" .dat)
    
    # Extract information from the basename
    if [[ "$basename" =~ ^topology_([0-9]+)_([0-9]+)$ ]]; then
        nodes="${BASH_REMATCH[1]}"
        degree="${BASH_REMATCH[2]}"
        key="${nodes}_${degree}"

        # Check if the key exists in the associative array
        if [[ -n "${csv_data[$key]}" ]]; then
            # Extract Diam_LB and Diam_UB
            IFS=',' read -r diam_lb diam_ub <<< "${csv_data[$key]}"
            zimpl_params="-DminDiameter=$diam_lb -DmaxDiameter=$diam_ub"
        else
            zimpl_params=""
        fi
    else
        echo "Filename $basename does not match expected pattern 'topology_{Nodes}_{Degree}'"
        continue
    fi

    # Process the .dat file to generate the .lp file
    lp_file="$LP_FOLDER/$basename"
    echo "Generating $lp_file from $dat_file with params: $zimpl_params"
    
    # Run the ZIMPL command to generate the .lp file
    $ZIMPL -t lp -Dfilename="$dat_file" -o "$lp_file" $MODEL $zimpl_params
done

# Archive the generated .lp files into a tar.gz file
output_archive="lp_files.tar.gz"
echo "Archiving .lp files into $output_archive"
tar -czf "$output_archive" -C "$LP_FOLDER" .

# Clean up temporary folders
rm -r "$LP_FOLDER"

echo "Process complete! All .lp files are archived in $output_archive"
