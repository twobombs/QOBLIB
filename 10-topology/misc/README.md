# Miscellaneous

## heuristic-random-graph.py

A Python implementation of heuristic based on generating random regular graphs is provided in the misc directory. 
The code for the heuristic is by Robert Waniek, based on a code by Ikki Fujiwara.

## convert_sol2gph_flow.py
 
Run 

```bash
python3 convert_sol2gph_flow.py -f <filename>
```

to convert a `.sol` file for the [flow model](./../models/flow_mip/) to a `.gph` file.

## convert_sol2gph_seidel.py
 
Run 

```bash
python3 convert_sol2gph_seidel.py -f <filename>
```

to convert a `.sol` file for both seidel models ([linear](./../models/seidel_linear/) and [quadratic](./../models/seidel_quadratic/)) to a `.gph` file.

## convert_sol2gph.sh

Run 

```bash
./convert_sol2gph.sh <problem_specific_python_script> <directory>
```

where `<problem_specific_python_script>` should be the corresponding of the two conversion scripts above, to convert all the `.sol` files in the given directory to `.gph` files.
This script is just for faster benchmarking.


## fix_indexing.py

Run

```bash
python fix_indexing.py <input_file> <output_file>
```

to convert the edge list graph `input_file` with non-consecutive or non-one-starting indices to a graph file `output_file` with consecutive indices starting from one. 
This is used for the solution checker as it assumes the vertices to be labeled from `1..n`.