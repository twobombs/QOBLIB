# Network Design

## Problem Description

Design a network with $N$ nodes (Between 5 and 24).
Each node has two incoming and two outgoing connections to another node.

We are interested in the following optimization problem.
Given an $n \times n$ matrix $T$ (whose $i, j$ entry is indicated by $t_{ij}$), and an integer $p > 0$,

1. construct a simple directed graph $D$ with node set $1,...,n$, where each node has indegree and outdegree equal to $p$, and
2. in $D$, simultaneously route $t_{ij}$ units of flow from $i$ to $j$, for all $1 \leq i, j \leq n, i \neq j$, so as to minimize the maximum aggregate flow on any edge of $D$.

In our case $p=2$, $N$ between 5 and 24, and the demand matrix has entries of either 0 or between 16 to 100.

## References

- [D. Bienstock, O. Günlük,
Computational experience with a difficult mixedinteger multicommodity flow problem.
Mathematical Programming 68, 213–237 (1995).](https://doi.org/10.1007/BF01585766)
