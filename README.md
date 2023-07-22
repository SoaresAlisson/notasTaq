
<!-- README.md is generated from README.Rmd. Please edit that file -->

# notasTaq - Parser das notas taquigráficas do Senado Federal - EM ELABORAÇÃO

<!-- badges: start -->

**PACOTE AINDA EM FASE DE TESTES !!**

**PACKAGE STILL UNDER DEVELOPMENT**

The goal of notasTaq is to get all tacquigraphic notes from brazilian
Senate and return a structured tibble/dataframe, so it is possible to
filter according to reunion, name, party, state, etc. It is a further
development of the *ad hoc* script [NotasTaquigraficas - CPI da
Pandemia](https://github.com/SoaresAlisson/NotasTaquigraficas).

A complete list of all CPIs and CPMIs you can find
[here](https://legis.senado.leg.br/comissoes/pesquisa_comissao?casa=sf,cn&tipo=cpi&sit=func,aguard,encerr).
Note that not all of them, mainly the old ones, does not have the
transcriptions.

<!-- O script pega as Notas Taquigráficas e a estrutura em dataframes .Rds e tabelas .csv. -->
<!-- badges: end -->

## Installation

You can install the development version of notasTaq from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("SoaresAlisson/notasTaq")
```

## Example

### Step 1 - Aquiring all the reunions information

The first step is get a tibble/data.frame with all the reunions wuth the
function`reunions()`. It requires two parameters: `cod` and `start`:

1)  `cod`: the code of the commission. To guess the reunion code, look
    at the url and “codcol=CODE_WE_WANT_TO_USE”. For example. given
    “<https://legis.senado.leg.br/comissoes/comissao?codcol=2606&>” our
    code will be “2606”

2)  `start`: the date of the begginning of the commission. You have to
    look at “Finalidade” / “Instalação” in the Senate page to figure out
    the date of beginning and the final date. It is also possible to get
    this information with the function `get_info()`. See below.

<!-- "https://legis.senado.leg.br/comissoes/comissao?codcol=2606&data1=2023-05-25&data2=2023-08-12" -->

``` r
library(notasTaq)

reunioesDF <- notasTaq::reunions(cod = "2606", start = "2023-05-25")
reunioesDF
#> # A tibble: 12 × 4
#>    data       reuniao_dia Depoente.tema                                    link 
#>    <chr>            <int> <chr>                                            <chr>
#>  1 2023-07-11           8 1ª PARTE - Depoimento de Mauro Cesar Barbosa Ci… http…
#>  2 2023-07-11           8 1ª PARTE - Depoimento de Mauro Cesar Barbosa Ci… http…
#>  3 2023-07-04           8 Oitiva de Mauro César Barbosa Cid                <NA> 
#>  4 2023-06-27           7 1ª PARTE - Oitiva de Jean Lawand Junior, 2ª PAR… http…
#>  5 2023-06-26           6 Oitiva de Jorge Eduardo Naime                    http…
#>  6 2023-06-22           5 1ª PARTE - Oitiva de Valdir Pires Dantas Filho,… http…
#>  7 2023-06-20           4 1ª PARTE - Oitiva de Silvinei Vasques, 2ª PARTE… http…
#>  8 2023-06-13           3 Deliberativa                                     http…
#>  9 2023-06-07           3 Deliberativa                                     <NA> 
#> 10 2023-06-06           2 Apresentação e apreciação do plano de trabalho.  http…
#> 11 2023-06-01           2 Apresentação e apreciação do plano de trabalho.  <NA> 
#> 12 2023-05-25           1 Instalação e Eleição                             http…
```

Even if you are too lazy to find the code, you can pass the entire url
and it works as well.

``` r
notasTaq::reunions("https://legis.senado.leg.br/comissoes/comissao?codcol=2602", start = "2023-02-02")
#> # A tibble: 6 × 4
#>   data       reuniao_dia Depoente.tema                                     link 
#>   <chr>            <int> <chr>                                             <chr>
#> 1 2023-07-12           2 Audiência Pública Interativa                      <NA> 
#> 2 2023-07-12           2 Audiência Pública Interativa                      <NA> 
#> 3 2023-07-11           2 Audiência Pública Interativa                      <NA> 
#> 4 2023-06-21           1 1ª PARTE - Instalação e Eleição, 2ª PARTE - Deli… <NA> 
#> 5 2023-06-13           1 Instalação e Eleição                              <NA> 
#> 6 2023-05-30           1 Instalação e Eleição                              <NA>
```

Or it is also possible to specify the:

3)  `end`: The end date. If no parameter is given, it uses the actual
    date (from `Sys.Date()`)

``` r
reunioesDF <- notasTaq::reunions(cod = "2606", start = "2023-05-25", end = "2023-08-12")
reunioesDF 
#> # A tibble: 12 × 4
#>    data       reuniao_dia Depoente.tema                                    link 
#>    <chr>            <int> <chr>                                            <chr>
#>  1 2023-07-11           8 1ª PARTE - Depoimento de Mauro Cesar Barbosa Ci… http…
#>  2 2023-07-11           8 1ª PARTE - Depoimento de Mauro Cesar Barbosa Ci… http…
#>  3 2023-07-04           8 Oitiva de Mauro César Barbosa Cid                <NA> 
#>  4 2023-06-27           7 1ª PARTE - Oitiva de Jean Lawand Junior, 2ª PAR… http…
#>  5 2023-06-26           6 Oitiva de Jorge Eduardo Naime                    http…
#>  6 2023-06-22           5 1ª PARTE - Oitiva de Valdir Pires Dantas Filho,… http…
#>  7 2023-06-20           4 1ª PARTE - Oitiva de Silvinei Vasques, 2ª PARTE… http…
#>  8 2023-06-13           3 Deliberativa                                     http…
#>  9 2023-06-07           3 Deliberativa                                     <NA> 
#> 10 2023-06-06           2 Apresentação e apreciação do plano de trabalho.  http…
#> 11 2023-06-01           2 Apresentação e apreciação do plano de trabalho.  <NA> 
#> 12 2023-05-25           1 Instalação e Eleição                             http…
```

It is possible to get some info about with the function
`get_info(CODE)`, that returns a list object

``` r
get_info(2102)
#> $codcol
#> [1] 2102
#> 
#> $title
#> [1] "CPIMT"
#> 
#> $description
#> [1] "CPI dos Maus-tratos - 2017"
#> 
#> $finality
#> [1] "Investigar as irregularidades e os crimes relacionados aos maus-tratos em crianças e adolescentes no país."
#> 
#> $start_date
#> [1] "2017-08-09"
```

And it is possible to use it with `reunions()`, like this

``` r
info <- get_info(2102)

reunions(info$codcol, info$start_date)
#> # A tibble: 46 × 4
#>    data       reuniao_dia Depoente.tema                  link                   
#>    <chr>            <int> <chr>                          <chr>                  
#>  1 2018-12-06          29 Apreciação do Relatório Final. http://www25.senado.le…
#>  2 2018-12-06          29 Apreciação do Relatório Final. http://www25.senado.le…
#>  3 2018-08-28          29 Deliberativa                   <NA>                   
#>  4 2018-08-21          29 Deliberativa                   <NA>                   
#>  5 2018-08-14          29 Deliberativa                   <NA>                   
#>  6 2018-07-12          28 Reunião de Trabalho            http://www25.senado.le…
#>  7 2018-07-11          28 Reunião de Trabalho            http://www25.senado.le…
#>  8 2018-07-04          27 Deliberativa                   http://www25.senado.le…
#>  9 2018-06-14          27 Coleta de Depoimentos.         <NA>                   
#> 10 2018-06-14          27 Deliberativa                   <NA>                   
#> # ℹ 36 more rows
```

### Step 2a - Downloading one file

Now that we have a dataframe with all the available links, just as an
example, we will download one individual file. We will do it specifying
the first line of the dataframe. (If you already run this function
before with the option `save = TRUE)`, it will return NULL. Try to 1)
choose another line number, or; 2) delete the file in /rds folder )

``` r
nt <- parser(reunioesDF, 1)
#> Processando: 8, 1ª PARTE - Depoimento de Mauro Cesar Barbosa Cid, 2ª PARTE - Deliberativa". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/11621"
#> Cod col: 2606
str( nt )
#> tibble [1,046 × 9] (S3: tbl_df/tbl/data.frame)
#>  $ reuniao        : chr [1:1046] "8" "8" "8" "8" ...
#>  $ data           : chr [1:1046] "2023-07-11" "2023-07-11" "2023-07-11" "2023-07-11" ...
#>  $ nome           : chr [1:1046] "Arthur Oliveira Maia" "MARCOS ROGÉRIO" "Arthur Oliveira Maia" "MARCOS ROGÉRIO" ...
#>  $ funcao_blocoPar: chr [1:1046] "PRESIDENTE" "(PL - RO)" "PRESIDENTE" "(PL - RO)" ...
#>  $ BlocoParl      : chr [1:1046] "(Arthur Oliveira Maia. UNIÃO - BA. Fala da Presidência.)" "(PL - RO)" "(Arthur Oliveira Maia. UNIÃO - BA)" "(PL - RO)" ...
#>  $ partido        : chr [1:1046] "UNIÃO" "PL" "UNIÃO" "PL" ...
#>  $ estado         : chr [1:1046] "BA" "RO" "BA" "RO" ...
#>  $ complemento    : chr [1:1046] "Fala da Presidência" "" "" "" ...
#>  $ fala           : chr [1:1046] "Havendo número regimental, declaro aberta a 8ª Reunião da Comissão Parlamentar Mista de Inquérito criada pelo R"| __truncated__ "Sr. Presidente... " "Com a palavra, o Senador Rogério. " "Marcos Rogério. " ...
#>  - attr(*, "cod")= chr "2606"

head(nt, 5) # only the first lines
#> # A tibble: 5 × 9
#>   reuniao data  nome  funcao_blocoPar BlocoParl partido estado complemento fala 
#>   <chr>   <chr> <chr> <chr>           <chr>     <chr>   <chr>  <chr>       <chr>
#> 1 8       2023… Arth… PRESIDENTE      (Arthur … UNIÃO   BA     "Fala da P… "Hav…
#> 2 8       2023… MARC… (PL - RO)       (PL - RO) PL      RO     ""          "Sr.…
#> 3 8       2023… Arth… PRESIDENTE      (Arthur … UNIÃO   BA     ""          "Com…
#> 4 8       2023… MARC… (PL - RO)       (PL - RO) PL      RO     ""          "Mar…
#> 5 8       2023… Arth… PRESIDENTE      (Arthur … UNIÃO   BA     ""          "Mar…
```

This function shows the content, If you want to also save a .rds and a
.csv locally, turn the parameter `save = TRUE`. You can delete all the
.csv files, but please let the rds files until the commission is over,
all the transcriptions are available and you have binded all reunions in
a single file. To download the files is useful if the commission is
still going on, and we don’t want to request/download the same data over
and over again. Another advantage to download the files is that this
script uses regular expressions to do the structuration of text into
dataframe, and this implies that minimal changes in text pattern can
cause malfunction of the structuration.

The returned dataframe have the following structure

- `reuniao`: number of reunion
- `data`: date of the reunion in format year-month-day
- `nome`: name of who speaks
- `funcao_blocoPar`: Information as function( if president) or
  parlamentary blocparty and State of the congressman. This column is
  dismembered in the following columns:
  - `BlocoParl`: only the parlamentary bloc
  - `partido`: the party of the politician
  - `estado`: State of federation of the politician
- `complemento`: some complement like such as “in order”, “off the
  microphone”, “as rapporteur”, “To question by videoconference”, etc.
- `fala`: text of the speak

<!-- - `reuniao`: número da reunião -->
<!-- - `data`:  data da reunião da CPI no formato ano-mês-dia -->
<!-- - `nome`: Nome de quem fala no momento -->
<!-- - `funcao_blocoPar`: Qual a função (se presidente) ou bloco parlamentar, partido e Estado da federação. Esta foi repetida de modo desmembrado nas seguintes colunas: -->
<!--   - `BlocoParl`: Apenas o bloco parlamentar -->
<!--   - `partido`: Apenas o partido -->
<!--   - `estado`: Estado da Federação do parlamentar -->
<!-- - `complemento`: alguns complementos, como "pela ordem", "fora do microfone", "como relator", "Para interpelar Por videoconferência", etc. -->
<!-- - `fala`: texto da fala da pessoa. -->

At the end of the `str()` function, there is an attribute `cod`, that is
the code of the commission, that we passed in `reunion()`.
<!-- But is also possible to not save the files and only get the tibble/data.frame, using the argument `save = FALSE` in `parse()`. -->

To construct this data.frame, the script uses the following parties to
extract data and construct the column “partido”. It follows the [TSE
list](https://www.tse.jus.br/partidos/partidos-registrados-no-tse), but
this shows only the actual parties. If there is any party not listed
here, please contact-me (or add it manually yourself into the
“data/partidos.txt”).

``` r
TodosPartidos
#>  [1] "AGIR"          "AVANTE"        "CIDADANIA"     "DC"           
#>  [5] "DEM"           "MDB"           "NOVO"          "PATRIOTA"     
#>  [9] "PC"            "PCB"           "PCO"           "PCdoB"        
#> [13] "PDT"           "PL"            "PMB"           "PMDB"         
#> [17] "PMN"           "PODE"          "PODEMOS"       "PP"           
#> [21] "PPS"           "PROS"          "PRTB"          "PSB"          
#> [25] "PSC"           "PSD"           "PSDB"          "PSL"          
#> [29] "PSOL"          "PSTU"          "PT"            "PTB"          
#> [33] "PTC"           "PV"            "REDE"          "REPUBLICANOS" 
#> [37] "SOLIDARIEDADE" "UNIÃO"         "UP"
```

<!-- ## Step 2b - downloading all files at once -->
<!-- Simple like this: -->
<!-- And to bind (rbind) / unite all this files together into a single tibble/dataframe, use: -->

## Getting all reunions (without downloading)

Use the function `get_all_tn()` to obtain a single tibble/dataframe with
the structured text of all reunions of all days of the commission. In
the example below, we use just a few lines .

``` r
df2606 <- reunioesDF[1:3,] |> get_all_tn()
#> running 1 of 2
#> Processando: 8, 1ª PARTE - Depoimento de Mauro Cesar Barbosa Cid, 2ª PARTE - Deliberativa". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/11621"
#> Cod col: 2606
#> waiting 3 seconds until the next requisition
#> running 2 of 2
#> Processando: 8, 1ª PARTE - Depoimento de Mauro Cesar Barbosa Cid, 2ª PARTE - Deliberativa". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/11621"
#> Cod col: 2606
#> waiting 3 seconds until the next requisition
df2606
#> # A tibble: 2,092 × 9
#>    reuniao data       nome  funcao_blocoPar BlocoParl partido estado complemento
#>    <chr>   <chr>      <chr> <chr>           <chr>     <chr>   <chr>  <chr>      
#>  1 8       2023-07-11 Arth… PRESIDENTE      (Arthur … UNIÃO   BA     "Fala da P…
#>  2 8       2023-07-11 MARC… (PL - RO)       (PL - RO) PL      RO     ""         
#>  3 8       2023-07-11 Arth… PRESIDENTE      (Arthur … UNIÃO   BA     ""         
#>  4 8       2023-07-11 MARC… (PL - RO)       (PL - RO) PL      RO     ""         
#>  5 8       2023-07-11 Arth… PRESIDENTE      (Arthur … UNIÃO   BA     ""         
#>  6 8       2023-07-11 MARC… (PL - RO)       (PL - RO) PL      RO     ""         
#>  7 8       2023-07-11 Arth… PRESIDENTE      (Arthur … UNIÃO   BA     ""         
#>  8 8       2023-07-11 MARC… (PL - RO. Pela… (PL - RO… PL      RO     "Pela orde…
#>  9 8       2023-07-11 Arth… PRESIDENTE      (Arthur … UNIÃO   BA     "Fazendo s…
#> 10 8       2023-07-11 MARC… (PL - RO)       (PL - RO) PL      RO     ""         
#> # ℹ 2,082 more rows
#> # ℹ 1 more variable: fala <chr>
```

From begin to end, if you want to get the full content of [commission
2292 (about Fake
News)](https://legis.senado.leg.br/comissoes/comissao?codcol=2292&data1=2019-08-04&data2=2020-03-20),
you’ll use the following commands:

``` r
info <- get_info(2292)
NT2292 <- reunions(info$codcol, info$start_date) |> get_all_tn()
#> running 1 of 24
#> Processando: 24, Deliberativa". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9686"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 2 of 24
#> Processando: 23, 1ª PARTE - Oitiva, 2ª PARTE - Oitiva, 3ª PARTE - Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9686"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 3 of 24
#> Processando: 22, 1ª PARTE - Oitiva, 2ª PARTE - Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9648"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 4 of 24
#> Processando: 21, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9643"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 5 of 24
#> Processando: 20, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9613"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 6 of 24
#> Processando: 19, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9612"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 7 of 24
#> Processando: 18, Deliberativa". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9572"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 8 of 24
#> Processando: 17, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9512"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 9 of 24
#> Processando: 16, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9511"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 10 of 24
#> Processando: 15, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9472"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 11 of 24
#> Processando: 14, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9471"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 12 of 24
#> Processando: 13, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9413"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 13 of 24
#> Processando: 12, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9412"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 14 of 24
#> Processando: 11, Audiência Pública Interativa". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9379"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 15 of 24
#> Processando: 10, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9333"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 16 of 24
#> Processando: 9, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9320"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 17 of 24
#> Processando: 8, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9319"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 18 of 24
#> Processando: 7, Oitiva". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9314"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 19 of 24
#> Processando: 6, 1ª PARTE - Deliberativa, 2ª PARTE - Eleição". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9282"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 20 of 24
#> Processando: 5, Audiência Pública Interativa". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9253"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 21 of 24
#> Processando: 4, Deliberativa". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9139"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 22 of 24
#> Processando: 3, Deliberativa". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9094"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 23 of 24
#> Processando: 2, Deliberativa". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9046"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition
#> running 24 of 24
#> Processando: 1, Instalação e Eleição". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/9005"
#> Cod col: 2292
#> waiting 3 seconds until the next requisition

str(NT2292)
#> tibble [12,032 × 9] (S3: tbl_df/tbl/data.frame)
#>  $ reuniao        : chr [1:12032] "23" "23" "23" "23" ...
#>  $ data           : chr [1:12032] "2020-03-17" "2020-03-17" "2020-03-17" "2020-03-17" ...
#>  $ nome           : chr [1:12032] "Ricardo Barros" "MARCOS AURÉLIO CARVALHO" "Ricardo Barros" "CAROLINE DE TONI" ...
#>  $ funcao_blocoPar: chr [1:12032] "PRESIDENTE" "(Para depor.)" "PRESIDENTE" "(PSL - SC. Pela ordem.)" ...
#>  $ BlocoParl      : chr [1:12032] "(Ricardo Barros. PP - PR)" "(Para depor.)" "(Ricardo Barros. PP - PR)" "(PSL - SC. Pela ordem.)" ...
#>  $ partido        : chr [1:12032] "PP" NA "PP" "PSL" ...
#>  $ estado         : chr [1:12032] "PR" NA "PR" "SC" ...
#>  $ complemento    : chr [1:12032] "" "(Para depor" "" "Pela ordem" ...
#>  $ fala           : chr [1:12032] "Havendo número regimental, declaro aberta a 23ª Reunião da Comissão Parlamentar Mista de Inquérito, criada pelo"| __truncated__ "Boa tarde a todos. É uma satisfação de verdade estar aqui, Presidente, nessa CPMI, que está prestando um excele"| __truncated__ "Obrigado pela sua disposição de comparecer à CPI.       13:12   R      Aguardando o Relator, que fará os seus q"| __truncated__ "Presidente, antes, eu gostaria de saber se o autor do requerimento vai... O autor do requerimento é o Deputado."| __truncated__ ...
#>  - attr(*, "cod")= num 2292
```

**…to be continued**

## Related Projects

If you want to get speeches of brazilian deputies, take a look at the
package [speechbr](https://github.com/cran/speechbr).
