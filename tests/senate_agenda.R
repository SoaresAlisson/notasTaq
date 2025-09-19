library(testthat)
library(httr2)
library(jsonlite)
library(tibble)

# Mock the API response to avoid hitting the real API during testing
mock_api_response <- function() {
  list(
    AgendaReuniao = list(
      reunioes = list(
        data.frame(
          data = "2024-12-01",
          hora = "10:00",
          descricao = "Test Meeting",
          local = "Test Location",
          comissao = "Test Commission",
          stringsAsFactors = FALSE
        )
      )
    )
  )
}

# Mock the httr2 request chain
with_mock_api <- function(expr) {
  mockery::stub(expr, "httr2::req_perform", function(req) {
    response <- list(
      body = charToRaw(toJSON(mock_api_response())),
      status_code = 200
    )
    class(response) <- "httr2_response"
    response
  })
}

test_that("fetch_senate_agenda works correctly", {
  # Test with valid input
  with_mock_api({
    result <- fetch_senate_agenda(202412)
  })
  
  expect_s3_class(result, "tbl_df")
  expect_named(result, c("data", "hora", "descricao", "local", "comissao"))
  expect_equal(nrow(result), 1)
})

test_that("input validation works", {
  # Test invalid month format
  expect_error(fetch_senate_agenda(202413), "Invalid month")
  expect_error(fetch_senate_agenda(202400), "Invalid month")
  
  # Test invalid year format
  expect_error(fetch_senate_agenda(2412), "6-digit number")
  expect_error(fetch_senate_agenda("202412"), "6-digit number")
  
  # Test unrealistic years
  expect_error(fetch_senate_agenda(189912), "unrealistic")
  future_year <- as.numeric(format(Sys.Date(), "%Y")) + 2
  expect_error(fetch_senate_agenda(paste0(future_year, "12")), "unrealistic")
})

test_that("empty response handling works", {
  # Mock empty response
  mock_empty <- function() {
    list(AgendaReuniao = list(reunioes = list(NULL)))
  }
  
  with_mock(
    `jsonlite::fromJSON` = function(...) mock_empty(),
    {
      result <- fetch_senate_agenda(202411)
    }
  )
  
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("API error handling works", {
  # Mock failed request
  mock_error <- function(req) {
    stop("API unavailable")
  }
  
  with_mock(
    `httr2::req_perform` = mock_error,
    expect_error(fetch_senate_agenda(202412), "Failed to fetch data")
  )
})

test_that("month validation works with all valid months", {
  valid_months <- sprintf("%02d", 1:12)
  
  for (month in valid_months) {
    year_month <- as.numeric(paste0("2024", month))
    with_mock_api({
      expect_silent(fetch_senate_agenda(year_month))
    })
  }
})
