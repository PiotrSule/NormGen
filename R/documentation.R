#' Multi-threaded Pseudo-Normal Random Number Generator
#'
#' @name PRnorm
#' @description Generates pseudo-random numbers from a normal distribution using multiple threads.
#' @param n number of samples to generate
#' @param mean distribution mean (default is 0.0)
#' @param sd distribution standard deviation (default is 1.0)
#' @param seed random number generator seed (default is 12345)
#' @return A numeric vector of length n containing pseudo-random numbers from the specified normal distribution.
#' @importFrom RcppParallel RcppParallelLibs
#' @usage PRnorm(n, mean = 0, sd = 1, seed = 12345L)
#' @examples
#' # Generate 100,000 parallel random samples
#' samples <- PRnorm(100000, mean = 0, sd = 1)
#' summary(samples)
#'
#' # Generate with a custom seed for reproducibility
#' samples_repro <- PRnorm(50000, mean = 10, sd = 2, seed = 999)
#' mean(samples_repro)
#' sd(samples_repro)
#' @export
NULL

#' Single-threaded Pseudo-Normal Random Number Generator
#'
#' @name Rnorm
#' @description Original single-threaded implementation of the NormGen quantile mapping algorithm.
#' @param n number of samples to generate
#' @param mean distribution mean (default is 0.0)
#' @param sd distribution standard deviation (default is 1.0)
#' @return A numeric vector of length n containing pseudo-random numbers from the specified normal distribution.
#' @importFrom RcppParallel RcppParallelLibs
#' @usage Rnorm(n, mean = 0, sd = 1)
#' @examples
#' # Generate 100,000 single-threaded random samples
#' samples_single <- Rnorm(100000, mean = 0, sd = 1)
#' summary(samples_single)
#' @export
NULL
