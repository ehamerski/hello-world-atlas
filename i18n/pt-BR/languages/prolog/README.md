---
source: languages/prolog/README.md
source_sha: 55f50b69637de551533f943b9bd00c52a1463a3a
---
# Prolog

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** programação lógica. Um programa em Prolog é um conjunto de
fatos e regras (cláusulas de Horn). Executá-lo significa fazer uma
pergunta, uma *consulta* (*query*), que o sistema tenta provar a partir
dessas cláusulas. Kowalski descreveu a ideia em 1974: "An axiomatisation of
a problem domain is a program for solving problems in that domain.
Individual problems are posed as theorems to be proved" [1] (tradução
livre: "Uma axiomatização de um domínio de problemas é um programa para
resolver problemas nesse domínio. Os problemas individuais são colocados
como teoremas a serem provados").

Ver também: [paradigmas](../../docs/paradigms.md#logic) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

Em uma linguagem **imperativa** (C, Python, Fortran), o programa é uma
lista de comandos: faça isto, depois faça aquilo. Um programa lógico
**declarativo** diz, em vez disso, *o que é verdadeiro*, e o sistema
descobre *como* encontrar uma resposta. Kowalski resumiu assim: "Algorithm
= Logic + Control" (tradução livre: "Algoritmo = Lógica + Controle"); o
componente lógico "specifies the knowledge to be used in solving problems"
(tradução livre: "especifica o conhecimento a ser usado para resolver
problemas"), e o componente de controle "determines the problem-solving
strategies by means of which that knowledge is used" [2] (tradução livre:
"determina as estratégias de resolução de problemas por meio das quais esse
conhecimento é usado").

Três palavras explicam como o Prolog prova uma consulta. O manual do
SWI-Prolog as define [3]:

- Uma **cláusula** (*clause*) é uma cabeça e um corpo unidos por `:-`, lido
  como "se". Um **fato** (*fact*) é uma "Clause without a body" (tradução
  livre: "Cláusula sem corpo"), de modo que não há "no condition to be
  satisfied" (tradução livre: "nenhuma condição a ser satisfeita").
- **Unificar** (*to unify*) é "make two terms equal by assigning variables
  in one term to values at the corresponding location of the other term"
  (tradução livre: "tornar dois termos iguais, atribuindo a variáveis de um
  termo os valores da posição correspondente do outro termo"). "Unlike
  assignment (which does not exist in Prolog), unification is not
  directed." (tradução livre: "Ao contrário da atribuição, que não existe
  em Prolog, a unificação não tem direção.")
- **Retrocesso** (*backtracking*): "If a predicate offers multiple clauses
  to solve a goal, they are tried one-by-one until one succeeds." (tradução
  livre: "Se um predicado oferece várias cláusulas para resolver um
  objetivo, elas são tentadas uma a uma até que uma tenha sucesso.")

Esse método de prova é a resolução SLD: o Prolog trabalha com cláusulas de
Horn usando "SLD-resolution (Kowalski, 1974) based on Robinson's principle
(1965) and Kowalski's procedural semantics (Kowalski, 1974) as the basic
execution mechanism" [5] (tradução livre: "resolução SLD (Kowalski, 1974),
baseada no princípio de Robinson (1965) e na semântica procedural de
Kowalski (Kowalski, 1974) como mecanismo básico de execução"). A própria
linguagem é padronizada como ISO/IEC 13211-1:1995 [4].

O Hello World é uma única regra: `main :- format("Hello, World!~n").` Lida
como lógica, ela diz que "`main` é verdadeiro se `format(...)` for
verdadeiro". Quando o Prolog prova `main`, precisa provar o corpo, e provar
`format/1` tem um efeito colateral: ele vai "Write formatted output to
Output or current_output" [22] (tradução livre: "Escrever saída formatada em
Output ou em current_output"). O programa é "provado" apenas para obter
esse efeito colateral. Nada nele é um fato a ser consultado, mas o
mecanismo é o mesmo usado em programas lógicos reais.

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | SWI-Prolog | ✅ |
| desktop | – | não implementada, ver [Por que não há versão desktop](#por-que-não-há-versão-desktop) | – |
| web | [web/](web/) | bibliotecas HTTP do SWI-Prolog | ✅ |

## História
O Prolog nasceu em Marselha, de trabalhos sobre linguagem natural. Alain
Colmerauer "was seeking to automate human-machine conversation" (tradução
livre: "buscava automatizar a conversação entre humanos e máquinas"), e seu
objetivo de escrever "a complete question-answering system" (tradução livre:
"um sistema completo de perguntas e respostas") em lógica "inspired him,
amongst others, to create Prolog" [5] (tradução livre: "inspirou-o, entre
outras coisas, a criar o Prolog"). Ele convidou Robert Kowalski, então na
Universidade de Edimburgo [1], a visitar Marselha "in the summer of 1971"
[5] (tradução livre: "no verão de 1971").
"Colmerauer and Kowalski's collaboration led in 1972 to a discovery
analogous, for programs, to that made previously for grammars" (tradução
livre: "A colaboração entre Colmerauer e Kowalski levou, em 1972, a uma
descoberta análoga, para programas, à feita anteriormente para
gramáticas"): um certo estilo de cláusulas permite que um provador de
teoremas "behave as a computational procedure for executing computer
programs" [5] (tradução livre: "se comporte como um procedimento
computacional para executar programas de computador").

"The first system ("Prolog 0") was written in Algol-W by Roussel in 1972"
[5] (tradução livre: "O primeiro sistema ("Prolog 0") foi escrito em
Algol-W por Roussel em 1972"). Uma segunda implementação, "Prolog I",
seguiu-se "at the end of 1973 by Battani, Meloni, and Bazzoli, in Fortran"
(tradução livre: "no final de 1973, por Battani, Meloni e Bazzoli, em
Fortran"), e "already had the same operational semantics and most of the
built-ins that later became part of the ISO standard" [5] (tradução livre:
"já tinha a mesma semântica operacional e a maioria dos predicados nativos
que mais tarde passaram a fazer parte do padrão ISO"). Em 1974, Kowalski,
na Universidade de Edimburgo, publicou "Predicate Logic as Programming
Language", que defendia que "predicate logic is a useful and practical,
high-level, non-deterministic programming language with sound theoretical
foundations" [1] (tradução livre: "a lógica de predicados é uma linguagem de
programação útil e prática, de alto nível, não determinística, com
fundamentos teóricos sólidos").

Edimburgo tornou o Prolog rápido. David H.D. Warren visitou Marselha em
1974, levou o Prolog para um DEC-10 em Edimburgo e escreveu "the first
compiler from Prolog to machine code" (tradução livre: "o primeiro
compilador de Prolog para código de máquina"), com velocidade "rivaling that
of Lisp systems" [5] (tradução livre: "que rivalizava com a dos sistemas
Lisp"). O DEC-10 Prolog se espalhou pelos departamentos de IA "from about
1976 onward" (tradução livre: "a partir de cerca de 1976"). Sua sintaxe,
conhecida como "Edinburgh syntax" (sintaxe de Edimburgo), e muitos de seus
recursos "constitute a fundamental component of the current Prolog ISO
standard" [5] (tradução livre: "constituem um componente fundamental do
atual padrão ISO do Prolog"). Em 1983, Warren descreveu uma máquina
abstrata que "became widely known as the Warren Abstract Machine, the WAM"
(tradução livre: "ficou amplamente conhecida como Máquina Abstrata de
Warren, a WAM"), e "the WAM became the standard blueprint for Prolog
compilers and continues to be today" [5] (tradução livre: "a WAM tornou-se o
modelo padrão para compiladores de Prolog e continua sendo até hoje").

Em 1982, o Ministério do Comércio Internacional e da Indústria do Japão deu
início à iniciativa Fifth Generation Computer Systems (FGCS), para "build
large parallel computers and apply them in artificial intelligence tasks,
with logic programming as the basis, and in particular Prolog" [5]
(tradução livre: "construir grandes computadores paralelos e aplicá-los a
tarefas de inteligência artificial, tendo a programação lógica como base e,
em particular, o Prolog"). Sua linguagem central afastou-se mais tarde do
retrocesso do Prolog (KL1) [5].

O trabalho sobre um padrão "started in 1984 and was organized formally in
1987" [5] (tradução livre: "começou em 1984 e foi organizado formalmente em
1987"). A norma ISO/IEC 13211-1, *Prolog, Part 1: General core*, foi
publicada em 1995-06-01 [4]. Ela "solidified the Edinburgh/Quintus de-facto
standard" [5] (tradução livre: "consolidou o padrão de fato Edimburgo/
Quintus").

O SWI-Prolog, o sistema usado neste repositório, foi escrito por Jan
Wielemaker. O manual afirma que ele "started back in 1986 with the
requirement for a Prolog that could handle recursive interaction with the
C-language" [6] (tradução livre: "começou em 1986, com a exigência de um
Prolog capaz de lidar com interação recursiva com a linguagem C"); a página
inicial afirma "Since its start in 1987" [7] (tradução livre: "Desde seu
início, em 1987"). Ele "took form in the SWI department at the University of
Amsterdam" [8] (tradução livre: "tomou forma no departamento SWI da
Universidade de Amsterdã").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1971 (verão) | Kowalski visita Colmerauer em Marselha | [5] |
| 1972 | Prolog 0, escrito em Algol-W por Philippe Roussel em Marselha | [5] |
| 1973 (final) | Prolog I, em Fortran (Battani, Meloni, Bazzoli) | [5] |
| 1974 | Kowalski, "Predicate Logic as Programming Language" (IFIP 74) | [1] |
| 1975 | Compilador DEC-10 Prolog em Edimburgo (Warren): "the first compiler from Prolog to machine code" (o primeiro compilador de Prolog para código de máquina) | [5] |
| 1979-07 | Kowalski, "Algorithm = Logic + Control" (*Communications of the ACM*) | [2] |
| 1982 | O Japão inicia a iniciativa Fifth Generation Computer Systems (FGCS) | [5] |
| 1983 | Máquina Abstrata de Warren (WAM) | [5] |
| 1986 / 1987 | Início do SWI-Prolog (manual: 1986; página inicial: 1987) | [6][7] |
| 1987 | Esquema de Programação em Lógica com Restrições (CLP), Jaffar e Lassez | [5] |
| 1995-06-01 | ISO/IEC 13211-1:1995, Prolog Parte 1: Núcleo geral | [4] |
| 2011-02 | O Watson, da IBM, vence o *Jeopardy!*; suas regras de análise de perguntas são escritas em Prolog | [12] |
| 2025-06-04 | ISO/IEC TS 13211-3:2025: regras de gramática de cláusulas definidas | [13] |
| 2025-12-03 | SWI-Prolog 10.0.0: ferramentas GUI baseadas em SDL3 em Linux, macOS e Windows | [14][15] |

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam todos os anos.

- **Índice TIOBE, outubro de 2026:** o Prolog ocupa a posição 31, com
  avaliação de 0,49% [9].
- **Stack Overflow Developer Survey 2026:** 0,9% de todos os respondentes
  da pergunta sobre linguagens de programação usaram Prolog (129 de
  14.099) [10].
- **Stack Overflow Developer Survey 2025:** 1,1% de todos os respondentes
  usaram Prolog. Entre as pessoas em "Learning to Code" (aprendendo a
  programar), a parcela foi de 3%, contra 0,8% entre os "Professional
  Developers" (desenvolvedores profissionais) [11].

Os números medem coisas diferentes: o TIOBE conta resultados de mecanismos
de busca, e a pesquisa do Stack Overflow conta os desenvolvedores que a
responderam. Ambos mostram uma linguagem pequena. A pesquisa de 2025
mostra também que o Prolog é mais usado por quem está aprendendo do que
por profissionais [11], o que combina com seu lugar no ensino.

## Importância antes e agora
- **Antes (1972–década de 1990):** o Prolog foi "first conceived" (tradução
  livre: "concebido inicialmente") para o processamento de linguagem
  natural [5] e mudou o que um programa podia ser: a programação lógica
  levou a computação de um "mostly imperative paradigm into the new, unique
  paradigm of inferential engines" [5] (tradução livre: "paradigma
  predominantemente imperativo para o novo e singular paradigma dos
  motores de inferência"). Foi a base escolhida do projeto FGCS do Japão
  [5], e a WAM ainda é "the standard blueprint for Prolog compilers" [5]
  (tradução livre: "o modelo padrão para compiladores de Prolog").
- **Ideias que se espalharam:** o Datalog, "a subset of Prolog" (tradução
  livre: "um subconjunto do Prolog"), "plays an important role in the
  research field of deductive databases" (tradução livre: "desempenha um
  papel importante na área de pesquisa de bancos de dados dedutivos") e
  encontrou usos em "program analysis", "security" e "natural language
  processing" [5] (tradução livre: "análise de programas", "segurança" e
  "processamento de linguagem natural"). A Programação em Lógica com
  Restrições substituiu "the unification procedure in the resolution steps
  by a more general process for solving constraints over specific domains"
  [5] (tradução livre: "o procedimento de unificação nos passos de
  resolução por um processo mais geral de resolução de restrições sobre
  domínios específicos").
- **Agora:** o Watson, da IBM, que venceu o *Jeopardy!* em fevereiro de
  2011, usou Prolog para "detection rules that match patterns in the parse"
  (tradução livre: "regras de detecção que casam padrões na análise
  sintática") de uma pergunta. Seus autores escreveram: "We found that
  Prolog was the ideal choice for the language due to its simplicity and
  expressiveness" [12] (tradução livre: "Constatamos que o Prolog era a
  escolha ideal de linguagem devido à sua simplicidade e expressividade").
  A ISO continua ampliando o padrão (regras DCG, 2025 [13]), e o foco do
  SWI-Prolog inclui "multi-threaded programming, implementations of
  communication network protocols such as HTTP" [5] (tradução livre:
  "programação multithread, implementações de protocolos de rede de
  comunicação como o HTTP").
- **No ensino:** "SWI-Prolog is traditionally strong in education because
  it is free and portable" [23] (tradução livre: "O SWI-Prolog é
  tradicionalmente forte na educação por ser gratuito e portável"). O
  Prolog é a única linguagem lógica neste repositório e mostra uma forma de
  programar em que se descrevem fatos e regras e se deixa o sistema buscar
  a resposta.

## Comparação entre as categorias
| | [`cli`](cli/) | [`web`](web/) |
|---|---|---|
| Ponto de entrada | `:- initialization(main, main).` e depois `main :- format("Hello, World!~n").` | `:- initialization(main, main).`; `main` inicia o servidor HTTP |
| Iniciado com | `swipl hello.pl` | `swipl` sobre o arquivo do servidor (porta vinda de `PORT`, padrão 8080) |
| Bibliotecas carregadas | nenhuma | `library(http/thread_httpd)`, `library(http/http_dispatch)` |
| Como `/` é respondido | – | um `http_handler` associa `/` a um predicado que envia `<p>Hello, World!</p>` |
| Quem controla o laço | ninguém: `main` tem sucesso e o Prolog encerra | as threads do servidor; `main` espera indefinidamente em vez de retornar |
| Saída | texto na saída padrão (stdout) | HTML na resposta HTTP |
| Downloads extras | nenhum | nenhum: as bibliotecas HTTP acompanham o SWI-Prolog [17] |

O que permanece igual: ambas são executadas pelo mesmo programa `swipl`,
sem etapa de compilação, e ambas usam `initialization(main, main)`. Com
essa diretiva, "the last goal registered using `initialization(Goal, main)`
is executed as main goal" (tradução livre: "o último objetivo registrado
com `initialization(Goal, main)` é executado como objetivo principal"), e,
quando ele termina, o toplevel "is set to `halt/0`, causing the process to
exit with status 0" [16] (tradução livre: "é configurado como `halt/0`, o
que faz o processo terminar com status 0"). Esse é o comportamento de que a
versão CLI precisa. A versão web não pode terminar, de modo que seu `main`
inicia o servidor e depois bloqueia.

O lado do servidor vem das próprias bibliotecas do SWI-Prolog: `thread_httpd`
"is responsible for accepting and managing connections" (tradução livre: "é
responsável por aceitar e gerenciar conexões"), e `http_dispatch`
"associates the path of the HTTP request with a handler" [17] (tradução
livre: "associa o caminho da requisição HTTP a um tratador"). O servidor é
multithread; os autores do SWI-Prolog escrevem que "Multi-threading was
initially introduced to support scalable web servers in Prolog" [8]
(tradução livre: "O multithreading foi introduzido inicialmente para
oferecer suporte a servidores web escaláveis em Prolog"). Compare com o
[PHP](../php/README.md), cujo servidor embutido não exige nenhum código de
servidor, e com o [Go](../go/README.md), que também escreve o servidor em
código com sua biblioteca padrão.

## Por que não há versão desktop
Este repositório não tem versão desktop do Prolog: uma categoria só é
mantida se existir, em todos os sistemas operacionais de destino, uma
toolchain mantida, de uso corrente e razoavelmente simples. O SWI-Prolog
tem, sim, um toolkit de GUI, o XPCE, de modo que o motivo é a toolchain que
este repositório instala, e não a ausência de um toolkit:

- **O XPCE existe e é mantido.** "XPCE is a toolkit for developing
  graphical applications in Prolog" [18] (tradução livre: "O XPCE é um
  toolkit para desenvolver aplicações gráficas em Prolog"). Seu repositório
  o descreve como "The graphics toolkit for SWI-Prolog" (tradução livre: "O
  toolkit gráfico do SWI-Prolog"), e seu README diz "Current versions use
  SDL3 and Cairo for the graphics and run on Linux, macOS and Windows" [19]
  (tradução livre: "As versões atuais usam SDL3 e Cairo para os gráficos e
  funcionam em Linux, macOS e Windows").
- **Nativo no macOS apenas desde dezembro de 2025.** No macOS, "For
  versions up to 9.3.25, XQuartz" (um servidor X11) era exigido [20]
  (tradução livre: "Para versões até a 9.3.25, o XQuartz"). O SWI-Prolog
  10.0, marcado em 2025-12-03 [15], é a primeira versão estável com
  "Native GUI tools for Linux (Wayland or X11), MacOS (Cocoa) and Windows
  (Win32) based on SDL3" [14] (tradução livre: "Ferramentas de GUI nativas
  para Linux (Wayland ou X11), MacOS (Cocoa) e Windows (Win32) baseadas em
  SDL3").
- **O pacote do Homebrew não tem GUI.** Este repositório instala o
  SWI-Prolog com o Homebrew, um gerenciador de pacotes consolidado
  ([Sobre as fontes](../../docs/sources.md#4-security-of-installers)). A
  fórmula do Homebrew o compila com `-DSWIPL_PACKAGES_GUI=OFF` [21], de
  modo que `brew install swi-prolog` não fornece o XPCE. Obter o XPCE no
  macOS significa usar a imagem de disco oficial [14] ou compilar a partir
  do código-fonte com as bibliotecas adicionais "sdl3 sdl3_image cairo
  pango" [20].

Assim, um Hello World desktop em Prolog exigiria uma segunda instalação do
SWI-Prolog ao lado da instalação do Homebrew usada por [`cli`](cli/) e
[`web`](web/), para um toolkit de GUI que só funciona nativamente nos três
sistemas operacionais desde dezembro de 2025.

## Fontes
1. Predicate Logic as Programming Language. Robert Kowalski, Information Processing 74 (IFIP Congress), North-Holland, 1974. <https://www.doc.ic.ac.uk/~rak/papers/IFIP%2074.pdf> (acessado em 2026-11-01)
2. Algorithm = Logic + Control. Robert Kowalski, Communications of the ACM, July 1979. <https://www.doc.ic.ac.uk/~rak/papers/algorithm%20=%20logic%20+%20control.pdf> (acessado em 2026-11-01)
3. SWI-Prolog Reference Manual: Glossary of Terms. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=glossary> (acessado em 2026-11-01)
4. ISO/IEC 13211-1:1995, Information technology - Programming languages - Prolog - Part 1: General core (catalog page). IEC Webstore (ISO/IEC JTC 1/SC 22). <https://webstore.iec.ch/publication/9731> (acessado em 2026-11-01)
5. Fifty Years of Prolog and Beyond. Philipp Körner, Michael Leuschel, João Barbosa, Vítor Santos Costa, Verónica Dahl, Manuel V. Hermenegildo, Jose F. Morales, Jan Wielemaker, Daniel Diaz, Salvador Abreu, Giovanni Ciatto. Theory and Practice of Logic Programming, 2022 (arXiv:2201.10816). <https://arxiv.org/abs/2201.10816> (acessado em 2026-11-01)
6. SWI-Prolog Reference Manual: 1.5 Implementation history. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=implhistory> (acessado em 2026-11-01)
7. SWI-Prolog (home page). SWI-Prolog. <https://www.swi-prolog.org/> (acessado em 2026-11-01)
8. SWI-Prolog. Jan Wielemaker, Tom Schrijvers, Markus Triska, Torbjörn Lager. Theory and Practice of Logic Programming, 2012 (arXiv:1011.5332). <https://arxiv.org/abs/1011.5332> (acessado em 2026-11-01)
9. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-01)
10. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-01)
11. 2025 Stack Overflow Developer Survey: Technology. Stack Overflow. <https://survey.stackoverflow.co/2025/technology> (acessado em 2026-11-01)
12. Natural Language Processing With Prolog in the IBM Watson System. Adam Lally (IBM Thomas J. Watson Research Center) and Paul Fodor (Stony Brook University). Association for Logic Programming, 2011-03-31. <https://logicprogramming.org/2011/03/natural-language-processing-with-prolog-in-the-ibm-watson-system> (acessado em 2026-11-01)
13. ISO/IEC TS 13211-3:2025, Programming languages - Prolog - Part 3: Definite clause grammar rules (catalog page). IEC Webstore. <https://webstore.iec.ch/en/publication/107758> (acessado em 2026-11-01)
14. Download SWI-Prolog stable versions (SWI-Prolog 10.0 highlights). SWI-Prolog. <https://www.swi-prolog.org/download/stable> (acessado em 2026-11-01)
15. Release V10.0.0. SWI-Prolog/swipl, GitHub. <https://github.com/SWI-Prolog/swipl/releases/tag/V10.0.0> (acessado em 2026-11-01)
16. SWI-Prolog Reference Manual: initialization/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/doc_for?object=initialization/2> (acessado em 2026-11-01)
17. SWI-Prolog HTTP support: 3 The HTTP server libraries. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=httpserver> (acessado em 2026-11-01)
18. XPCE: the SWI-Prolog native GUI library. SWI-Prolog. <https://www.swi-prolog.org/packages/xpce/> (acessado em 2026-11-01)
19. SWI-Prolog/packages-xpce. GitHub. <https://github.com/SWI-Prolog/packages-xpce> (acessado em 2026-11-01)
20. "Building SWI-Prolog on MacOS". SWI-Prolog. <https://www.swi-prolog.org/build/macos.html> (acessado em 2026-11-01)
21. `swi-prolog.rb` (Homebrew formula). Homebrew/homebrew-core, GitHub. <https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/s/swi-prolog.rb> (acessado em 2026-11-01)
22. SWI-Prolog Reference Manual: format/1, format/2, format/3. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=format/1> (acessado em 2026-11-01)
23. SWI-Prolog Reference Manual: 1.1 Positioning SWI-Prolog. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=swiprolog> (acessado em 2026-11-01)
