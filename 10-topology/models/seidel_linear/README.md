# Linearized Seidl-APSP Model

The Linearized Model reformulates the quadratic terms from the [Quadratic Model](./../seidl_quadratic/) into linear constraints. To linearize the quadratic terms in the Seidel-APSP Model, the algorithm introduce a binary variable $y_{stuj}$, where:

$$
    y_{stuj} := \text{dist}_{suj} \cdot \text{dist}_{ut1}.
$$

This variable is 1 if both $\text{dist}_{suj}$ and $\text{dist}_{ut1}$ are 1, and 0 otherwise. Using this variable, the quadratic terms are replaced with the following linear constraints:

$$
\begin{align}
    y_{stuj} &\leq \text{dist}_{suj}\\
    y_{stuj} &\leq \text{dist}_{ut1}\\
    y_{stuj} &\geq \text{dist}_{suj} + \text{dist}_{ut1} - 1. 
\end{align}
$$

The linearized model then computes distances as follows:

$$
\begin{align*}
    \text{(Distance calculation)} \quad & \forall s, t \in V, s \neq t, \forall j \in \{1, \dots, n-1\} : \\
    \text{dist}_{st(j+1)} &\leq \text{dist}_{stj} + \sum_{u \in V, u \neq s, u \neq t} y_{stuj}.
\end{align*}
$$

The supporting constraints for linearization are:

$$
\begin{align*}
    \text{Linearization 1:} \quad & \forall s, t \in V, s \neq t, \forall j \in \{1, \dots, n-1\}, \forall u \in V \setminus \{s, t\} : \\
    & y_{stuj} \leq \text{dist}_{suj}, \\
    \text{Linearization 2:} \quad & \forall s, t \in V, s \neq t, \forall j \in \{1, \dots, n-1\}, \forall u \in V \setminus \{s, t\} : \\
    & y_{stuj} \leq \text{dist}_{ut1}.
\end{align*}
$$

Finally, the binary variable domain for $y_{stuj}$ is:

$$
    y_{stuj} \in \{0, 1\}, \quad \forall s, t \in V, s \neq t, \forall j \in \{1, \dots, n-1\}, \forall u \in V \setminus \{s, t\}.
$$
