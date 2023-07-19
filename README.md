
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
Senate a return it in a tibble/dataframe, structured so it is possible
to filter according to reunion, name, party, state, etc. It is a further
development from the script of the [CPI da
Pandemia](https://github.com/SoaresAlisson/NotasTaquigraficas).

## Installation

You can install the development version of notasTaq from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("SoaresAlisson/notasTaq")
```

## Example

### Step 1

The first step is get a tibble/data.frame with all the reunions. It is
minimally required two parameters to the function `reunions()`: `cod`
and `start`: 1) `cod`: the code of the comission. To guess the reunion
code, look at the url and “colcod=CODE_WE_WANT”. For example. given
“<https://legis.senado.leg.br/comissoes/comissao?codcol=2606&>” our code
will be “2606”

2)  `start`: the date of the begginning of the comission. Look at
    “Finalidade” / “Instalação”

And optionally, you can use also: 3) `end`: The end date, If no
parameter is given, it uses the actual date

<!-- "https://legis.senado.leg.br/comissoes/comissao?codcol=2606&data1=2023-05-25&data2=2023-08-12" -->

``` r
library(notasTaq)

reunioesDF <- notasTaq::reunions(cod = "2606", start = "2023-05-25")
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
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

Or it possible also to specify the end date

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

### Step 2
