
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
Rnorm(10)
#>  [1] -0.481834073  0.070919666  0.100871525  0.228601729 -0.622437488 -0.006578594
#>  [7] -0.125655220  0.325686814 -0.352871726 -0.332205368
parallel_Rnorm(10,2,2)
#>  [1]  4.45466992 -0.24577313 -1.50696356  3.88024531  2.16097564  5.41857159
#>  [7]  1.80885156  4.86104178  1.35706814 -0.03064803
parallel_Rnorm(10)
#>  [1]  1.22733496 -1.12288656 -1.75348178  0.94012265  0.08048782  1.70928580
#>  [7] -0.09557422  1.43052089 -0.32146593 -1.01532402
```

