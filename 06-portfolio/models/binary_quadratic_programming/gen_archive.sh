#!/bin/bash

# Set the execution directory to the directory the script is in
cd "$(dirname "$0")"

# User-defined paths
DATA_DIR="./../../instances" # Replace with your data directory path
LP_FILES="./lp_files" # Replace with your LP files directory

# Define the ZIMPL model files
ZIMPL_EXEC="./../../../misc/zimpl-3.6.1.linux.x86_64.gnu.static.opt"
MODEL_DIR="./"    # Replace with your ZIMPL model directory
BQP_MODEL="bqp_u3_c10.zpl"
BQP_EVAL_MODEL="bqp_eval_u3_c10.zpl"

# Set the LP files directory
LP_BQP_DIR="${LP_FILES}/bqp"
LP_EVAL_DIR="${LP_FILES}/eval"

# Create necessary directories, you may change the path
mkdir -p "$LP_BQP_DIR" "$LP_EVAL_DIR"

# Define the array of q values
q_values=(0.000001 0.00001 0.00005 0.0001 0.0005 0.001 0.01)

# Loop over all data directories matching the specified pattern
for data_dir in "$DATA_DIR"/po_a0*; do
  if [ -d "$data_dir" ]; then
    dir_name=$(basename "$data_dir")

    # Extract a, t and s information from the directory name
    if [[ "$dir_name" =~ _a([0-9]{3})_t([0-9]{2})_(s[0-9]{2}|orig) ]]; then
      a=$(echo "${BASH_REMATCH[1]}" | sed 's/^0*//')
      t="${BASH_REMATCH[2]}"
      s="${BASH_REMATCH[3]}"
    fi

    echo "Processing directory: $dir_name with $a assets, $t time periods, and seed $s"

    # Set the paths to the stock price data and covariance data
    stock_price_data="$data_dir/stock_prices.txt.gz"
    covariance_data="$data_dir/covariance_matrices.txt.gz"

    # Three-level loops over (a, t, q)
    # Determine b_tot based on a
    # Determine b_tot based on a using a more flexible approach
    case "$a" in
      10) b_tot=4 ;;
      50) b_tot=20 ;;
      200) b_tot=50 ;;
      400) b_tot=100 ;;
      *)
      echo "Warning: Unhandled number of assets ($a). Defaulting b_tot to 0."
      b_tot=0
      ;;
    esac

    for q in "${q_values[@]}"; do
      echo "Running with a=$a, t=$t, q=$q, b_tot=$b_tot"

      # Define output filenames, embedding parameters a, t, q, replace them with the path you want.
      a_padded=$(printf "%03d" "$a")
      b_padded=$(printf "%03d" "$b_tot")

      SUB_DIR="a${a_padded}_t${t}_${s}_b${b_padded}"

      mkdir -p "$LP_BQP_DIR/$SUB_DIR" "$LP_EVAL_DIR/$SUB_DIR"

      base_filename="bqp_a${a_padded}_t${t}_q${q}_b${b_padded}"
      base_eval_filename="bqp_eval_a${a_padded}_t${t}_q${q}_b${b_padded}"

      lp_file="${LP_BQP_DIR}/${SUB_DIR}/${base_filename}"
      eval_lp_file="${LP_EVAL_DIR}/${SUB_DIR}/${base_eval_filename}"

      # Generate LP model files using ZIMPL, passing a, t, q, b_tot
      $ZIMPL_EXEC \
        -Dnum_assets="$a" \
        -Dtime_intervals="$t" \
        -Dq="$q" \
        -Db_tot="$b_tot" \
        -Dstock_price="$stock_price_data" \
        -Dstock_covariance="$covariance_data" \
        -o "$lp_file" \
        "$MODEL_DIR/$BQP_MODEL"

      $ZIMPL_EXEC \
        -Dnum_assets="$a" \
        -Dtime_intervals="$t" \
        -Dq="$q" \
        -Db_tot="$b_tot" \
        -Dstock_price="$stock_price_data" \
        -Dstock_covariance="$covariance_data" \
        -o "$eval_lp_file" \
        "$MODEL_DIR/$BQP_EVAL_MODEL"

      # (Optional) Use sed to modify the LP files if needed
      sed -i 's/\.[^ ]*//g' "$lp_file.lp"
      sed -i 's/\.[^ ]*//g' "$eval_lp_file.lp"

      # remove tbl file
      rm -f "$lp_file.tbl" "$eval_lp_file.tbl"

      # Compress the LP files
      # gzip -f "$lp_file.lp"
      # gzip -f "$eval_lp_file.lp"
    done
  fi
done


# Archive the generated .lp files into a tar.gz file
output_archive="lp_files.tar.gz"
echo "Archiving .lp files into $output_archive"
tar -czf "$output_archive" -C "$LP_FILES" .

# Clean up temporary folders
rm -r "$LP_FILES"

echo "Process complete! All .lp files are archived in $output_archive"
