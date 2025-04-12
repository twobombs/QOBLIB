# Quantum Optimization Benchmarking Library - QOBLIB

## Description
With the aim of enabling fair, comparable, and meaningful benchmarks for quantum optimization methods, 
we here present ten optimization problem classes that are difficult for
existing classical algorithms and can (mostly) be linked to practically-relevant applications.
While the individual properties of the problem classes  vary in terms of objective and variable type, coefficient ranges, and density, they all become
challenging for established classical methods already at system sizes in the range of about 100
to 10 000 decision variables.
This repository holds problem instances of varying complexity, exemplary model descriptions, solution track records,
and references or explicit functionality for checking solution feasibility.

### Paper reference

[Quantum Optimization Benchmark Library:
The Intractable Decathlon](https://arxiv.org/pdf/2504.03832)

## Problem classes

- [01 Market Split                  ](01-marketsplit)   (multi-dimensional Subset-sum)
- [02 LABS                          ](02-labs)          (Low Autocorrelation Binary Sequences)
- [03 Minimum Birkhoff Decomposition](03-birkhoff)
- [04 Steiner Tree Packing ](04-steiner)       (VLSI Design/Wire Routing)
- [05 Sports Tournament Scheduling  ](05-sports)
- [06 Portfolio Optimization        ](06-portfolio)     with multiple periods, transaction costs and short selling
- [07 Maximum Independent Set       ](07-independentset)     (Unweighted Maximum Independent Set (MIS))
- [08 Network Design                ](08-network)
- [09 Vehicle Routing   ](09-routing)       (VRP: TSP + Time Window + Knapsack)
- [10 Topology Design               ](10-topology)      (Graph Golf, Node-Degree-Diameter Problem)

## Structure
In this repository every problem class has its own folder.
The content for each problem class is structured via the following sub-folders.

- `info`        holds relevant information about the problem class such as papers.
- `instances`   holds various problem instances for the respective problem class.
                The format in which the instances are given depend on the problem class.
- `misc`        holds miscallenous files and scripts.
- `models`      holds model descriptions for problem instances given in the `instances` folder.
- `solutions`   holds solutions for problem instances given in the `instances` folder.

## Contributors and acknowledgment

This repository was put together as part of the Quantum Optimization Working Group effort initiated in July
2023 by IBM Quantum and its partners.

Thorsten Koch <koch@zib.de>, David E. Bernal Neira, Ying Chen, Giorgio Cortiana,
Daniel J. Egger, Raoul Heese, Narendra N. Hegade, Alejandro Gomez
Cadavid, Rhea Huang, Toshinari Itoko, Thomas Kleinert, Pedro Maciel
Xavier, Naeimeh Mohseni, Jhon A. Montanez-Barrera, Koji Nakano,
Giacomo Nannicini, Corey O’Meara, Justin Pauckert, Manuel Proissl, Anurag
Ramesh, Maximilian Schicker <schicker@zib.de>, Noriaki Shimada, Mitsuharu Takeori, Victor
Valls, David Van Bulck, Stefan Woerner <WOR@zurich.ibm.com>, and Christa Zoufal <OUF@zurich.ibm.com>.

## License
tbd

## Project status
Status building up

## Best-practice for solution reporting
Please refer to the [contribution guidelines](CONTRIBUTING) for further information.

## Best-practice for hardware implementation 
A collection of guidelines to run quantum optimization algorithms with Qiskit on hardware that is based on superconducting qubits can be found [here](https://github.com/qiskit-community/qopt-best-practices).
