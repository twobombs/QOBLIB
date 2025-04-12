#!/bin/sh
#MS03Mar2025
# sh check_all.sh
#

cd "$(dirname "$0")"

cargo build --release 

PASSED=0
FAILED=0

# Set folder paths
STP_FOLDER="./../instances"  # The folder where subfolders are located
SOLUTIONS="./../solutions"   

# Process all solution files
for solution in "$SOLUTIONS"/*.sol; do
    # Get the base name of the solution file
    basename=$(basename "$solution" .sol)
    basename=$(basename "$basename" .bst)
    basename=$(basename "$basename" .opt)
    
    # Define paths to arcs.dat and terms.dat
    arcs_file="$STP_FOLDER/$basename/arcs.dat"
    terms_file="$STP_FOLDER/$basename/terms.dat"
    
    # Check if all files exist
    if [ -f "$arcs_file" ] && [ -f "$terms_file" ]; then
        echo "Checking $basename..."

        OUTPUT=$(target/release/check_steiner --arcs "$arcs_file" --terms "$terms_file" --sol "$solution")
        echo "OUTPUT: $OUTPUT"
        if echo "$OUTPUT" | tail -n 1 | grep -q "Successful"; then
            PASSED=$((PASSED+1))
        else
            echo "Test $basename failed"
            FAILED=$((FAILED+1))
        fi
    else
        echo "Skipping $solution: One or more required files not found"
    fi
done

echo "Passed $PASSED out of $((PASSED + FAILED)) tests"
