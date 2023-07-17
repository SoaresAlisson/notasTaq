# Função que
# faz o parser da nota taquigráfica, o estruturando em um data.frame salvo em rds e csv


func_DB_NT <- function(linha){
  message("Baixando: ", nt.reunioes.df[linha,2],", ", nt.reunioes.df[linha,3] ,"\". Analisando url: \"",nt.reunioes.df[linha,4],"\"")
  url_atual <- nt.reunioes.df[linha,4] %>% as.character()

  # carregando o conteúdo da url numa variável, dentro do R
  NT_html <- url_atual %>% read_html(., encoding = "utf8")

  # texto da pagina
  texto <- NT_html %>% html_nodes('.escriba-jq') %>% html_text()
  alerta <- NT_html %>% html_element('.alert') %>% html_text()
  message("Aviso no arquivo: ", alerta)

  texto_vetores0 = gsub('[0-9]{2}\\:[0-9]{2}  R|\\(Pausa\\.\\)', '', texto) %>%
    gsub('(O SR|A SRA)\\.', 'ZZZVECTOR_\\1\\.', .) %>% strsplit(. , "ZZZVECTOR_") %>% unlist()

  # limpando a linha 1, se ela contiver o indesejável texto abaixo (sempre vem)
  reuniao = texto_vetores0[1] %>% gsub(".* ([0-9]+)ª.*", "\\1",.)
  regex.1linha = "\n\n+.*@import.*Texto com revisão +"

  if (grepl(regex.1linha, texto_vetores0[1])){
    texto_vetores = texto_vetores0[-1]
  } else {
    texto_vetores = texto_vetores0
  }

  ExpReg <- '(O SR|A SRA)\\. ([A-ZÀ-Ÿ \\.]+)(\\(.*?\\)| ?)([-   ––]{3})(.*)'
  vetor_nomes = unlist(str_extract_all(texto_vetores, ExpReg))
  nome = gsub(ExpReg,'\\2', texto_vetores) %>% gsub(' $','',.)
  unique(nome)
  funcao_bloco = gsub(ExpReg,'\\3', texto_vetores)
  fala <- gsub(ExpReg,'\\5', texto_vetores)

  cargo_funcao = gsub(ExpReg,'\\3', texto_vetores)

  estado <- gsub(paste0(".*",siglas.estados,".*"), "\\1",cargo_funcao) %>% unlist
  regex.bloco = paste0(".*([Bb]loco.*[Pp]arlamentar.*)\\/(",TodosPartidos,") - ", siglas.estados, "(.*)")
  BlocoParl <- gsub(regex.bloco,"\\1",cargo_funcao)
  partido1 <- cargo_funcao %>% gsub(".*(\\/|\\. |\\()([A-Z]+) . ([A-Z]{2}).*).*","\\2",.)

  # adicionando NA para a lista preservar seu tamanho
  partido1[lengths(partido1) == 0] <- NA
  # pegando apenas o último elemento da lista
  partido <- sapply(partido1, tail, 1) %>% unlist()

  complemento = gsub(paste0(".*", siglas.estados, "(.*)"),"\\2", funcao_bloco) %>% gsub("\\.|)","",.) %>% str_trim

  NotasTaq_db <- tibble(reuniao, data = nt.reunioes.df$data[linha], Nome = nome, funcao_bloco, BlocoParl, partido, estado,
                        complemento, fala)
  # Trocando nome por nome - função
  regex.nome = "\\((.*?)\\..*"

  # 'Presidente' aparece na coluna 'nome'. vamos colocá-lo na coluna 'funcao_bloco'
  NTDB <- NotasTaq_db %>%
    mutate(nome = ifelse(Nome == "PRESIDENTE", funcao_bloco, Nome), .before = Nome) %>%
    mutate(funcao_blocoPar = ifelse(Nome == "PRESIDENTE", Nome, funcao_bloco), .before = funcao_bloco) %>%
    select(!c(Nome, funcao_bloco)) %>%
    # limpando: pegando apenas o nome na var nome, deixando de fora partido, bloco parlamentar e estado
    mutate(nome =   gsub(regex.nome, "\\1",nome))

  ## Salvando csv rds rdata
  nomearq = paste0("NT_",nt.reunioes.df[linha,]$reuniao_dia, "-",nt.reunioes.df[linha,]$Depoente.tema) %>% gsub("ª|,", "",.) %>% gsub(" - ", "-", .) %>% gsub(" ", "_",.)

  write.csv(NTDB, paste0("csv/", nomearq, ".csv"))
  saveRDS(NTDB, paste0("rds/", nomearq, ".Rds"))
  # save(NTDB, paste0("rdata/","NT_", nomearq, ".Rdata"))
}

