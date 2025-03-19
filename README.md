# Descrição do Script de Análise de Questionário de Ecologia Evolutiva

Este script em R analisa dados de um questionário sobre ecologia evolutiva, focando na relação entre escolaridade e crenças religiosas. Ele gera gráficos e tabelas para visualização e análise estatística.

## Autores e Versão

* Felipe Cordeiro
* Felipe Fernandes
* Jaderson Coriolano
* Juliana Barbosa

Versão 4 - 07 de janeiro de 2025

## Estrutura do Script

O script está organizado em seções, cada uma com uma tarefa específica:

1. **Introdução:** Configura o ambiente (diretório de trabalho com `setwd()`), carrega bibliotecas necessárias (ggplot2, dplyr, scales, readr) e importa os dados de `Resultados_Reduzido.csv`.

2. **Escolaridade:** Calcula e plota a distribuição da escolaridade, mostrando a porcentagem de cada nível. Salva o gráfico como `escolaridade.png`.

3. **Perguntas sobre Religião (1-4):** Usa a função `perguntas()` para gerar gráficos de barras para cada pergunta (1 a 4).  A pergunta 5 é tratada separadamente.

4. **Pergunta 5 sobre Religião:** Similar às perguntas 1-4, mas com múltiplas opções de resposta. Gera um gráfico de barras e o salva como `religiao5.png`.

5. **Religião x Escolaridade:** Usa a função `graficos()` para gerar gráficos mostrando a relação entre as respostas de religião (1-4) e a escolaridade, criando gráficos separados por nível de escolaridade.  A pergunta 5 é tratada separadamente.

6. **Religião 5 x Escolaridade:** Cria um gráfico similar para a pergunta 5, mostrando a distribuição das respostas por escolaridade.

7. **Tabelas de Contingência e Teste Qui-Quadrado:** Usa a função `tabelas()` para criar tabelas de contingência entre religião (1-4) e escolaridade e realiza o teste qui-quadrado para verificar associação estatística. A pergunta 5 é tratada separadamente.

## Funções Personalizadas

O script define três funções para automatizar tarefas repetitivas:

* **`perguntas(coluna, número)`:**  Recebe o nome da coluna (ex: `Religiao_1`) e o número da pergunta. Filtra as respostas "Sim" e "Não", calcula a porcentagem de cada uma e gera um gráfico de barras, salvando-o como `religiao[número].png`.

* **`graficos(coluna, número)`:**  Similar à `perguntas()`, mas gera gráficos mostrando a relação entre a pergunta de religião e a escolaridade, criando gráficos separados para cada nível de escolaridade. Salva os gráficos como `rel-esc[número].png`.

* **`tabelas(coluna, número)`:** Cria uma tabela de contingência entre a pergunta de religião e a escolaridade, calcula a tabela de proporções e realiza o teste qui-quadrado, imprimindo os resultados.

## Hipóteses do Teste Qui-Quadrado

* **H0 (Hipótese nula):** Não há relação entre escolaridade e religião.
* **H1 (Hipótese alternativa):** Há relação entre escolaridade e religião.

A interpretação do valor-p (p) é:

* **p < 0.05:** Rejeita-se H0 (escolaridade afeta religião).
* **p > 0.05:** Não se rejeita H0 (escolaridade não afeta religião).

## Observações

O script usa `ggplot2` para gráficos, `dplyr` para manipulação de dados e `scales` para formatação.  A função `setwd()` define o diretório de trabalho.  O script assume que o arquivo de dados tem colunas específicas ("Escolaridade", "Religiao_1", etc.) e que as respostas para as perguntas 1-4 são "Sim" ou "Não". A  função `ggsave()` é usada para salvar todos os gráficos, com parâmetros consistentes de tamanho e resolução.

Texto gerado por inteligência artificial
