library(rvest)
library(stringr)
library(dplyr)
library(purrr)


TodosPartidos <- "data/partidos.txt" |> read.table() |> unlist() |> as.vector() |> paste(collapse= "|") %>% paste0("\\b(", ., ")\\b")
siglas.estados <- "\\b(AC|AL|AP|AM|BA|CE|DF|ES|GO|MA|MT|MS|MG|PA|PB|PR|PE|PI|RJ|RN|RS|RO|RR|SC|SP|SE|TO)\\b"



# Criando os subdiretórios necessários
dir.create(paste0(getwd(),"/rds"), showWarnings = F)
dir.create(paste0(getwd(),"/csv"), showWarnings = F)



# nt.reunioes.df <- reunioes(url)


nomeArqRds <- function(N.arq){
  paste0("/rds/NT_",nt.reunioes.df[N.arq,]$reuniao_dia, "-",nt.reunioes.df[N.arq,]$Depoente.tema, ".") %>%
    gsub("ª|,", "",.) %>% gsub(" - ", "-", .) %>% gsub(" ", "_",.)
}



## Checa se arquivo já existe no computador. Se não existir, o baixa.
arq_existente <- function(N.arq){
  nomearq = paste0(nomeArqRds(N.arq),"Rds")
  testeExisteArq = file.exists(paste0(getwd(),nomearq))

  if (testeExisteArq) {
    message("Arquivo \"", nomearq, "\" já existe.")
  }  else {
    message("Arquivo \"", nomearq, "\" NÃO existe localmente no diretório. Processando...")
    if (is.na(nt.reunioes.df[N.arq,]$link_notaTaquigrafica)) {
      message("Ops! Porém não há ainda link disponível para esta nota taquigráfica.")
    } else{
      func_DB_NT(N.arq)
      Sys.sleep(5.5)
    }
  }
}
