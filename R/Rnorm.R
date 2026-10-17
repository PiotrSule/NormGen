#' An Efficient and Precise Quantile Mapping for Normal Pseudo-Random Number Generation
#'
#' @description
#' Random generation for the normal distribution with parameters m and s.
#'
#' @param n number of observations.
#' @param m vector of means.
#' @param s vector of standard deviations.
#' @return The function returns the value of random generation for the normal distribution with m equal to mean and standard deviation equal to s.
#'
#' @examples
#' Rnorm(10,2,2)
#' Rnorm(33)
#'
#' @rdname Rnorm
#' @name Rnorm
#' @references
#' {Sulewski P., Drapella A. (2026). \emph{An Efficient and Precise Quantile Mapping for Normal Pseudo-Random Number Generation.} Journal of Statistical Software, Under review.}
#' @importFrom Rcpp sourceCpp
#' @useDynLib NormGen, .registration = TRUE
#' @export
NULL
