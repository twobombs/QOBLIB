# Integer LP

The model used here is the following model: 

$$
    \begin{darray}{rll}
        \min &\sum_{i \in I} z_i & \\
        \text{s.t.} & \sum_{i \in I} \lambda_i = S & \\
        & \sum_{i \in I} \lambda_i P_i = A & \\
        & 0\leq \lambda_i \leq S \cdot z_i & \forall i \in I & \\
        & z_i \in \{0,1\} &\forall i \in I
    \end{darray}
$$ 

Here, $I \coloneqq \{1,...,n!\}$ is an indexset of the permutation matrices and $P_i$ for $i \in I$ are permutation patrices.
Moreover, $S$ defines the integer scale - mostly chosen to be $1000$.