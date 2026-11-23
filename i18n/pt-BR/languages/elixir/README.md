---
source: languages/elixir/README.md
source_sha: 3144023070d0ae421e62e6d10c0bd99805ee3625
---
# Elixir

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** funcional e concorrente, de tipagem dinâmica. A equipe do
Elixir descreve a linguagem como "a dynamic, functional language designed for
building scalable and maintainable applications" [1] (tradução livre: "uma
linguagem dinâmica e funcional projetada para construir aplicações escaláveis
e de fácil manutenção"). Ela é executada na máquina virtual do Erlang, e suas
unidades de programa são processos, não objetos nem threads.

Veja também: [paradigmas](../../docs/paradigms.md#functional) (como este
paradigma se compara aos outros) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as demais).

O que estas palavras significam aqui:

- **Funcional:** um programa é construído a partir de funções que recebem
  valores e devolvem novos valores. Os dados do Elixir são imutáveis: uma
  função nunca altera seu argumento. A versão [web](web/) mostra isso: o
  operador pipe `|>` passa uma conexão por uma função após a outra, e cada
  função devolve uma nova conexão.
- **De tipagem dinâmica:** o tipo de um valor é verificado quando o programa
  é executado, não antes. O anúncio da versão 1.0 usa a palavra "dynamic" para
  a linguagem [1].
- **Concorrente:** o guia do Elixir diz que "Processes are isolated from each
  other, run concurrent to one another and communicate via message passing"
  [2] (tradução livre: "Os processos são isolados uns dos outros, executam de
  forma concorrente entre si e se comunicam por troca de mensagens"). Esses
  processos pertencem à máquina virtual do Erlang: "Elixir's processes should
  not be confused with operating system processes" (tradução livre: "Os
  processos do Elixir não devem ser confundidos com processos do sistema
  operacional"), e são "extremely lightweight in terms of memory and CPU" [2]
  (tradução livre: "extremamente leves em termos de memória e CPU"). Um
  servidor web é uma árvore desses processos.

## Implementações
| Categoria | Pasta | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Elixir (`elixir hello.exs`) | ✅ |
| desktop | – | não implementado, veja [Por que não há versão desktop](#por-que-não-há-versão-desktop) | – |
| web | [web/](web/) | projeto Mix, Plug e Bandit do Hex | ✅ |

## Histórico
José Valim criou o Elixir. A página da equipe do Elixir diz: "José Valim
created Elixir in 2012 as a Research and Development project inside
Plataformatec" [3] (tradução livre: "José Valim criou o Elixir em 2012 como
um projeto de Pesquisa e Desenvolvimento dentro da Plataformatec").
Plataformatec era a empresa de Valim: ele escreve "I have pitched Elixir to my
company, Plataformatec" [4] (tradução livre: "Apresentei o Elixir à minha
empresa, a Plataformatec"). A história do código começa antes. O anúncio da
versão 1.0 contabiliza "8005 commits by 189 contributors, including the
initial commit on January 9th, 2011" [1] (tradução livre: "8005 commits de 189
contribuidores, incluindo o commit inicial em 9 de janeiro de 2011").

Valim descreve o começo no anúncio da versão 0.5.0 (2012-05-25). Uma versão
inicial do Elixir "attempted to be a considerable departure from Erlang"
(tradução livre: "tentava ser um afastamento considerável do Erlang"), o que
foi uma má decisão de projeto: para usar qualquer módulo do Erlang, o Elixir
precisaria antes de um wrapper para ele. Depois dessa versão, ele fez uma
pausa "to study old, new and emerging languages" (tradução livre: "para
estudar linguagens antigas, novas e emergentes"). O desafio era "to not
re-invent Erlang as a language, but how to provide the productivity and
flexibility I expect from Elixir while staying a 100% compatible with Erlang"
(tradução livre: "não reinventar o Erlang como linguagem, mas oferecer a
produtividade e a flexibilidade que espero do Elixir sem deixar de ser 100%
compatível com o Erlang"). A base da versão atual veio "around October 2011,
during a short stay in San Francisco" (tradução livre: "por volta de outubro
de 2011, durante uma curta estadia em San Francisco"), com a ajuda de Yehuda
Katz. Valim então apresentou o Elixir à Plataformatec, que "accepted to
sponsor Elixir" [4] (tradução livre: "aceitou patrocinar o Elixir").

A versão 0.5.0 foi "the first release since the language was rewritten" [4]
(tradução livre: "a primeira versão desde que a linguagem foi reescrita"). A
versão 0.6.0 (2012-08-01) acrescentou "a build tool called Mix" [5] (tradução
livre: "uma ferramenta de build chamada Mix"). O anúncio da versão 1.0
(2014-09-18) diz: "We are glad to announce Elixir v1.0 is finally out"
(tradução livre: "Temos o prazer de anunciar que o Elixir v1.0 finalmente
saiu"), e que a versão "is the consolidation of all the work done through the
years" [1] (tradução livre: "é a consolidação de todo o trabalho feito ao
longo dos anos"). Diz também: "Elixir leverages the Erlang VM, known for
running low-latency, distributed and fault-tolerant systems" (tradução livre:
"O Elixir aproveita a VM do Erlang, conhecida por executar sistemas de baixa
latência, distribuídos e tolerantes a falhas"), e "the whole Erlang ecosystem
is also available to Elixir developers" [1] (tradução livre: "todo o
ecossistema do Erlang também está disponível para os desenvolvedores de
Elixir"). A página da equipe do Elixir diz que o Elixir v1.0 foi lançado em
setembro de 2014 e que uma nova versão menor é lançada "every 6 months,
around June and December of every year" [3] (tradução livre: "a cada 6 meses,
por volta de junho e dezembro de cada ano").

**De onde vêm as ideias.** Em uma entrevista, Valim nomeia as fontes: "The
three main ones were Ruby, Erlang, and Clojure." (tradução livre: "As três
principais foram Ruby, Erlang e Clojure."). Do Erlang, o Elixir "inherited the
whole infrastructure" (tradução livre: "herdou toda a infraestrutura"). "With
Clojure, there are a bunch of similar ways we approach problems, like
protocols." (tradução livre: "Com o Clojure, há várias maneiras semelhantes de
abordarmos problemas, como os protocolos."). E "Ruby reflects on the syntax,
the standard libraries, and how we name things" [6] (tradução livre: "O Ruby
se reflete na sintaxe, nas bibliotecas padrão e em como nomeamos as coisas").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 2011-01-09 | Commit inicial do Elixir | [1] |
| 2011-10 | A base da versão atual é concebida (por volta deste mês) | [4] |
| 2012 | Valim cria o Elixir como um projeto de pesquisa e desenvolvimento dentro da Plataformatec | [3] |
| 2012-05-25 | Versão 0.5.0, a primeira versão desde que a linguagem foi reescrita | [4] |
| 2012-08-01 | A versão 0.6.0 inclui a ferramenta de build Mix | [5] |
| 2014-09-18 | Versão 1.0 | [1] |
| 2025-10-16 | Versão 1.19.0 | [7] |
| 2026-06-03 | Versão 1.20.0 | [7] |
| 2026-10-29 | Versão 1.20.5, a usada neste repositório | [7] |

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam todo ano.

- **Stack Overflow Developer Survey 2026:** 2,6% de todos os respondentes da
  pergunta sobre linguagens de programação usaram Elixir (367 de 14.099) [8].
  Na mesma pesquisa, 4,7% dos respondentes querem trabalhar com ela
  ("Desired"), e 62,1% de quem a usou quer continuar usando ("Admired") [8].
- **TIOBE Index, outubro de 2026:** o Elixir não está entre as 50 primeiras. O
  índice o lista apenas pelo nome entre as linguagens "#51 to #100", sem
  posição nem índice de avaliação [9].

Os números medem coisas diferentes. A pesquisa do Stack Overflow conta os
desenvolvedores que a responderam, e o TIOBE conta resultados de mecanismos de
busca. O Elixir tem uma participação pequena nos dois. Na pesquisa, 62,1% de
quem o usou quer continuar usando, enquanto 4,7% de todos os respondentes
querem trabalhar com ele [8].

## Importância antes e agora
- **Antes (2011–2014):** o Elixir oferecia a máquina virtual do Erlang com uma
  nova sintaxe e novas ferramentas. O objetivo do projeto era a
  compatibilidade: "staying a 100% compatible with Erlang" [4] (tradução
  livre: "sem deixar de ser 100% compatível com o Erlang"). O resultado é que
  o Elixir chama bibliotecas do Erlang diretamente. O guia do Elixir diz que
  "Elixir provides excellent interoperability with Erlang libraries" [10]
  (tradução livre: "O Elixir oferece excelente interoperabilidade com
  bibliotecas do Erlang").
- **Agora:** o site do Elixir diz que "Thanks to the Erlang VM, Elixir also
  excels at IoT, distributed systems, and everything Erlang is renowned for"
  [11] (tradução livre: "Graças à VM do Erlang, o Elixir também se destaca em
  IoT, sistemas distribuídos e em tudo aquilo pelo que o Erlang é
  reconhecido"). Uma nova versão menor ainda aparece a cada seis meses, mais
  ou menos [3] (versão 1.20.0 em 2026-06-03 [7]), e a versão 1.20 exige
  Erlang/OTP 27 ou posterior [12].
- **No ensino:** o Elixir é o exemplo deste repositório de uma linguagem
  funcional com o modelo de processos do Erlang. Sua versão [web](web/) mostra
  como um servidor é descrito como uma árvore de processos supervisionados. Ele
  compartilha a máquina virtual com a versão em [Erlang](../erlang/) do mesmo
  programa.

## Comparando as categorias
| | [cli](cli/) | [web](web/) |
|---|---|---|
| Arquivo de projeto | nenhum: um único script `hello.exs` | um projeto Mix: `mix.exs` e `mix.lock`; "Mix is a build tool that ships with Elixir" [13] (tradução livre: "O Mix é uma ferramenta de build que acompanha o Elixir") |
| Arquivos-fonte | `.exs`: "meant for scripting" [14] (tradução livre: "destinado a scripts") | arquivos `.ex`: "meant to be compiled" [14] (tradução livre: "destinados a serem compilados") |
| Bibliotecas | apenas a biblioteca padrão (`IO.puts`) | Plug e Bandit do Hex, o repositório de pacotes da comunidade Erlang e Elixir |
| Executar com | `elixir hello.exs` | `mix run --no-halt` |
| Build | nenhum: o script é "compiled and loaded into memory, but no `.beam` file was written to disk" [14] (tradução livre: "compilado e carregado na memória, mas nenhum arquivo `.beam` foi gravado em disco") | `mix compile` grava arquivos `.beam` em `_build/` [13] |
| Downloads | nenhum | Plug, Bandit e suas dependências, fixadas em `mix.lock` |
| Ponto de entrada | o arquivo é executado de cima para baixo | `HelloWeb.Application.start/2`, indicado em `mix.exs`, inicia um supervisor que inicia o servidor web |
| Saída | `Hello, World!` na saída padrão | `<p>Hello, World!</p>` na resposta a `GET /`, na `PORT` (padrão 8080) |

O que permanece igual: os dois programas são executados na BEAM, a máquina
virtual do Erlang, e os dois são Elixir puro. A versão web apenas acrescenta
um arquivo de projeto, duas bibliotecas e uma árvore de supervisão.

## Por que não há versão desktop
Este repositório não tem versão desktop do Elixir, pelo seguinte motivo: o
Elixir não tem um toolkit GUI desktop próprio em sua biblioteca padrão. A pasta
`lib/` do repositório do Elixir contém seis aplicações (`eex`, `elixir`,
`ex_unit`, `iex`, `logger` e `mix`), e um toolkit GUI não está entre elas [15].
Um programa desktop escrito em Elixir chamaria a aplicação `wx` do Erlang por
meio da interoperabilidade. O Elixir chama um módulo do Erlang escrevendo seu
nome como um átomo, como em `:binary.first("hello")` [10]. A documentação do
Erlang descreve o `wx` como "an erlang binding of wxWidgets" [16] (tradução
livre: "um binding do wxWidgets para Erlang").

É o mesmo toolkit que a versão [desktop em Erlang](../erlang/desktop/) mostra,
com as mesmas chamadas, na sintaxe do Erlang. Uma versão em Elixir mostraria a
mesma janela por meio de outra sintaxe, por isso ela é omitida aqui. O guia do
Elixir desaconselha apenas encapsular bibliotecas do Erlang e recomenda
chamar o código Erlang diretamente [10].

## Fontes
1. Elixir v1.0 released. José Valim, elixir-lang.org, 2014-09-18. <https://elixir-lang.org/blog/2014/09/18/elixir-v1-0-0-released/> (acessado em 2026-11-04)
2. Processes (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/processes.html> (acessado em 2026-11-04)
3. Development & team. The Elixir team, elixir-lang.org. <https://elixir-lang.org/development/> (acessado em 2026-11-04)
4. Elixir v0.5.0 released. José Valim, elixir-lang.org, 2012-05-25. <https://elixir-lang.org/blog/2012/05/25/elixir-v0-5-0-released/> (acessado em 2026-11-04)
5. Elixir v0.6.0 released. José Valim, elixir-lang.org, 2012-08-01. <https://elixir-lang.org/blog/2012/08/01/elixir-v0-6-0-released/> (acessado em 2026-11-04)
6. Elixir is great for everything that runs on top of a socket: José Valim, creator of Elixir (interview by Evrone). HackerNoon, 2020-10-20. <https://hackernoon.com/elixir-is-great-for-everything-that-runs-on-top-of-a-socket-jose-valim-creator-of-elixir-4m2l3zhb> (acessado em 2026-11-04)
7. Releases. elixir-lang/elixir, GitHub. <https://github.com/elixir-lang/elixir/releases> (acessado em 2026-11-04)
8. 2026 Stack Overflow Developer Survey: Technology (data; languages, admired and desired). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-11-04)
9. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-04)
10. Erlang libraries (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/erlang-libraries.html> (acessado em 2026-11-04)
11. Elixir (home page). The Elixir team, elixir-lang.org. <https://elixir-lang.org/> (acessado em 2026-11-04)
12. Install Elixir. The Elixir team, elixir-lang.org. <https://elixir-lang.org/install/> (acessado em 2026-11-04)
13. Introduction to Mix (Mix and OTP). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/introduction-to-mix.html> (acessado em 2026-11-04)
14. Modules and functions (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/1.18.1/modules-and-functions.html> (acessado em 2026-11-04)
15. `lib/` folder of elixir-lang/elixir. GitHub. <https://github.com/elixir-lang/elixir/tree/main/lib> (acessado em 2026-11-04)
16. wx (Erlang/OTP documentation). Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/wx/chapter.html> (acessado em 2026-11-04)
