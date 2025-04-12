# MS 13Dec2024
# LABS Low Autocorrelation Binary Sequence modelled as an Integer Linear Program
#
param n := 47;
param P := 10000;

set I := { 1 .. n };
set K := { 1 .. n - 1 };

var x[I] binary;
var z[<i, k> in I*K with i <= n - k] binary;

# -1,1 => 2 x - 1

minimize energy: 
   sum <k> in K : (
      sum <i> in { 1 .. n - k } : (
         4 * z[i, k] - 2 * x[i] - 2 * x[i + k] + 1
      )
   )^2
   + P
   * sum <k> in K : (
      sum <i> in { 1 .. n - k } : (
         3 * z[i, k] - 2 * z[i, k] * x[i] 
         - 2 * z[i, k] * x[i + k] + x[i] * x[i + k]
      )
   );
   