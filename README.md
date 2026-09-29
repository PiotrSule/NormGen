
# NormGen: Normal pseudo - random number generation

**author: Piotr Sulewski, Pomeranian University in Slupsk, Poland**

<!-- badges: start -->
<!-- badges: end -->

Random generation for the normal distribution is presented. To read more about the package
please see (and cite :)) papers:

Sulewski P., Drapella A. (2026). An Efficient and Precise Quantile Mapping for Normal Pseudo-Random Number Generation. Journal of Statistical Software, Under review.


## Installation

You can install the released version of **NormGen** from CRAN with:

``` r
install.packages("NormGen")
```

You can install the development version of **NormGen** from
[GitHub](https://github.com/) with:

``` r
library("remotes")
install_github("PiotrSule/NormGen")
```

### Functions

**Rnorm**

Random generation for the Normal Distribution is calculated

``` r
library(NormGen)
Rnorm(10,2,2)
#>  [1]  2.7330164  0.8988458 -0.1690484  2.3681542  3.5832490  1.9752853  2.1125923  1.8527157
#>  [9]  2.6327170  2.7305332
```

