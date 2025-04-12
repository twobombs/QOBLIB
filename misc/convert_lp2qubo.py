import os
import tarfile
import tempfile
import sys
import shutil
from pathlib import Path
import numpy as np

from docplex.mp.model_reader import ModelReader
from qiskit_optimization.converters import QuadraticProgramToQubo
from qiskit_optimization.translators import from_docplex_mp
from gurobipy import read
from qiskit_optimization.translators import from_gurobipy


def extract_lp_files(tar_path, tmp_dir):
    """
    Extracts .lp files from a .tar.gz archive (including subfolders).
    Returns a list of extracted file paths in the temporary directory.
    """
    lp_files = []
    with tarfile.open(tar_path, 'r:gz') as tar:
        tar.extractall(tmp_dir)
        # Walk through extracted files and pick out .lp files
        for root, _, files in os.walk(tmp_dir):
            for file in files:
                if file.endswith('.lp'):
                    full_path = os.path.join(root, file)
                    lp_files.append(full_path)
    return lp_files


def lp_to_qubo(lp_path):
    """
    Reads an LP file via docplex's ModelReader, then converts to a QUBO.
    Returns the QUBO as a QuadraticProgram.
    """
    print(f"Parsing LP: {lp_path} ...")
    # Use Gurobi to parse the LP file
    model = read(lp_path)

    
    # Convert all continuous variables to integer
    for var in model.getVars():
        if var.vtype == 'C':  # Check if the variable is continuous
            var.vtype = 'I'  # Change the variable type to integer

    # Convert Gurobi model to Qiskit's QuadraticProgram
    qp = from_gurobipy(model)

    # Convert QuadraticProgram to QUBO
    converter = QuadraticProgramToQubo()
    qubo = converter.convert(qp)

    quadratic_matrix = qubo.objective.quadratic.to_array()
    density = (quadratic_matrix != 0).sum() / quadratic_matrix.size
    size = quadratic_matrix.shape
    print(f"Quadratic matrix size: {size}")
    print(f"Quadratic matrix density: {density}")

    return qubo


def write_qubo(qubo, output_path):
    """
    Writes a QUBO to a file in QS format.
    Every line in the file is of the form:
    <row> <col> <value>
    """
    quadratic_matrix = qubo.objective.quadratic.to_array()
    linear_matrix = qubo.objective.linear.to_array()
    constant = qubo.objective.constant

    print(f"Writing QUBO to {output_path} ...")

    Q = quadratic_matrix + np.diag(linear_matrix)
    Q = (Q + Q.T) / 2  # Ensure symmetry

    nonzero_entries = np.count_nonzero(np.triu(Q))
    num_vars = Q.shape[0]

    with open(output_path, 'w') as f:
        f.write(f"# ObjectiveOffset {constant}\n")
        f.write(f"{num_vars} {nonzero_entries}\n")
        for i in range(Q.shape[0]):
            for j in range(i, Q.shape[1]):
                if Q[i, j] != 0:
                    f.write(f"{i + 1} {j + 1} {Q[i, j]}\n")


def main(tar_gz_path):
    tmp_dir = tempfile.mkdtemp(dir="/tmp")
    output_files = []

    try:
        lp_files = extract_lp_files(tar_gz_path, tmp_dir)
        lp_files.sort()
        for lp_file in lp_files:
            try:
                qubo = lp_to_qubo(lp_file)
                print(f"Successfully converted {lp_file} to a QUBO!\n")
                output_file = lp_file.replace(".lp", ".qs")
                write_qubo(qubo, output_file)
                output_files.append(output_file)
                print("-" * 60)
            except Exception as e:
                print(f"Failed to convert {lp_file}: {e}")

    finally:
        # Create a .tar.gz archive of the .qs files
        output_archive = os.path.join(os.path.dirname(tar_gz_path), "qs_files.tar.gz")
        with tarfile.open(output_archive, "w:gz") as tar:
            for output_file in output_files:
                tar.add(output_file, arcname=os.path.basename(output_file))
                os.remove(output_file)  # Clean up individual .qs files after archiving

        print(f"All QUBOs have been archived into {output_archive}")

        # Ensure the temporary directory is deleted
        shutil.rmtree(tmp_dir)
        print(f"Temporary directory {tmp_dir} has been deleted.")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python convert_lp_to_qubo.py <path_to_tar_gz>")
        sys.exit(1)

    archive_path = sys.argv[1]
    main(archive_path)
