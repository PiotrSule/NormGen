library(testthat)
library(NormGen)

context("Testing standard Rnorm function")

test_that("Rnorm generates correct vector length", {
  # Check that the function returns the exact requested length using positional arguments
  expect_length(Rnorm(10), 10)
  expect_length(Rnorm(100), 100)
})

test_that("An invalid number of parameters", {
  # Ensure the function throws an error when the required argument 'n' is missing
  expect_error(Rnorm())
})

test_that("Rnorm returns correct data type", {
  res <- Rnorm(50)
  expect_type(res, "double")
})

test_that("Rnorm is fully reproducible with global set.seed", {
  set.seed(2026)
  sample1 <- Rnorm(500)

  set.seed(2026)
  sample2 <- Rnorm(500)

  expect_identical(sample1, sample2)
})
