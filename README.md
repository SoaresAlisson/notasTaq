
<!-- README.md is generated from README.Rmd. Please edit that file -->

# notasTaq - Parser das notas taquigráficas do Senado Federal - EM ELABORAÇÃO

<!-- badges: start -->

**PACOTE AINDA EM FASE DE TESTES !!**

**PACKAGE STILL UNDER DEVELOPMENT**

Este pacote faz o download de notas taquigráficas e as transforma em
dataframe. Aqui você encontra notas taquigráficas da CPMI ([ex. de uma
Nota taquigráfica de uma
CPMI](https://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/11621)
).

O script pega as Notas Taquigráficas e a estrutura em dataframes .Rds e
tabelas .csv. No caso, este script capta dados da CPMI do 8 de Janeiro,
mas com ajustes mínimos funcionar também para notas taquigráficas de
outros casos (Ele foi usado na CPI da Pandemia e testado com a CPMI do
08 de Janeiro).

Os arquivos de Nota Taquigráfica ficam estruturados da seguinte forma:

- `reuniao`: número da reunião
- `data`: data da reunião da CPI no formato ano-mês-dia
- `nome`: Nome de quem fala no momento
- `funcao_blocoPar`: Qual a função (se presidente) ou bloco parlamentar,
  partido e Estado da federação. Esta foi repetida de modo desmembrado
  nas seguintes colunas:
  - `BlocoParl`: Apenas o bloco parlamentar
  - `partido`: Apenas o partido
  - `estado`: Estado da Federação do parlamentar
- `complemento`: alguns complementos, como “pela ordem”, “fora do
  microfone”, “como relator”, “Para interpelar Por videoconferência”,
  etc.
- `fala`: texto da fala da pessoa.

<!-- badges: end -->

The goal of notasTaq is to get all tacquigraphic notes from brazilian
Senate and return a structured tibble/dataframe, so it is possible to
filter according to reunion, name, party, state, etc. It is a further
development of the *ad hoc* script [NotasTaquigraficas - CPI da
Pandemia](https://github.com/SoaresAlisson/NotasTaquigraficas).

## Installation

You can install the development version of notasTaq from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("SoaresAlisson/notasTaq")
```

## Example

### Step 1 - Aquiring all the reunions information

The first step is get a tibble/data.frame with all the reunions. It is
minimally required two parameters to the function `reunions()`: `cod`
and `start`:

1)  `cod`: the code of the comission. To guess the reunion code, look at
    the url and “colcod=CODE_WE_WANT”. For example. given
    “<https://legis.senado.leg.br/comissoes/comissao?codcol=2606&>” our
    code will be “2606”

2)  `start`: the date of the begginning of the comission. Look at
    “Finalidade” / “Instalação” in the senate page

<!-- "https://legis.senado.leg.br/comissoes/comissao?codcol=2606&data1=2023-05-25&data2=2023-08-12" -->

``` r
library(notasTaq)

reunioesDF <- notasTaq::reunions(cod = "2606", start = "2023-05-25")
reunioesDF
#> # A tibble: 12 × 4
#>    data       reuniao_dia Depoente.tema                    link_notaTaquigrafica
#>    <chr>            <int> <chr>                            <chr>                
#>  1 2023-07-11           8 1ª PARTE - Depoimento de Mauro … http://www25.senado.…
#>  2 2023-07-11           8 1ª PARTE - Depoimento de Mauro … http://www25.senado.…
#>  3 2023-07-04           8 Oitiva de Mauro César Barbosa C… <NA>                 
#>  4 2023-06-27           7 1ª PARTE - Oitiva de Jean Lawan… http://www25.senado.…
#>  5 2023-06-26           6 Oitiva de Jorge Eduardo Naime    http://www25.senado.…
#>  6 2023-06-22           5 1ª PARTE - Oitiva de Valdir Pir… http://www25.senado.…
#>  7 2023-06-20           4 1ª PARTE - Oitiva de Silvinei V… http://www25.senado.…
#>  8 2023-06-13           3 Deliberativa                     http://www25.senado.…
#>  9 2023-06-07           3 Deliberativa                     <NA>                 
#> 10 2023-06-06           2 Apresentação e apreciação do pl… http://www25.senado.…
#> 11 2023-06-01           2 Apresentação e apreciação do pl… <NA>                 
#> 12 2023-05-25           1 Instalação e Eleição             http://www25.senado.…
```

Even if you are too lazy to find the code, you can pass the entire url
and it works like a charm.

``` r
notasTaq::reunions("https://legis.senado.leg.br/comissoes/comissao?codcol=2602", start = "2023-02-02")
#> Warning in dir.create(paste0(getwd(), "/", cod, "/csv"), recursive = T, :
#> '/home/alisson/Documentos/Programação/R/notasTaq/2602/csv' já existe
#> # A tibble: 6 × 4
#>   data       reuniao_dia Depoente.tema                     link_notaTaquigrafica
#>   <chr>            <int> <chr>                             <chr>                
#> 1 2023-07-12           2 Audiência Pública Interativa      <NA>                 
#> 2 2023-07-12           2 Audiência Pública Interativa      <NA>                 
#> 3 2023-07-11           2 Audiência Pública Interativa      <NA>                 
#> 4 2023-06-21           1 1ª PARTE - Instalação e Eleição,… <NA>                 
#> 5 2023-06-13           1 Instalação e Eleição              <NA>                 
#> 6 2023-05-30           1 Instalação e Eleição              <NA>
```

Or it is also possible to specify the:

3)  `end`: The end date. If no parameter is given, it uses the actual
    date (from `Sys.Date()`)

``` r
reunioesDF <- notasTaq::reunions(cod = "2606", start = "2023-05-25", end = "2023-08-12")
reunioesDF 
#> # A tibble: 12 × 4
#>    data       reuniao_dia Depoente.tema                    link_notaTaquigrafica
#>    <chr>            <int> <chr>                            <chr>                
#>  1 2023-07-11           8 1ª PARTE - Depoimento de Mauro … http://www25.senado.…
#>  2 2023-07-11           8 1ª PARTE - Depoimento de Mauro … http://www25.senado.…
#>  3 2023-07-04           8 Oitiva de Mauro César Barbosa C… <NA>                 
#>  4 2023-06-27           7 1ª PARTE - Oitiva de Jean Lawan… http://www25.senado.…
#>  5 2023-06-26           6 Oitiva de Jorge Eduardo Naime    http://www25.senado.…
#>  6 2023-06-22           5 1ª PARTE - Oitiva de Valdir Pir… http://www25.senado.…
#>  7 2023-06-20           4 1ª PARTE - Oitiva de Silvinei V… http://www25.senado.…
#>  8 2023-06-13           3 Deliberativa                     http://www25.senado.…
#>  9 2023-06-07           3 Deliberativa                     <NA>                 
#> 10 2023-06-06           2 Apresentação e apreciação do pl… http://www25.senado.…
#> 11 2023-06-01           2 Apresentação e apreciação do pl… <NA>                 
#> 12 2023-05-25           1 Instalação e Eleição             http://www25.senado.…
```

### Step 2a - Downloading one file

Now that we have a dataframe with all the available links, just as an
example, we will download one individual files. We will do it specifying
the first line of the dataframe. (If you already run this function
before, it will return NULL. Try 1) choose another line number, or; 2)
delete the file in /rds folder )

``` r
nt <- parser(reunioesDF, 1)
#> Processando: 8, 1ª PARTE - Depoimento de Mauro Cesar Barbosa Cid, 2ª PARTE - Deliberativa". Analisando url: "http://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/11621"
#> 2606
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

head(nt, 5)
#> # A tibble: 5 × 9
#>   reuniao data  nome  funcao_blocoPar BlocoParl partido estado complemento fala 
#>   <chr>   <chr> <chr> <chr>           <chr>     <chr>   <chr>  <chr>       <chr>
#> 1 8       2023… Arth… PRESIDENTE      (Arthur … UNIÃO   BA     "Fala da P… "Hav…
#> 2 8       2023… MARC… (PL - RO)       (PL - RO) PL      RO     ""          "Sr.…
#> 3 8       2023… Arth… PRESIDENTE      (Arthur … UNIÃO   BA     ""          "Com…
#> 4 8       2023… MARC… (PL - RO)       (PL - RO) PL      RO     ""          "Mar…
#> 5 8       2023… Arth… PRESIDENTE      (Arthur … UNIÃO   BA     ""          "Mar…
```

This functions show the content, as well as save a .rds and a .csv
locally. If you want you can delete all the .csv files, but please let
the rds files until the comission is over, all the transcriptions are
available and you have binded all reunions in a single file. To download
the files is useful if the comission is still going on, and we don’t
want to request/download the same data over and over again. At the end
of the `str()` function, there is an attribute `cod`, that is the code
of the comission, that we passed in `reunion()`. But is also possible to
not save the files and only get the tibble/data.frame, using the
argument `save = FALSE` in `parse()`.

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

## Step 2b - downloading all files at once

Simple like this:

``` r
download_all( reunioesDF )
```

And to bind (rbind) / unite all this into a single tibble/dataframe,
use:

``` r
bindAll_TN(reunioesDF)
```

**…to be continued**

## Related Projects

If you want to get speeches of brazilian deputies, take a look at
<https://github.com/cran/speechbr>.
