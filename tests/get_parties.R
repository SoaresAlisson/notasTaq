baseURL <- "https://legis.senado.leg.br/dadosabertos/"


library(testthat)
library(httr)
library(tibble)

# Mock the actual function (assuming it's in a package called "mypackage")
# If not using a package, you can source the file containing the function
# source("path/to/your/function.R")

test_that("get_parties() returns expected output", {
  # Test 1: Function returns a tibble
  result <- get_parties()
  expect_true(is_tibble(result), info = "Output should be a tibble")
  
  # Test 2: Tibble has expected columns (adjust based on actual API response)
  expected_cols <- c("Codigo", "Sigla", "Nome", "DataCriacao", "DataExtincao")
  expect_true(all(expected_cols %in% names(result)), 
              info = "Tibble should contain expected columns")
  
  # Test 3: Response contains at least some known Brazilian parties
  known_parties <- c("PT", "PSDB", "MDB", "PL", "PSOL")
  expect_true(any(result$Sigla %in% known_parties), 
              info = "Should contain known Brazilian parties")
  
  # Test 4: Columns have expected types
  # expect_type(result$Codigo, "integer")
  expect_type(result$Sigla, "character")
  expect_type(result$Nome, "character")
  
  # Test 5: No empty values in critical columns
  expect_false(any(is.na(result$Codigo)), 
               info = "Codigo should not contain NA values")
  expect_false(any(is.na(result$Sigla)), 
               info = "Sigla should not contain NA values")
  expect_false(any(result$Sigla == ""), 
               info = "Sigla should not contain empty strings")

# Test: number of lines
  expect_gt(  nrow(result), 0)
})

test_that("get_parties() handles API errors", {
  # Test 6: Should handle API errors gracefully
  # Mock a failed API response
  # with_mock(
  #   `httr::GET` = function(...) stop("API unavailable"),
  #   expect_error(get_parties(), "API unavailable")
  # )
  
  # Test 7: Should handle empty responses
  mock_empty_response <- list(
    content = charToRaw("{}"),
    status_code = 200
  )
  class(mock_empty_response) <- "response"
  
  with_mock(
    `httr::GET` = function(...) mock_empty_response,
    result <- get_parties(),
    expect_equal(nrow(result), 0))
})

# -----

library(testthat)
library(httptest)
library(tibble)

# Mock test context
with_mock_api({
  test_that("get_parties() returns expected tibble of Brazilian political parties", {
    # Expected API response structure
    expected_response <- list(
      ListaPartidos = list(
        Partidos = data.frame(
          Id = c(1, 2),
          Sigla = c("PT", "PSDB"),
          Nome = c("Partido dos Trabalhadores", "Partido da Social Democracia Brasileira"),
          Uri = c("http://example.com/pt", "http://example.com/psdb"),
          stringsAsFactors = FALSE
        )
      )
    )
    
    # Mock the API response
    mock_url <- paste0(baseURL, "composicao/lista/partidos")
    mock_response <- list(
      content = charToRaw(jsonlite::toJSON(expected_response, auto_unbox = TRUE)),
      status_code = 200
    )
    
    # Set up the mock
    expect_GET(
      assign("http", mock_response, envir = environment(get_parties)),
      mock_url
    )
    
    # Call the function
    result <- get_parties()
    
    # Test the returned object
    expect_s3_class(result, "tbl_df")
    expect_named(result, c("Codigo", "Sigla", "Nome", "DataCriacao", "DataExtincao"))
    # expect_equal(nrow(result), 2)
    expect_true(all((c("PT", "PSDB") %in% result$Sigla )))
    expect_true(all((c("Partido dos Trabalhadores", "Partido da Social Democracia Brasileira") %in% result$Nome)))
    
    # Test for empty response handling (if needed)
    empty_response <- list(ListaPartidos = list(Partidos = data.frame()))
    mock_response$content <- charToRaw(jsonlite::toJSON(empty_response, auto_unbox = TRUE))
    expect_GET(
      assign("http", mock_response, envir = environment(get_parties)),
      mock_url
    )
    empty_result <- get_parties()
    expect_equal(nrow(empty_result), 0)
  })
})

# Test error handling (if needed)
with_mock_api({
  test_that("get_parties() handles HTTP errors appropriately", {
    mock_url <- paste0(baseURL, "composicao/lista/partidos")
    mock_response <- list(status_code = 404)
    
    expect_GET(
      assign("http", mock_response, envir = environment(get_parties)),
      mock_url
    )
    
    expect_error(get_parties(), "HTTP request failed")
  })
})
