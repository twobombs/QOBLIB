# QUBO Formulation

This directory contains a script to generate the labs instances from length 2 to 100 using the following QUBO formulation:

$$
    \begin{darray}{lll}
        \min & \sum_{k=1}^{N-1} \left(\sum_{i=1}^{N-k} 4 z_{ik} - 2 x_i - 2 x_{i+k} + 1\right)^2 + \sum_{k=1}^{N-1} \sum_{i=1}^{N-k} P (3 z_{ik} - 2 z_{ik} x_i - 2 z_{ik} x_{i+1} + x_i x_{i+k}) &\\
        \text{s.t.}& z_{ik} \in \{0,1\}\quad \forall i \in \{1, ..., N-k\} \quad \forall  k \in \left\{1, ..., N-1\right\} & \\
        & x_i \in \{0,1\} \quad \forall i\in \{1, ..., N\} &
    \end{darray}.
$$

(We see that by the penalty, we enforce that $z_{ik} = x_i x_{i+k}$.)

Thank you, Noah Krümbugel, for this formulation.