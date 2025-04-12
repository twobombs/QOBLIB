import os
import csv
import re
import argparse
from pyscipopt import Model
import tarfile
import shutil
import gzip

def parse_lp(lp_file_path):
    """
    Parse an LP file using PySCIPOpt, extracting:
      - Number of variables (split by binary, integer, continuous).
      - Number of constraints (split by linear, quadratic).
      - A simplistic 'density' measure of the constraint matrix.
      - Minimum and maximum coefficients observed.

    Returns:
        dict: {
            'file': str,
            'num_binary_vars': int,
            'num_integer_vars': int,
            'num_continuous_vars': int,
            'num_linear_constraints': int,
            'num_quadratic_constraints': int,
            'density': float,
            'min_coeff': float or None,
            'max_coeff': float or None
        }
    """

    # 1) Create and read the model
    model = Model()
    model.readProblem(lp_file_path)

    # 2) Count variables by type
    num_binary_vars = model.getNBinVars()
    num_integer_vars = model.getNIntVars()
    num_continuous_vars = model.getNContVars()

    # 3) Count constraints by type & gather coefficient info
    num_linear_constraints = 0
    num_quadratic_constraints = 0
    nonzero_count = 0
    min_coeff = None
    max_coeff = None

    constraints = model.getConss()
    for cons in constraints:
        # Must be 'getConshdlrName()' as requested
        ctype = cons.getConshdlrName()

        if cons.isLinear():
            num_linear_constraints += 1

            # Get dictionary of Constraint variables and coefficients
            cons_dict = model.getValsLinear(cons)
            
            # We only need the coefs here, but we unpack everything to avoid the ValueError
            for coeff in cons_dict.values():
                # Update min, max
                if min_coeff is None or coeff < min_coeff:
                    min_coeff = coeff
                if max_coeff is None or coeff > max_coeff:
                    max_coeff = coeff

                if coeff != 0.0:
                    nonzero_count += 1

        elif model.checkQuadraticNonlinear(cons):
            num_quadratic_constraints += 1

            # Get the terms of the quadratic constraint
            bilin_terms, quad_terms, lin_terms = model.getTermsQuadratic(cons)
            
            # 1) Linear part
            for (var1, coeff) in lin_terms:
                if min_coeff is None or coeff < min_coeff:
                    min_coeff = coeff
                if max_coeff is None or coeff > max_coeff:
                    max_coeff = coeff
                if coeff != 0.0:
                    nonzero_count += 1

            # 2) Bilinear part
            for (var1, var2, coeff) in bilin_terms:
                if min_coeff is None or coeff < min_coeff:
                    min_coeff = coeff
                if max_coeff is None or coeff > max_coeff:
                    max_coeff = coeff
                if coeff != 0.0:
                    nonzero_count += 1

            # 3) Quadratic part
            for (var1, coeff, _) in quad_terms:
                if min_coeff is None or coeff < min_coeff:
                    min_coeff = coeff
                if max_coeff is None or coeff > max_coeff:
                    max_coeff = coeff
                if coeff != 0.0:
                    nonzero_count += 1

        else:
            # Skip or handle other constraint types (indicator, SOS, etc.)
            print(f"Unknown constraint type: {ctype}")

            print(cons)

            pass

    # 4) Compute a "density" measure
    total_vars = model.getNVars()
    total_constraints = num_linear_constraints + num_quadratic_constraints

    total_possible = total_vars * num_linear_constraints + total_vars * (total_vars + 3) / 2 * num_quadratic_constraints

    density = 0.0
    if total_possible > 0:
        density = nonzero_count / total_possible

    return {
        'file': os.path.basename(lp_file_path),
        'num_binary_vars': num_binary_vars,
        'num_integer_vars': num_integer_vars,
        'num_continuous_vars': num_continuous_vars,
        'num_vars': total_vars,
        'num_linear_constraints': num_linear_constraints,
        'num_quadratic_constraints': num_quadratic_constraints,
        'num_constraints': total_constraints,
        'density': density,
        'min_coeff': min_coeff,
        'max_coeff': max_coeff
    }

def parse_qs(qs_file_path):
    """
    Parse a QS (QUBO) file to extract:
      - The number of variables.
      - The QUBO matrix density (ratio of nonzero entries to total entries).
      - Minimum and maximum coefficients observed.
    
    Returns:
        dict: {
          'file': str,
          'num_variables': int,
          'density': float,
          'min_coeff': float or None,
          'max_coeff': float or None
        }
    """
    num_vars = 0
    nonzero_entries = 0
    min_coeff = None
    max_coeff = None

    with open(qs_file_path, 'r') as f:
        lines = f.readlines()

    for line in lines:
        if not line.lower().startswith("#"):
            parts = line.strip().split()
            if len(parts) == 2:
                try:
                    num_vars = int(parts[0])
                    break
                except ValueError:
                    pass

    print(f"Found {num_vars} variables in {qs_file_path}")

    for line in lines:
        if line.lower().startswith("#"):
            continue

        parts = line.split()

        if len(parts) == 3:
            try:
                i = int(parts[0])
                j = int(parts[1])
                val = float(parts[2])

                if min_coeff is None or val < min_coeff:
                    min_coeff = val
                if max_coeff is None or val > max_coeff:
                    max_coeff = val
                if val != 0:
                    # Count off-diagonal entries twice
                    nonzero_entries += 1

            except ValueError:
                pass

    total_entries = num_vars * (num_vars + 1) / 2
    density = 0.0
    if total_entries > 0:
        density = nonzero_entries / total_entries

    return {
        'file': os.path.basename(qs_file_path),
        'num_variables': num_vars,
        'density': density,
        'min_coeff': min_coeff,
        'max_coeff': max_coeff
    }

def parse_directory(directory_path, output_csv_path):
    """
    Goes through all .lp or .qs files in `directory_path`, parses them using
    parse_lp() or parse_qs(), then writes a CSV with the collected data.
    
    Args:
        directory_path (str): Path to directory containing LP and QS files, or a .tar.gz file.
        output_csv_path (str): Path to the output CSV file.
    """
    print(f"Parsing files in {directory_path} and writing results to {output_csv_path}")

    rows = []
    temp_dir = None

    if directory_path.endswith('.tar.gz'):
        temp_dir = './tmp/extracted_files'
        with tarfile.open(directory_path, 'r:gz') as tar:
            tar.extractall(path=temp_dir, filter='data')
            directory_path = temp_dir

    for root, dirs, files in os.walk(directory_path):
        for filename in sorted(files):
            filepath = os.path.join(root, filename)
            if os.path.isfile(filepath):
                if filename.lower().endswith('.lp.gz') or filename.lower().endswith('.qs.gz'):
                    tmp_path = filepath[:-3]  # remove .gz
                    with gzip.open(filepath, 'rb') as f_in, open(tmp_path, 'wb') as f_out:
                        shutil.copyfileobj(f_in, f_out)
                    if tmp_path.lower().endswith('.lp'):
                        data = parse_lp(tmp_path)
                        rows.append(data)
                    elif tmp_path.lower().endswith('.qs'):
                        data = parse_qs(tmp_path)
                        rows.append(data)
                    os.remove(tmp_path)
                else:
                    if filename.lower().endswith('.lp'):
                        data = parse_lp(filepath)
                        rows.append(data)
                    elif filename.lower().endswith('.qs'):
                        data = parse_qs(filepath)
                        rows.append(data)

    all_keys = rows[0].keys()

    with open(output_csv_path, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=all_keys)
        writer.writeheader()
        for r in rows:
            writer.writerow(r)

    if temp_dir:
        shutil.rmtree(temp_dir)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Parse .lp and .qs files (or a .tar.gz) and output results to a CSV.")
    parser.add_argument("--directory", type=str, help="Path to the directory or .tar.gz archive containing .lp and .qs files")
    parser.add_argument("--output_csv", type=str, help="Path to the output CSV file")
    parser.add_argument("--parent_dir", type=str, default=None,
                        help="If provided, recursively search subdirectories for 'qs_files.tar.gz' and parse each one, writing the CSV in the same directory.")
    args = parser.parse_args()

    

    if args.parent_dir:
        if not args.directory:
            print("Please provide a directory or .tar.gz file to parse.")
            exit(1)

        directory_name = args.directory
        if args.directory.endswith('.tar.gz'):
            directory_name = os.path.splitext(os.path.basename(args.directory))[0]

        for root, dirs, files in os.walk(args.parent_dir):
            if f"{directory_name}.tar.gz" in files:
                tar_path = os.path.join(root, f"{directory_name}.tar.gz")
                out_csv_path = os.path.join(root, f"metrics_{directory_name}.csv")
                # skip if the output file already exists
                if os.path.exists(out_csv_path):
                    print(f"Skipping {tar_path}, output file already exists.")
                    continue
                parse_directory(tar_path, out_csv_path)
                print(f"Parsed {tar_path}, results written to {out_csv_path}")
    else:
        parse_directory(args.directory, args.output_csv)
        print(f"Results written to {args.output_csv}")
