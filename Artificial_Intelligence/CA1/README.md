# Genetic Algorithm for the Knapsack Problem

A from-scratch genetic algorithm that solves a continuous, multi-constraint variant of the 0/1 knapsack problem, developed as the first assignment for an Artificial Intelligence course. The algorithm selects a subset of snacks (with partially selectable, i.e. fractional, weight per item) to maximize total value under simultaneous constraints on total weight, minimum total value, and the number of distinct items chosen.

**Institution:** University of Tehran, School of Electrical and Computer Engineering
**Course:** Artificial Intelligence
**Author:** Babak Hosseini Mohtasham
**Assignment specification:** [`AI-S03-A1.pdf`](./AI-S03-A1.pdf)

---

## Overview

Given a list of snacks, each with an available weight and a value, the goal is to choose a combination of snacks — and how much of each to take — that maximizes total value, subject to:

1. Total weight must not exceed a maximum (`MAX_SUM_OF_WEIGHTS`).
2. Total value must be at least a required minimum (`MIN_SUM_OF_VALUES`).
3. The number of distinct snacks chosen must fall within a given range (`MIN_NUMBER_OF_GENES`–`MAX_NUMBER_OF_GENES`).
4. The amount taken of any snack cannot exceed its available weight.

Rather than a brute-force or exact search, the problem is solved with a genetic algorithm, evolving a population of candidate solutions ("chromosomes") over many generations through selection, crossover, and mutation.

**Objectives:**

1. Design a chromosome/gene representation for the continuous knapsack problem and a fitness function that rewards high value while penalizing deviation from the weight limit.
2. Implement selection, crossover, and mutation operators that always respect the item-count constraint (the crossover step is designed so that the number of distinct items in each offspring provably stays within bounds — see the notebook for the derivation).
3. Compare multiple fitness functions and selection strategies experimentally.
4. Study the effect of population size, crossover rate, and mutation rate on convergence speed and solution quality, and answer a set of conceptual questions about genetic algorithm design.

## Methodology

| Component | Description |
|---|---|
| **Representation** | A **gene** is one snack with a randomized weight (0.1 up to its available weight); a **chromosome** is a variable-length list of genes (i.e. a candidate combination of snacks and how much of each to take) |
| **Fitness functions** | Two strategies compared: (1) `(value − min_value) / (\|weight − max_weight\| + 0.1)` and (2) `(value − min_value) / ((weight − max_weight)² + 0.1)` — both reward value while sharply penalizing weight that deviates from the limit |
| **Selection strategies** | Three strategies compared: rank-based selection (probability ∝ fitness rank), fitness-proportional selection, and a variant of rank-based selection that grows the population by one chromosome per generation |
| **Crossover** | Uniform crossover between paired chromosomes: shared ("common") snacks are split between offspring, then remaining snacks are distributed with the split point randomized within provably-safe bounds, so neither offspring ever violates the min/max item-count constraint |
| **Mutation** | Each gene in a chromosome is independently re-randomized (a new weight for that snack) with a configurable per-gene probability |
| **Evaluation** | Each configuration is run for a number of independent training runs (default 10), tracking average population fitness per generation, the best chromosome per run, and the frequency of each snack among all best-of-run solutions |

## Repository Structure

| Path | Description |
|---|---|
| [`A1.ipynb`](./A1.ipynb) | Full implementation, experiments, plots, and written answers to the assignment's conceptual questions |
| [`snacks.csv`](./snacks.csv) | Input dataset: 19 snacks, each with an available weight and a value |
| [`AI-S03-A1.pdf`](./AI-S03-A1.pdf) | Original assignment specification (theory questions on search/agents, plus the knapsack GA specification) |

## Key Results

**The algorithm reliably converges to near-optimal solutions.** Under the final configuration (rank-based selection, the absolute-weight fitness strategy, population size 100, crossover rate 0.9, mutation rate 0.01, 1,000 generations per run), best-of-run fitness across 10 independent runs averaged **95.6**, with individual runs reaching a **fitness of 100.0** and total weight consistently landing at exactly the 10-unit limit — indicating the algorithm learns to fully utilize the available capacity rather than under-filling it.

**Fitness strategy and selection strategy both affect solution quality**, but the differences among the three selection strategies tested were modest under a large, fixed population; the more pronounced effects came from population size and the presence of crossover/mutation (below).

**Population size has the largest single effect on solution quality:**

| Population size | Average best-of-run fitness (10 runs) |
|---|---|
| 6 | 37.5 |
| 100 (default) | 96.5 |
| 500 | 96.9 |

A very small population converges far less reliably; beyond a moderate size, further growth yields diminishing returns at a steep cost in runtime.

**Both crossover and mutation are necessary for consistent convergence.** Disabling either one individually degrades and destabilizes the average-fitness curve (crossover-off relies on mutation alone and becomes highly noisy across runs; mutation-off relies on crossover alone and plateaus below the full-operator baseline), and disabling both simultaneously performs worst of all — confirming that crossover (recombining existing good genes) and mutation (introducing new gene values) play complementary roles.

*(Full experimental output, plots for every configuration, and written answers to six conceptual questions on population size, selection pressure, operator ablation, and edge cases are in the notebook.)*

## Reproducing the Results

1. Install dependencies: `pip install pandas numpy matplotlib`.
2. Open [`A1.ipynb`](./A1.ipynb) and run all cells — `snacks.csv` is loaded via a relative path, so keep it alongside the notebook.
3. The final configuration is defined near the top of the notebook (`FILE_ADDR`, `MAX_SUM_OF_WEIGHTS`, `MIN_SUM_OF_VALUES`, `MIN_NUMBER_OF_GENES`, `MAX_NUMBER_OF_GENES`, and the GA hyperparameters); the `Population` class exposes `set_config(...)` to change any parameter or strategy and `run(n)` to execute `n` independent training runs and collect statistics.
4. Use `plot_averages()`, `plot_best_snacks_cnt()`, `print_best_snacks_cnt()`, and `print_best_chromosomes_info()` on a `Population` instance to inspect convergence curves, item-selection frequency, and per-run/average final value, weight, and fitness.

## Notes on Scope

- The dataset (`snacks.csv`) and constraint values (max weight 10, min value 12, 2–4 distinct items) follow the example given in the assignment specification.
- The assignment PDF also includes an unrelated theory section (agent properties, uninformed/informed search, and local search) for the same course module; this README and repository cover only the genetic algorithm / knapsack implementation.
- Weight per gene is discretized to one decimal place; genes are treated as taking a continuous (not strictly binary) amount of each snack, which is why the problem is described as a fractional rather than classic 0/1 knapsack.
