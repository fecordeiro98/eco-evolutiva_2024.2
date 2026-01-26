# Script para a analise dos dados do questionario de ecologia evolutiva
# Felipe Cordeiro, Felipe Fernandes, Jaderson Coriolano, Juliana Barbosa
# 07 de janeiro de 2025
# Versao 4

# Introducao --------------------------------------------------------------

## Diretorio de trabalho ----
setwd('./Ecologia evolutiva')

## Bibliotecas ----
if(!require('ggplot2')) {
  install.packages('ggplot2')
}
if(!require('dplyr')) {
  install.packages('dplyr')
}
if(!require('scales')) {
  install.packages('scales')
}
if(!require('readr')) {
  install.packages('readr')
}

## Importacao dos dados ----
dados <- read.csv('./Resultados_Reduzido.csv', sep = ';')

### Escolaridade - Religiao ----
grupo <- select(dados, Escolaridade, Religiao_1, Religiao_2, Religiao_3, Religiao_4, Religiao_5)

### Dados de escolaridade ----
escolaridade <- grupo |>
  count(Escolaridade) |>
  mutate(
    Porcentagem = n / sum(n) * 100
  )

## Criacao do grafico ----
ggplot(escolaridade, aes(Escolaridade, Porcentagem)) +
  geom_col(fill = c('darkred', 'orange', 'darkgreen', 'darkblue')) +
  geom_text(aes(
    Escolaridade, Porcentagem,
    label = paste0(n, " (", round(Porcentagem, 1), '%)'),
    vjust = -0.5
  )) +
  theme_bw() +
  labs(title = 'Escolaridade')

### Salvando o grafico ----
ggsave(
  './gráficos/escolaridade.png',
  height = 9,
  width = 16,
  dpi = 300,
  scale = 0.75
)

# Perguntas ---------------------------------------------------------------

## Criacao da funcao para fazer a contagem das respostas por pergunta ----
perguntas <- function(coluna, numero) {
  temp1 <- grupo |> 
    filter({{coluna}} %in% c('Sim', 'Nao'))
  temp2 <- temp1 |>
    count({{coluna}}) |>
    mutate(Porcentagem = n / sum(n) * 100)
  gráfico <- ggplot(temp2, aes({{coluna}}, Porcentagem)) +
    geom_col(fill = c('darkred', 'darkblue')) +
    geom_text(aes(
      {{coluna}}, Porcentagem,
      label = paste0(n, ' (', round(Porcentagem), '%)'),
      vjust = -0.5
    )) +
    theme_bw() +
    labs(
      x = 'Respostas',
      y = 'Porcentagem',
      title = paste('Pergunta', numero, 'sobre religião')
    )
  ggsave(
    paste0('./gráficos/religiao', numero, '.png'),
    height = 9,
    width = 16,
    dpi = 300,
    scale = 0.75
  )
}

### Execucao da funcao ----
perguntas(Religiao_1, 1)
perguntas(Religiao_2, 2)
perguntas(Religiao_3, 3)
perguntas(Religiao_4, 4)

## Criacao do grafico 5 ----
religiao5 <- grupo |>
  count(Religiao_5) |>
  mutate(Porcentagem = n / sum(n) * 100)
gr5 <- ggplot(religiao5, aes(Religiao_5, Porcentagem)) +
  geom_col(fill = c('darkred', 'orange', 'darkblue')) +
  geom_text(aes(
    Religiao_5, Porcentagem,
    label = paste0(n, ' (', round(Porcentagem, 1), '%)'),
    vjust = -0.5
  )) +
  theme_bw() +
  labs(
    title = 'Pergunta 5 sobre religião',
    x = 'Resposta'
  )
ggsave(
  './gráficos/religiao5.png',
  plot = gr5,
  height = 9,
  width = 16,
  dpi = 300,
  scale = 0.75
)

# Religiao x Escolaridade -------------------------------------------------

## Criacao da funcao de repeticao ----
graficos <- function(coluna, numero) {
  temp <- grupo |>
    filter({{coluna}} %in% c('Sim', 'Nao'))
  ggplot(temp, aes({{coluna}}, fill = {{coluna}})) +
    geom_bar(show.legend = FALSE) +
    scale_fill_manual(values = c('darkred', 'darkblue')) +
    labs(
      x = 'Resposta',
      y = 'Número de entrevistados',
      title = paste('Religião', numero, 'x Escolaridade')
    ) +
    facet_grid(cols = vars(Escolaridade)) +
    theme_bw()
  ggsave(
    paste0('./gráficos/rel-esc', numero, '.png'),
    height = 9,
    width = 16,
    dpi = 300,
    scale = 0.75
  )
}

### Chamada da funcao ----
graficos(Religiao_1, 1)
graficos(Religiao_2, 2)
graficos(Religiao_3, 3)
graficos(Religiao_4, 4)

## Grafico 5 ----
ggplot(grupo, aes(Religiao_5, fill = Religiao_5)) +
  geom_bar(show.legend = FALSE) +
  scale_fill_manual(values = c('darkred', 'gold', 'darkblue')) +
  labs(
    x = 'Resposta',
    y = 'Número de entrevistados',
    title = 'Religião 5 x Escolaridade'
  ) +
  facet_grid(cols = vars(Escolaridade)) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))
ggsave(
  './gráficos/rel-esc5.png',
  height = 9,
  width = 16,
  dpi = 300,
  scale = 0.75
)

# Tabelas -----------------------------------------------------------------

## Criacao da funcao ----
tabelas <- function(coluna, numero) {
  filtro <- grupo |> filter({{coluna}} %in% c('Sim', 'Nao'))
  tabela <- table(filtro[,{{numero}}], filtro$Escolaridade)
  (prop.table(tabela, 2) * 100) |> print()
  chisq.test(tabela)
}

### Execucao da funcao ----
tabelas(Religiao_1, 2)
tabelas(Religiao_2, 3)
tabelas(Religiao_3, 4)
tabelas(Religiao_4, 5)

## Tabela 5 ----
t5 <- table(grupo$Religiao_5, grupo$Escolaridade)
prop.table(t5, 2) * 100
chisq.test(t5)

# H0 = Nao ha relacao entre escolaridade e religiao
# H1 = Ha relacao entre escolaridade e religiao

# Se P < 0.05, a escolaridade afeta a religiao
# Se P > 0.05, a escolaridade nao afeta a religiao
