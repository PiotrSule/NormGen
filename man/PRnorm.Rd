\name{PRnorm}
\alias{PRnorm}
\title{High-Performance Multithreaded Pseudo-Normal Random Number Generator}
\description{
Generates multi-core parallel processing normal pseudo-random numbers powered by 'RcppParallel' and Intel 'TBB'.
}
\usage{
PRnorm(n, mean = 0, sd = 1, seed = 12345L)
}
\arguments{
\item{n}{An integer specifying the number of observations to generate.}
\item{mean}{A numeric value specifying the mean of the distribution. Default is 0.}
\item{sd}{A numeric value specifying the standard deviation of the distribution. Default is 1.}
\item{seed}{An integer to initialize the pseudo-random number generator state. Default is 12345L.}
}
\value{
A numeric vector containing \code{n} pseudo-random numbers drawn from the specified normal distribution.
}
\details{
This function divides the generation task across available CPU threads to maximize execution performance. By passing a specific integer to the \code{seed} parameter, you ensure the full reproducibility of the obtained results across different executions.
}
\examples{
# Generate parallel numbers with an explicit seed
parallel_samples <- PRnorm(1000, mean = 0, sd = 1, seed = 2026)

# Verify reproducibility directly via the parameter
verify_samples <- PRnorm(1000, mean = 0, sd = 1, seed = 2026)
identical(parallel_samples, verify_samples)
}
\author{
Piotr Sulewski \email{piotr.sulewski@upsl.edu.pl}
}
