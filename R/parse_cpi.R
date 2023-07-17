library(rvest)
library(stringr)
library(dplyr)
library(purrr)


TodosPartidos <- "data/partidos.txt" |> read.table() |> unlist() |> as.vector() |> paste(collapse= "|") %>% paste0("\\b(", ., ")\\b")
siglas.estados <- "\\b(AC|AL|AP|AM|BA|CE|DF|ES|GO|MA|MT|MS|MG|PA|PB|PR|PE|PI|RJ|RN|RS|RO|RR|SC|SP|SE|TO)\\b"



# Criando os subdiretórios necessários
dir.create(paste0(getwd(),"/rds"), showWarnings = F)
dir.create(paste0(getwd(),"/csv"), showWarnings = F)



nt.reunioes.df <- reunioes(url)


nomeArqRds <- function(N.arq){
  paste0("/rds/NT_",nt.reunioes.df[N.arq,]$reuniao_dia, "-",nt.reunioes.df[N.arq,]$Depoente.tema, ".") %>%
    gsub("ª|,", "",.) %>% gsub(" - ", "-", .) %>% gsub(" ", "_",.)
}



