# Integer Linear Model

We provide an implementation of the following model. 

$$
    \begin{align*}
        &\min_{x,y} &\sum_{\substack{}{i,j=0 \\ i \neq j}}^{n+1} c_{ij} x_{ij} \\
        &\text{s.t.} &\sum_{\substack{j=1 \\ j \neq i}}^{n+1}  x_{ij} &= 1 &\text{for all }i \in \{ 1 \ldots, n\}\\
        &&\sum_{\substack{i=0 \\ i \neq h}}^{n} x_{ih} &= \sum_{\substack{j=1 \\ j \neq h}}^{n+1} x_{hj} &\text{for all } h \in \{1, \ldots, n \}\\
        &&\sum_{j=1}^{n} x_{0j} &\leq K \\
        &&y_{j} &\geq y_{i} + d_j x_{ij} - Q ( 1 - x_{ij} )  &\text{for all }i\neq j \in \{ 0, \ldots, n+1\}\\
        &&d_{i} &\leq y_{i} \leq Q,  &\text{for all }i \in \{0, \ldots, n+1\}\\
        &&x_{ij} &\in \{0,1\}  &\text{for all }i,j \in\{0, \ldots, n+1\}\\
        &&y_{i} &\in \mathbb{N}_0 &\text{for all } i \in\{ 0, \ldots, n+1\}
    \end{align*}
$$

For an in depth review of the constraints and variables, we refer to the main paper. 