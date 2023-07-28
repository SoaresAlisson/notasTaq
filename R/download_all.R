# functions to downloadd all files from a commision

nomeArqRds <- function(DF, N.arq){
  codcol <- attr(DF, "cod")
  paste0("/", codcol,"/rds/NT_",DF[N.arq,]$reuniao_dia, "-",DF[N.arq,]$Depoente.tema, ".") %>%
    gsub("ª|,", "",.) %>% gsub(" - ", "-", .) %>% gsub(" ", "_",.)
}

#' test if the file was downloaded previously
arq_existente <- function(DF, N.arq){
  nomearq = paste0(nomeArqRds(DF, N.arq),"Rds")
  testeExisteArq = file.exists(paste0(getwd(),nomearq))

  if (testeExisteArq) {
    message("File \"", nomearq, "\" already downloaded.")
  }  else {
    message("File \"", nomearq, "\" do NOT exists locally. Processing...")
    if (is.na(DF[N.arq,]$link)) {
      message("Ops! There is no available link to this tacqgraphic note")
    } else{
      # func_DB_NT(N.arq)
      parser(DF, N.arq, save = TRUE)
      Sys.sleep(3.5)
      message("Waiting 3.5 seconds between the requisitions")
    }
  }
}

# Baixar todos os arquivos de uma vez só
#' Download all the links at once
#'
#' To download all the links in the dataframe created with meetings().
#' First, it checks if the file do not exist, than save it. If the file is already
#' available, it jumps to the next line and proceed it again.
#'
#' @examples
#' download_all( DF )
#'
#' @export
download_all <- function(DF){
  for (i in 1:nrow(DF)) {
    arq_existente(DF, i)
  # purrr::map_dfr(1:length(DF$link), DF, arq_existente)
  }
}


# Unindo  todos os .rds em um único data.frame/tibble

#' bindAll_TN
#'
#' bind (rbind) / unite all downloaded dataframes in the /code/rds folder
#' into a single tibble/dataframe.
#'
#' @export
bindAll_TN <- function(cod){
  dir <- paste0(getwd(), "/",cod, "/rds/")
  arqs <- list.files(dir, pattern = "NT_", full.names = T)
  message(arqs)

  # criando o data frame vazio
  NT_todas_df <- data.frame(matrix(ncol = 9, nrow = 0))

  # iterando e juntando todos os tibbles em um só
  for (file in arqs) {
    message(file)
    rdstemp <- readRDS(file)
    NT_todas_df <- rbind(NT_todas_df, rdstemp)
  }

  attr(NT_todas_df, "cod") <- cod

  tibble::tibble(NT_todas_df)

}
