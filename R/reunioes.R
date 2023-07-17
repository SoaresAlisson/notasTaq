# lendo a página html com todas as reuniões e retorna um tibble

reunioes <- function(url){
  reunioes <- read_html(url)
  # estruturando
  reunioes.vetor <- reunioes %>% html_elements('.row:nth-child(2) .content .col-md-12')

  datas.vetor <- reunioes.vetor  %>% html_element('a:nth-child(1) span:nth-child(1)') %>% html_text() %>%
    grep("^$", .,value=T, invert = T) %>%
    gsub("([0-9]{2})/([0-9]{2})/([0-9]{4})", "\\3-\\2-\\1",.)
  reuniao_dia <-  reunioes.vetor %>% html_element('span+ span') %>% html_text()  %>%
    grep("Reunião", .,value = T) %>%
    gsub("([0-9]+).*Reunião.*", "\\1", .) %>% as.integer()
  Depoente.tema <-  reunioes.vetor  %>% html_element('.f2') %>% html_text()

  link_notaTaquigrafica <- reunioes.vetor  %>% html_element('.bgc-cpmi:nth-child(4) a, .bgc-cpmi:nth-child(4) a') %>% html_attr('href') # ver cpi/cpmi

  tibble(data = datas.vetor, reuniao_dia, Depoente.tema, link_notaTaquigrafica)
}


