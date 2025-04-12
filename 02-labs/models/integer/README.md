# IP Formulation

We consider the following formulation as an IP.

$$
    \begin{darray}{lll}
        \min &\sum_{k=1}^{n-1} c_k^2&\\
        \text{s.t.}& c_k = \sum_{i=1}^{n-k} (2 x_i - 1) (2 x_{i+k} - 1) & \forall k \in \{1,...,n-1\}\\
        & x_i \in \{0,1\}&\forall i \in \{1,...,n\}\\
        & c_k \in \{-n+k,...,n-k\} &\forall k \in \{1,...,n-1\}
    \end{darray}
$$

Here, we use the substitution $z = 2x-1$ so we can use binary variables instead of spin variables. 