library(testthat)

text_files <- list.files("tests/testdata", full.names = T)

# Test cases
test_that("from_html_2_df works correctly", {
  # test_html <- create_test_html()
  # list.files("testdata")
  # file.path("testdata", "yourfile.html")
  file_html <- list.files("inst/extdata/", full.names = TRUE)
  NT_html_xml <- rvest::read_html(file_html[1], encoding = "utf8")
  NT_html_char <- readLines(file_html[1], warn = FALSE)


  # Test with character input
  # char_input <- read_html(test_html) %>% as.character()
  result_char <- from_html_2_df(NT_html_char)
  result_xml <- from_html_2_df(NT_html_xml)

  # Test with xml_document input
  expect_s3_class(result_char, "tbl_df")
  expect_s3_class(result_xml, "tbl_df")

  # Test structure
  expect_s3_class(result_char, "tbl_df")
  expect_named(result_char, c("Title", "text"))
  expect_equal(ncol(result_char), 2)

  expect_s3_class(result_xml, "tbl_df")
  expect_named(result_xml, c("Title", "text"))
  expect_equal(ncol(result_xml), 2)


  # Test that both input types produce same output
  expect_equal(result_char, result_xml)

  # Test with empty input
  expect_error(from_html_2_df(""))
  expect_error(from_html_2_df(NULL))

  # Test with malformed HTML
  # malformed_html <- "<html><body><h1>Title</h1><b>Text</malformedtag>"
  # expect_error(from_html_2_df(malformed_html), NA) # Should not error
  #
  # # Test title filtering (only titles with pattern "\\d+/\\d+")
  # custom_html <- '
  # <html>
  #   <h1>Valid 1/1</h1>
  #   <h1>Invalid Title</h1>
  #   <b>Text</b>
  # </html>'
  # custom_result <- from_html_2_df(custom_html)
  # expect_equal(custom_result$title, "Valid 1/1")
})

# test_that("Edge cases are handled", {
#   # No bold text
#   no_bold_html <- '<html><h1>Title 1/1</h1><p>No bold here</p></html>'
#   no_bold_result <- from_html_2_df(no_bold_html)
#   expect_equal(nrow(no_bold_result), 1)
#   expect_equal(no_bold_result$text, character(0))
#
#   # No matching titles
#   no_title_html <- '<html><h1>No Pattern</h1><b>Text</b></html>'
#   no_title_result <- from_html_2_df(no_title_html)
#   expect_equal(nrow(no_title_result), 0)
# })


test_that("Encoding is handled properly", {
  utf8_html <- "<html><h1>Title 1/1</h1><b>Texto en español ñandú</b></html>"
  result <- from_html_2_df(utf8_html)
  expect_equal(result$text, "Texto en español ñandú")
})

test_that("list files from_html_2_df works correctly", {
  files_html <- list.files("inst/extdata/", full.names = TRUE)
  list_xml <- lapply(files_html, rvest::read_html, encoding = "utf8")
  # NT_html_xml <- rvest::read_html(file_html[1], encoding = "utf8")
  list_char <- lapply(files_html, readLines, warn = FALSE)
  # NT_html_char <- readLines(file_html[1], warn = FALSE)


  # Test with character input
  # char_input <- read_html(test_html) %>% as.character()
  result_char <- lapply(list_char, from_html_2_df)
  result_xml <- lapply(list_xml, from_html_2_df)

  # Test with xml_document input
  expect_s3_class(result_char[[1]], "tbl_df")
  expect_s3_class(result_char[[2]], "tbl_df")
  expect_s3_class(result_char[[3]], "tbl_df")
  expect_s3_class(result_xml[[1]], "tbl_df")
  expect_s3_class(result_xml[[2]], "tbl_df")
  expect_s3_class(result_xml[[3]], "tbl_df")

  # Test structure
  expect_s3_class(result_char[[1]], "tbl_df")
  expect_named(result_char[[1]], c("Title", "text"))
  expect_equal(ncol(result_char[[1]]), 2)

  expect_s3_class(result_xml[[1]], "tbl_df")
  expect_named(result_xml[[1]], c("Title", "text"))
  expect_equal(ncol(result_xml[[1]]), 2)


  # Test that both input types produce same output
  expect_equal(result_char[[1]], result_xml[[1]])
  expect_equal(result_char[[2]], result_xml[[2]])
  # expect_equal(result_char[[3]], result_xml[[3]]) # TODO

  # Test with empty input
  expect_error(from_html_2_df(""))
  expect_error(from_html_2_df(NULL))
})
