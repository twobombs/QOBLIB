# IP Formulation

We use the following IP formulation.

$$
    \begin{darray}{lll}
        \min &z&\\
        \text{s.t.}& \sum_{a \in \delta^+(v)} x_{a} = 2 & \forall v \in V\\
        & \sum_{a \in \delta^-(v)} x_{a} = 2 & \forall v \in V\\
        & \sum_{a \in \delta^+(t)} f_{s,a} - \sum_{a \in \delta^-(t)} f_{s,a} = t_{s, t} & \forall s, t \in V, s \neq t\\
        & \sum_{s \in V} f_{s, a} \leq z & \forall a \in A\\
        & f_{s, a} \leq M \cdot x_a & \forall s \in V, a \in A\\
        & f_{s,a} \geq 0& \forall s \in V, a \in A\\
        & x_{a} \in \{0,1\} & \forall a \in A\\
        & z \geq 0 &\\
    \end{darray}
$$

Here, we pick $M$ to be sufficiently large.
This formulation describes a multi-commodity flow problem where flow on an arc is only permitted if this arc is chosen to be in the solution.
