# Minimum Birkhoff Decomposition

## Problem Description

Let $D$ be an $n\times n$ doubly stochastic matrix and $P_i$ the $i$-th $n \times n$ permutation matrix, $i \in  \{1,\dots, n! \}$. A matrix is doubly stochastic if its entries are non-negative and the rows and columns sum to one. Similarly, a permutation matrix is a doubly stochastic matrix with binary entries. 

For a given doubly stochatic matrix $D$, the **minimum Birkhoff decomposition** problem is:

$$
\underset{\lambda_i \in [0,1]}{\text{minimize}} \qquad  \sum_{i=1}^{n!} |\lambda_i|^0 \qquad \text{subject to} \quad D = \sum_{i=1}^{n!} \lambda_i P_i, \quad  \sum_{i=1}^{n!} \lambda_i = 1
$$

where $0^0 = 0$. That is, the goal is to find the smallest collection of permutation matrices such that $D$ is in its convex hull. 

## References
1. Kulkarni, J., Lee, E. and Singh, M., 2017, May. Minimum birkhoff-von neumann decomposition. In International Conference on Integer Programming and Combinatorial Optimization (pp. 343-354). Cham: Springer International Publishing.

2. Dufossé, F. and Uçar, B., 2016. Notes on Birkhoff–von Neumann decomposition of doubly stochastic matrices. Linear Algebra and its Applications, 497, pp.108-115.
 
