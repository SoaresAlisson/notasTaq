library(testthat)

test_files <- list.files("tests/testdata", full.names=T)
test_files_list <- lapply(test_files, \(i) { 
    i  |> xml2::read_html(encoding = "utf8") #|> from_html_2_df() 
  })
# file.path("testdata", "13559_20250520.html")
test_that("extract_metadata works correctly", {

  list_DF <- lapply(test_files_list, extract_metadata)
  list(list_DF, \(i) (i))

}
