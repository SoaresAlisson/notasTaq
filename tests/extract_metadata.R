library(testthat)

dir_exs <- "./inst/extdata/"
file_name <- paste0(dir_exs, "NT_13219.html")
DF <- rvest::read_html(file_name, encoding = "utf8") 
# DF <- from_html_2_df(DF)

testthat::test_that("extract_metadata works", {

  # expect_true(colnames(DF) |> length() == 2)
  # expect_true(nrow(DF) > 1)
  DF2 <- DF |> extract_metadata()
  expect_gt( colnames(DF2) |> length(), 2)
  # expect_type(DF2Date, "date" )
  expect_true(grepl(x=DF2$reunion_n, "\\d") |> any())

})

test_files <- list.files("tests/testdata", full.names=T)
test_files_list <- lapply(test_files, \(i) { 
    i  |> xml2::read_html(encoding = "utf8") #|> from_html_2_df() 
  })
# file.path("testdata", "13559_20250520.html")
test_that("extract_metadata works correctly", {

  list_DF <- lapply(test_files_list, extract_metadata)
  list(list_DF, \(i) (i))

}
