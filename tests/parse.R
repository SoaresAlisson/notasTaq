library(testthat)

testthat::test_that("parse_TN works", {
  URLv <- c(
    "https://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/13611",
    "https://escriba.camara.leg.br/escriba-servicosweb/html/79315"
  )
  # exists("file_html")
  URL <- list.files(path = "tests/testdata", full.names = TRUE)
  page <- rvest::read_html(URL[1])
  DF_url_rvest <- parse_TN(page)
  DF_url <- parse_TN(URL)

  file_html <- list.files("inst/extdata/", full.names = TRUE)
  DF <- parse_TN(file_html[1])
  DF2 <- parse_TN(file_html[2])

  DF_xml2 <- xml2::read_html(file_html, encoding = "utf8") |> parse_TN()
  DF_rvest <- rvest::read_html(file_html, encoding = "utf8") |> parse_TN()

  # Test: input is URL (char)
  expect_true(is.character(URL))
  # Test: output is data.frame
  expect_true(is.data.frame(DF))
  expect_true(is.data.frame(DF_url_rvest))
  expect_true(is.data.frame(DF_url))
  expect_true(is.data.frame(DF_xml2))
  expect_true(is.data.frame(DF_rvest))

  # Test: output is not empty
  expect_true(nrow(DF) > 0)
  expect_true(nrow(DF_url_rvest) > 0)
  expect_true(nrow(DF_url) > 0)
  expect_true(nrow(DF_xml2) > 0)
  expect_true(nrow(DF_rvest) > 0)

  # Test: output has at least one column
  expect_true(ncol(DF) > 0)
  expect_true(ncol(DF_url_rvest) > 0)
  expect_true(ncol(DF_url) > 0)
  expect_true(ncol(DF_xml2) > 0)
  expect_true(ncol(DF_rvest) > 0)
})
