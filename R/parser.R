#' Parser de notas taquigráficas do Senado
#'

#' All brazilian parties
#'
#' The names of parties used to extract the data of the column "partido"
#' Estes nomes serão usados para construir a coluna "partido"
#'
#' @examples
#' TodosPartidos
#'
#' @export
TodosPartidos <- "data/partidos.txt" |> read.table() |> unlist() |> unique() |> as.vector()


siglas.estados <- "\\b(AC|AL|AP|AM|BA|CE|DF|ES|GO|MA|MT|MS|MG|PA|PB|PR|PE|PI|RJ|RN|RS|RO|RR|SC|SP|SE|TO)\\b"

#' parses the tacquigraphic notes
#'
#' turns the pure text of the tacquigraphic notes, into
#' an structured tibble/ data.frame, and saves it in .rds and .csv
#' @param DF the dataframe generated with reunions()
#' @param linha number of the line of the dataframe generated with reunions()
#' @param save = TRUE (default). To save the files in .rds and .csv.
#'
#' @examples
#' df <- reunions(cod = "2606", start = "2023-05-25")
#' parser( df, 1 )
#'
#' @export
parser <- function(DF, linha, save = T){
  library(rvest, quietly = T)
  library(dplyr, quietly = T)
  library(stringr, quietly = T)

  nt.reunioes.df <- DF

  message("Processando: ", nt.reunioes.df[linha,2],", ", nt.reunioes.df[linha,3] ,"\". Analisando url: \"",nt.reunioes.df[linha,4],"\"")
  url_atual <- nt.reunioes.df[linha,"link_notaTaquigrafica"] %>% as.character()

  # carregando o conteúdo da url numa variável, dentro do R
  NT_html <- url_atual %>% read_html(., encoding = "utf8")

  # texto da pagina
  texto <- NT_html %>% html_nodes('.escriba-jq') %>% html_text()
  alerta <- NT_html %>% html_element('.alert') %>% html_text()
  # message("Aviso no arquivo: ", alerta)

  texto_vetores0 = gsub('[0-9]{2}\\:[0-9]{2}  R|\\(Pausa\\.\\)', '', texto) %>%
    gsub('(O SR|A SRA)\\.', 'ZZZVECTOR_\\1\\.', .) %>% strsplit(. , "ZZZVECTOR_") %>% unlist()

  # limpando a linha 1, se ela contiver o indesejável texto abaixo (sempre vem)
  reuniao <- texto_vetores0[1] %>% gsub(".* ([0-9]+)ª.*", "\\1",.)
  regex.1linha <- "\n\n+.*@import.*Texto com revisão +"

  if (grepl(regex.1linha, texto_vetores0[1])){
    texto_vetores = texto_vetores0[-1]
  } else {
    texto_vetores = texto_vetores0
  }

  ExpReg <- '(O SR|A SRA)\\. ([A-ZÀ-Ÿ \\.]+)(\\(.*?\\)| ?)([-   ––]{3})(.*)'
  vetor_nomes <- unlist(str_extract_all(texto_vetores, ExpReg))
  nome <- gsub(ExpReg,'\\2', texto_vetores) %>% gsub(' $','',.)
  # unique(nome)
  funcao_bloco = gsub(ExpReg,'\\3', texto_vetores)
  fala <- gsub(ExpReg,'\\5', texto_vetores)

  cargo_funcao = gsub(ExpReg,'\\3', texto_vetores)

  # regex com todos os partidos
  TodosPartidosER <- TodosPartidos |> paste(collapse = "|") %>% paste0("\\b(", ., ")\\b")

  regex.bloco <- paste0(".*([Bb]loco.*[Pp]arlamentar.*)\\/(",TodosPartidosER,") - ", siglas.estados, "(.*)")
  BlocoParl <- gsub(regex.bloco,"\\1",cargo_funcao)

  complemento <- gsub(paste0(".*", siglas.estados, "(.*)"),"\\2", funcao_bloco) %>% gsub("\\.|)","",.) %>% str_trim

  NotasTaq_db <- tibble(reuniao, data = nt.reunioes.df$data[linha], Nome = nome, funcao_bloco, BlocoParl, complemento, fala)
  # Trocando nome por nome - função
  regex.nome = "\\((.*?)\\..*"

  # 'Presidente' aparece na coluna 'nome'. vamos colocá-lo na coluna 'funcao_bloco'
  NTDB <- NotasTaq_db %>%
    mutate(nome = ifelse(Nome == "PRESIDENTE", funcao_bloco, Nome), .before = Nome) %>%
    mutate(funcao_blocoPar = ifelse(Nome == "PRESIDENTE", Nome, funcao_bloco), .before = funcao_bloco) %>%
    select(!c(Nome, funcao_bloco)) %>%
    # limpando: pegando apenas o nome na var nome, deixando de fora partido, bloco parlamentar e estado
    mutate(nome = gsub(regex.nome, "\\1",nome)) |>
    mutate(estado = str_extract(BlocoParl, siglas.estados ), .after = BlocoParl) |>
    mutate(partido = str_extract(BlocoParl, TodosPartidosER), .before = estado)

  # message(str(DF) )
  attr(NTDB, "cod") <- attr(DF, "cod")
  cod <- attr(DF, "cod")
  message( cod )

  if (save) {  ## Salvando csv rds rdata
    nomearq = paste0("NT_",nt.reunioes.df[linha,]$reuniao_dia, "-", nt.reunioes.df[linha,]$Depoente.tema) %>% gsub("ª|,", "",.) %>% gsub(" - ", "-", .) %>% gsub(" ", "_",.)

    # dir.create(paste0(getwd(),"/", cod, "/rds"), recursive = T, showWarnings = F)
    write.csv(NTDB, paste0( cod, "/csv/", nomearq, ".csv"))
    saveRDS(NTDB, paste0(cod, "/rds/", nomearq, ".Rds"))
    # save(NTDB, paste0("rdata/","NT_", nomearq, ".Rdata"))
  }

  NTDB
}

