# NormGen 0.0.9

## Significant API and User-Facing Changes
* Unified and standardized the formal function signatures across the package layout to closely align with the core R statistical ecosystem. 
* Converted the legacy parameter syntax for statistical descriptors: renamed input argument `m` to `mean` and `s` to `sd` within both the sequential `Rnorm()` and parallel `PRnorm()` functions. This provides full plug-and-play parameter signature compatibility with R's native `stats::rnorm` utility.

## Architectural and Engineering Improvements
* Restructured the core source layout to guarantee strict international CRAN repository compliance.
* Renamed the internal documentation file from Polish `R/dokumentacja.R` to an fully anglicized configuration `R/documentation.R` to eliminate cross-platform locale compilation warnings.
* Refined the multi-threaded compilation instructions on Windows systems by introducing the explicit `-DRCPP_PARALLEL_USE_TBB=1` definition flag inside `src/Makevars.win` to fully optimize the pipeline link to Intel TBB workers.
* Integrated comprehensive roxygen2 documentation headers alongside standard functional examples to ensure clean runtime help-file generation.
