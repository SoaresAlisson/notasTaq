#' Get Brazilian political parties in the Senate History
#' 
#' @description
#' get a dataframe with existing and extinguished Brazilian political parties in Senate. 
#' "Obtém a lista dos Partidos Políticos em atividade e/ou extintos no Senado Federal"
#'
#' @return tibble
#' @export
#' @examples
#' get_parties()
get_parties <- function() {  
    URL <- paste0(baseURL, "composicao/lista/partidos")
    http <- httr::GET(URL)

    partidos <- http$content |> rawToChar() |> jsonlite::fromJSON() 

    DF <- partidos$ListaPartidos$Partidos[[1]]  |> 
          tibble::as_tibble() |>
            dplyr::mutate(DataCriacao = as.Date(DataCriacao),
                         DataExtincao = as.Date(DataExtincao))
    DF
}

