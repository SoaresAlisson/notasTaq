#' return a tibble(data.frame) with information about the reunions
#'
#' it read the page of the specified comission and return a tibble with many
#' information, like: date, number of reunion, description, links
#'
# url = "https://legis.senado.leg.br/comissoes/comissao?codcol=2606&data1=2023-05-25&data2=2023-08-12"
#' @param cod The code of the reunion
#' @param start The start date. When the comission was created
#' @param end (optional) The end date. If no parameter is given, it uses the
#' actual date, given by Sys.Date()
#'
#' @examples
#' reunions(cod = "2606", start = "2023-05-25")
#' reunions(cod = "2606", start = "2023-05-25", end ="2023-08-12")
#' reunions("https://legis.senado.leg.br/comissoes/comissao?codcol=2602", start = "2023-02-02")
#'
#' @export
reunions <- function(cod, start, end = Sys.Date() ){
   library(stringr, quietly = T )

    # extract the code if the code provided is not only numbers
  if (!stringr::str_detect(cod, "^\\d+$") ) {
    cod <- stringr::str_replace(cod , ".*codcol=(\\d+).*", "\\1")
  }

  url <- paste0("https://legis.senado.leg.br/comissoes/comissao?codcol=", cod, "&data1=", start, "&data2=", end )

  reunioes <- rvest::read_html(url)

  # data_start <- get_start_date(reunioes)
  # if(exists(data_start)){
  #   message(paste("Sugested begin data: ", as.character(data_start) ))
  # }

  reunioes.vetor <- reunioes %>% rvest::html_elements('.row:nth-child(2) .content .col-md-12')

  datas.vetor <- reunioes.vetor  %>% rvest::html_element('a:nth-child(1) span:nth-child(1)') %>% rvest::html_text() %>%
    grep("^$", .,value=T, invert = T) %>%
    gsub("([0-9]{2})/([0-9]{2})/([0-9]{4})", "\\3-\\2-\\1", .)

  reuniao_dia <-  reunioes.vetor %>% rvest::html_element('span+ span') %>% rvest::html_text()  %>%
    grep("Reunião", .,value = T) %>%
    gsub("([0-9]+).*Reunião.*", "\\1", .) %>% as.integer()

  Depoente.tema <-  reunioes.vetor  %>% rvest::html_element('.f2') %>% rvest::html_text()

  link <- reunioes.vetor  %>% rvest::html_element('.bgc-cpi:nth-child(4) a, .bgc-cpmi:nth-child(4) a') %>% rvest::html_attr('href')

 reunDF <- tibble::tibble(data = datas.vetor,
                          reuniao_dia, Depoente.tema, link)
 # metadata = list(cod = cod)
 attr(reunDF, "cod") <- cod

 reunDF
}

