\name{Rnorm}
\alias{Rnorm}
\title{Single-threaded Pseudo-Normal Random Number Generator}
\usage{
Rnorm(n, m = 0, s = 1)
}
\arguments{
\item{n}{An integer specifying the number of observations to generate.}

\item{m}{A numeric value specifying the mean of the distribution. Default is 0.}

\item{s}{A numeric value specifying the standard deviation of the distribution. Default is 1.}
}
\value{
A numeric vector containing \code{n} pseudo-random numbers drawn from the specified normal distribution.
}
\description{
Generates high-performance normal pseudo-random numbers based on an optimized quantile mapping algorithm.
}
\details{
This function applies precise mathematical approximations to provide a fast alternative to the classic \code{rnorm} function.
}
\examples{
# Generate 100 random numbers from N(0,1)
samples <- Rnorm(100)
mean(samples)
sd(samples)

# Generate with custom mean and standard deviation
custom_samples <- Rnorm(10, m = 2, s = 2)
}
\references{
{Sulewski P., Drapella A. (2026). \emph{An Efficient and Precise Quantile Mapping for Normal Pseudo-Random Number Generation.} Journal of Statistical Software, Under review.}
}
\author{
Piotr Sulewski \email{piotr.sulewski@upsl.edu.pl}
}
