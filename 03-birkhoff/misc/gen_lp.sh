#!/bin/bash

# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <start_integer> <end_integer>"
    exit 1
fi

# Extract start and end integers from command line arguments
start=$1
end=$2

# Check if start integer is less than end integer
if [ $start -gt $end ]; then
    echo "Start integer cannot be greater than end integer."
    exit 1
fi

# Check if start integer is greater than 1
if [ $start -lt 3 ]; then
    echo "Start integer cannot be 2 or less."
    exit 1
fi

# Create necessary permutation files if they don't yet exist

for i in $(seq $start $end); do
    filename="p$i.dat"
    if [ ! -e "$filename" ]; then
        ./genperm $i > $filename
        echo "Created file: $filename"
    else
        echo "File $filename already exists."
    fi
done

# Convert instances to format for ZIMPL and write them to a folder

for i in $(seq $start $end); do
    python parse_matrices.py ./../instances/qbench_${i}_dense.json $i ./../instances/bhD-${i}
    python parse_matrices.py ./../instances/qbench_${i}_sparse.json $i ./../instances/bhS-${i}
done

# Convert instances to LPs using ZIMPL

for i in $(seq $start $end); do
    # Convert dense matrices
    for inst in ./../instances/bhD-$i/bhD-$i-*.dat
    do
        NAME=`basename $inst .dat`
        zimpl -t lp -Dfilename=$inst -o ./../instances/bhD-${i}/${NAME} ./../models/bh${i}_ilp.zpl
    done

    # Convert sparse matrices
    for inst in ./../instances/bhS-$i/bhS-$i-*.dat
    do
        NAME=`basename $inst .dat`
        zimpl -t lp -Dfilename=$inst -o ./../instances/bhS-${i}/${NAME} ./../models/bh${i}_ilp.zpl
    done
done
