# TK 20May2024
# LABS Low Autocorrelation Binary Sequence modelled as an Integer Linear Program
#
param n := 47;

set I := {1 .. n};
set K := {1 .. n - 1};

var x[I] binary;
var c[<k> in K] integer >= - n + k  <= n - k;

# -1,1 => 2 x - 1

minimize energy: sum <k> in K : c[k] * c[k];

subto c1:
   forall <k> in K do
      c[k] == sum <i> in {1 .. n - k} : (2 * x[i] - 1) * (2 * x[i + k] - 1);
      
   