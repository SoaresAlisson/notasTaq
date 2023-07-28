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

#' parse the tacquigraphic notes text
#'
#' turns the pure text of the tacquigraphic notes, into
#' an structured tibble/ data.frame, and saves it in .rds and .csv
#' @param DF the dataframe generated with meetings()
#' @param linha number of the line of the dataframe generated with meetings()
#' @param save = FALSE (default). To save the files in .rds and .csv.
#'
#' @examples
#' df <- meetings(cod = "2606", start = "2023-05-25")
#' parser( df, 1 )
#'
#' @export
parser <- function(DF, linha, save = FALSE){

    cod <- attr(DF, "cod")

  message('Processing ',
          "cod:", cod,
          ", meeting: ", DF[linha, 2],
          ', "', DF[linha,3] ,
          "\", from the URL: \"",DF[linha, 4],"\"")

  url_atual <- DF[linha, 'link'] %>% as.character()

  # carregando o conteúdo da url numa variável, dentro do R
  NT_html <- url_atual %>% rvest::read_html(., encoding = "utf8")

  # texto da pagina
  texto <- NT_html %>% rvest::html_nodes('.escriba-jq') %>% rvest::html_text()
  alerta <- NT_html %>% rvest::html_element('.alert') %>% rvest::html_text()

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
  TodosPartidosER <- TodosPartidos %>% paste(collapse = "|") %>% paste0("\\b(", ., ")\\b")

  regex.bloco <- paste0(".*([Bb]loco.*[Pp]arlamentar.*)\\/(",TodosPartidosER,") - ", siglas.estados, "(.*)")
  BlocoParl <- gsub(regex.bloco,"\\1",cargo_funcao)

  complemento <- gsub(paste0(".*", siglas.estados, "(.*)"),"\\2", funcao_bloco) %>% gsub("\\.|)","",.) %>% str_trim

  NotasTaq_db <- tibble::tibble(reuniao, data = DF$data[linha], Nome = nome, funcao_bloco, BlocoParl, complemento, fala)
  # Trocando nome por nome - função
  regex.nome = "\\((.*?)\\..*"

  # 'Presidente' aparece na coluna 'nome'. vamos colocá-lo na coluna 'funcao_bloco'
  NTDB <- NotasTaq_db %>%
    dplyr::mutate(nome = ifelse(Nome == "PRESIDENTE", funcao_bloco, Nome), .before = Nome) %>%
    dplyr::mutate(funcao_blocoPar = ifelse(Nome == "PRESIDENTE", Nome, funcao_bloco), .before = funcao_bloco) %>%
    dplyr::select(!c(Nome, funcao_bloco)) %>%
    # limpando: pegando apenas o nome na var nome, deixando de fora partido, bloco parlamentar e estado
    dplyr::mutate(nome = gsub(regex.nome, "\\1",nome)) %>%
    dplyr::mutate(estado = stringr::str_extract(BlocoParl, siglas.estados ), .after = BlocoParl) %>%
    dplyr::mutate(partido = stringr::str_extract(BlocoParl, TodosPartidosER), .before = estado)


  if (save) {  ## Salvando csv rds rdata
        nomearq = paste0("NT_",DF[linha,]$reuniao_dia, "-", DF[linha,]$Depoente.tema) %>% gsub("ª|,", "",.) %>% gsub(" - ", "-", .) %>% gsub(" ", "_",.)

        dir.create(paste0(getwd(),"/", cod, "/rds"), recursive = T, showWarnings = F)
        dir.create(paste0(getwd(), "/", cod, "/csv"),  recursive = T, showWarnings = F)

        # dir.create(paste0(getwd(),"/", cod, "/rds"), recursive = T, showWarnings = F)
        write.csv(NTDB, paste0( cod, "/csv/", nomearq, ".csv"))
        saveRDS(NTDB, paste0(cod, "/rds/", nomearq, ".Rds"))
        # save(NTDB, paste0("rdata/","NT_", nomearq, ".Rdata"))
  }

  NTDB
}

