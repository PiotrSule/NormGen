# ==============================================================================
# NormGen: Comprehensive Reproducible Simulation and Benchmarking Suite
# Author: Piotr Sulewski
# Seed Anchor: 2026 (Standardized Environment)
# Criteria 1 - 6
# ==============================================================================

library(nortest) # normality Tests
library(pracma) # practical mathematics
library(xlsx) # reading, writing, and formatting Excel files
library(microbenchmark) # accurate timing and benchmarking of R code
library(ggplot2) # creating elegant and complex data visualization
library(EnvStats) # graphical and statistical analyses of environmental data
library(randtests) # testing the randomness of a numeric sequence
library(NormGen) # new package with PRnorm and Rnorm functions

set.seed(2026) # initialize the pseudo-random number generator

# analyzed values (n, u) in the paper:
# (10^2, 10^6), (10^3, 10^5), (10^4, 10^4), (10^5, 10^3), (10^6, 10^2),

alfa=0.05 # significance level
n=10^2 # sample size (number of observations)
u=10^6 # number of test repetitions (trials)

xPRnorm=matrix(NA, nrow=n, ncol=u) # for NormGen::PRnorm
xRnorm=matrix(NA, nrow=n, ncol=u)  # for NormGen::Rnorm
xrnorm=matrix(NA, nrow=n, ncol=u)  # for classic rnorm

for (j in 1:u) {
  print(j)
  xPRnorm[,j] = PRnorm(n)
  xRnorm[,j] = Rnorm(n)
  xrnorm[,j] = rnorm(n)
}

# Sample central moments, auxiliary function for criterion1
cm = function(x, a) return(sum((x - mean(x)) ^ a)/length(x))

# ==============================================================================
# 1. Moments of standard normal distribution
# ==============================================================================

criterion1 = function(x){
  c1 = numeric(4);  u = ncol(x)
  n = nrow(x);  Mn = matrix(NA, nrow = u, ncol = 4)

  # Multipliers for unbiased estimators (computed once)
  w2 = n / (n - 1)
  w3 = (n * n) / ((n - 1) * (n - 2))
  w4_1 = (n * (n * n - 2 * n + 3)) / ((n - 1) * (n - 2) * (n - 3))
  w4_2 = (3 * n * (2 * n - 3)) / ((n - 1) * (n - 2) * (n - 3))

  for (j in 1:u){
    print(j)
    dat = x[, j]
    m2 = cm(dat, 2)
    Mn[j,1] = abs(mean(dat))                               # abs(sample mean)
    Mn[j,2] = abs(m2 * w2 - 1)                             # abs(sample variance - 1)
    Mn[j,3] = abs(cm(dat, 3) * w3)                         # abs(sample third central moments)
    Mn[j,4] = abs(cm(dat, 4) * w4_1 - (m2^2) * w4_2 - 3)   # abs(sample fourth central moments - 3)
  }
  for (i in 1:4) c1[i] = mean(Mn[,i])
return(c1)
}

# ==============================================================================
# 2. Goodness-of-fit tests
# ==============================================================================

criterion2 = function(x, alfa) {
  n = nrow(x) # Sample size
  u = ncol(x) # Number of repetitions (u)

  # Step 2: Initialize T_i (acceptance counter) and S_i (p-value accumulator)
  T_vec = numeric(5)
  S_vec = numeric(5)

  # Step 3: Loop through each simulation run (j = 1 to u)
  for (j in 1:u) {
    print(j)
    # Step 4: Extract the j-th generated sample from N(0,1)
    dat = sort(as.vector(x[, j]))

    # Step 5: Calculate pv_i (i = 1, 2, ..., 5)
    pv = numeric(5)
    pv[1] = nortest::lillie.test(dat)$p.value
    pv[2] = nortest::ad.test(dat)$p.value
    pv[3] = nortest::cvm.test(dat)$p.value
    pv[4] = nortest::sf.test(dat)$p.value
    pv[5] = shapiro.test(dat)$p.value

    # Step 6 & 7: Update counters if pv_i > alpha, and accumulate p-values
    for (i in 1:5) {
      if (pv[i] > alfa) {
        T_vec[i] = T_vec[i] + 1
      }
      S_vec[i] = S_vec[i] + pv[i]
    }
  }

  # Step 8: Calculate final means (S_bar and T_bar) across all u repetitions
  S_bar = S_vec / u
  T_bar = T_vec / u

  # Step 9: Format and return results as a 5x2 matrix
  results_matrix = matrix(NA, nrow = 5, ncol = 2)
  rownames(results_matrix) = c("Lilliefors", "Anderson-Darling", "Cramer-von Mises", "Shapiro-Francia", "Shapiro-Wilk")
  colnames(results_matrix) = c("Mean_p_value", "Acceptance_Rate")

  results_matrix[, 1] = S_bar
  results_matrix[, 2] = T_bar
  return(results_matrix)
}

# ==============================================================================
# 3. Measure for theoretical and empirical distribution functions
# ==============================================================================

criterion3 = function(x, type = 1){
  u = ncol(x)
  n = nrow(x)
  M = numeric(u)

  # Precompute Blom's plotting points to optimize calculation speed
  bloms_points = ((1:n) - 0.375) / (n + 0.25)

  for (j in 1:u){
    print(j)
    # Convert matrix column to a sorted vector directly
    dat = sort(as.vector(x[, j]))

    # Vectorized computation of absolute differences against the standard normal CDF
    FF = abs(pnorm(dat, 0, 1) - bloms_points)
    M[j] = sum(FF)
  }

  if (type == 1) return(mean(M)) else return(M)
}

# ==============================================================================
# 4. Trend tests
# ==============================================================================

criterion4 = function(x, alfa) {
  n = nrow(x) # Sample size
  u = ncol(x) # Number of repetitions (u)

  # Initialize T_i (acceptance counter) and S_i (p-value accumulator)
  T_vec = numeric(3)
  S_vec = numeric(3)

  # Loop through each simulation run (j = 1 to u)
  for (j in 1:u) {
    print(j)
    dat = x[, j]

    # Calculate pv_i (i = 1, 2, 3)
    pv = numeric(3)
    pv[1] = randtests::turning.point.test(dat)$p.value
    pv[2] = randtests::difference.sign.test(dat)$p.value
    pv[3] = randtests::rank.test(dat)$p.value

    # Update counters and accumulate p-values
    for (i in 1:3) {
      if (pv[i] > alfa) {
        T_vec[i] = T_vec[i] + 1
      }
      S_vec[i] = S_vec[i] + pv[i]
    }
  }

  # Calculate final means (S_bar and T_bar) across all u repetitions
  S_bar = S_vec / u
  T_bar = T_vec / u

  # Format and return results as a 3x2 matrix
  results_matrix = matrix(NA, nrow = 3, ncol = 2)
  rownames(results_matrix) = c("Turning Point Test", "Difference Sign Test", "Rank Test")
  colnames(results_matrix) = c("Mean_p_value", "Acceptance_Rate")

  results_matrix[, 1] = S_bar
  results_matrix[, 2] = T_bar

  return(results_matrix)
}

# ==============================================================================
# 5.Seasonality test
# ==============================================================================

criterion5 = function(x, alfa) {
  n = nrow(x) # Sample size
  u = ncol(x) # Number of repetitions (u)

  # Initialize global variables for the final output aggregation
  pS = 0
  sum_pvS = 0

  # Loop through each simulation run (j = 1 to u)
  for (j in 1:u) {
    print(j)
    dat = x[, j]

    # Dynamically allocate array based on sample size to prevent memory overflows
    tab1 = numeric(n)

    znacznik = (dat[2] > dat[1])
    zez = znacznik
    dl = 1

    for (i in 3:n) {
      if (dat[i] > dat[i-1]) {
        znacznik = TRUE
      } else {
        znacznik = FALSE
      }

      if (znacznik != zez) {
        tab1[dl] = tab1[dl] + 1
        dl = 1
        zez = znacznik
      } else {
        dl = dl + 1
      }
    }
    tab1[dl] = tab1[dl] + 1

    # Establish the maximum sequence window size dynamically
    maks = 0
    for (i in 1:10) {
      if (tab1[i] != 0) maks = i
    }

    # Prevent degree of freedom errors for static or low-variance sequences
    if (maks <= 1) maks = 2

    ns = numeric(maks)
    stat = numeric(maks)

    for (i in 1:maks) {
      ns[i] = (2 * (n - i - 2) * (i * i + 3 * i + 1)) / factorial(i + 3)
      if (ns[i] > 0) {
        stat[i] = ((tab1[i] - ns[i]) ^ 2) / ns[i]
      } else {
        stat[i] = 0
      }
    }

    # Safe evaluation of degrees of freedom and p-value computation
    deg_freedom = max(1, maks - 1)
    p_val = 1 - pchisq(sum(stat), deg_freedom)
    p_val = max(0, min(1, p_val))

    # Accumulate results for the global counter
    sum_pvS = sum_pvS + p_val
    if (p_val > alfa) {
      pS = pS + 1
    }
  }

  # Calculate final means across all u repetitions
  S_bar = sum_pvS / u
  T_bar = pS / u

  # Format and return results as a 1x2 matrix
  results_matrix = matrix(NA, nrow = 1, ncol = 2)
  rownames(results_matrix) = c("Runs Test (Up/Down)")
  colnames(results_matrix) = c("Mean_p_value", "Acceptance_Rate")

  results_matrix[1, 1] = S_bar
  results_matrix[1, 2] = T_bar

  return(results_matrix)
}

# ==============================================================================
# 6. Cumulative distribution function of order statistics
# ==============================================================================

criterion6 = function(x, type = 1){
  u = ncol(x) # Number of samples
  n = nrow(x) # Sample size

  # Ensure nos is an integer (e.g., 1st, 11th, 21st... order statistic)
  nos = floor(n / 10) + 1

  # Step 1: Sort each sample (column) internally
  for (j in 1:u) x[, j] = sort(x[, j])

  # Step 2: Extract selected order statistics
  xn = matrix(NA, nrow = u, ncol = nos)
  xn[, 1] = x[1, ] # 1st order statistic
  if (nos > 1) {
    for (i in 2:nos) {
      xn[, i] = x[10 * (i - 1), ] # 10th, 20th, 30th... order statistic
    }
  }

  # Step 3: Sort across samples for each selected order statistic
  for (i in 1:nos) {
    xn[, i] = sort(xn[, i])
  }

  # Step 4: Calculate theoretical CDF of order statistics using pbinom (Vectorized)
  Phi = matrix(NA, nrow = u, ncol = nos)
  for (j in 1:u) {
    if(j %% 10 == 0 || j == u) {
      print(paste("Calculating Order Statistics CDF for sample:", j, "/", u))
    }

    # Probability for standard normal distribution (for all statistics in row j)
    prob = pnorm(xn[j, ], 0, 1)

    # 1st order statistic - POPRAWIONE: prob[1] zamiast prob
    Phi[j, 1] = pbinom(0, n, prob[1], lower.tail = FALSE)

    # Subsequent order statistics
    if (nos > 1) {
      for (i in 2:nos) {
        # Teoretyczna dystrybuanta i-tej statystyki pozycyjnej
        k_stat = 10 * (i - 1)
        Phi[j, i] = pbinom(k_stat - 1, n, prob[i], lower.tail = FALSE)
      }
    }
  }
  # Step 5: Compute absolute deviations from empirical distribution j / (u + 1)
  MOS = matrix(NA, nrow = u, ncol = nos)
  empirical_grid = (1:u) / (u + 1)
  for (i in 1:nos) {
    MOS[, i] = abs(Phi[, i] - empirical_grid)
  }
  # Step 6: Sum over all samples for each order statistic
  s = colSums(MOS)

  if (type == 1) return(mean(s)) else return(s)
}

# ==============================================================================
# Execution Framework and Data Export - Criterion 1
# ==============================================================================

# 1. Install and load the independent Excel export package (no Java dependency required)
if (!requireNamespace("writexl", quietly = TRUE)) install.packages("writexl")
library(writexl)

# 2. Evaluate Criterion 1 across the generator triad using the active environment variables
C11 <- criterion1(xPRnorm)
C12 <- criterion1(xRnorm)
C13 <- criterion1(xrnorm)

# 3. Construct a strictly unique named list to prevent worksheet name collisions in Excel
wyniki_momenty <- list(
  "PRnorm_Moments"   = as.data.frame(C11),
  "Rnorm_Moments"    = as.data.frame(C12),
  "Native_rnorm_Mom" = as.data.frame(C13)
)

# 4. Dynamically construct the filename by embedding active 'n' and 'u' environment variables
output_filename <- paste0("C:/NormGen/Criterion_1_Results_n", n, "_u", u, ".xlsx")

# 5. Consolidate and export all data frames into the dynamically named Excel workbook
writexl::write_xlsx(wyniki_momenty, path = output_filename)

# 6. Display successful compilation message in the R console
message(paste("Success! Consolidated simulation results saved to:", output_filename))

# ==============================================================================
# Execution Framework and Data Export - Criterion 2
# ==============================================================================

# 1. Install and load the independent Excel export package (no Java dependency required)
if (!requireNamespace("writexl", quietly = TRUE)) install.packages("writexl")
library(writexl)

# 2. Evaluate Criterion 2 across the generator triad using active environment variables (alfa, n, u)
C21 <- criterion2(xPRnorm, alfa)
C22 <- criterion2(xRnorm, alfa)
C23 <- criterion2(xrnorm, alfa)

# 3. Construct a strictly unique named list to prevent worksheet name collisions in Excel
wyniki_zgodnosci <- list(
  "PRnorm_Fit"       = as.data.frame(C21),
  "Rnorm_Fit"        = as.data.frame(C22),
  "Native_rnorm_Fit" = as.data.frame(C23)
)

# 4. Dynamically construct the output filename by embedding active 'n' and 'u' environment variables
output_filename_c2 <- paste0("C:/NormGen/Criterion_2_Results_n", n, "_u", u, ".xlsx")

# 5. Consolidate and export all data frames into the dynamically named Excel workbook
writexl::write_xlsx(wyniki_zgodnosci, path = output_filename_c2)

# 6. Display successful compilation message with the absolute path in the R console
message(paste("Success! Consolidated Criterion 2 results saved to:", output_filename_c2))

# ==============================================================================
# Execution Framework and Data Export - Criterion 3
# ==============================================================================

# 1. Install and load the independent Excel export package (no Java dependency required)
if (!requireNamespace("writexl", quietly = TRUE)) install.packages("writexl")
library(writexl)

# 2. Evaluate Criterion 3 across the generator triad using active environment variables (n, u)
C31 <- criterion3(xPRnorm)
C32 <- criterion3(xRnorm)
C33 <- criterion3(xrnorm)

# 3. Construct a strictly unique named list to prevent worksheet name collisions in Excel
wyniki_dystansu <- list(
  "PRnorm_Dist"       = as.data.frame(C31),
  "Rnorm_Dist"        = as.data.frame(C32),
  "Native_rnorm_Dist" = as.data.frame(C33)
)

# 4. Dynamically construct the output filename embedding active 'n' and 'u' environment variables
output_filename_c3 <- paste0("C:/NormGen/Criterion_3_Results_n", n, "_u", u, ".xlsx")

# 5. Consolidate and export all data frames into the dynamically named Excel workbook
writexl::write_xlsx(wyniki_dystansu, path = output_filename_c3)

# 6. Display successful compilation message with the absolute path in the R console
message(paste("Success! Consolidated Criterion 3 results saved to:", output_filename_c3))

# ==============================================================================
# Execution Framework and Data Export - Criterion 4
# ==============================================================================

# 1. Install and load the independent Excel export package (no Java dependency required)
if (!requireNamespace("writexl", quietly = TRUE)) install.packages("writexl")
library(writexl)

# 2. Evaluate Criterion 4 across the generator triad using active environment variables (alfa, n, u)
C41 <- criterion4(xPRnorm, alfa)
C42 <- criterion4(xRnorm, alfa)
C43 <- criterion4(xrnorm, alfa)

# 3. Construct a strictly unique named list to prevent worksheet name collisions in Excel
wyniki_trendow <- list(
  "PRnorm_Trend"       = as.data.frame(C41),
  "Rnorm_Trend"        = as.data.frame(C42),
  "Native_rnorm_Trend" = as.data.frame(C43)
)

# 4. Dynamically construct the output filename embedding active 'n' and 'u' environment variables
output_filename_c4 <- paste0("C:/NormGen/Criterion_4_Results_n", n, "_u", u, ".xlsx")

# 5. Consolidate and export all data frames into the dynamically named Excel workbook
writexl::write_xlsx(wyniki_trendow, path = output_filename_c4)

# 6. Display successful compilation message with the absolute path in the R console
message(paste("Success! Consolidated Criterion 4 results saved to:", output_filename_c4))

# ==============================================================================
# Execution Framework and Data Export - Criterion 5
# ==============================================================================

# 1. Install and load the independent Excel export package (no Java dependency required)
if (!requireNamespace("writexl", quietly = TRUE)) install.packages("writexl")
library(writexl)

# 2. Evaluate Criterion 5 across the generator triad using active environment variables (alfa, n, u)
C51 <- criterion5(xPRnorm, alfa)
C52 <- criterion5(xRnorm, alfa)
C53 <- criterion5(xrnorm, alfa)

# 3. Construct a strictly unique named list to prevent worksheet name collisions in Excel
wyniki_sezonowosci <- list(
  "PRnorm_Season"       = as.data.frame(C51),
  "Rnorm_Season"        = as.data.frame(C52),
  "Native_rnorm_Season" = as.data.frame(C53)
)

# 4. Dynamically construct the output filename embedding active 'n' and 'u' environment variables
output_filename_c5 <- paste0("C:/NormGen/Criterion_5_Results_n", n, "_u", u, ".xlsx")

# 5. Consolidate and export all data frames into the dynamically named Excel workbook
writexl::write_xlsx(wyniki_sezonowosci, path = output_filename_c5)

# 6. Display successful compilation message with the absolute path in the R console
message(paste("Success! Consolidated Criterion 5 results saved to:", output_filename_c5))

# ==============================================================================
# Execution Framework and Data Export - Criterion 6
# ==============================================================================

# 1. Install and load the independent Excel export package (no Java dependency required)
if (!requireNamespace("writexl", quietly = TRUE)) install.packages("writexl")
library(writexl)

# 2. Evaluate Criterion 6 across the generator triad using active environment variables (n, u)
C61 <- criterion6(xPRnorm, 1)
C62 <- criterion6(xRnorm, 1)
C63 <- criterion6(xrnorm, 1)

# 3. Construct a strictly unique named list to prevent worksheet name collisions in Excel
wyniki_stat_pozycyjnych <- list(
  "PRnorm_Order"       = as.data.frame(C61),
  "Rnorm_Order"        = as.data.frame(C62),
  "Native_rnorm_Order" = as.data.frame(C63)
)

# 4. Dynamically construct the output filename embedding active 'n' and 'u' environment variables
output_filename_c6 <- paste0("C:/NormGen/Criterion_6_Results_n", n, "_u", u, ".xlsx")

# 5. Consolidate and export all data frames into the dynamically named Excel workbook
writexl::write_xlsx(wyniki_stat_pozycyjnych, path = output_filename_c6)

# 6. Display successful compilation message with the absolute path in the R console
message(paste("Success! Consolidated Criterion 6 results saved to:", output_filename_c6))


