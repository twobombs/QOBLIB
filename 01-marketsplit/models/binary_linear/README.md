# BLP Formulation

We use the following model

$$
    \begin{darray}{rll}
        \min &\sum_{i \in I} s_i & \\
        \text{s.t.} & s_i + \sum_{j \in J} a_{ij} x_j = b_i & \forall i \in I\\
        & s_i \geq 0 & \forall i \in I\\
        & x_j \in \{0,1\}& \forall j \in J
    \end{darray}
$$

where $A = [a_{ij}] \in \mathbb{N}^{m,n}$, $I \coloneqq \{1,...,m\}$ and $J \coloneqq \{1,...,n\}$.

Thus, a feasible solution has been found, when the objective value is $0$.