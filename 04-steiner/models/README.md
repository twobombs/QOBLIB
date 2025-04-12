# Models for Steiner Tree Packing problem

We provide one mathematical programming formulation for the problem.
The formulation uses a multicommodity flow to enforce connectivity
between the terminals of each Steiner tree. It correspond to the
formulation described in Section 2.2 of the paper "Steiner tree
packing revisited", provided in the [info](./info/) directory. The
formulation yields an integer linear optimization problem. All
decision variables are binary.
