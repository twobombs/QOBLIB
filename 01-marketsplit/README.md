# Market Split Problem (or Multi-Dimensional Subset Sum Problem)

## Problem Description

Given a matrix $A \in \mathbb{N}^{m,n}$ and a RHS $b \in \mathbb{N}^m$, find a feasible vector $x \in \{0,1\}^{n}$ that fulfills 

$$
    Ax = b.
$$

Each row represents its own subset sum problem. 
Thus, this is referred to as multi-dimensional subset sum.

## References

* **Originate from:** [Cornuéjols, G., Dawande, M. (1998).
A Class of Hard Small 0—1 Programs.
In: Bixby, R.E., Boyd, E.A., Ríos-Mercado, R.Z. (eds)
Integer Programming and Combinatorial Optimization. IPCO 1998.
Lecture Notes in Computer Science, vol 1412. Springer, Berlin, Heidelberg.](https://doi.org/10.1007/3-540-69346-7_22)
