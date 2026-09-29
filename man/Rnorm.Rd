\name{Rnorm}
\alias{Rnorm}
\title{An Efficient and Precise Quantile Mapping for Normal Pseudo-Random Number Generation}
\usage{Rnorm(n,m,s)}
\arguments{
\item{n}{number of observations.}

\item{m}{vector of means.}

\item{s}{vector of standard deviations.}
}
\value{
The function returns the value of random generation for the normal distribution with m equal to mean and standard deviation equal to s.
}
\description{
Random generation for the normal distribution with parameters m and s.
}
\examples{
Rnorm(10,2,2)
Rnorm(33)

}
\references{
{Sulewski P., Drapella A. (2026). \emph{An Efficient and Precise Quantile Mapping for Normal Pseudo-Random Number Generation.} Journal of Statistical Software, Under review.}
}
