# Maximilian Schicker / September 2024

# Read the necessary parameter
param edges := read filename as "4n" use 1 match "^p" comment "c";
param nodes := read filename as "3n" use 1 match "^p" comment "c";

# get the set of edges
set E := { read filename as "<2n,3n>" match "^e" comment "c" };

# Initialize the set of nodes
set V := {1..nodes};

# Create binary variables for each node
var x[V] binary;

maximize obj:
  sum <v> in V   : x[v]
  - 2 * sum <u,v> in E : x[u] * x[v];