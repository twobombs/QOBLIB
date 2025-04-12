#TK 13Jul2024

# TODO/Variations
# Replace x by sum <k> : 2^k z[k]
# Replace x < z by x * z

param msize := 4;
param ssize := 10000;
set J := { 1 .. msize };

#param a3[J*J] :=
#      <1,1> 916, <1,2>  84, <1,3>   0,
#      <2,1>  84, <2,2> 457, <2,3> 459,
#      <3,1>   0, <3,2> 459, <3,3> 541
#      ;
#set P3 := {
#   <1,2,3>, <1,3,2>, <2,1,3>, <2,3,1>, <3,1,2>, <3,2,1>
#};

param a4[J*J] := read filename as "<1n,2n> 3n";

set P4 := { read perm as "<1n,2n,3n,4n>" };
set I   := { 1 .. card(P4) };

var x[I] integer <= ssize;
var z[I] binary;

minimize count: sum <i> in I: z[i];

subto c1:
   sum <i> in I: x[i] == ssize;

subto c2:
   forall <m,n> in J*J do
      sum <i> in I with ord(P4, i, m) == n: x[i] == a4[m,n];
       
subto c3:
   forall <i> in I do
      x[i] <= ssize * z[i];



       