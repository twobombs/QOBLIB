# Binary LP Unconstrained

The model used here is the following (unconstrained) model: 

$$
    \max \sum_{v \in V} x_v - 2 \cdot \sum_{(v,w) \in E} x_v x_w\\
    x_v \in \{0,1\} \quad \forall v \in V
$$ 