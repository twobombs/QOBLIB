# MISC

We provide micellaneous scripts and binaries in this directory.
If you add something here, please provide a brief description on what it does and how to run it.

## ZIMPL (binary)

We use ZIMPL create models and generate corresponding LP and QS files.
PLease refer to [this](https://zimpl.zib.de/) for more information about ZIMPL.

## get_metrics.py

Run

```bash
python get_metrics.py --parent_dir ../ --directory qs_files
```

to walk the main project directory, extract the metrics from all `.tar.gz` with the name `qs_files` and save the metrics in the respective directory.
Already generated metrics will not be regenerated.
Note that the script creates a directory in `/tmp`.
If the script frashes, you must remove the folder by yourself.

You can also run

```bash
python get_metrics.py --directory ../09-routing/models/integer_linear/lp_files.tar.gz --output_csv text.csv
```

To extract the data from a single directory.

## convert_lp2qubo.py

Run

```bash
python convert_lp_to_qubo.py <path_to_tar_gz>
```

to convert all the `.lp` files in an archive to qubos.
Note that this conversion uses Qiskit to convert integer variables to binarz variables.
All integer variabels must be bounded.

## Markdown Utility

`mdutils.py` is a small collection of helper functions used for Markdown table
creation in each problem class. \
Typically, scripts in `<problem_class>/misc` are
importing relevant functions from `mdutils.py` to create nice READMEs in
`<problem_class>/solutions`.
