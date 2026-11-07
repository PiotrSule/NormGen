# NormGen: Paper Simulations and Empirical Validation Suite

This directory contains the complete localized R source code scripts required to fully replicate the empirical evaluations, statistical validation suites, and high-performance benchmarking workloads presented in the manuscript:

> **"AN EFFICIENT AND PRECISE QUANTILE MAPPING FOR THE GENERATION OF NORMAL PSEUDO-RANDOM NUMBERS"**
> *Piotr Sulewski & Antoni Drapella*

---

## Directory Architecture and Component Files

The replication suite is split into two standalone pipeline modules to separate distribution statistics from computing performance profiling:

1. **`Criteria_1-6.R`**: Executes the mathematical and distributional criteria suite (Criteria 1 through 6). It handles:
   * Theoretical moment fitting and unbiased estimations (Criterion 1).
   * Goodness-of-fit collapse indicators (Criterion 2).
   * Empirical distribution distance bounds (Criterion 3).
   * Non-parametric serial trend tracking (Criterion 4).
   * Phase-length seasonality runs testing (Criterion 5).
   * Local binomial order statistics deviations (Criterion 6).
   * **Output**: Consolidates results into dynamic multi-tab spreadsheet matrix files (`Criterion_1_Results_n[X]_u[Y].xlsx`, etc.) saved directly to your local computer.

2. **`Criterion_7.R`**: Evaluates hardware throughput limits and multi-core thread scaling (Criterion 7). It handles:
   * Empirical descriptive quantile runtime tracking (Table 7 data export).
   * Side-by-side split log-scale violin density charts (Figure 5 visualization asset).
   * Computational time trend-line distributions (Figure 6 asset).
   * Parallel speedup factor curves governed by Amdahl's Law (Figure 7 asset).
   * **Output**: Generates high-resolution, publication-grade visualization graphics (300 DPI) directly inside the workspace.

---

## Replication and Execution Guide

### Prerequisites
To guarantee successful local compilation and execution without Java dependency errors, ensure the following localized R packages are installed within your environment:
```R
install.packages(c("nortest", "randtests", "writexl", "microbenchmark", "ggplot2", "RcppParallel", "openxlsx"))
```

### Verification Pipeline Step-by-Step
1. Ensure the `NormGen` production library package (version 0.0.9) is fully attached to your active R session.
2. Set the working directory to this folder path.
3. Execute `Criteria_1-6.R` to run the statistical simulation pipelines. All generated arrays operate deterministically under the standardized initialization seed parameter `2026`.
4. Execute `Criterion_7.R` to trigger hardware workload optimizations, export the runtime table matrices, and render the high-resolution scaling assets.

---
*Note: All data pipelines, export layers, and visualization rendering blocks are designed to run fully locally without external server dependencies to ensure long-term stability and absolute scientific reproducibility.*
