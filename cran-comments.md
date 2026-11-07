## Submission Comments
This is a patch release focused on standardized API unification and international repository compliance for the `NormGen` package. The key modifications implemented in version 0.0.9 include:

* **API Standardization:** Replaced legacy argument syntax `m` and `s` with `mean` and `sd` across both `Rnorm()` and `PRnorm()` functions to guarantee signature consistency with R's native `stats::rnorm`.
* **Repository Globalization:** Completely anglicized the internal file layout by renaming `R/dokumentacja.R` to `R/documentation.R` to ensure cross-platform locale compatibility.
* **Windows Pipeline Optimization:** Refined the high-performance multi-threaded engine linkage by explicitly implementing the `-DRCPP_PARALLEL_USE_TBB=1` definition flag inside `src/Makevars.win` to fully stabilize the interaction with Intel TBB workers.
* **Statistical Integrity:** Verified that internal RNG seed correlations across parallel threads and localized piecewise cubic polynomial boundaries are completely resolved, preserving exact distributional shapes.

## Test Environments
* Local: Windows 11 Pro, R 4.6.1 (64-bit), Intel Core i7 (Multithreaded Intel TBB/RcppParallel validation)
* Cloud: Ubuntu Linux (latest release via GitHub Actions / R-hub testing workflows)

## R CMD check results
There were no ERRORs, WARNINGs, or NOTEs.

* All integrated structural and statistical unit tests (`tests/testthat/`) executed successfully with zero divergence tolerances.
* The multi-threaded quantile mapping accuracy perfectly matches the single-threaded `Rnorm` baseline performance while efficiently utilizing all available physical processor cores.
