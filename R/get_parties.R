#' get brazilian political parties
#' 
#' @return tibble
#' @export
#' @examples
#' get_parties()
get_parties <- function() {  
    URL <- paste0(baseURL, "composicao/lista/partidos")
    http <- httr::GET(URL)

    partidos <- http$content |> rawToChar() |> jsonlite::fromJSON()  #|> dplyr::bind_rows()

    partidos |> listviewer::jsonedit()

    DF <- partidos$ListaPartidos$Partidos[[1]]  |> tibble::as_tibble() |>
            dplyr::mutate(DataCriacao = as.Date(DataCriacao),
                         DataExtincao = as.Date(DataExtincao))
    DF
}

