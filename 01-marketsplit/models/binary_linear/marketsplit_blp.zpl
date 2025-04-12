# TK 20May2024
# Market Split problem modelled as Binary Linear Problem
#
param filename := "ms_3_100_2.dat";

set I   := { read filename as "<1n>" comment "#" };
set J   := { read filename as "<2n>" comment "#" };
set IxJ := { read filename as "<1n,2n>" comment "#" };

param a[IxJ] := read filename as "<1n,2n> 3n" comment "#";

var x[J\{0}] binary;
var s[I] integer >= 0;

minimize obj: sum <i> in I : s[i];

subto c1:
   forall <i> in I do
      s[i] + sum <i,j> in IxJ with j > 0 : a[i,j] * x[j] == a[i,0];
