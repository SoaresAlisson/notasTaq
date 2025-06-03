library(testthat)


#' get_info(2292)
# Load the function to be tested
# source("path/to/your/get_info.R")

test_that("get_info returns a list with correct information", {
  # Mock data for testing
  mock_page <- "<html><body>
    <div class='white'>Commission Title</div>
    <p>Finalidade: Description of the commission's finality</p>
    <p>Instalação: 01/01/2023</p>
    <div class='color-cpi'>Description 1</div>
    <div class='color-cpmi'>Description 2</div>
    <div class='color-mpv'>Description 3</div>
  </body></html>"

  # Mock the read_html function to return the mock page
  mock_read_html <- function(url) {
    read_html(mock_page)
  }

  # Replace the real rvest::read_html with the mock function
  old_read_html <- rvest::read_html
  on.exit(rvest::read_html <<- old_read_html)
  rvest::read_html <- mock_read_html

  # Call the get_info function with a mock cod value
  result <- get_info(1234)

  # Check if the result is a list
  expect_is(result, "list")

  # Check if the list contains the correct elements
  expect_length(result, 5)
  expect_equal(result$codcol, 1234)
  expect_true(grepl("Commission Title", result$title))
  expect_true(grepl("Description of the commission's finality", result$description))
  expect_true(grepl("01/01/2023", as.character(result$start_date)))
})

test_that("get_info handles missing data gracefully", {
  # Mock data for testing with missing elements
  mock_page_missing <- "<html><body>
    <div class='white'>Commission Title</div>
    <p>Finalidade: Description of the commission's finality</p>
    <p>Instalação:</p>
    <div class='color-cpi'>Description 1</div>
    <div class='color-cpmi'>Description 2</div>
    <div class='color-mpv'>Description 3</div>
  </body></html>"

  # Mock the read_html function to return the mock page
  mock_read_html <- function(url) {
    read_html(mock_page_missing)
  }

  # Replace the real rvest::read_html with the mock function
  old_read_html <- rvest::read_html
  on.exit(rvest::read_html <<- old_read_html)
  rvest::read_html <- mock_read_html

  # Call the get_info function with a mock cod value
  result <- get_info(1234)

  # Check if the start_date is NA when there's no installation date
  expect_true(is.na(result$start_date))
})

