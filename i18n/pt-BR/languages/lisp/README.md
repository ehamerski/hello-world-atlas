---
source: languages/lisp/README.md
source_sha: c75cc9d52e3735d556ae610e613664b4cdfb91b1
---
# Common Lisp

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** multiparadigma: funcional, imperativo e orientado a objetos.
Este repositório a agrupa com as linguagens funcionais. O Common-Lisp.net a
descreve como "a modern, multi-paradigm, high-performance, compiled,
ANSI-standardized descendant of the long-running family of Lisp
programming languages" [16] (tradução livre: "um descendente moderno,
multiparadigma, de alto desempenho, compilado e padronizado pela ANSI da
longeva família de linguagens de programação Lisp").

Veja também: [paradigmas](../../docs/paradigms.md#functional) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

Por que "funcional": o Lisp nasceu como uma linguagem de funções. O artigo
de McCarthy de 1960 começa com "a formalism for defining functions
recursively" [1] (tradução livre: "um formalismo para definir funções
recursivamente"), e uma das ideias por trás dele era "to express programs as
applicative expressions built up from variables and constants using
functions" [3] (tradução livre: "expressar programas como expressões
aplicativas construídas a partir de variáveis e constantes por meio de
funções"). As funções são valores: o padrão define uma função como "an
object representing code" [18] (tradução livre: "um objeto que representa
código"), de modo que é possível passá-la a outra função, como em
`(funcall #'+ 1 2 3)` [19] ou em `(mapcar #'car '((1 a) (2 b) (3 c)))`, que
retorna `(1 2 3)` [23]. O código Lisp também é escrito como listas,
chamadas S-expressions [1][3]: McCarthy citou "representation of program in
the same way" (tradução livre: "representação do programa da mesma forma")
como listas entre as ideias que "will probably have a very long life" [41]
(tradução livre: "provavelmente terão uma vida muito longa"). Um programa é
um dado que outro programa pode ler e construir, e as macros usam isso para
acrescentar sintaxe nova à linguagem [7][16][22].

Por que "multiparadigma": o Common Lisp não é puramente funcional. McCarthy
escreveu que "side-effects are often a great convenience when
computational efficiency is important, and 'functions' with side-effects
are present in LISP" [3] (tradução livre: "os efeitos colaterais costumam ser
uma grande conveniência quando a eficiência computacional é importante, e
'funções' com efeitos colaterais estão presentes no LISP"). O Common Lisp
tem atribuição (`(setq var1 form1 ...)` "is the simple variable assignment
statement of Lisp" [20], em tradução livre: "é a instrução simples de
atribuição de variável do Lisp"), instruções com saltos `go` (`tagbody` [21])
e um sistema de objetos, o CLOS, com classes, funções genéricas e métodos
[24]. Compare com o Haskell, em que "Every
function in Haskell is a function in the mathematical sense (i.e.,
"pure")" [17] (tradução livre: "Toda função em Haskell é uma função no
sentido matemático (isto é, "pura")"). No Common Lisp, o programador escolhe
o estilo. O Hello World deste repositório é uma única chamada de função com
um efeito colateral: ele imprime.

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | SBCL | ✅ |
| desktop | – | não implementada, veja [Por que não há versão desktop](#por-que-não-há-versão-desktop) | – |
| web | [web/](web/) | Hunchentoot (Quicklisp), SBCL | ✅ |

## História
Dois artigos contam esta história por dentro: o próprio *History of
Lisp* de McCarthy (rascunho datado de 1979-02-12) [6] e *The Evolution of
Lisp*, de Guy L. Steele Jr. e Richard P. Gabriel, escrito para a ACM
Conference on the History of Programming Languages II [7][8].

A ideia veio primeiro. McCarthy escreveu que seu "desire for an algebraic
list processing language for artificial intelligence work on the IBM 704
computer arose in the summer of 1956 during the Dartmouth Summer Research
Project on Artificial Intelligence" [2][9] (tradução livre: "desejo de uma
linguagem algébrica de processamento de listas para trabalhos de inteligência
artificial no computador IBM 704 surgiu no verão de 1956, durante o
Dartmouth Summer Research Project on Artificial Intelligence"). Enquanto
escrevia rotinas de xadrez em FORTRAN "at M.I.T. during 1957-58" (tradução
livre: "no M.I.T. durante 1957-58"), ele inventou a expressão condicional,
que "evaluates only one of N1 and N2 according to whether M is true or
false" [2] (tradução livre: "avalia apenas uma entre N1 e N2, conforme M seja
verdadeiro ou falso").

"In the Fall of 1958" (tradução livre: "No outono de 1958"), McCarthy e
Marvin Minsky "started the M.I.T. Artificial Intelligence Project" (tradução
livre: "iniciaram o M.I.T. Artificial Intelligence Project"), e "The
implementation of LISP began in Fall 1958" [3] (tradução livre: "A
implementação do LISP começou no outono de 1958"). Em abril de 1960,
McCarthy publicou *Recursive Functions of Symbolic Expressions and Their
Computation by Machine, Part I* na Communications of the ACM [1]. O artigo
começa assim: "A programming system called LISP (for LISt Processor) has
been developed for the IBM 704 computer by the Artificial Intelligence group
at M.I.T." [1] (tradução livre: "Um sistema de programação chamado LISP
(de LISt Processor) foi desenvolvido para o computador IBM 704 pelo grupo de
Inteligência Artificial do M.I.T."). O artigo descrevia o LISP "both as a
programming language and as a formalism for doing recursive function
theory" [3] (tradução livre: "tanto como linguagem de programação quanto como
formalismo para fazer teoria das funções recursivas"). Para isso, McCarthy
escreveu uma função universal, `eval`, que exigia "a notation representing
LISP functions as LISP data" [3] (tradução livre: "uma notação que
representasse funções LISP como dados LISP"). Então "S.R. Russell noticed
that eval could serve as an interpreter for LISP, promptly hand coded it,
and we now had a programming language with an interpreter" [3] (tradução
livre: "S.R. Russell percebeu que o eval poderia servir de interpretador para
o LISP, codificou-o prontamente à mão, e passamos a ter uma linguagem de
programação com um interpretador").

O *LISP 1.5 Programmer's Manual*, de McCarthy, Levin e outros, foi
publicado pela M.I.T. Press em 1962 [5], e "The primary dialect of Lisp
between 1960 and 1965 was Lisp 1.5" [9] (tradução livre: "O dialeto
principal do Lisp entre 1960 e 1965 foi o Lisp 1.5"). Muitos dialetos se
seguiram. "By the early 1970's there were two predominant dialects of Lisp"
(tradução livre: "No início da década de 1970, havia dois dialetos
predominantes do Lisp"): o MacLisp e o Interlisp [9]. No fim da década de
1970, Gerald J. Sussman e Guy L. Steele Jr. projetaram o Scheme, "a simple
dialect of Lisp" [9] (tradução livre: "um dialeto simples do Lisp"), e as
máquinas Lisp da Xerox, da LMI e da Symbolics "were on the market by 1981"
[9] (tradução livre: "estavam no mercado em 1981").

O Common Lisp foi a resposta a essa divisão. "In April 1981, ARPA called a
'Lisp Community Meeting'" [7] (tradução livre: "Em abril de 1981, a ARPA
convocou uma 'Lisp Community Meeting'"), após a qual a Symbolics, o projeto
SPICE, o projeto NIL e o projeto S-1 Lisp "joined together to define
Common Lisp" [9] (tradução livre: "uniram-se para definir o Common Lisp"). O
livro de Guy Steele, *Common Lisp: The Language* (CLtL), foi publicado em
1984 [7], e uma segunda edição (CLtL2), em 1990 [12]. "In 1986 X3J13 was
formed as a technical working group to produce a draft for an ANSI Common
Lisp standard" [9] (tradução livre: "Em 1986, o X3J13 foi formado como um
grupo técnico de trabalho para produzir um rascunho de um padrão ANSI Common
Lisp"). Seu sistema de objetos, o CLOS, "was adopted in June of 1988" [7]
(tradução livre: "foi adotado em junho de 1988"). O resultado foi o padrão
ANSI X3.226-1994, hoje chamado ANSI INCITS 226-1994 [10][11]. A versão
gratuita on-line é o Common Lisp HyperSpec, publicado pela LispWorks: ele
"is not the ANSI Common Lisp standard, but is based on that standard (with
permission from ANSI and X3)" [10] (tradução livre: "não é o padrão ANSI
Common Lisp, mas se baseia nesse padrão (com permissão da ANSI e do X3)").

O compilador usado aqui, o SBCL (Steel Bank Common Lisp), "derives most of
its code from CMU CL, created at Carnegie Mellon University" (tradução
livre: "deriva a maior parte de seu código do CMU CL, criado na Carnegie
Mellon University"), e "In December 1999, SBCL forked off the main branch of
CMUCL" [14] (tradução livre: "Em dezembro de 1999, o SBCL se separou do ramo
principal do CMUCL"). O nome homenageia os fundadores da Carnegie Mellon: "the
system is named Steel Bank after the industries where Andrew Carnegie and
Andrew Mellon, respectively, made the big bucks" [14] (tradução livre: "o
sistema se chama Steel Bank por causa das indústrias em que Andrew Carnegie
e Andrew Mellon, respectivamente, ganharam muito dinheiro").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1956 (verão) | Ideia de McCarthy de uma linguagem de processamento de listas para IA, no projeto de Dartmouth | [2][9] |
| 1957–1958 | McCarthy inventa a expressão condicional no M.I.T. | [2] |
| 1958 (outono) | Começa a implementação do LISP no M.I.T. AI Project | [3] |
| 1960-04 | *Recursive Functions of Symbolic Expressions ...*, Communications of the ACM | [1] |
| 1962 | *LISP 1.5 Programmer's Manual* (M.I.T. Press) | [5] |
| meados da década de 1960 | O MacLisp introduz o recurso de macros em que se baseia o `defmacro` | [7] |
| início da década de 1970 | MacLisp e Interlisp são os dois dialetos principais | [9] |
| fim da década de 1970 | Scheme, de Sussman e Steele | [9] |
| 1981-04 | "Lisp Community Meeting" da ARPA; começa o esforço do Common Lisp | [7][9] |
| 1984 | *Common Lisp: The Language* (CLtL1) | [7] |
| 1986 | O X3J13 é formado para escrever um padrão ANSI | [9] |
| 1988-06 | O CLOS, o Common Lisp Object System, é adotado | [7] |
| 1990 | *Common Lisp the Language, 2nd Edition* (CLtL2) | [12] |
| 1994 | ANSI X3.226-1994 (hoje ANSI INCITS 226-1994), o padrão vigente | [10][11] |
| 1999-12 | O SBCL se separa do CMUCL | [14] |
| 2026-10-29 | SBCL 2.6.10, a versão mais recente em 2026-11-01 | [13] |

## Uso de mercado hoje
Cada número abaixo traz sua data e sua fonte. Eles mudam todos os anos.

- **Índice TIOBE, outubro de 2026:** o Lisp ocupa a 36ª posição, com uma
  avaliação de 0,42% [25].
- **Stack Overflow Developer Survey 2026:** 2,6% de todos os respondentes da
  pergunta sobre linguagens de programação usaram Lisp (368 de 14.099) [26].
  Na pesquisa de 2025, o número era 2,4% de todos os respondentes [27].
- **IEEE Spectrum Top Programming Languages 2025:** o Lisp ocupa a 48ª
  posição no ranking "Spectrum" padrão [28].

Os três números medem coisas diferentes. O TIOBE conta resultados de
mecanismos de busca, a pesquisa do Stack Overflow conta os desenvolvedores
que a responderam, e o IEEE Spectrum combina várias métricas em três
rankings (Spectrum, Trending e Jobs) [28]. Nenhum deles separa o
Common Lisp dos demais dialetos Lisp: o rótulo nos três é
"Lisp".

## Importância antes e agora
- **Antes (1958–década de 1990):** o Lisp trouxe várias ideias hoje comuns:
  - **A expressão condicional.** McCarthy a inventou e a propôs para o
    Algol [2]. O artigo de 1960 diz "the notion of conditional
    expression is believed to be new" [1] (tradução livre: "acredita-se que
    a noção de expressão condicional seja nova").
  - **Recursão.** "The use of conditional expressions permits functions
    to be defined recursively in a new and convenient way" [1] (tradução
    livre: "O uso de expressões condicionais permite definir funções
    recursivamente de uma forma nova e conveniente"). O FLPL, a linguagem de
    listas que a IBM construiu dentro do FORTRAN, "had neither conditional
    expressions nor recursion" [2] (tradução livre: "não tinha expressões
    condicionais nem recursão").
  - **Coleta de lixo.** McCarthy rejeitou o apagamento explícito e escolheu
    "garbage collection in which storage is abandoned until the free
    storage list is exhausted" [3] (tradução livre: "coleta de lixo, na qual
    o armazenamento é abandonado até que a lista de armazenamento livre se
    esgote"). No artigo de 1960, "No provision need
    be made for the user to program the return of registers to the
    free-storage list" [1] (tradução livre: "Não é preciso prever que o
    usuário programe a devolução de registradores à lista de armazenamento
    livre").
  - **O interpretador interativo (REPL).** "It is convenient to define
    functions, test them, and re-edit them without ever leaving the LISP
    interpreter" [5] (tradução livre: "É conveniente definir funções,
    testá-las e reeditá-las sem nunca sair do interpretador LISP").
  - **Compiladores que compilam a si mesmos (self-hosting).** O primeiro
    compilador LISP bem-sucedido, de Timothy Hart e Michael Levin, "was
    written in LISP and was claimed to be the first compiler written in the
    language to be compiled" [4] (tradução livre: "foi escrito em LISP e
    afirmava-se ser o primeiro compilador escrito na linguagem que ele
    próprio compilava").
  - **IA.** Na década de 1980, "AI was on the rise, and Lisp was the language
    of AI" [7] (tradução livre: "a IA estava em ascensão, e o Lisp era a
    linguagem da IA"). Em 1979, McCarthy chamou o LISP de "the second oldest
    programming language in present widespread use (after FORTRAN ...)"
    [41] (tradução livre: "a segunda linguagem de programação mais antiga em
    uso difundido atualmente (depois do FORTRAN ...)").
- **Uma linguagem para construir linguagens:** "Lisp has been used throughout
  its history as a language laboratory" [7] (tradução livre: "O Lisp foi
  usado ao longo de sua história como um laboratório de linguagens"). Com
  macros, "it is pretty easy to add new control structures or other syntactic
  constructs" [7] (tradução livre: "é bastante fácil acrescentar novas
  estruturas de controle ou outras construções sintáticas").
  O Scheme trouxe para a família Lisp "lexical scoping, lexical closures,
  first-class continuations" (tradução livre: "escopo léxico, closures
  léxicas, continuações de primeira classe"), e alguns desses recursos "made a
  large impact on the design of Common Lisp" [9] (tradução livre: "tiveram
  grande impacto no projeto do Common Lisp").
- **Agora:** o Lisp tem uma pequena parcela de desenvolvedores (2,6% na
  pesquisa do Stack Overflow de 2026 [26]), mas o Common Lisp continua
  sendo mantido: o SBCL teve uma versão em 2026-10-29 [13], e o Quicklisp
  oferece "over 1,500 libraries" [29] (tradução livre: "mais de 1.500
  bibliotecas"). O padrão oficial continua sendo o de 1994, o ANSI INCITS
  226-1994 [11].
- **No ensino:** o Common Lisp mostra "code as data" (tradução livre:
  "código como dado") em sua forma mais simples: o programa é uma lista,
  `(format t "Hello, World!~%")`. Mostra também um modelo que as outras
  linguagens deste repositório não têm: um ambiente de execução "that
  allows modification and debugging of running applications" [16] (tradução
  livre: "que permite modificar e depurar aplicações em execução"), cujo
  estado pode ser salvo em disco como um executável [15] (veja [cli](cli/)).

## Comparação entre as categorias
| | [`cli`](cli/) | [`web`](web/) |
|---|---|---|
| Código-fonte | um arquivo, `hello.lisp`, com uma função `main` | o código do servidor em [web/](web/), com uma função `main` |
| Imprime com | `(format t "Hello, World!~%")` | o Hunchentoot envia `<p>Hello, World!</p>` para `GET /` |
| Bibliotecas | nenhuma: apenas o padrão | Hunchentoot, baixado e carregado pelo Quicklisp [29][30] |
| Compilação | o SBCL carrega o arquivo e salva a imagem com `sb-ext:save-lisp-and-die` [15] | o SBCL carrega o Quicklisp, o Hunchentoot (`ql:quickload`) e o código do servidor e, em seguida, salva a imagem com `sb-ext:save-lisp-and-die` [15] |
| Resultado | um executável independente "containing both an image of the current Lisp session and an SBCL runtime" [15] (tradução livre: "contendo tanto uma imagem da sessão Lisp atual quanto um runtime do SBCL") | o mesmo tipo de executável, com o Hunchentoot dentro; ele escuta em `PORT` (padrão 8080) |
| Quem controla o laço | ninguém: o `main` imprime e o programa termina | o Hunchentoot: ele "starts one thread for listening to incoming requests and one thread for each incoming connection" [30] (tradução livre: "inicia uma thread para escutar as requisições recebidas e uma thread para cada conexão recebida"); por isso o `main` precisa bloquear, ou o processo terminaria |
| Primeira compilação | compilar e depois executar o executável | o Quicklisp "will automatically download any supporting software it needs" [29] (tradução livre: "baixará automaticamente qualquer software de apoio de que precise") durante o `build.sh`; por isso a primeira compilação demora mais que as seguintes; a execução não precisa de rede |

O que permanece igual: ambas usam o mesmo SBCL, ambas partem de uma função
`main` e ambas fazem o trabalho pesado uma única vez, na compilação, e o salvam
como um executável. A diferença está no que o `main` faz: o executável cli
imprime e termina, enquanto o executável web inicia o Hunchentoot e espera
requisições em outras threads.
Compare com o [Python](../python/README.md), cuja versão web também carrega
uma biblioteca de um índice de pacotes (o Flask, do PyPI).

## Por que não há versão desktop
Este repositório não tem versão desktop do Common
Lisp: uma categoria só é mantida se existir para ela uma toolchain mantida,
de uso comum e razoavelmente simples em todas as plataformas-alvo.
O Common Lisp tem bibliotecas de GUI, mas nenhuma atende às três condições:

- **O McCLIM é mantido, mas precisa de um servidor X.** O McCLIM é "a FOSS
  implementation of the Common Lisp Interface Manager specification"
  [31] (tradução livre: "uma implementação FOSS da especificação Common Lisp
  Interface Manager"). Ele está ativo: a versão 1.0.0 "Koliada" foi lançada em
  2026-05-05 [33]. Mas seu README diz: "Right now the only backend supported by
  McCLIM is CLX, which ties it to the Xserver on the host system. Any
  platform capable of running Xserver may run McCLIM applications" [32]
  (tradução livre: "No momento, o único back-end com suporte no McCLIM é o
  CLX, que o vincula ao Xserver do sistema hospedeiro. Qualquer plataforma
  capaz de executar o Xserver pode executar aplicações McCLIM").
  No macOS e no Windows, o estudante precisaria primeiro instalar e iniciar
  um servidor X, antes de qualquer Lisp.
- **O LTK depende do Tcl/Tk, e sua página inicial é de 2011.** O LTK é "a
  Common Lisp binding for the Tk graphics toolkit" [34] (tradução livre:
  "um binding Common Lisp para o toolkit gráfico Tk"). Sua documentação diz:
  "To use Ltk you need of course tcl/tk installed. This should be default on
  most Linux systems, for Windows/Mac OS you need to download and install
  tcl/tk" (tradução livre: "Para usar o Ltk, é claro, é preciso ter o tcl/tk
  instalado. Isso deve ser o padrão na maioria dos sistemas Linux; para
  Windows/Mac OS, é preciso baixar e instalar o tcl/tk"), e "Ltk has been
  tested against Tcl/Tk 8.4" [35] (tradução livre: "O Ltk foi testado com o
  Tcl/Tk 8.4"). Sua página inicial foi modificada pela última vez em julho de
  2011 e lista `ltk-0.981` como a versão mais recente [34].
- **Os bindings do GTK precisam do GTK e não estão na distribuição principal
  do Quicklisp.** O cl-cffi-gtk4 é "a Lisp binding to GTK 4" (tradução livre:
  "um binding Lisp para o GTK 4"), e seu README diz que ele "is developped
  using SBCL on UBUNTU. The library runs successfully on WINDOWS" [36]
  (tradução livre: "é desenvolvido usando o SBCL no UBUNTU. A biblioteca
  funciona com sucesso no WINDOWS"); ele não menciona o macOS. O cl-gtk4
  pede que se "ensure these libraries are available in your system: GTK4,
  GObject Introspection" (tradução livre: "garanta que estas bibliotecas
  estejam disponíveis em seu sistema: GTK4, GObject Introspection"), e "is
  available on Ultralisp, so it can be downloaded via Quicklisp with
  Ultralisp installed as its distribution" [37] (tradução livre: "está
  disponível no Ultralisp, de modo que pode ser baixado pelo Quicklisp com o
  Ultralisp instalado como sua distribuição"). Em ambos os casos, o estudante
  instala primeiro a biblioteca C GTK (como na versão
  [C desktop](../c/desktop/)) e depois um binding.
- **O CAPI é portável, mas comercial.** O CAPI, da LispWorks, "is a portable
  GUI toolkit, supporting native look and feel on Microsoft Windows, GTK+,
  Cocoa and Motif" [38] (tradução livre: "é um toolkit de GUI portável, com
  suporte ao visual nativo no Microsoft Windows, GTK+, Cocoa e Motif"), e
  "The CAPI is included in LispWorks" [38] (tradução livre: "O CAPI está
  incluído no LispWorks"), um Common Lisp comercial, e não no SBCL. Em
  2026-11-01, o LispWorks 8.1 (64 bits) para Macintosh, Professional Edition,
  custava US$ 3.000 por usuário para usuários comerciais na América do Norte
  [39]. A Personal Edition gratuita tem "a time limit of 5 hours for each
  session" (tradução livre: "um limite de tempo de 5 horas por sessão"), e
  "The functions save-image, deliver, and load-all-patches are not
  available" [40] (tradução livre: "As funções save-image, deliver e
  load-all-patches não estão disponíveis"); por isso, ela não pode salvar nem
  distribuir uma aplicação.

Um Hello World desktop precisaria, portanto, de um servidor X, de um binding
antigo do Tk, de uma instalação do GTK mais um binding fora da distribuição
principal do Quicklisp, ou de um Lisp comercial. Nenhuma dessas opções atende
às três condições acima.

## Fontes
1. Recursive Functions of Symbolic Expressions and Their Computation by Machine, Part I (Communications of the ACM, April 1960). John McCarthy. <https://www-formal.stanford.edu/jmc/recursive.pdf> (acessado em 2026-11-01)
2. History of Lisp (draft dated 1979-02-12): "LISP prehistory - Summer 1956 through Summer 1958". John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/node2.html> (acessado em 2026-11-01)
3. History of Lisp: "The implementation of LISP". John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/node3.html> (acessado em 2026-11-01)
4. History of Lisp: "From LISP 1 to LISP 1.5". John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/node4.html> (acessado em 2026-11-01)
5. History of Lisp: "Beyond LISP 1.5". John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/node5.html> (acessado em 2026-11-01)
6. History of Lisp (title page and contents). John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/lisp.html> (acessado em 2026-11-01)
7. The Evolution of Lisp (HOPL II version). Guy L. Steele Jr. and Richard P. Gabriel. <https://www.dreamsongs.com/Files/Hopl2.pdf> (acessado em 2026-11-01)
8. Essays: The Evolution of Lisp (how the paper was written for the ACM Conference on the History of Programming Languages II). Richard P. Gabriel. <https://www.dreamsongs.com/Essays.html> (acessado em 2026-11-01)
9. Common Lisp HyperSpec, 1.1.2 History. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/01_ab.htm> (acessado em 2026-11-01)
10. About the Common Lisp HyperSpec. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Front/Help.htm> (acessado em 2026-11-01)
11. Common Lisp Documentation (the standard ANSI INCITS 226-1994). LispWorks. <https://www.lispworks.com/documentation/common-lisp.html> (acessado em 2026-11-01)
12. Common Lisp the Language, 2nd Edition (Guy L. Steele, Digital Press, 1990). CMU Artificial Intelligence Repository. <https://www.cs.cmu.edu/Groups/AI/html/cltl/cltl2.html> (acessado em 2026-11-01)
13. Steel Bank Common Lisp (home page). SBCL. <https://www.sbcl.org/> (acessado em 2026-11-01)
14. History and Copyright. SBCL. <https://www.sbcl.org/history.html> (acessado em 2026-11-01)
15. SBCL User Manual (Executable Delivery; `save-lisp-and-die`). SBCL. <https://www.sbcl.org/manual/> (acessado em 2026-11-01)
16. Common-Lisp.net (home page: "What is Common Lisp?"). Common-Lisp.net. <https://common-lisp.net/> (acessado em 2026-11-01)
17. Haskell Language (home page: "Purely functional"). haskell.org. <https://www.haskell.org/> (acessado em 2026-11-01)
18. Common Lisp HyperSpec, Glossary: F ("function"). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/26_glo_f.htm> (acessado em 2026-11-01)
19. Common Lisp HyperSpec, Function FUNCALL. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/f_funcal.htm> (acessado em 2026-11-01)
20. Common Lisp HyperSpec, Special Form SETQ. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/s_setq.htm> (acessado em 2026-11-01)
21. Common Lisp HyperSpec, Special Operator TAGBODY. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/s_tagbod.htm> (acessado em 2026-11-01)
22. Common Lisp HyperSpec, Macro DEFMACRO. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_defmac.htm> (acessado em 2026-11-01)
23. Common Lisp HyperSpec, Function MAPC, MAPCAR, .... LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/f_mapc_.htm> (acessado em 2026-11-01)
24. Common Lisp HyperSpec, Macro DEFMETHOD (and Chapter 7, Objects). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_defmet.htm> (acessado em 2026-11-01)
25. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-01)
26. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-01)
27. 2025 Stack Overflow Developer Survey: Technology. Stack Overflow. <https://survey.stackoverflow.co/2025/technology> (acessado em 2026-11-01)
28. The Top Programming Languages 2025. IEEE Spectrum. <https://spectrum.ieee.org/top-programming-languages-2025> (acessado em 2026-11-01)
29. Quicklisp beta. Quicklisp. <https://www.quicklisp.org/beta/> (acessado em 2026-11-01)
30. Hunchentoot - The Common Lisp web server formerly known as TBNL. Edi Weitz, edicl. <https://edicl.github.io/hunchentoot/> (acessado em 2026-11-01)
31. McCLIM (home page). McCLIM. <https://mcclim.common-lisp.dev/> (acessado em 2026-11-01)
32. McCLIM (repository and README). Codeberg. <https://codeberg.org/McCLIM/McCLIM> (acessado em 2026-11-01)
33. McCLIM releases. Codeberg. <https://codeberg.org/McCLIM/McCLIM/releases> (acessado em 2026-11-01)
34. LTK - The Lisp Toolkit (home page). Peter Herth. <https://www.peter-herth.de/ltk/> (acessado em 2026-11-01)
35. LTK - a Lisp binding to the Tk toolkit: Installation. Peter Herth. <https://www.peter-herth.de/ltk/ltkdoc/node3.html> (acessado em 2026-11-01)
36. crategus/cl-cffi-gtk4 (README). GitHub. <https://github.com/crategus/cl-cffi-gtk4> (acessado em 2026-11-01)
37. bohonghuang/cl-gtk4 (README). GitHub. <https://github.com/bohonghuang/cl-gtk4> (acessado em 2026-11-01)
38. LispWorks CAPI. LispWorks. <https://www.lispworks.com/products/capi.html> (acessado em 2026-11-01)
39. LispWorks prices. LispWorks. <https://www.lispworks.com/buy/prices-1c.html> (acessado em 2026-11-01)
40. LispWorks Personal Edition (download page and limitations). LispWorks. <https://www.lispworks.com/downloads/index.html> (acessado em 2026-11-01)
41. History of Lisp: "Conclusions". John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/node6.html> (acessado em 2026-11-01)
