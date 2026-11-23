---
source: languages/fortran/README.md
source_sha: d8617487f037e922587661497b70d22455d62220
---
# Fortran

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** imperativo (procedural), com módulos e operações sobre
arrays. Desde o Fortran 2003, também oferece suporte à orientação a objetos
("the major changes concern object orientation and interfacing with C" [1],
tradução livre: "as principais mudanças dizem respeito à orientação a
objetos e à interface com C"). O Fortran foi criado para o trabalho
numérico: o site da Fortran-lang diz que ela "has been designed from the
ground up for computationally intensive applications in science and
engineering" [2] (tradução livre: "foi projetada desde a base para
aplicações computacionalmente intensivas em ciência e engenharia").

Ver também: [paradigmas](../../docs/paradigms.md#imperative) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | GFortran (`gfortran`) | ✅ |
| desktop | – | não implementado, ver [Por que não há versão desktop nem web](#por-que-não-há-versão-desktop-nem-web) | – |
| web | – | não implementado, mesma seção | – |

## Histórico
O Fortran é mais antigo do que as duas linguagens com que é comparado
adiante ([COBOL](../cobol/README.md), 1959–1960, e [Ada](../ada/README.md),
1983). A página de história da IBM diz que John Backus, na IBM, queria que
os programas fossem escritos em algo semelhante à notação matemática: "In
1953, he was given a budget to hire a small team to test the feasibility of
that notion" [3] (tradução livre: "Em 1953, ele recebeu um orçamento para
contratar uma pequena equipe e testar a viabilidade dessa ideia"). O
"Preliminary Report: Specifications for the IBM Mathematical FORmula
TRANslating System, FORTRAN" da equipe é datado de 1954-11-10, e o primeiro
*Programmer's Reference Manual* é datado de 1956-10-15 [4]. "In 1957, the
IBM Mathematical Formula Translating System, or Fortran, debuted. Soon
after, IBM made the first Fortran compiler available to users of the IBM
704" [3] (tradução livre: "Em 1957, o IBM Mathematical Formula Translating
System, ou Fortran, estreou. Pouco depois, a IBM disponibilizou o primeiro
compilador Fortran aos usuários do IBM 704"); ele "was shipped in April
1957" [4] (tradução livre: "foi distribuído em abril de 1957").

O Fortran se espalhou rapidamente: "By the mid-1960s, Fortran had become the
first national computing standard" [3] (tradução livre: "Em meados da década
de 1960, o Fortran havia se tornado o primeiro padrão nacional de
computação"), o ANSI X3.9-1966, conhecido como FORTRAN 66 [5]. Seguiram-se o
FORTRAN 77 (ISO 1539-1980 [6]), o Fortran 90 (ISO/IEC 1539:1991 [5]) e o
Fortran 95 [5]. O Fortran 2003 acrescentou a orientação a objetos e a
interoperabilidade com C [1], o Fortran 2008 acrescentou os coarrays para
programas paralelos [7], e o padrão atual é o Fortran 2023, "published
November 2023" [8] (tradução livre: "publicado em novembro de 2023"). O
comitê já trabalha no próximo: o WG5 lista um "Fortran 2028 Committee
Draft" (2026) [9].

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1953 | John Backus recebe um orçamento e uma pequena equipe na IBM | [3] |
| 1954-11-10 | *Preliminary Report: Specifications for ... FORTRAN* | [4] |
| 1957-04 | O primeiro compilador FORTRAN é distribuído para o IBM 704 | [3][4] |
| 1966 | FORTRAN 66 (ANSI X3.9-1966), "the first national computing standard" (o primeiro padrão nacional de computação) | [3][5] |
| 1978 / 1980 | FORTRAN 77 (ANSI e depois ISO 1539-1980) | [5][6] |
| 1991 | Fortran 90 (ISO/IEC 1539:1991) | [5] |
| 1997 | Fortran 95 (ISO/IEC 1539:1997) | [5] |
| 2004 | Fortran 2003 (ISO/IEC 1539:2004): orientação a objetos, interoperabilidade com C | [1][10] |
| 2010 | Fortran 2008 (ISO/IEC 1539:2010): coarrays; o padrão usado em [cli](cli/) | [7][11] |
| 2018 | Fortran 2018 ("Formerly Fortran 2015", ou seja, anteriormente Fortran 2015) | [12] |
| 2023-11 | Fortran 2023 (ISO/IEC 1539:2023), o padrão atual | [8] |

## Uso no mercado hoje
Cada número abaixo tem data e fonte. Eles mudam a cada ano.

- **Índice TIOBE, outubro de 2026:** o Fortran é o nº 13, com taxa de 1,12%.
  Era o nº 11 em outubro de 2025 [13].
- **Stack Overflow Developer Survey 2026:** 1,7% de todos os respondentes da
  pergunta sobre linguagens de programação usaram Fortran (239 de 14.099)
  [14].

Os dois números medem coisas diferentes: o TIOBE conta resultados de
mecanismos de busca, e a pesquisa do Stack Overflow conta os desenvolvedores
que a responderam.

## Importância antes e agora
- **Antes (1957 até a década de 1970):** a IBM escreve que o Fortran
  "democratized computer programming by providing scientists, mathematicians
  and engineers the ability to input their problems directly into the
  computer without relying on a programmer" (tradução livre: "democratizou a
  programação de computadores ao dar a cientistas, matemáticos e engenheiros
  a capacidade de inserir seus problemas diretamente no computador sem
  depender de um programador") e que ele "greatly increased programmer
  productivity and significantly lowered costs" [3] (tradução livre:
  "aumentou muito a produtividade dos programadores e reduziu
  significativamente os custos").
- **Agora:** o site da Fortran-lang descreve o Fortran como uma
  "High-performance parallel programming language" (tradução livre:
  "linguagem de programação paralela de alto desempenho") e diz que "Fortran
  is mature and under active development" [2] (tradução livre: "o Fortran é
  maduro e está em desenvolvimento ativo"). O padrão continua sendo revisado
  (Fortran 2023 [8], um rascunho de comitê de 2028 [9]).
- **No ensino:** o Fortran mostra duas eras da programação em uma só
  linguagem. A versão [`cli`](cli/) usa o formato livre moderno; o formato
  fixo `.f` da era dos cartões perfurados [15] segue a mesma ideia das
  regras de coluna do [`cli` em COBOL](../cobol/cli/). O espaço em branco
  inicial que `print *` escreve (ver o
  [passo a passo do `cli`](cli/README.md#step-by-step-walkthrough)) mostra
  que até uma única linha de saída segue regras escritas no padrão.

## Comparação entre as categorias
O Fortran tem aqui uma única categoria, `cli`; por isso, esta seção o compara
com duas outras linguagens mais antigas deste repositório que compilam para
um executável nativo:

| | [COBOL cli](../cobol/cli/) | [Fortran cli](cli/) | [Ada cli](../ada/cli/) |
|---|---|---|---|
| Instrução que imprime | `DISPLAY "Hello, World!".` | `print '(a)', "Hello, World!"` | `Ada.Text_IO.Put_Line ("Hello, World!");` |
| Sintaxe de comentário | `*` na coluna 7 | `!` até o fim da linha | `--` até o fim da linha |
| Diferencia maiúsculas de minúsculas? | não | não | não |
| Cabeçalho do programa | `PROGRAM-ID. HELLO.` | `program hello` | `procedure Hello is` |
| Compilador | GnuCOBOL (COBOL → C) | GFortran (GCC) | GNAT (GCC) via Alire |

## Por que não há versão desktop nem web
Este repositório inclui uma categoria somente se existir, para ela, uma
toolchain mantida, convencional e razoavelmente simples em todas as
plataformas-alvo. Para o Fortran, não existe essa toolchain nas categorias
desktop e web:

- **Desktop: apenas bindings para toolkits em C.** O índice de pacotes do
  site da Fortran-lang tem uma categoria "Graphics, plotting and user
  interfaces" [16]. Suas entradas de interface gráfica do usuário (GUI) são
  bindings: o `gtk-fortran` ("A cross-platform library to build Graphical
  User Interfaces (GUI)", tradução livre: "uma biblioteca multiplataforma
  para criar interfaces gráficas do usuário (GUI)"), bindings Fortran 2008
  para X/Motif e interfaces de binding ISO C para Xlib [17]. O
  `gtk-fortran` é mantido ("A GTK / Fortran binding" [18], tradução livre:
  "um binding GTK / Fortran"), mas exige que a biblioteca C GTK seja
  instalada antes e a chama por meio da interoperabilidade com C: o estudante
  instalaria e aprenderia o GTK (como na versão [desktop em C](../c/desktop/))
  mais o binding, antes de qualquer Fortran.
- **Web: nenhum framework web no índice de pacotes.** O índice não tem
  categoria de web nem de servidor HTTP [16]; portanto, não há uma forma
  convencional de servir uma página a partir do Fortran.
- **Adequação ao uso da linguagem:** o Fortran destina-se a "computationally
  intensive applications in science and engineering" [2] (tradução livre:
  "aplicações computacionalmente intensivas em ciência e engenharia"), e seu
  padrão define entrada e saída para arquivos e registros [6], não para
  janelas nem para HTTP.

O Hello World em Fortran é, portanto, apenas um programa de linha de comando.

## Fontes
1. The New Features of Fortran 2003 (WG5 N1648). John Reid. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/N1601-N1650/N1648.pdf> (acessado em 2026-11-01)
2. The Fortran Programming Language (home page and FAQ). Fortran-lang. <https://fortran-lang.org/> (acessado em 2026-11-01)
3. Fortran. IBM Heritage. <https://www.ibm.com/history/fortran> (acessado em 2026-11-01)
4. History of FORTRAN and FORTRAN II. Computer History Museum, Software Preservation Group. <https://softwarepreservation.computerhistory.org/FORTRAN/> (acessado em 2026-11-01)
5. Earlier Fortran standards (FORTRAN 66, FORTRAN 77, Fortran 90, Fortran 95). ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/fearlier.html> (acessado em 2026-11-01)
6. Fortran 2018 working draft J3/18-007r1, 4.3.1 (table of earlier standards). INCITS/Fortran (J3). <https://j3-fortran.org/doc/year/18/18-007r1.pdf> (acessado em 2026-11-01)
7. Coarrays in the next Fortran Standard (WG5 N1824). John Reid. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/N1801-N1850/N1824.pdf> (acessado em 2026-11-01)
8. Fortran 2023. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/f2023.html> (acessado em 2026-11-01)
9. WG5 home page (news: N2258 Fortran 2028 Committee Draft). ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/> (acessado em 2026-11-01)
10. Fortran 2003. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/f2003.html> (acessado em 2026-11-01)
11. Fortran 2008. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/f2008.html> (acessado em 2026-11-01)
12. Fortran 2018. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/f2018.html> (acessado em 2026-11-01)
13. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-01)
14. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-01)
15. GNU Fortran and GCC (source form by file extension). GCC. <https://gcc.gnu.org/onlinedocs/gfortran/GNU-Fortran-and-GCC.html> (acessado em 2026-11-01)
16. Fortran packages (categories). Fortran-lang. <https://fortran-lang.org/packages/> (acessado em 2026-11-01)
17. Graphics, plotting and user interfaces. Fortran-lang. <https://fortran-lang.org/packages/graphics/> (acessado em 2026-11-01)
18. `vmagnin/gtk-fortran`. GitHub. <https://github.com/vmagnin/gtk-fortran> (acessado em 2026-11-01)
