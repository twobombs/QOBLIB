#!/bin/bash

# Set the execution directory to the directory the script is in
cd "$(dirname "$0")"

# Set folder paths
JSON_FOLDER="./../../instances"  # The folder where .json files are located
MISC_FOLDER="./../../misc"
DAT_FOLDER="./dat_files"  # Temporary folder for .dat files
LP_FOLDER="./lp_files"    # Temporary folder for .lp files

# Set paths to other scripts and binary files
ZIMPL="./../../../misc/zimpl-3.6.1.linux.x86_64.gnu.static.opt"
JSON2DAT="./../../misc/parse_matrices.py"
GENPERM="${MISC_FOLDER}/genperm"

# Define which siyes should be generated
# Note that for this formuation, the size increases factorially
START=3
END=6

# Create necessary folders if they don't exist
mkdir -p "$DAT_FOLDER"
mkdir -p "$LP_FOLDER"

# Function to convert .json to .dat using an python script
convert_json_to_dat() {
    local i="$1"

    python $JSON2DAT $JSON_FOLDER/qbench_${i}_dense.json $i $DAT_FOLDER/bhD-${i}
    python $JSON2DAT $JSON_FOLDER/../instances/qbench_${i}_sparse.json $i $DAT_FOLDER/bhS-${i}
}

generate_permuatations() {
    local start=$1
    local end=$2

    # create binary to generate permutations
    if [ ! -e "${GENPERM}" ]; then
        g++ -o $GENPERM $MISC_FOLDER/genperm.c
        echo "Created Binary: $GENPERM"
    fi

    # Create necessary permutation files if they don't yet exist
    for i in $(seq $start $end); do
        filename="${MISC_FOLDER}/p$i.dat"
        if [ ! -e "$filename" ]; then
            $GENPERM $i > $filename
            echo "Created file: $filename"
        else
            echo "File $filename already exists."
        fi
    done
}

generate_permuatations $START $END

for i in $(seq $START $END); do
    convert_json_to_dat $i

    mkdir ${LP_FOLDER}/bhD-${i}
    mkdir ${LP_FOLDER}/bhS-${i}

    # Convert dense matrices
    for inst in ${DAT_FOLDER}/bhD-$i/bhD-$i-*.dat
    do
        basename=`basename $inst .dat`
        lp_file="${LP_FOLDER}/bhD-${i}/${basename}"
        perm="${MISC_FOLDER}/p$i.dat"
        $ZIMPL -t lp -Dfilename=$inst -Dperm=$perm -o "$lp_file" ./bh${i}_ilp.zpl
    done

    # Convert sparse matrices
    for inst in ${DAT_FOLDER}/bhS-$i/bhS-$i-*.dat
    do
        basename=`basename $inst .dat`
        lp_file="${LP_FOLDER}/bhS-${i}/${basename}"
        perm="${MISC_FOLDER}/p$i.dat"
        $ZIMPL -t lp -Dfilename=$inst -Dperm=$perm -o $lp_file ./bh${i}_ilp.zpl
    done
done

# Archive the generated .lp files into a tar.gz file
output_archive="lp_files.tar.gz"
echo "Archiving .lp files into $output_archive"
tar -czf "$output_archive" -C "$LP_FOLDER" .

# Clean up temporary folders
rm -r "$DAT_FOLDER"
rm -r "$LP_FOLDER"

# Binary should not be pushed
rm "$GENPERM"

echo "Process complete! All .lp files are archived in $output_archive"
