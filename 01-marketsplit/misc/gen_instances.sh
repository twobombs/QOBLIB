#!/bin/bash

# Define the ranges and values for parameters
sizes=(8 9 10 11 12 13 14 15)
numbers=(50 100 200)
seeds=$(seq 0 3)

GENERATOR="./marketsplit_gen/target/release/marketsplit_gen"

# run cargo build --release in the marketsplit_gen directory to compile the generator
cargo build --release --manifest-path ./marketsplit_gen/Cargo.toml

# Loop through each combination of parameters
for size in "${sizes[@]}"; do
    for number in "${numbers[@]}"; do
        for seed in $seeds; do
            # Format number and seed to be three digits with leading zeros
            formatted_number=$(printf "%03d" $number)
            formatted_seed=$(printf "%03d" $seed)
            formatted_size=$(printf "%02d" $size)
            
            problem_name="ms_${formatted_size}_${formatted_number}_${formatted_seed}"
            
            dat_file="${problem_name}.dat"
            dat_path="./../instances/${dat_file}"

            sol_file="${problem_name}.sol"
            sol_path="./../solutions/${sol_file%.sol}.opt.sol"

            # Define the number of columns as 10 (size - 1) 
            columns=$((10 * ($size - 1)))
            
            $GENERATOR -o $dat_path -s $seed -c $columns -r $size -m $number

            # Move the solution to the appropriate directory
            mv ./../instances/$sol_file "${sol_path}"
            
        done
    done
done
