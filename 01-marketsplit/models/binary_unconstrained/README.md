# BUP Formulation

We use the following model

$$
    \begin{darray}{rll}
        \min &\sum_{i \in I} \left(b_i - \sum_{j \in J} a_{ij} x_j\right)^2 & \\
        \text{s.t.} & x_j \in \{0,1\}& \forall j \in J
    \end{darray}
$$

where $A = [a_{ij}] \in \mathbb{N}^{m,n}$, $I \coloneqq \{1,...,m\}$ and $J \coloneqq \{1,...,n\}$.

Thus, a feasible solution has been found, when the objective value is $0$.

This formulation also yields a nice QUBO form. 