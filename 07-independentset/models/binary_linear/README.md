# Binary LP

The standard IP formulation of for independent set looks as follows: 

$$
    \max \sum_{v \in V} x_v\\
    s.t.\quad x_v + x_w \leq 1 \quad \forall (v,w) \in E\\
    x_v \in \{0,1\} \quad \forall v \in V
$$