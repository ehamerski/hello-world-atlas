---
source: languages/cobol/README.md
source_sha: 1b528c6af1334511d7495fc1ad8f1b79ab389012
---
# COBOL

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** imperativo (procedural). Um programa COBOL é uma sequência de
instruções organizadas em divisões, seções e parágrafos. O padrão de 2002
acrescentou a orientação a objetos [5], mas o Hello World deste repositório
usa o COBOL-85 procedural. O nome vem de "Common business-oriented
language" [3] (tradução livre: "linguagem comum orientada a negócios"): ela
foi projetada para "business data processing applications" [1] (tradução
livre: "aplicações de processamento de dados comerciais"), com instruções
que se leem como frases em inglês (`DISPLAY "Hello, World!".`).

Ver também: [paradigmas](../../docs/paradigms.md#imperative) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | GnuCOBOL | ✅ |
| desktop | – | não implementado, ver [Por que não há versão desktop nem web](#por-que-não-há-versão-desktop-nem-web) | – |
| web | – | não implementado, mesma seção | – |

## Histórico
O COBOL foi criado por um comitê, não por uma empresa nem por um único
autor. O apêndice histórico do padrão ANSI COBOL diz: "On May 28 and 29, 1959,
a meeting was held in the Pentagon for the purpose of considering both the
desirability and the feasibility of establishing a common language for the
programming of electronic computers for business-type applications" [2]
(tradução livre: "Em 28 e 29 de maio de 1959, realizou-se uma reunião no
Pentágono com o objetivo de considerar a conveniência e a viabilidade de
estabelecer uma linguagem comum para a programação de computadores
eletrônicos em aplicações do tipo comercial"). Os participantes concordaram
"that it should be problem-oriented and machine-independent, and that it
should use simple English or pseudo-English and avoid symbolism as far as
possible" [1] (tradução livre: "que ela deveria ser orientada ao problema e
independente de máquina, e que deveria usar inglês simples ou pseudoinglês
e evitar o simbolismo tanto quanto possível"). "The Conference on DAta
SYstems Languages (CODASYL) developed out of this meeting" [1] (tradução
livre: "A Conference on DAta SYstems Languages (CODASYL) surgiu dessa
reunião").

A linguagem foi descrita em "a report published in April of 1960 by the
Government Printing Office" que "has since become known as COBOL-60" [2]
(tradução livre: "um relatório publicado em abril de 1960 pela Government
Printing Office", que "passou a ser conhecido como COBOL-60"). O padrão
lista as linguagens anteriores em que se baseou, a começar por "FLOW-MATIC
(trademark of Sperry Rand Corporation), Programming for the UNIVAC® I and
II" [2]. A IBM descreve o COBOL como "Partly derived from FLOW-MATIC, a
language created by computer science pioneer Dr. Grace Hopper" [3]
(tradução livre: "Derivada em parte do FLOW-MATIC, uma linguagem criada
pela pioneira da ciência da computação Dra. Grace Hopper").

O COBOL tornou-se então um padrão nacional. O primeiro foi aprovado "on
August 23, 1968, as a USA Standard" (X3.23-1968) [2] (tradução livre: "em
23 de agosto de 1968, como um padrão dos EUA"), revisado em 1974 [2] e em
1985, quando "This standard has been adopted as ISO International Standard
1989-1985" [1] (tradução livre: "Este padrão foi adotado como o Padrão
Internacional ISO 1989-1985"). O padrão ISO foi revisado desde então:
ISO/IEC 1989:2002 (com objetos e classes) [5], ISO/IEC 1989:2014 [6] e o
atual ISO/IEC 1989:2023 [7].

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1959-05-28/29 | Reunião no Pentágono sobre uma linguagem comercial comum; criação do CODASYL | [1][2] |
| 1960-04 | Relatório COBOL-60 publicado pela US Government Printing Office | [2] |
| 1961 / 1963 | COBOL-61 e COBOL-61 Extended | [2] |
| 1968-08-23 | Primeiro padrão, USA Standard X3.23-1968 | [2] |
| 1974-05-10 | ANSI X3.23-1974 | [2] |
| 1985-09-10 | ANSI X3.23-1985 (COBOL-85), adotado como ISO 1989:1985; o padrão usado em [cli](cli/) | [1] |
| 2002-12-01 | ISO/IEC 1989:2002: objetos e classes | [5] |
| 2014 | ISO/IEC 1989:2014 (idêntico ao ANSI INCITS 1989-2014) | [6] |
| 2023-01 | ISO/IEC 1989:2023, a edição atual | [7] |
| 2023-07-28 | GnuCOBOL 3.2, o compilador usado aqui | [8] |

## Uso no mercado hoje
Cada número abaixo tem data e fonte. Eles mudam a cada ano.

- **Índice TIOBE, outubro de 2026:** o COBOL é o nº 16, com taxa de 0,89%.
  Era o nº 23 em outubro de 2025 [9].
- **Stack Overflow Developer Survey 2026:** 1,1% de todos os respondentes da
  pergunta sobre linguagens de programação usaram COBOL (150 de 14.099) [10].
- **Números da IBM** (afirmações de um fornecedor, não uma pesquisa
  independente): a IBM escreve que o COBOL "serves as the foundation for more
  than 40% of all online banking systems", "supports 80% of in-person credit
  card transactions, handles 95% of all ATM transactions, and powers systems
  that generate more than USD 3 billion of commerce each day" [3] (tradução
  livre: "serve de base para mais de 40% de todos os sistemas bancários
  online", "oferece suporte a 80% das transações presenciais com cartão de
  crédito, processa 95% de todas as transações em caixas eletrônicos e
  movimenta sistemas que geram mais de 3 bilhões de dólares americanos em
  comércio por dia").

Os dois tipos de números medem coisas diferentes. As pesquisas contam
desenvolvedores ou buscas na web, e poucos desenvolvedores escrevem COBOL.
Os números da IBM contam as transações comerciais executadas em sistemas
COBOL existentes.

## Importância antes e agora
- **Antes (décadas de 1960 a 1980):** o COBOL era uma linguagem única para
  programas comerciais em computadores de fabricantes diferentes
  ("machine-independent" [1], ou seja, independente de máquina), apoiada
  pelo governo dos EUA (a reunião de 1959 foi realizada no Pentágono [2]) e
  padronizada pela ANSI a partir de 1968 [2].
- **Agora:** segundo a IBM [3], o COBOL continua executando sistemas
  bancários centrais e de pagamentos, e ainda está sendo padronizado
  (ISO/IEC 1989:2023 [7]). As pesquisas com desenvolvedores mostram poucas
  pessoas escrevendo nessa linguagem [10].
- **No ensino:** o COBOL mostra a era dos cartões perfurados no próprio
  código-fonte: colunas fixas, um marcador de comentário na coluna 7 e
  palavras em inglês para tudo (compare com [C](../c/cli/hello.c), em que o
  programa é feito de símbolos e chaves). Seu compilador também mostra uma
  técnica comum: o GnuCOBOL traduz o COBOL para C e deixa o restante para um
  compilador C [4].

## Comparação entre as categorias
O COBOL tem aqui uma única categoria, cli; por isso, a comparação útil é
com as outras duas linguagens mais antigas deste repositório que compilam
para um executável nativo:

| | [COBOL cli](cli/) | [Fortran cli](../fortran/cli/) | [Ada cli](../ada/cli/) |
|---|---|---|---|
| Primeira versão | COBOL-60 (1960) | FORTRAN (1957) | Ada 83 (1983) |
| Projetada para | processamento de dados comerciais | computação científica | sistemas grandes e críticos para a segurança |
| Instrução que imprime | `DISPLAY "Hello, World!".` | `print '(a)', "Hello, World!"` | `Ada.Text_IO.Put_Line ("Hello, World!");` |
| Layout do código-fonte | colunas fixas (COBOL-85) | formato livre (Fortran 2008) | formato livre |
| Compilador | GnuCOBOL: COBOL → C → código de máquina | GFortran (GCC) | GNAT (GCC) via Alire |

## Por que não há versão desktop nem web
Este repositório não tem versão desktop nem web do COBOL. Uma categoria só
permanece se existir, para ela, uma toolchain mantida, convencional e
razoavelmente simples em todas as plataformas-alvo. O GnuCOBOL não tem:

- **Nenhuma GUI no produto.** O FAQ do GnuCOBOL responde "Does GnuCOBOL
  support a GUI?" (tradução livre: "O GnuCOBOL oferece suporte a uma GUI?")
  com: "Yes, but not out of the box. There is not currently (March 2018)
  anything that ships with the product. Third party extensions for Tcl/Tk and
  linkage to GTK+ and other frameworks do allow for graphical user
  interfaces" [4] (tradução livre: "Sim, mas não de imediato. Atualmente
  (março de 2018) não há nada que acompanhe o produto. Extensões de
  terceiros para Tcl/Tk e a ligação com GTK+ e outros frameworks permitem
  interfaces gráficas do usuário"). Um programa desktop em COBOL consistiria
  principalmente em chamadas a um toolkit C por meio de código de ligação
  de terceiros.
- **As telas do próprio COBOL são telas de texto.** A SCREEN SECTION da
  linguagem destina-se a "text-based screens, as is a typical function on
  mainframe and midframe computers" [11] (tradução livre: "telas baseadas em
  texto, como é típico em computadores de grande e médio porte"), desenhadas
  no terminal ("ncurses can be used to implement SCREEN SECTION" [4],
  tradução livre: "o ncurses pode ser usado para implementar a SCREEN
  SECTION"). Isso continua sendo um programa de terminal, não uma janela
  desktop.
- **Nenhum framework web.** O FAQ diz que o GnuCOBOL "is more than capable of
  supporting advanced Common Gateway Interface programming" [4] (tradução
  livre: "é mais do que capaz de oferecer suporte à programação avançada de
  Common Gateway Interface"). Um programa CGI não serve HTTP por conta
  própria: é preciso instalar e configurar um servidor web separado para
  iniciá-lo a cada requisição. O GnuCOBOL não inclui servidor web nem
  framework web próprio.

Assim, o Hello World em COBOL continua sendo um programa cli. Isso também
corresponde à forma como a IBM descreve o trabalho típico do COBOL hoje:
"batch processing jobs, like processing financial transactions, managing
databases and generating reports" [3] (tradução livre: "tarefas de
processamento em lote, como o processamento de transações financeiras, o
gerenciamento de bancos de dados e a geração de relatórios").

## Fontes
1. FIPS PUB 21-2, COBOL (ANSI X3.23-1985, ISO 1989-1985), Appendix "Development of COBOL". National Institute of Standards and Technology, 1986. <https://nvlpubs.nist.gov/nistpubs/Legacy/FIPS/fipspub21-2.pdf> (acessado em 2026-11-01)
2. FIPS PUB 21-1, COBOL (ANSI X3.23-1974), Appendix "History of COBOL". National Institute of Standards and Technology. <https://nvlpubs.nist.gov/nistpubs/Legacy/FIPS/fipspub21-1.pdf> (acessado em 2026-11-01)
3. What is COBOL? IBM Think (updated 2026-02-25). <https://www.ibm.com/think/topics/cobol> (acessado em 2026-11-01)
4. GnuCOBOL FAQ. GnuCOBOL project. <https://gnucobol.sourceforge.io/faq/index.html> (acessado em 2026-11-01)
5. ISO/IEC 1989:2002 Information technology — Programming languages — COBOL, sample pages (first edition 2002-12-01; contents "9.3 Objects", "9.3.1 Objects and classes"). ISO, via iTeh Standards. <https://cdn.standards.iteh.ai/samples/28805/3eea529d195e4bc0a570738daa1e8b5d/ISO-IEC-1989-2002.pdf> (acessado em 2026-11-01)
6. Enterprise COBOL for z/OS 6.4: Industry specifications. IBM. <https://www.ibm.com/docs/en/cobol-zos/6.4.0?topic=appendixes-industry-specifications> (acessado em 2026-11-01)
7. ISO/IEC 1989:2023 Programming language COBOL (catalog entry). AFNOR. <https://www.boutique.afnor.org/en-gb/standard/iso-iec-19892023/information-technology-programming-languages-their-environments-and-system-/xs140772/341896> (acessado em 2026-11-01)
8. GnuCOBOL (home page, releases). GnuCOBOL project. <https://gnucobol.sourceforge.io/> (acessado em 2026-11-01)
9. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-01)
10. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-01)
11. GnuCOBOL Programmer's Guide (SCREEN SECTION). Gary L. Cutler. <https://gnucobol.sourceforge.io/HTML/gnucobpg.html> (acessado em 2026-11-01)
