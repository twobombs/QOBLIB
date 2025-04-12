# How to contribute?


If you would like to contribute to this benchmarking effort by submitting a solution
to one of the provided instances, please send an e-mail to Thorsten Koch <koch@zib.de>, Christa Zoufal <OUF@zurich.ibm.com>,
Stefan Wörner <WOR@zurich.ibm.com>, or Maximilian Schicker <schicker@zib.de>.
<br>In this context, we kindly ask you to follow the guidelines described below.

Each reported benchmark should include information about the approached problem instance, the submitter(s), and the 
submission date. 
Since not every detail can be given in a compact form, submissions ideally refer to a paper or a code repository with 
further information, such as hyperparameters, additional hardware specifications, software versions, etc.
Furthermore, the best objective value found (for optimization problems) as well as the corresponding solution should be 
submitted. For the latter, we would ask submitters to provide a separate file--see solution folders.
If supported by an algorithm, an a posteriori bound on the optimal objective value can be provided.
Furthermore, the chosen modeling approach should and the resulting number and type of decision variables 
and (non-zero) coefficients needed to represent the considered problem instance.
Next, the submission should briefly summarize the complete optimization workflow to facilitate reproducability. 
This includes pre-processing, pre-solver, main optimization algorithm, and post-processing, as well as an indication if 
the algorithm is deterministic or stochastic.
Stochastic algorithms are generally recommended to be repeated multiple times. 
In which case, the number of successful runs that result in feasible solutions or return solutions close to the best 
found solutions should be reported.
Finally, the overall runtime and the runtime spend on the various hardware platforms should be provided--without 
including potential queuing times for hardware access.
In case of multiple repetitions, we ask for a reporting of the average runtime over all repetitions.
Additional information, such as the distribution of the runtimes or potential correlations with solution quality, 
is encouraged to be described in a corresponding publication or reference. 

## Benchmark Reporting Sheet

We provide a [template](misc/submission_template.csv) for the metrics given below.

- **Problem**: Identifier of the considered problem instance.
- **Submitter**: Name(s) of the submitter(s) and affiliation(s).
- **Date**: Date of submission.
---
- **Reference**: Reference to a paper/repository with more details.
- ---
- **Best Objective Value**: The best objective value found by the algorithm across all repetitions.
- **Optimality Bound**: Lower bound (minimization) or upper bound (maximization) for the optimal objective value, if supported, otherwise, set to N/A.
- **Modeling Approach**: Describe how the considered problem instance is modeled.
- **\# Decision Variables**: Total number of decision variables.
- **\# Binary Variables**: Number of binary decision variables.
- **\# Integer Variables**: Number of integer decision variables.
- **\# Continuous Variables**: Number of continuous decision variables.
- **Decision Variables Range**: Range of the decision variables, i.e., min/max values.
- **\# Non-Zero Coefficients**: Number of non-zero coefficients in objective function and constraints.
- **Coefficients Type**: Type of coefficients such as integer, binary, continuous.
- **Coefficients Range**: Range of non-zero coefficients, i.e., min/max values.
- ---
- **Workflow**: Description of the optimization workflow: pre-processing, pre-solvers, optimization algorithms, and post-processing, etc.
- **Algorithm Type**: Indicate whether the algorithm is deterministic or stochastic.
- **\# Runs**: The number of times the experiment been repeated.
- **\# Feasible Runs**: The number of times a run found a feasible solution.
- **\# Successful Runs**: Number of runs that found a feasible solution with objective value $\leq (1 + \epsilon) * f_{min}$
(minimization) or $\geq (1 - \epsilon) * f_{max}$ (maximization), where $f_{min}/f_{max}$ is the best solution found by the algorithm.
- **Success Threshold**: The threshold $\epsilon$ to define a successful run.
- ---
- **Total Runtime**: Total runtime to run the complete workflow.
- **CPU Runtime**: CPU runtime to run the workflow.
- **GPU Runtime**: GPU runtime to run the workflow.
- **QPU Runtime**: QPU runtime to run the workflow.
- **Other HW Runtime**: Runtime on other hardware to run the workflow.

[ All runtimes should be reported as average if multiple algorithm runs were executed. ]
