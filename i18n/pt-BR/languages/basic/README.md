---
source: languages/basic/README.md
source_sha: 83a4283b1ff7a9dd2c1f425bea6e1711c8aff043
---
# BASIC

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** imperativo (procedural). Um programa BASIC clássico é uma
lista de instruções executadas de cima para baixo, com `GOTO`/`GOSUB` e, em
dialetos posteriores como o QBasic, procedimentos `SUB` e `FUNCTION`. O nome
vem de "Beginner's All-purpose Symbolic Instruction Code" [1] (tradução
livre: "Código de Instruções Simbólicas de Uso Geral para Principiantes"): a
linguagem foi criada para o aprendizado. Dialetos posteriores da Microsoft
cresceram em outras direções: o Visual Basic (1991), para programas Windows
[6], e depois o Visual Basic .NET, uma linguagem da plataforma .NET da
Microsoft [8]. O Hello World deste repositório usa o dialeto clássico e
procedural QBasic.

Veja também: [paradigmas](../../docs/paradigms.md#imperative) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | QB64 Phoenix Edition | ✅ |
| desktop | – | não implementada, veja [Por que não há versão desktop nem web](#por-que-não-há-versão-desktop-nem-web) | – |
| web | – | não implementada, mesma seção | – |

## História
O BASIC nasceu no Dartmouth College. "At 4 a.m. on May 1, 1964, in the
basement of College Hall, Professor John Kemeny and a student programmer
simultaneously typed RUN on neighboring terminals. When they both got back
correct answers to their simple programs, time-sharing and BASIC were
born" [1] (tradução livre: "Às 4 horas da manhã de 1º de maio de 1964, no
porão do College Hall, o professor John Kemeny e um estudante programador
digitaram RUN simultaneamente em terminais vizinhos. Quando ambos obtiveram
respostas corretas para seus programas simples, nasceram o tempo
compartilhado e o BASIC"). Kemeny e Thomas Kurtz "wanted to create a language
their students could learn quickly for use on the timesharing system" [2]
(tradução livre: "queriam criar uma linguagem que seus alunos pudessem
aprender rapidamente para usar no sistema de tempo compartilhado"), e o
resultado "made computing accessible to all Dartmouth students and
faculty, and soon after, to people across the nation and the world" [1]
(tradução livre: "tornou a computação acessível a todos os estudantes e
docentes de Dartmouth e, logo depois, a pessoas de todo o país e do mundo").

O BASIC se espalhou em muitos dialetos incompatíveis, e por isso órgãos de
padronização tentaram fixar um núcleo comum. A ECMA publicou o **Minimal
BASIC** (ECMA-55) em janeiro de 1978, "designed to promote the
interchangeability of BASIC programs among a variety of automatic data
processing systems" [3] (tradução livre: "projetado para promover a
intercambiabilidade de programas BASIC entre diversos sistemas automáticos
de processamento de dados"), e um padrão **BASIC** completo (ECMA-116) em
junho de 1986 [4]. Nos Estados Unidos, o NIST adotou "American National
Standard for BASIC, ANSI X3.113-1987" (tradução livre: "Padrão Nacional
Americano para BASIC, ANSI X3.113-1987") como padrão federal, substituindo
seu padrão anterior, o Minimal BASIC [5].

Nos computadores pessoais, os dialetos mais difundidos vieram da Microsoft.
O **QBasic** acompanhava o MS-DOS 5.0: no MS-DOS "versions 5.0 and later"
(tradução livre: "versões 5.0 e posteriores"), até o editor de texto
`EDIT.COM` "invokes QBASIC.EXE with the /EDITOR switch" [7] (tradução livre:
"invoca o QBASIC.EXE com a opção /EDITOR"). Em "May 20th, 1991 at Windows
World, in Atlanta, Microsoft founder Bill Gates demoed Visual Basic 1.0" [6]
(tradução livre: "20 de maio de 1991, na Windows World, em Atlanta, o
fundador da Microsoft, Bill Gates, demonstrou o Visual Basic 1.0"), que levou
o BASIC à programação para Windows. Em 2020, a Microsoft anunciou, a respeito
do Visual Basic .NET: "Going forward, we do not plan to evolve Visual Basic
as a language" [8] (tradução livre: "Daqui em diante, não planejamos evoluir
o Visual Basic como linguagem").

O dialeto QBasic sobrevive em compiladores de código aberto. O **QB64
Phoenix Edition**, usado aqui, "retains QB4.5/QBasic compatibility"
(tradução livre: "mantém a compatibilidade com o QB4.5/QBasic") e compila
programas nativos para Windows, Linux e macOS. O Phoenix Edition foi
"created when the old project related pages went offline in April 2022"
(tradução livre: "criado quando as antigas páginas relacionadas ao projeto
saíram do ar em abril de 2022") e continua a mesma linguagem QB64 [9]. O
**FreeBASIC** é outro exemplo: ele "provides a high level of support for
programs written for QuickBASIC" [10] (tradução livre: "oferece um alto
nível de suporte a programas escritos para o QuickBASIC").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1964-05-01 | Os primeiros programas BASIC são executados em Dartmouth (Kemeny, Kurtz e estudantes) | [1] |
| 1978-01 | ECMA-55 Minimal BASIC | [3] |
| 1986-06 | ECMA-116 BASIC (BASIC completo) | [4] |
| 1987 | ANSI X3.113-1987 BASIC, adotado pelo NIST como FIPS PUB 68-2 | [5] |
| MS-DOS 5.0 | O QBasic passa a acompanhar o MS-DOS | [7] |
| 1991-05-20 | Visual Basic 1.0 demonstrado por Bill Gates | [6] |
| 2020-03-11 | Microsoft: sem planos de evoluir mais a linguagem Visual Basic | [8] |
| 2022-04 | Formação do QB64 Phoenix Edition | [9] |
| 2026-09-26 | QB64-PE 4.7.0, o compilador usado em [cli](cli/) | [11] |

## Uso de mercado hoje
Cada número abaixo traz sua data e sua fonte. Eles mudam todos os anos.

- **Índice TIOBE, outubro de 2026:** "Visual Basic" (nome que o TIOBE usa
  para o Visual Basic .NET) ocupa a 7ª posição, com 2,20%, e "Classic Visual
  Basic" ocupa a 24ª, com 0,70% [12]. O TIOBE explica que, até 2010,
  "(Visual) Basic" "referred to all possible dialects of Basic" (tradução
  livre: "referia-se a todos os dialetos possíveis do Basic"), e que depois
  foi dividido "into all its dialects such as Visual Basic .NET, Classic
  Visual Basic, PureBasic, and Small Basic" [12] (tradução livre: "em todos
  os seus dialetos, como Visual Basic .NET, Classic Visual Basic, PureBasic e
  Small Basic").
- **Stack Overflow Developer Survey 2026:** 4,0% de todos os respondentes da
  pergunta sobre linguagens de programação usaram Visual Basic (.Net) (557 de
  14.099), e 3,9% usaram VBA, a linguagem de macros Visual Basic for
  Applications do Microsoft Office (552 de 14.099) [13]. O BASIC no estilo
  QBasic não consta da lista.

Assim, "BASIC" hoje significa, em sua maior parte, a família Visual Basic da
Microsoft. O dialeto QBasic deste projeto é uma linguagem de ensino e de
passatempo, sem números próprios em pesquisas.

## Importância antes e agora
- **Antes:** o BASIC tornou a programação acessível a pessoas que não eram
  especialistas em computação, primeiro no sistema de tempo compartilhado de
  Dartmouth [1][2] e depois nos computadores pessoais, nos quais o QBasic
  acompanhava o MS-DOS 5.0 e as versões posteriores [7].
- **Agora:** o Visual Basic .NET e o VBA ainda figuram entre as linguagens
  de uso comum [12][13], embora a Microsoft não evolua mais o Visual Basic
  como linguagem [8]. O dialeto clássico sobrevive por meio de compiladores
  como o QB64-PE (lançado em 2026-09-26 [11]) e o FreeBASIC [10].
- **No ensino:** o programa [cli](cli/hello.bas) é uma única instrução
  `PRINT`, sem `main`, cabeçalho ou declarações. Compare-o com o de
  [C](../c/cli/hello.c), que precisa de um `#include`, de uma função `main` e
  de chaves antes de conseguir imprimir qualquer coisa.

## Comparação entre as categorias
O BASIC tem aqui uma única categoria, cli. A comparação útil é com a outra
linguagem da era do MS-DOS deste repositório, o Clipper, e com o programa cli
em C:

| | [BASIC cli](cli/) | [Clipper cli](../clipper/cli/) | [C cli](../c/cli/) |
|---|---|---|---|
| Linhas de código (sem comentários) | 3 | 4 | 5 |
| Instrução que imprime | `PRINT "Hello, World!"` | `?? "Hello, World!"` e depois `?` | `printf("Hello, World!\n");` |
| Ponto de entrada | primeira instrução do arquivo | `PROCEDURE Main()` | `int main(void)` |
| Encerramento do programa | `SYSTEM` (caso contrário, o QB64 espera uma tecla) | `RETURN` de `Main()` | `return 0;` |
| Compilador | QB64-PE: BASIC → C++ → código de máquina | Harbour: Clipper → C (pcode) → código de máquina | clang: C → código de máquina |

## Por que não há versão desktop nem web
Este repositório tem apenas a versão cli do BASIC. Uma categoria só é mantida
se existir para ela uma toolchain mantida, de uso comum e razoavelmente
simples em todas as plataformas-alvo.

- **Desktop:** o dialeto clássico não tem toolkit de GUI. Um programa
  QB64-PE sem `$CONSOLE:ONLY` abre sua "graphical program window" [14]
  (tradução livre: "janela gráfica do programa"), uma tela na qual o programa
  imprime e desenha. Ela não tem botões, menus nem rótulos e, por isso, não é
  uma GUI desktop no sentido das pastas desktop das outras linguagens. Um
  BASIC desktop hoje seria o Visual Basic .NET com Windows Forms ou WPF, que
  funcionam apenas no Windows. Essa é a mesma pilha .NET da versão
  [C# desktop](../csharp/desktop/).
- **Web:** o QBasic e o QB64-PE não têm framework web. Servir HTTP a partir
  do BASIC significaria escrever o protocolo manualmente sobre sockets
  brutos, o que deixa de ser um Hello World simples.

## Fontes
1. BASIC Begins at Dartmouth. Dartmouth College, BASIC at 50. <https://www.dartmouth.edu/basicfifty/basic.html> (acessado em 2026-11-01)
2. May 1, 1964: First BASIC program runs. Computer History Museum, This Day in History. <https://www.computerhistory.org/tdih/may/1/> (acessado em 2026-11-01)
3. ECMA-55 Minimal BASIC, 1st edition (January 1978). Ecma International. <https://ecma-international.org/publications-and-standards/standards/ecma-55/> (acessado em 2026-11-01)
4. ECMA-116 BASIC, 1st edition (June 1986). Ecma International. <https://ecma-international.org/publications-and-standards/standards/ecma-116/> (acessado em 2026-11-01)
5. FIPS PUB 68-2, BASIC (adopts ANSI X3.113-1987), August 1987. National Institute of Standards and Technology. <https://nvlpubs.nist.gov/nistpubs/Legacy/FIPS/fipspub68-2-Aug1987.pdf> (acessado em 2026-11-01)
6. Happy 20th Birthday, Visual Basic! (2011-05-20). Microsoft Visual Basic Team Blog. <https://devblogs.microsoft.com/vbteam/happy-20th-birthday-visual-basic/> (acessado em 2026-11-01)
7. `EDIT.COM` Cannot Find `QBASIC.EXE` (KB 63777). Microsoft Knowledge Base, archived copy. <https://ftp.zx.net.nz/pub/archive/ftp.microsoft.com/MISC/KB/en-us/63/777.HTM> (acessado em 2026-11-01)
8. Visual Basic support planned for .NET 5.0 (2020-03-11). Microsoft .NET Blog. <https://devblogs.microsoft.com/vbteam/visual-basic-support-planned-for-net-5-0/> (acessado em 2026-11-01)
9. QB64 Phoenix Edition README. QB64-PE project, GitHub. <https://github.com/QB64-Phoenix-Edition/QB64pe> (acessado em 2026-11-01)
10. FreeBASIC home page. FreeBASIC project. <https://www.freebasic.net/> (acessado em 2026-11-01)
11. Release v4.7.0-GLFW (2026-09-26). QB64-PE project, GitHub. <https://github.com/QB64-Phoenix-Edition/QB64pe/releases/tag/v4.7.0-GLFW> (acessado em 2026-11-01)
12. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-01)
13. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-01)
14. $CONSOLE. QB64 Phoenix Edition Wiki. <https://qb64phoenix.com/qb64wiki/index.php/$CONSOLE> (acessado em 2026-11-01)
