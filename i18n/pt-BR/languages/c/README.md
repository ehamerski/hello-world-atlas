---
source: languages/c/README.md
source_sha: 8a13b2561a68f7b6f18bfef31538ace8cc3273c3
---
# C (ANSI C)

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** imperativo (procedural). Um programa em C é um conjunto de
funções cujas instruções alteram dados passo a passo. O padrão define uma
instrução (*statement*) assim: "A statement specifies an action to be
performed. Except as indicated, statements are executed in sequence" [1]
(tradução livre: "Uma instrução especifica uma ação a ser executada. Exceto
quando indicado, as instruções são executadas em sequência"). Não há
classes nem objetos na linguagem: compare com o [Java](../java/README.md),
em que até o Hello World precisa de uma classe. A API em C do GTK, em
[desktop/](desktop/), mostra como bibliotecas orientadas a objetos ainda
são escritas em C, com structs, ponteiros para funções e convenções de
nomenclatura.

Ver também: [paradigmas](../../docs/paradigms.md#imperative) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Padrão | Situação |
|---|---|---|---|---|
| cli | [cli/](cli/) | compilador C do sistema, `-std=c89` | **C89** (`-std=c89 -pedantic-errors`) | ✅ |
| desktop | [desktop/](desktop/) | GTK 4, `-std=c99` | C99 (`-std=c99 -pedantic`) | ✅ |
| web | [web/](web/) | GNU libmicrohttpd, `-std=c99` | C99 (`-std=c99 -pedantic-errors`) | ✅ |

"ANSI C" designa o C do primeiro padrão, ANSI X3.159-1989, que a ISO
publicou sem alterações como ISO/IEC 9899:1990 [2]. Cada pasta é compilada
em um modo ISO estrito (`-std=...` mais `-pedantic`), de modo que extensões
específicas do compilador são rejeitadas ou sinalizadas. A versão `cli` é
C89 puro. As versões `desktop` e `web` usam C99, porque os cabeçalhos das
bibliotecas que chamam o exigem; o README de cada uma mostra a mensagem do
compilador que o comprova.

## História
O C foi criado por Dennis Ritchie nos Bell Labs. Seu próprio relato, *The
Development of the C Language* (HOPL-II, 1993), é a principal fonte desta
seção [3].

- **Finalidade:** "The C programming language was devised in the early
  1970s as a system implementation language for the nascent Unix operating
  system" [3] (tradução livre: "A linguagem de programação C foi concebida
  no início da década de 1970 como linguagem de implementação de sistemas
  para o então nascente sistema operacional Unix").
- **Ancestrais, BCPL e B:** Ken Thompson "decided that Unix ... needed a
  system programming language. After a rapidly scuttled attempt at
  Fortran, he created instead a language of his own, which he called B. B
  can be thought of as C without types; more accurately, it is BCPL
  squeezed into 8K bytes of memory" [3] (tradução livre: "decidiu que o
  Unix ... precisava de uma linguagem de programação de sistemas. Após uma
  tentativa rapidamente abandonada com Fortran, criou em vez disso uma
  linguagem própria, que chamou de B. O B pode ser entendido como o C sem
  tipos; mais exatamente, é o BCPL comprimido em 8K bytes de memória").
  Ritchie estendeu o B com tipos: "I called the slightly-extended language
  NB, for 'new B'" (tradução livre: "Chamei a linguagem levemente estendida
  de NB, de 'new B'"); seu artigo chama o NB de "embryonic C" [3]
  (tradução livre: "C embrionário").
- **Quando:** "C came into being in the years 1969-1973, in parallel with
  the early development of the Unix operating system; the most creative
  period occurred during 1972" [3] (tradução livre: "O C surgiu nos anos de
  1969 a 1973, em paralelo com o desenvolvimento inicial do sistema
  operacional Unix; o período mais criativo ocorreu em 1972"). Entre as
  mudanças de 1972–73, "the most important was the introduction of the
  preprocessor" (tradução livre: "a mais importante foi a introdução do
  pré-processador"), a linha `#include` presente em todos os programas
  daqui [3].
- **Unix em C:** "By early 1973, the essentials of modern C were complete.
  The language and compiler were strong enough to permit us to rewrite the
  Unix kernel for the PDP-11 in C during the summer of that year" [3]
  (tradução livre: "No início de 1973, o essencial do C moderno estava
  pronto. A linguagem e o compilador eram robustos o bastante para nos
  permitir reescrever em C o kernel do Unix para o PDP-11 durante o verão
  daquele ano"). Uma segunda onda de mudanças no C "peaked between 1977 and
  1979, when portability of the Unix system was being demonstrated" [3]
  (tradução livre: "atingiu o auge entre 1977 e 1979, quando a
  portabilidade do sistema Unix estava sendo demonstrada").
- **K&R:** "In 1978 Brian Kernighan and I published The C Programming
  Language", um livro que "served as the language reference until a formal
  standard was adopted more than ten years later" [3] (tradução livre: "Em
  1978, Brian Kernighan e eu publicamos The C Programming Language", um
  livro que "serviu como referência da linguagem até que um padrão formal
  fosse adotado mais de dez anos depois").
- **ANSI:** "ANSI established the X3J11 committee under the direction of
  CBEMA in the summer of 1983, with the goal of producing a C standard.
  X3J11 produced its report [ANSI 89] at the end of 1989, and subsequently
  this standard was accepted by ISO as ISO/IEC 9899-1990" [3] (tradução
  livre: "A ANSI instituiu o comitê X3J11, sob a direção da CBEMA, no verão
  de 1983, com o objetivo de produzir um padrão para o C. O X3J11 produziu
  seu relatório [ANSI 89] no final de 1989, e esse padrão foi
  posteriormente aceito pela ISO como ISO/IEC 9899-1990").

Hoje, o padrão é mantido pelo ISO/IEC JTC1/SC22/WG14, "the international
standardization working group for the programming language C" [4]
(tradução livre: "o grupo de trabalho internacional de padronização da
linguagem de programação C").

## Marcos
| Ano | Marco | Fonte |
|---|---|---|
| 1969–1973 | O C é criado nos Bell Labs, junto com o Unix; "the most creative period occurred during 1972" (o período mais criativo ocorreu em 1972) | [3] |
| 1973 | O kernel do Unix para o PDP-11 é reescrito em C | [3] |
| 1978 | *The C Programming Language* (Kernighan e Ritchie, "K&R"): a referência de fato | [3] |
| 1983 | A ANSI forma o comitê X3J11 para padronizar o C | [3] |
| 1989 / 1990 | **ANSI C**: X3.159-1989, "ratified in 1989 and published in 1990" (ratificado em 1989 e publicado em 1990), depois ISO/IEC 9899:1990 ("C89"/"C90"). Usado por [cli/](cli/) | [2][3] |
| 1999 | C99, ISO/IEC 9899:1999: comentários `//`, `long long`, `<stdint.h>`, `return 0` implícito em `main`. Usado por [desktop/](desktop/) e [web/](web/) | [2][1] |
| 2011 | C11, ISO/IEC 9899:2011 | [2] |
| 2018 | C17, ISO/IEC 9899:2018: C11 com correções, sem novos recursos | [2] |
| 2024 | C23, ISO/IEC 9899:2024, o padrão atual: `bool`, `true` e `false` como palavras-chave; `()` vazio em uma declaração passa a significar "sem parâmetros" | [2][4][5] |

A documentação do GCC menciona também a próxima revisão em andamento,
"known as C2Y" [2] (tradução livre: "conhecida como C2Y").

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam todos os anos.

- **Índice TIOBE, outubro de 2026:** o C ocupa a **posição 2**, com
  avaliação de 11,33%, também na posição 2 em outubro de 2025 [6]. O TIOBE
  nomeia o C "Programming Language of the Year" (linguagem do ano; a
  linguagem com "the highest rise in ratings in a year", isto é, o maior
  aumento de avaliação em um ano) em 2008, 2017 e 2019 [6]. O TIOBE chama
  seu índice de "an indicator of the popularity of programming languages"
  (tradução livre: "um indicador da popularidade das linguagens de
  programação"), calculado a partir de mecanismos de busca e sites, e "not
  about ... the language in which most lines of code have been written" [6]
  (tradução livre: "não se trata de ... a linguagem em que mais linhas de
  código foram escritas").
- **Stack Overflow Developer Survey 2026:** 21,8% de todos os respondentes
  (3.070 de 14.099) disseram ter "done extensive development work" (tradução
  livre: "feito trabalho extensivo de desenvolvimento") em C no último ano
  [7]. Entre eles, 45,9% querem continuar usando ("admired"); 14,2% de
  todos os respondentes querem usá-lo ("desired") [7].
- **Onde o C é executado:** "The Linux kernel is written in the C
  programming language" (tradução livre: "O kernel do Linux é escrito na
  linguagem de programação C"), compilado "under -std=gnu11 ... the GNU
  dialect of ISO C11" [8] (tradução livre: "sob -std=gnu11 ... o dialeto
  GNU do ISO C11"). "SQLite is a C-language library" (tradução livre: "O
  SQLite é uma biblioteca em linguagem C") e, segundo seus autores, "the
  most used database engine in the world" [9] (tradução livre: "o mecanismo
  de banco de dados mais usado no mundo"). O GTK, usado em
  [desktop/](desktop/), "is written in C" [10] (tradução livre: "é escrito
  em C"), assim como a libmicrohttpd [11]. Bibliotecas escritas em C também
  são chamadas por outras linguagens: neste repositório, a versão
  [Go desktop](../go/desktop/) precisa de um compilador C porque seu
  toolkit de GUI, o Fyne, contém código C.

## Importância antes e agora
- **Antes (décadas de 1970 e 1980):** o C foi a linguagem em que o Unix foi
  escrito, e a portabilidade do Unix foi demonstrada com ela em 1977–1979
  [3]. O resumo do próprio Ritchie: "C is quirky, flawed, and an enormous
  success. ... it evidently satisfied a need for a system implementation
  language efficient enough to displace assembly language, yet sufficiently
  abstract and fluent to describe algorithms and interactions in a wide
  variety of environments" [3] (tradução livre: "O C é excêntrico, falho e
  um enorme sucesso. ... ele evidentemente satisfez a necessidade de uma
  linguagem de implementação de sistemas eficiente o bastante para
  substituir a linguagem de montagem (assembly), mas suficientemente
  abstrata e fluente para descrever algoritmos e interações em uma grande
  variedade de ambientes").
- **A semelhança de família:** compare os programas Hello World deste
  repositório. As versões em [Java](../java/cli/) e [Go](../go/cli/) usam
  as mesmas chaves, as mesmas formas de comentário `/* */` e `//` e um
  ponto de entrada `main`. A impressão formatada delas também vem do C: o
  `fmt` do Go "implements formatted I/O with functions analogous to C's
  printf and scanf" [12] (tradução livre: "implementa E/S formatada com
  funções análogas ao printf e ao scanf do C"), e, em Java, "formatted
  printing ... is heavily inspired by C's printf" [13] (tradução livre: "a
  impressão formatada ... é fortemente inspirada no printf do C").
- **Agora:** ainda na posição 2 do TIOBE (outubro de 2026) [6] e usado
  extensivamente por 21,8% dos respondentes do Stack Overflow em 2026 [7].
  É a linguagem de kernels de sistemas operacionais, bancos de dados
  embutidos e bibliotecas de sistema [8][9][10].
- **No ensino:** o C mostra o que outras linguagens escondem. Uma string é
  um vetor de bytes terminado em `'\0'`; memória e objetos são liberados
  manualmente (`MHD_destroy_response`, `g_object_unref`); bibliotecas são um
  cabeçalho mais um binário que o linker conecta. O preço é a segurança:
  nada verifica os limites de vetores nem os tipos de uma chamada variádica
  (ver o [passo a passo da versão web](web/README.md#step-by-step-walkthrough)).

## Comparação entre as categorias
| | [`cli`](cli/) | [`desktop`](desktop/) | [`web`](web/) |
|---|---|---|---|
| Linhas de C (sem comentários, sem linhas em branco) | 6 | 39 (6 são a autoverificação) | 67 |
| Padrão (`-std`) | C89 | C99 | C99 |
| Biblioteca | somente a biblioteca padrão do C (`<stdio.h>`) | GTK 4.24 (+ GLib, Pango, Cairo, ...) | GNU libmicrohttpd 1.0.10 |
| Como a biblioteca é encontrada | desnecessário | `pkg-config --cflags --libs gtk4` | `pkg-config --cflags --libs libmicrohttpd` |
| Executável (`ls -l`, macOS Intel) | 8.440 bytes | 9.888 bytes | 9.472 bytes |
| Bibliotecas carregadas em tempo de execução (`otool -L`) | `libSystem` (a biblioteca C) | `libgtk-4` + mais 11 bibliotecas GTK/GLib/Pango/Cairo + `libSystem` | `libmicrohttpd` + `libSystem` |
| Quem controla o laço | ninguém: `main` imprime e retorna | o laço principal do GTK (`g_application_run`) | `for (;;) MHD_run_wait(...)` em `main` |
| Saída | texto na saída padrão (stdout) | uma janela nativa | HTML via HTTP |

O que permanece igual: um único `hello.c`, compilado pelo `cc` em modo ISO
estrito e ligado em um único executável nativo em `bin/`. O que muda é
apenas a biblioteca. Os executáveis são minúsculos porque, ao contrário do
[Go](../go/README.md#comparing-the-categories), o C liga suas bibliotecas
**dinamicamente**: o código de `printf`, do GTK e da libmicrohttpd fica em
bibliotecas compartilhadas do sistema, que, portanto, precisam estar
instaladas onde o programa é executado.

A outra diferença é o padrão do C: a versão `cli` é C89 puro, enquanto os
cabeçalhos do GTK e da libmicrohttpd exigem C99 (`long long`,
`<stdint.h>`), de modo que essas duas pastas usam `-std=c99`.

O C tem uma implementação em cada uma de suas três categorias, de modo que
esta página não tem seção que explique uma categoria ausente.

## Fontes
1. ISO/IEC 9899:TC3, committee draft WG14/N1256 (C99 with corrigenda; Foreword list of changes; 6.8 Statements and blocks). ISO/IEC JTC1/SC22/WG14, 2007-09-07. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (acessado em 2026-10-31)
2. Language Standards Supported by GCC (C Language: C89/C90, C99, C11, C17, C23, C2Y). GCC, the GNU Compiler Collection. <https://gcc.gnu.org/onlinedocs/gcc/Standards.html> (acessado em 2026-10-31)
3. The Development of the C Language. Dennis M. Ritchie, Second History of Programming Languages conference (HOPL-II), ACM, 1993. Author's reprint, archived copy of bell-labs.com (2015-12-31). <https://web.archive.org/web/20151231162516/http://www.bell-labs.com/usr/dmr/www/chist.html> (acessado em 2026-10-31)
4. ISO/IEC JTC1/SC22/WG14 - C (home page: "The current C programming language standard (C23) [ISO/IEC 9899] was adopted by ISO and IEC in 2024"). WG14. <https://www.open-std.org/jtc1/sc22/wg14/> (acessado em 2026-10-31)
5. ISO/IEC 9899:2024, working draft WG14/N3220 (C23; Annex M, list of changes). WG14. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3220.pdf> (acessado em 2026-10-31)
6. TIOBE Index for October 2026 (ranking, Programming Language of the Year). TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-10-31)
7. 2026 Stack Overflow Developer Survey: Technology, programming languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> and <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
8. Programming Language (Linux kernel documentation). The kernel development community. <https://docs.kernel.org/process/programming-language.html> (acessado em 2026-10-31)
9. SQLite home page. SQLite. <https://www.sqlite.org/index.html> (acessado em 2026-10-31)
10. The GTK Project (home page). GNOME. <https://www.gtk.org/> (acessado em 2026-10-31)
11. GNU libmicrohttpd. GNU Project. <https://www.gnu.org/software/libmicrohttpd/> (acessado em 2026-10-31; cópia arquivada: <https://web.archive.org/web/20261113123927/http://www.gnu.org/software/libmicrohttpd/>, acessado em 2026-11-22)
12. Package `fmt`. The Go Authors. <https://pkg.go.dev/fmt> (acessado em 2026-10-31)
13. Class Formatter (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/Formatter.html> (acessado em 2026-10-31)
