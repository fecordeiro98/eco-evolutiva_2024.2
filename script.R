# Script para a análise dos dados do questionário de ecologia evolutiva
# Felipe Cordeiro, Felipe Fernandes, Jaderson Coriolano, Juliana Barbosa
# 07 de janeiro de 2025
# Versão 4

# Introdução --------------------------------------------------------------

#### Diretório de trabalho ####
setwd('./Ecologia evolutiva')

#### Bibliotecas ####
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

#### Importação dos dados ####
dados <- read.csv('./Resultados_Reduzido.csv', sep = ';')

##### Escolaridade - Religião #####
grupo <- select(dados, Escolaridade, Religiao_1, Religiao_2, Religiao_3, Religiao_4, Religiao_5)

##### Dados de escolaridade #####
escolaridade <- grupo |>
  count(Escolaridade) |>
  mutate(
    Porcentagem = n / sum(n) * 100
  )

#### Criação do gráfico ####
ggplot(escolaridade, aes(Escolaridade, Porcentagem)) +
  geom_col(fill = c('darkred', 'orange', 'darkgreen', 'darkblue')) +
  geom_text(aes(
    Escolaridade, Porcentagem,
    label = paste0(n, " (", round(Porcentagem, 1), '%)'),
    vjust = -0.5
  )) +
  theme_bw() +
  labs(title = 'Escolaridade')

##### Salvando o gráfico #####
ggsave(
  './gráficos/escolaridade.png',
  height = 9,
  width = 16,
  dpi = 300,
  scale = 0.75
)

# Perguntas ---------------------------------------------------------------

#### Criação da função para fazer a contagem das respostas por pergunta ####
perguntas <- function(coluna, número) {
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
      title = paste('Pergunta', {{número}}, 'sobre religião')
    )
  ggsave(
    paste0('./gráficos/religiao', {{número}}, '.png'),
    height = 9,
    width = 16,
    dpi = 300,
    scale = 0.75
  )
}

##### Execução da função #####
perguntas(Religiao_1, 1)
perguntas(Religiao_2, 2)
perguntas(Religiao_3, 3)
perguntas(Religiao_4, 4)

#### Criação do gráfico 5 ####
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

# Religião x Escolaridade -------------------------------------------------

#### Criação da função de repetição ####
gráficos <- function(coluna, número) {
  temp <- grupo |>
    filter({{coluna}} %in% c('Sim', 'Nao'))
  ggplot(temp, aes({{coluna}}, fill = {{coluna}})) +
    geom_bar(show.legend = FALSE) +
    scale_fill_manual(values = c('darkred', 'darkblue')) +
    labs(
      x = 'Resposta',
      y = 'Número de entrevistados',
      title = paste('Religião', {{número}}, 'x Escolaridade')
    ) +
    facet_grid(cols = vars(Escolaridade)) +
    theme_bw()
  ggsave(
    paste0('./gráficos/rel-esc', {{número}}, '.png'),
    height = 9,
    width = 16,
    dpi = 300,
    scale = 0.75
  )
}

##### Chamada da função #####
gráficos(Religiao_1, 1)
gráficos(Religiao_2, 2)
gráficos(Religiao_3, 3)
gráficos(Religiao_4, 4)

#### Gráfico 5 ####
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

#### Criação da função ####
tabelas <- function(coluna, número) {
  filtro <- grupo |> filter({{coluna}} %in% c('Sim', 'Nao'))
  tabela <- table(filtro[,{{número}}], filtro$Escolaridade)
  (prop.table(tabela, 2) * 100) |> print()
  chisq.test(tabela)
}

##### Execução da função #####
tabelas(Religiao_1, 2)
tabelas(Religiao_2, 3)
tabelas(Religiao_3, 4)
tabelas(Religiao_4, 5)

#### Tabela 5 ####
t5 <- table(grupo$Religiao_5, grupo$Escolaridade)
prop.table(t5, 2) * 100
chisq.test(t5)

# H0 = Não há relação entre escolaridade e religião
# H1 = Há relação entre escolaridade e religião

# Se P < 0.05, a escolaridade afeta a religião
# Se P > 0.05, a escolaridade não afeta a religião
