#' get_info
#'
#' returns a list with some info about the commission, like title, description
#' date of installation (start_date)
#'
#' @param cod the number of the code of the commission
#'
#' @examples
#' get_info(2292)
#'
#' @export
get_info <- function(cod){

  URL_base <- c("https://legis.senado.leg.br/atividade/comissoes/comissao/", 
    "https://legis.senado.leg.br/comissoes/comissao?codcol=")[2]

  page <- paste0(URL_base, cod)  |> 
    rvest::read_html()

  title <- page |> rvest::html_elements(".white") |> rvest::html_text2( )

  description <- page |> 
    rvest::html_elements(".color-cpi, .color-cpmi, .color-mpv") |> 
    rvest::html_text2()

  finalidadeVec <- page |> rvest::html_elements("p:contains('Finalidade')") |> 
    rvest::html_text2() |> strsplit("\\n") |> unlist()

  indicefinalidade <- which(grepl("Finalidade", finalidadeVec, ignore.case=T))

  finalidade <- finalidadeVec[indicefinalidade + 1]

  start_date <- grep("instala", finalidadeVec,  ignore.case = TRUE, value = TRUE) |>  stringr::str_extract_all("[\\d\\/]+") |>  unlist() |> as.Date(format =  "%d/%m/%Y")

  list(codcol = cod,
       title =  title,
       description = description,
       finality = finalidade,
       start_date = start_date
  )
}
