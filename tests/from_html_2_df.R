library(testthat)

text_files <- list.files("tests/testdata", full.names=T)

# Test cases
test_that("from_html_2_df works correctly", {
  # test_html <- create_test_html()
  # list.files("testdata")
  # file.path("testdata", "yourfile.html")
  file_html <- list.files("inst/extdata/", full.names=TRUE)
  NT_html_xml <- rvest::read_html(file_html,encoding = "utf8")
  NT_html_char <- readLines(file_html, warn = FALSE)

  
  # Test with character input
  # char_input <- read_html(test_html) %>% as.character()
  result_char <- from_html_2_df(NT_html_char)
  result_xml <- from_html_2_df(NT_html_xml)
  
  # Test with xml_document input
  expect_s3_class(result_char, "tbl_df")
  expect_s3_class(result_xml, "tbl_df")
  
  # Test structure
  expect_s3_class(result_char, "tbl_df")
  expect_named(result_char, c("title", "text"))
  expect_equal(ncol(result_char), 2)

  expect_s3_class(result_xml, "tbl_df")
  expect_named(result_xml, c("title", "text"))
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
   lapply(text_files, \(i) { 
  i  |> xml2::read_html(encoding = "utf8") |> 
  from_html_2_df() })


test_that("Encoding is handled properly", {
  utf8_html <- '<html><h1>Title 1/1</h1><b>Texto en español ñandú</b></html>'
  result <- from_html_2_df(utf8_html)
  expect_equal(result$text, "Texto en español ñandú")
})
