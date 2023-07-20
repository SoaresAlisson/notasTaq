
nomeArqRds <- function(DF, N.arq){
  paste0("/rds/NT_",DF[N.arq,]$reuniao_dia, "-",DF[N.arq,]$Depoente.tema, ".") %>%
    gsub("ª|,", "",.) %>% gsub(" - ", "-", .) %>% gsub(" ", "_",.)
}


arq_existente <- function(DF, N.arq){
  nomearq = paste0(nomeArqRds(N.arq),"Rds")
  testeExisteArq = file.exists(paste0(getwd(),nomearq))

  if (testeExisteArq) {
    message("Arquivo \"", nomearq, "\" já existe.")
  }  else {
    message("Arquivo \"", nomearq, "\" NÃO existe localmente no diretório. Processando...")
    if (is.na(DF[N.arq,]$link_notaTaquigrafica)) {
      message("Ops! Porém não há ainda link disponível para esta nota taquigráfica.")
    } else{
      func_DB_NT(N.arq)
      Sys.sleep(5.5)
    }
  }
}

# Baixar todos os arquivos de uma vez só
#' Download all the links at once
#'
#' To download all the links in the dataframe created with reunions().
#' First, it checks if the file do not exist, than save it. If the file is already
#' available, it jumps to the next line.
#'
#' @examples
#' download_all( DF )
#'
#' @export
download_all <- function(DF){
  purrr::map_dfr(1:length(DF$link_notaTaquigrafica), DF, arq_existente)
}


# Unindo  todos os .rds em um único data.frame/tibble

#' bindAll_TN
#'
#' bind (rbind) / unite all downloades dataframes in the /code/rds folder
#' into a single tibble/dataframe.
#'
#' @export
bindAll_TN <- function(){
  dir <- paste0(getwd(), "/rds/")
  arqs <- list.files(dir, pattern = "NT_", full.names = T)

  # criando o data frame vazio
  NT_todas_df <- data.frame(matrix(ncol=9, nrow=0))

  # iterando e juntando todos os tibbles em um só
  for (file in arqs){
    message(file)
    rdstemp <- readRDS(file)
    NT_todas_df <- rbind(NT_todas_df, rdstemp)
  }

  attr(NT_todas_df, "cod") <- attr(DF, "cod")

  NT_todas_df

}
