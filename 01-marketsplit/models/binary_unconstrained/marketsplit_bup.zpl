# TK 20May2024
# Market Split problem modelled as Binary Unconstraint Program
#
param filename := "ms_3_100_1.dat";

set I   := { read filename as "<1n>" comment "#" };
set J   := { read filename as "<2n>" comment "#" };
set IxJ := { read filename as "<1n,2n>" comment "#" };
set JJ  := { <j> in J with j > 0 };

param a[IxJ] := read filename as "<1n,2n> 3n" comment "#";

var x[JJ] binary;

minimize obj: sum <i> in I : (a[i,0] - sum <j> in J with j > 0 : a[i,j] * x[j])^2;
