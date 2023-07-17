# notasTaq - Parser das notas taquigráficas do Senado Federal.


**AINDA EM FASE DE TESTES !!**

Este pacote faz o download de notas taquigráficas e as transforma em dataframe.
Aqui você encontra notas taquigráficas da CPMI ([ex. de uma Nota taquigráfica desta CPMI](https://www25.senado.leg.br/web/atividade/notas-taquigraficas/-/notas/r/11621) 


O script pega as Notas Taquigráficas e a estrutura em dataframes .Rds e tabelas .csv.
No caso, este script capta dados da CPMI do 8 de Janeiro, mas com ajustes mínimos funcionar também para notas taquigráficas de outros casos (Ele foi usado na CPI da Pandemia e testado com a CPMI do 08 de Janeiro).

Os arquivos de Nota Taquigráfica ficam estruturados da seguinte forma:
  
  - `reuniao`: número da reunião
- `data`:  data da reunião da CPI no formato ano-mês-dia
- `nome`: Nome de quem fala no momento
- `funcao_blocoPar`: Qual a função (se presidente) ou bloco parlamentar, partido e Estado da federação. Esta foi repetida de modo desmembrado nas seguintes colunas:
  - `BlocoParl`: Apenas o bloco parlamentar
  - `partido`: Apenas o partido
  - `estado`: Estado da Federação do parlamentar
- `complemento`: alguns complementos, como "pela ordem", "fora do microfone", "como relator", "Para interpelar Por videoconferência", etc.
- `fala`: texto da fala da pessoa.

# How to use it

func_DB_NT()
