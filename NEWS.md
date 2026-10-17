# NormGen 0.0.6

## New Features
* Added `parallel_Rnorm()`, a high-performance multithreaded pseudo-normal random number generator powered by `RcppParallel` and Intel 'TBB'.
* Integrated an explicit `seed` argument as the optional parameter in `parallel_Rnorm()` to strictly guarantee the reproducibility of the obtained simulation results.

## Documentation and Standards
* Created comprehensive `.Rd` user documentation files for both `Rnorm` and `parallel_Rnorm` in the `man/` directory to resolve package check notes.
* Fully updated `README.Rmd` and `README.md` to formally document the usage and reproducibility architecture of the new parallel processing implementation.
* Switched all internal package documentation, errors, and source code comments to English for full CRAN compliance.

## Bug Fixes and Optimization
* Fixed a package check omission where the parallel generator function lacked user-facing documentation files.
* Optimized package compilation flags within `src/Makevars` and `src/Makevars.win` to seamlessly support multi-core parallel processing.
* Added a comprehensive suite of unit tests using `testthat` (under `tests/testthat/`) covering edge cases, vector lengths, missing parameters, and cross-reproducibility between single-threaded and parallel functions.
* Renamed `parallel_Rnorm()` to `PRnorm()` for brevity
