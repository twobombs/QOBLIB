# Low Autocorrelation Binary Sequences (LABS)

## Problem Description

Given a sequence $\mathcal{S} = \{s_1, ..., s_n\}$ of spins $s_i \in \{-1,1\}, i \in [n]$, we define the autocorrelations of a sequence as

$$
    C_k(\mathcal{S}) \coloneqq \sum_{i = 1}^{n-k} s_i s_{i+k}
$$

and the energy of a sequence as

$$
    E(\mathcal{S}) \coloneqq \sum_{i \in [k]} C_k^2(\mathcal{S}).
$$

The goal is to find the sequence of minimum energy given its length $n$.

## References

* [Tom Packebusch and Stephan Mertens
Low autocorrelation binary sequences
Journal of Physics A: Mathematical and Theoretical, Vol 49, Number 16
DOI 10.1088/1751-8113/49/16/165001](https://doi.org/10.48550/arXiv.1512.02475)
