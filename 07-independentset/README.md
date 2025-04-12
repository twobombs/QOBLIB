# Maximum Independent Set Problem (or Maximum Stable Set Problem)

## Problem Description

The maximum independent set problem (MISP)--also often referred to as maximum stable set problem--describes the challenge of finding
an independent set $I$ of a graph $G=(V,E)$ of maximum cardinality. $I$ is considered to be independent, if there does not exist an edge in $G$ between nodes of $I$.

## Related Works

<!--- max. clique and stable set --->

- [Benchmarking Adiabatic Quantum Optimization for Complex Network
  Analysis](https://arxiv.org/abs/1604.00319) by Parekh, Wendt, Shulenburger, Landahl, Moussa, Aidun 
  <!---
  D-Wave Two AQO with 512 qubits on Chimera graph layout fitting the
  underlying architecture. Selby’s exact method outerperformed the DWave experiments 
  --->
- [Mathematical Foundation of Quantum Annealing](https://arxiv.org/abs/0806.1859) by Morita, Nishimori
<!--- 
The results were obtained on D-Wave Two AQO with 512 qubits
in Chimera graph architecture. The experiments were compared to Selby’s exact and heuristic
algorithms for Chimera graphs, revealing that Selby’s exact method performed better than the
heuristic and quantum annealing approaches, since it found optimal solutions in a shorter running
time. 
--->
- [An SDP-based approach for computing the stability number of a graph](https://link.springer.com/article/10.1007/s00186-022-00773-1) by Gaar, Siebenhofer, Wiegele
  <!--- 
  D-Wave 2X with about 1000 qubits for Chimera graph architecture, random graphs with 45 vertices: classical solvers outperformed DWave
  subgraphs with 800 or more vertices via decomposition with DWave: outperformed benchmarked classical methods
  --->
- [Advancing stable set problem solutions through quantum annealers](https://arxiv.org/abs/2308.13041) by Povh, Pucher
<!--- 
DWave for up to 125 vertices using QUBO formulation
--->
- [Quantum computing and the stable set problem](https://arxiv.org/pdf/2405.12845) by Krpan, Povh, Pucher
<!---
DWave  annealing -- QUBO formulation + penalty terms + newly developed post-processing, they also show a
partitioning method to enable the execution of larger instances on distributed resources. Notably, the penalty terms
in a QUBO impact the annealing results. DIMACS instances, Paley graphs, and several evil instances.
-->
- [Finding Maximum Cliques on the D-Wave Quantum Annealer](https://arxiv.org/abs/1801.08649) by Chapuis, Djidjev, Hahn, Rizk
<!---
The authors compared quantum annealing implementation to several classical algorithms, such as simulating annealing, Gurobi, and
some third-party clique-finding heuristics. For their tests, they used D-Wave 2X with roughly 1000
qubits in Chimera graph architecture. The experiments were performed on random graphs with 45
vertices and edge probabilities ranging from 0.3 to 0.9. D-Wave returned solutions of comparable
quality to classical methods, but classical solvers were generally faster for small instances. They
also tested subgraphs of D-Wave chimera graphs, where D-Wave returned the best solutions for
large instances and showed a substantial computing speed-up.  
--->

## References
* [Xiao, Mingyu & Nagamochi, Hiroshi "Exact Algorithms for Maximum Independent Set." In: Cai, L., Cheng, SW., Lam, TW. (eds) Algorithms and Computation. ISAAC 2013. Lecture Notes in Computer Science, vol 8283. Springer, Berlin, Heidelberg. (2013)](https://link.springer.com/chapter/10.1007/978-3-642-45030-3_31)
* [Hoang, D.A., "On the Complexity of Distance-d Independent Set Reconfiguration." In: Lin, CC., Lin, B.M.T., Liotta, G. (eds) WALCOM: Algorithms and Computation. WALCOM 2023. Lecture Notes in Computer Science, vol 13973. (2023)](https://link.springer.com/chapter/10.1007/978-3-031-27051-2_22)