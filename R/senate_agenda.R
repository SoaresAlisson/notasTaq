#' Fetch Senate Committee Agenda for a Given Month
#'
#' @param year_month Numeric in format YYYYMM (e.g., 202412 for December 2024)
#' @return A tibble with the committee agenda data
#' @export
#'
#' @examples
#' \dontrun{
#'   df_agenda <- fetch_senate_agenda(202412)
#' }
senate_agenda <- function(year_month) {
  # Validate input format
  if (!is.numeric(year_month) || nchar(year_month) != 6) {
    stop("year_month must be a 6-digit number in YYYYMM format")
  }
  
  year <- substr(year_month, 1, 4)
  month <- substr(year_month, 5, 6)
  
  # if (!month %in% c("01","02","03","04","05","06","07","08","09","10","11","12")) {
  #   stop("Invalid month in year_month (must be between 01 and 12)")
  # }
  if (!month %in% sprintf("%02d", 1:12)) {
    stop("Invalid month in year_month (must be between 01 and 12)")
  } 
  if (year < 1900 || year > as.numeric(format(Sys.Date(), "%Y")) + 1) {
    stop("Year seems unrealistic (check your year_month value)")
  }
  
  # Build and make request
  url <- paste0("https://legis.senado.leg.br/dadosabertos/comissao/agenda/mes/", 
                year_month, "?v=2")
  
  tryCatch({
    response <- url |> 
      httr2::request() |>
      httr2::req_method("GET") |>
      httr2::req_headers(accept = "application/json") |>
      httr2::req_perform()
    
    # Process response
    body <- response$body |> 
      rawToChar() |> 
      jsonlite::fromJSON()
    
    if (is.null(body$AgendaReuniao$reunioes[[1]])) {
      message("No meetings found for ", year_month)
      return(tibble::tibble())  # Return empty tibble if no data
    }
    
    body$AgendaReuniao$reunioes[[1]] |> 
      tibble::as_tibble()
    
  }, error = function(e) {
    stop("Failed to fetch data: ", e$message)
  })
}

# Example usage:
# df_agenda <- fetch_senate_agenda(202412)
