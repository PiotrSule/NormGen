test_that("Rnorm generates correct vector length", {
  expect_length(Rnorm(10, 0, 1), 10)
  expect_length(Rnorm(100, 5, 2), 100)
})
