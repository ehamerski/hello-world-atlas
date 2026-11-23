---
source: languages/clipper/README.md
source_sha: 9403947ff866c68ac37c452de52b52b7c1a03992
---
# Clipper

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** imperativo (procedural), com tipagem dinâmica. Um programa
Clipper é um conjunto de procedimentos e funções que executam instruções em
ordem. A linguagem "is a superset of dBASE III+, and also shares some
features with C/C++ and Smalltalk" (tradução livre: "é um superconjunto do
dBASE III+ e também compartilha alguns recursos com C/C++ e Smalltalk"); é
"a general-purpose, high-level programming language well suited to corporate
and commercial applications development" [1] (tradução livre: "uma
linguagem de programação de propósito geral e alto nível, adequada ao
desenvolvimento de aplicações corporativas e comerciais"). Pertence à
família **xBase**, as linguagens que surgiram do dBASE. O Clipper 5
acrescentou variáveis locais e blocos de código [3], mas o Hello World deste
repositório é código procedural simples.

Ver também: [paradigmas](../../docs/paradigms.md#imperative) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

O Hello World é compilado com o **Harbour**, o sucessor livre e de código
aberto do Clipper ("100% compatible with Clipper compilers" [2], tradução
livre: "100% compatível com os compiladores Clipper").

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | Harbour | ✅ |
| desktop | – | não implementado, ver [Por que não há versão desktop nem web](#por-que-não-há-versão-desktop-nem-web) | – |
| web | – | não implementado, mesma seção | – |

## Histórico
O Clipper começou como um **compilador para dBASE**, a linguagem de banco de
dados da Ashton-Tate nos PCs com MS-DOS. Uma página de história do
desenvolvedor do Clipper Greg Holmes conta uma história que, nas palavras
de "insiders", "is not far from the truth" (tradução livre: "não está longe
da verdade"): um funcionário da Ashton-Tate, Brian Russell, e um consultor,
Barry ReBell, estavam "expressing their annoyance at the fact that
Ashton-Tate had not created a compiler for the dBase language" (tradução
livre: "manifestando seu desagrado pelo fato de a Ashton-Tate não ter criado
um compilador para a linguagem dBase") e fundaram a Nantucket para criar
um [3]. "There were four "seasonally" named versions of the compiler: Winter
85, Spring 86, Autumn 86, Summer 87", que "clearly billed themselves as dBase
compilers" [3] (tradução livre: "Houve quatro versões do compilador com nomes
"sazonais": Winter 85, Spring 86, Autumn 86, Summer 87", que "se anunciavam
claramente como compiladores dBase").

O **Clipper 5** mudou isso: "No longer billed as a dBase compiler, Clipper
became an "Application Development System"", com conceitos "borrowed from C
and other languages", como o operador `++` [3] (tradução livre: "Deixando de
ser anunciado como compilador dBase, o Clipper tornou-se um "Sistema de
Desenvolvimento de Aplicações"", com conceitos "emprestados do C e de outras
linguagens").

Em maio de 1992, o fundador da Nantucket "sold Nantucket to Computer
Associates International Inc" [4] (tradução livre: "vendeu a Nantucket para
a Computer Associates International Inc"), e o produto passou a se chamar
**CA-Clipper**. Em março de 1998, o FAQ do Clipper informava que ele havia
"definitely stopped evolving; CA has announced that 5.3 will be the last
significant release and only maintenance patches will be forthcoming", com
a 5.3b como versão atual [1] (tradução livre: "definitivamente parado de
evoluir; a CA anunciou que a 5.3 será a última versão significativa e que
haverá apenas correções de manutenção").

Outros compiladores mantiveram a linguagem viva. O FAQ de 1998 já contava
"FlagShip, xBase++, x2c, FORCE, and Visual Objects" como "Clipper clones,
improvements, and adaptations" [1] (tradução livre: "clones, melhorias e
adaptações do Clipper"). O **Harbour** é o representante de software livre:
ele se descreve como "backward compatible with Clipper/xBase" (tradução
livre: "retrocompatível com Clipper/xBase") e executa no macOS, no Linux, no
Windows e em outros sistemas [5]. Seu código-fonte traz a linha de direitos
autorais "Copyright (c) 1999-2025" (impressa por `hbmk2 -build`). O Harbour
3.0.0 foi lançado em 2011-07-17 [2], e o **Harbour 3.2.0**, "the first
official stable release since 3.0.0 (2011)" (tradução livre: "a primeira
versão estável oficial desde a 3.0.0 (2011)"), em 2026-07-07 [6].

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| "Winter 85" | Primeira versão do Clipper da Nantucket, um compilador dBASE | [3] |
| "Summer 87" | Última versão sazonal, vendida como "dBase III® compiler" (compilador dBase III®) | [3] |
| Clipper 5 | Deixa de ser um compilador dBASE: um "Application Development System" (Sistema de Desenvolvimento de Aplicações) | [3] |
| 1992-05 | A Computer Associates compra a Nantucket; o produto passa a ser o CA-Clipper | [4] |
| até 1998-03 | A CA anuncia a 5.3 como a última versão significativa; a 5.3b é a atual | [1] |
| 2011-07-17 | Harbour 3.0.0 | [2] |
| 2026-07-07 | Harbour 3.2.0, a toolchain usada em [cli](cli/) | [6] |

Os anos de lançamento do Clipper 5.0 e do 5.3 foram omitidos: não foi
encontrada fonte primária para eles.

## Uso no mercado hoje
- **Índice TIOBE, outubro de 2026:** nem o Clipper nem o Harbour aparecem
  entre as 50 primeiras nem em "The Next 50 Programming Languages" (do nº 51
  ao nº 100). A única linguagem xBase listada é o `XBase++`, na lista sem
  classificação do nº 51 ao nº 100 [7].
- **Stack Overflow Developer Survey 2026:** Clipper, Harbour e xBase não
  estão entre as linguagens da pesquisa [8].

Não foi encontrado nenhum número de uso confiável e datado para o Clipper
ou o Harbour; por isso, nenhum é apresentado. O próprio Harbour é mantido:
seu repositório no GitHub tem CI em Linux, Windows e macOS [5] e uma versão
lançada em 2026 [6].

## Importância antes e agora
- **Antes (final da década de 1980 e década de 1990):** o Clipper transformou
  programas dBASE em aplicações MS-DOS autônomas e compiladas, e tornou-se uma
  linguagem própria para "corporate and commercial applications development"
  [1] (tradução livre: "desenvolvimento de aplicações corporativas e
  comerciais").
- **Agora:** o Harbour mantém esses programas vivos em sistemas operacionais
  modernos. Ele "can be used to make open source applications, free or
  nonfree products" [2] (tradução livre: "pode ser usado para criar
  aplicações de código aberto e produtos gratuitos ou não gratuitos") e lista
  "Native RDDs, SQL, ODBC" e suporte a "JSON, SSL, TCP/IP, XML" entre seus
  recursos [2]. Um RDD é um "replaceable database driver" [9] (tradução
  livre: "driver de banco de dados substituível"), a camada pela qual os
  programas Clipper leem e gravam seus arquivos de dados.
- **No ensino:** o Clipper mostra uma linguagem construída em torno de
  *comandos* que são regras de pré-processador: `?` e `??` parecem
  instruções, mas o `std.ch` os transforma nas funções `QOut()` e
  `QQOut()` (ver o
  [passo a passo](cli/README.md#step-by-step-walkthrough)). Mostra também,
  como o [COBOL](../cobol/cli/), um compilador que produz C, aqui como pcode
  para uma máquina virtual.

## Comparação entre as categorias
O Clipper tem aqui uma única categoria, cli. A comparação útil é com a outra
linguagem da era MS-DOS deste repositório, o BASIC, e com o COBOL, que também
compila por meio de C:

| | [Clipper cli](cli/) | [BASIC cli](../basic/cli/) | [COBOL cli](../cobol/cli/) |
|---|---|---|---|
| Dialeto | Clipper 5 | QBasic / QuickBASIC 4.5 | COBOL-85 |
| Era do dialeto | aplicações comerciais para MS-DOS | PCs com MS-DOS, uso doméstico e ensino | mainframes |
| Instrução que imprime | `?? "Hello, World!"` e depois `?` | `PRINT "Hello, World!"` | `DISPLAY "Hello, World!".` |
| Ponto de entrada | `PROCEDURE Main()` | primeira instrução do arquivo | primeira instrução da `PROCEDURE DIVISION` |
| Tipos | dinâmicos | estáticos, por sufixo do nome ou `DIM ... AS` | estáticos, cláusulas `PICTURE` |
| Compilador moderno | Harbour 3.2.0: Clipper → C (pcode) → código de máquina | QB64-PE 4.7.0: BASIC → C++ → código de máquina | GnuCOBOL 3.2: COBOL → C → código de máquina |
| Instalado por | compilação do código-fonte da versão oficial | compilação do pacote oficial para macOS | Homebrew |

## Por que não há versão desktop nem web
Este repositório tem apenas a versão cli do Clipper. Uma categoria só
permanece se existir, para ela, uma toolchain mantida, convencional e
razoavelmente simples em todas as plataformas-alvo.

- **A interface própria do Clipper era a tela de texto.** O CA-Clipper
  executava em "IBM-PC-type personal computers running DOS-like operating
  systems" [1] (tradução livre: "computadores pessoais do tipo IBM-PC com
  sistemas operacionais semelhantes ao DOS"); suas telas eram telas de texto
  desenhadas com comandos como `@...SAY` e `@...GET` [9]. O Harbour
  reproduz isso por meio de seus drivers de terminal (GT), como mostra a
  versão cli.
- **As opções de GUI e web do Harbour são bibliotecas contrib opcionais.** A
  árvore de código-fonte da 3.2.0 tem terminais GUI, como `gtqtc` (Qt) e
  `gtwvg` (somente Windows), e uma biblioteca de servidor HTTP, `hbhttpd`,
  em `contrib/` [6]. Elas exigem bibliotecas adicionais do sistema (Qt para
  o `gtqtc`) e não fazem parte do núcleo que o `install.sh` compila
  (`HB_BUILD_CONTRIBS=no`). Um Hello World desktop ou web seria
  principalmente código de ligação em torno delas, e não Clipper; por isso,
  foi deixado de fora.

## Fontes
1. Clipper FAQ, part 3: "About Clipper and Visual Objects" (as of March 1998). The Oasis archive, hosted by the Harbour project. <https://harbour.github.io/the-oasis/docs/clipper-3.html> (acessado em 2026-11-01)
2. Harbour home page (features, project status, license summary). Harbour project. <https://harbour.github.io/> (acessado em 2026-11-01)
3. The CA-Clipper Story. Greg Holmes, The Holmes Page (a third-party history, not a vendor document). <https://ghservices.com/gregh/clipper/story.htm> (acessado em 2026-11-01)
4. "Nantucket After Computer Associates". CBR (Computer Business Review), 1992-06-01, archived by Tech Monitor. <https://www.techmonitor.ai/?p=171092> (acessado em 2026-11-01)
5. Harbour README. Harbour project, GitHub. <https://github.com/harbour/core> (acessado em 2026-11-01)
6. Release v3.2.0 (2026-07-07). Harbour project, GitHub. <https://github.com/harbour/core/releases/tag/v3.2.0> (acessado em 2026-11-01)
7. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-01)
8. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-01)
9. CA-Clipper 5.3 reference (commands and functions, RDDs). Computer Associates documentation, hosted by the Harbour project. <https://harbour.github.io/doc/clc53.html> (acessado em 2026-11-01)
