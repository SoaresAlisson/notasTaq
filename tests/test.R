library(rvest)
library(xml2)

# Notas Taquigráficas das sessões do plenário do Congresso
NotasTaquigraficasSessao <- "https://legis.senado.leg.br/dadosabertos/docs/resource_TaquigrafiaService.html#resource_TaquigrafiaService_obterXmlNotasTaquigraficasSessao_idSessao_GET" |>
  httr::GET()
NotasTaquigraficasSessao$date # data da requisição
NotasTaquigraficasSessao$content |> rawToChar() |> xml2::read_html() |> XML::xmlParse()
NotasTaquigraficasSessao$content |> rawToChar() |> XML::xmlParse()
NotasTaquigraficasSessao |> xml2::read_html() |> xml2::xml_structure()
# write(rawToChar(NotasTaquigraficasSessao$content), file = "NTsessao.html")


NT <- "https://legis.senado.leg.br/dadosabertos/taquigrafia/notas/reuniao/11516" |> xml2::read_xml()
NT |>  xml2::xml_structure()
codigo sequencia tipo descricao inicioEncontro

dadosNT <- function(NTaq, element){
  rvest::html_elements(NTaq, element) %>% rvest::html_text()
}

tibble::tibble(
  nomesComissoes = dadosNT(NT, "nomesComissoes"),
  numeroCom = dadosNT(NT, "numeroCom"),
  siglasComissoes = dadosNT(NT, "siglasComissoes"),
  reuniao_data = dadosNT(NT, "data"),
  reuniao_numero = dadosNT(NT, "numero"),
  # falaCodigo = dadosNT(NT, "codigo"),
  fala_dataInicio =   dadosNT(NT, "dataInicio"),
  fala_dataFim = dadosNT(NT, "dataFim"),
  # fala_sequencia = dadosNT(NT, "sequencia"),
  # fala_etapa = dadosNT(NT, "sequencia"),
  fala_texto = dadosNT(NT, "texto"),
  fala_linkAudio = dadosNT(NT, "linkAudio"),
  #itens
  # codigo = dadosNT(NT, "codigo"),
  # sequencia = dadosNT(NT, "sequencia"),
  tipo = dadosNT(NT, "tipo"),
  codigoOrador = dadosNT(NT, "codigoOrador"),
  nomeOrador = dadosNT(NT, "nomeOrador"),
  papelPalavra = dadosNT(NT, "papelPalavra"),
  inicioEncontro = dadosNT(NT, "inicioEncontro"),
  removerParagrafoInicial = as.logical( dadosNT(NT, "removerParagrafoInicial") ),
  isParagrafoAdicionadoFim = as.logical( dadosNT(NT, "isParagrafoAdicionadoFim")),
  codigoReuniaoComiss = as.integer(dadosNT(NT, "codigoReuniaoComiss")),
  codStatusGrupoItem = as.integer(dadosNT(NT, "codStatusGrupoItem"))
)

tibble::tibble(
  nomesComissoes = dadosNT(NT, "nomesComissoes"),
  numeroCom = as.integer(dadosNT(NT, "numeroCom")),
  siglasComissoes = dadosNT(NT, "siglasComissoes"),
  reuniao_data = as.Date(dadosNT(NT, "data")),
  reuniao_numero = as.integer(dadosNT(NT, "numero")),
  fala_dataInicio =   as.Date(dadosNT(NT, "dataInicio") ),
  fala_dataFim = as.Date(dadosNT(NT, "dataFim")),
  fala_texto = dadosNT(NT, "texto"),
  fala_linkAudio = dadosNT(NT, "linkAudio"),
  codStatusGrupoItem = dadosNT(NT, "codStatusGrupoItem")
) |> str() # View()


tibble::tibble(quartos = rvest::html_elements(NT, "quartos") ) |>
    dplyr::mutate(falaCodigo =  dadosNT("codigo")
)

retirar
