---
source: languages/lua/README.md
source_sha: edab2f334fb389d0f64ead0edb9d558e319119d9
---
# Lua

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** multiparadigma. O site oficial diz que o Lua "supports several
programming styles: procedural, object-oriented, functional, data-driven,
and data description" [1] (tradução livre: "oferece suporte a vários estilos
de programação: procedural, orientado a objetos, funcional, orientado a dados
e de descrição de dados"). Os programas Hello World deste repositório usam
apenas o estilo procedural (imperativo): as instruções são executadas em
ordem, e a única estrutura de dados que aparece é a tabela, que é a estrutura
de dados única do Lua [2].

Veja também: [paradigmas](../../docs/paradigms.md#every-language-and-its-paradigm)
(como este paradigma se compara aos outros) e
[comparações](../../docs/comparisons.md) (esta linguagem lado a lado com as
demais).

## Implementações
| Categoria | Pasta | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Lua 5.5 | ✅ |
| desktop | [desktop/](desktop/) | LÖVE 11.5 (LuaJIT, dialeto Lua 5.1) | 🔶 |
| web | [web/](web/) | Pegasus, LuaRocks | ✅ |

## Histórico
O Lua nasceu em 1993 no Tecgraf, o Grupo de Tecnologia em Computação Gráfica
da PUC-Rio, a Pontifícia Universidade Católica do Rio de Janeiro, no Brasil.
Seus criadores foram Roberto Ierusalimschy, Luiz Henrique de Figueiredo e
Waldemar Celes [2]. O site oficial nomeia a mesma equipe como projetistas,
implementadores e mantenedores da linguagem desde 1993 [3].

Os autores contam a história no artigo que apresentaram na Terceira
Conferência ACM SIGPLAN sobre a História das Linguagens de Programação
(HOPL III) [2]:

- O Tecgraf trabalhava com a Petrobras, a empresa brasileira de petróleo, em
  front ends gráficos para entrada de dados. O Tecgraf escreveu primeiro uma
  linguagem declarativa de entrada de dados (DEL) para esses programas, e os
  usuários passaram a pedir mais poder.
- Por volta de meados de 1993, os três criadores decidiram projetar uma nova
  linguagem em vez de usar uma existente. O artigo diz que "In 1993, the only
  real contender was Tcl", que "had unfamiliar syntax, did not offer
  good support for data description, and ran only on Unix platforms" [2]
  (tradução livre: "Em 1993, o único concorrente real era o Tcl", que "tinha
  sintaxe pouco familiar, não oferecia bom suporte à descrição de dados e
  executava apenas em plataformas Unix").
- Os autores definem os objetivos como uma linguagem "simple, small,
  portable, fast, and easily embedded into applications" [2] (tradução livre:
  "simples, pequena, portátil, rápida e facilmente embutida em aplicações").

O nome não é uma sigla: "Lua" significa "Moon" (Lua, o satélite da Terra) em
português [4].

Os autores também escreveram que "while almost all programming languages come
from North America and Western Europe (with the notable exception of Ruby,
from Japan), Lua is the only language created in a developing country to
have achieved global relevance" [2] (tradução livre: "embora quase todas as
linguagens de programação venham da América do Norte e da Europa Ocidental
(com a notável exceção do Ruby, do Japão), o Lua é a única linguagem criada
em um país em desenvolvimento que alcançou relevância global").

## Marcos
| Ano | Marco | Fonte |
|---|---|---|
| 1993 | O Lua nasce no Tecgraf, PUC-Rio. | [2] |
| 1994 | Julho: o Lua 1.1, a primeira versão pública, é publicado junto com o primeiro artigo sobre o Lua. | [2] |
| 1995 | Fevereiro: o Lua 2.1 introduz a semântica extensível. | [2] |
| 1996 | Dezembro: a Dr. Dobb's Journal publica um artigo sobre o Lua, que o leva à atenção da indústria de software. | [2] |
| 1997 | Julho: Lua 3.0. | [2] |
| 1998 | Outubro: é lançado o jogo de aventura Grim Fandango, que usa o Lua. | [2] |
| 2000 | Novembro: Lua 4.0. | [2] |
| 2003 | Abril: o Lua 5.0, que tem uma máquina virtual baseada em registradores e corrotinas. | [2] |
| 2006 | 2006-02-21: Lua 5.1. | [5] |
| 2007 | O Lua é apresentado na HOPL III. | [3] |
| 2011 | 2011-12-16: Lua 5.2. | [5] |
| 2015 | 2015-01-12: o Lua 5.3 adiciona inteiros e operadores bit a bit. | [5] |
| 2020 | 2020-06-29: o Lua 5.4 adiciona um modo de coletor de lixo geracional. | [5] |
| 2025 | 2025-12-22: o Lua 5.5 adiciona declarações de variáveis globais. | [5] |

Desde o Lua 5.0, a linguagem é distribuída sob a licença MIT; os autores
tomaram essa decisão em maio de 2002 [2]. Antes disso, a versão 1.1 tinha uma
licença que permitia o uso acadêmico livremente e exigia que usuários
comerciais negociassem [2].

## Uso no mercado hoje
- **Stack Overflow Developer Survey 2026:** o Lua é usado por 9,4% de todos
  os respondentes (1.327 de 14.099; pergunta: em quais linguagens de
  programação, de script e de marcação o respondente fez desenvolvimento
  extensivo no último ano) [6].
- **Índice TIOBE, outubro de 2026:** o Lua ocupa a 35ª posição, com uma
  avaliação de 0,44% [7]. O TIOBE afirma que seu índice "is not about the best
  programming language or the language in which most lines of code have
  been written" [7] (tradução livre: "não trata da melhor linguagem de
  programação nem da linguagem em que mais linhas de código foram escritas").

As duas fontes medem coisas diferentes: uma pesquisa conta os
desenvolvedores que a respondem, e um índice calcula uma avaliação para cada
linguagem. O Lua não está entre as 20 primeiras do índice TIOBE, mas é usado
por uma parcela maior dos respondentes da pesquisa do que o Swift (5,9%) ou o
Ruby (5,8%) na mesma pesquisa [6].

O site oficial cita World of Warcraft e Angry Birds como jogos que usam o
Lua, o Adobe Photoshop Lightroom como aplicação industrial e o middleware
Ginga, da televisão digital no Brasil, como aplicação embarcada [1].

## Importância antes e agora
**Antes.** O Lua começou como uma linguagem interna para dois projetos do
Tecgraf [2]. Suas metas de projeto, uma linguagem simples e pequena e uma
implementação simples, pequena, rápida, portátil e livre, a tornaram própria
para ser embutida em outros programas, e os autores atribuem a elas o sucesso
da linguagem [2]. O jogo Grim Fandango (1998) foi um dos primeiros usos de
grande visibilidade em jogos [2].

**Agora.** O site oficial chama o Lua de "the leading scripting language in
games" (tradução livre: "a principal linguagem de script em jogos") e o
descreve como portátil, embutível e pequeno: o código-fonte do Lua 5.5.1 tem
cerca de 32000 linhas de C [1]. Seu uso principal continua sendo a
incorporação em outro programa, que então oferece o Lua como linguagem de
script ou de configuração. O Lua 5.5, a versão atual, continua a série
iniciada em 1993 [5]. O LuaJIT, uma implementação independente da linguagem,
é "fully upwards-compatible with Lua 5.1" [8] (tradução livre:
"totalmente compatível com o Lua 5.1, para versões posteriores"); a
implementação [desktop](desktop/README.md) é executada sobre ele.

## Comparando as categorias
| Aspecto | cli | desktop | web |
|---|---|---|---|
| Ponto de entrada | `hello.lua`, executado pelo programa `lua` | `main.lua`, executado pelo LÖVE | `app.lua`, executado pelo programa `lua` |
| Bibliotecas | nenhuma: `print` é nativo | LÖVE (`love.graphics`), que embute a linguagem | Pegasus, LuaSocket e outras, instaladas pelo LuaRocks |
| Versão da linguagem | Lua 5.5 | dialeto Lua 5.1 (LuaJIT) | Lua 5.5 |
| Quem controla o laço principal | ninguém: o programa executa uma vez | LÖVE: chama `love.load`, `love.update` e `love.draw` | Pegasus: `server:start` executa um laço bloqueante e chama o seu tratador a cada requisição |
| Etapa de build | nenhuma | nenhuma | nenhuma (o LuaRocks compila os módulos em C das dependências durante o `install.sh`) |
| Como é executado | `./run.sh` imprime e termina | `./run.sh` abre uma janela | `./run.sh` atende na porta 8080 até Ctrl+C |

A linguagem em si é a mesma nas três. O que muda é quem tem o controle. No
[cli](cli/README.md), o programa começa, imprime e termina. Na versão
[web](web/README.md), uma biblioteca aguarda requisições e chama uma função
fornecida pelo programa. Na versão [desktop](desktop/README.md), um framework
cria a janela e chama três funções fornecidas pelo programa. Nas duas últimas
categorias, o Lua é a linguagem que o programa hospedeiro embute e conduz,
que é o uso para o qual seus autores a projetaram [2].

**O compromisso.** A versão desktop executa o dialeto Lua 5.1 porque o LÖVE
embute o LuaJIT, e não a implementação de referência. O código do Hello World
é o mesmo nos dois dialetos. Os detalhes estão no
[README do desktop](desktop/README.md#what-this-is).

## Fontes
1. Lua: about. Lua.org, PUC-Rio. <https://www.lua.org/about.html> (acessado em 2026-11-04)
2. The Evolution of Lua. Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes. Proceedings of the Third ACM SIGPLAN History of Programming Languages Conference (HOPL III), 2007. <https://www.lua.org/doc/hopl.pdf> (acessado em 2026-11-04)
3. Lua: authors. Lua.org, PUC-Rio. <https://www.lua.org/authors.html> (acessado em 2026-11-04)
4. Lua: about, section "What's in a name?". Lua.org, PUC-Rio. <https://www.lua.org/about.html> (acessado em 2026-11-04)
5. Lua: version history. Lua.org, PUC-Rio. <https://www.lua.org/versions.html> (acessado em 2026-11-04)
6. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-20)
7. TIOBE Index for October 2026. TIOBE Software BV. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-04)
8. LuaJIT Extensions. Mike Pall. <https://luajit.org/extensions.html> (acessado em 2026-11-04)
