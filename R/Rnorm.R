#' @title Normal generator
#'
#' @description
#' Random generation for the normal distribution with parameters m and s.
#'
#' @param n number of observations. If length(n) > 1, the length is taken to be the number required.
#' @param m vector of means.
#' @param s vector of standard deviations.
#' @return The function returns the value of random generation for the normal distribution with m equal to mean and standard deviation equal to s.
#' @rdname Rnorm
#'
#' @details
#' This function generates random numbers using a fast piecewise-polynomial spline approximation.
#'
#' @author
#' Piotr Sulewski, \email{piotr.sulewski@@upsl.edu.pl}, Pomeranian University in Slupsk. Antoni Drapella, professor emeritus
#'
#' @references
#' Sulewski P., Drapella A (2026). Very simple and relatively precise mapping of the normal quantile function intended to fastly generate normal pseudo-random numbers. under review.
#'
#' @examples
#' Rnorm(10, 2, 2)
#' Rnorm(33)
#'
#' @export
Rnorm <- function(n, m = 0, s = 1) {
  return(Rnorm_cpp(n, m, s))
}
