library(testthat)

testthat::test_that("parse_NT works", {
    # URL <- "https://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/13611"
# exists("file_html")
    page <- rvest::read_html(URL)
    DF_url_rvest <- parse_NT(page)
    DF_url <- parse_NT(URL)

    file_html <- list.files("inst/extdata/", full.names=TRUE)
    DF <- parse_TN(file_html)

    DF_xml2 <- xml2::read_html(file_html,encoding = "utf8") |> parse_NT() 
    DF_rvest <- rvest::read_html(file_html,encoding = "utf8") |> parse_NT()

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
