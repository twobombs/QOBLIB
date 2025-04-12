# VV 2July 2024
# Birkhoff problem modelled as an integer program
#

param filename := "qbench_3_dense.json";
param n := 3 # size of nxn scaled doubly stochastic matrix

param X  := # target permutation matrix
var W   := # (n-1)^2+ weights
var P   := # (n-1)^2 + 1 permutations matrices of size nxn

minimize obj: # number of weights that are not zero

subto c1:
   # weights must be non-negative integers
   # sum weights must be equal to 10000
   # matrices W must be binary. Sum rows and columns must be equal to one. 
   # X = sum P[i]*W[i] for i=1,...,(n-1)^2+1
