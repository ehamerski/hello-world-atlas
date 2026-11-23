---
source: languages/ada/README.md
source_sha: 0b9cfc42adf5daa9c23c336f8ef56c33406b8098
---
# Ada

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** imperativo, com módulos (pacotes) e, desde o Ada 95,
programação orientada a objetos. A Ada Resource Association afirma que o
Ada 95 tornou a Ada "the world's first internationally standardized object
oriented language" [1] (tradução livre: "a primeira linguagem orientada a
objetos padronizada internacionalmente no mundo"). A Ada é usada onde o
software precisa ser seguro ("These applications require a high degree of
safety" [10], em tradução livre: "Essas aplicações exigem um alto grau de
segurança"), e seu compilador realiza muitas verificações: na versão
[cli](cli/), até um nome de procedimento escrito incorretamente é
reportado com uma sugestão de correção.

Veja também: [paradigmas](../../docs/paradigms.md#imperative) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | GNAT via Alire | ✅ |
| desktop | – | não implementada, veja [Por que não há versão desktop nem web](#por-que-não-há-versão-desktop-nem-web) | – |
| web | – | não implementada, mesma seção | – |

## História
A Ada foi encomendada pelo Departamento de Defesa dos Estados Unidos (DoD).
A introdução do Ada Reference Manual afirma: "The common high order language
program began in 1974. The requirements of the United States Department of
Defense were formalized in a series of documents" (tradução livre: "O
programa da linguagem comum de alto nível começou em 1974. Os requisitos do
Departamento de Defesa dos Estados Unidos foram formalizados em uma série de
documentos"), e "The Ada language
was designed in accordance with the final (1978) form of these
requirements, embodied in the Steelman specification" [2] (tradução livre:
"A linguagem Ada foi projetada de acordo com a forma final (1978) desses
requisitos, consubstanciada na especificação Steelman").

O projeto foi escolhido por concorrência: "After several rounds of competition
the winner was a team from France lead by Jean Ichbiah" [1] (tradução livre:
"Após várias rodadas de concorrência, a vencedora foi uma equipe da França
liderada por Jean Ichbiah"). O Reference Manual acrescenta: "The Ada design
team was led by Jean D. Ichbiah" [2] (tradução livre: "A equipe de projeto da
Ada foi liderada por Jean D. Ichbiah") e "The
Ada 83 language definition was developed by Cii Honeywell Bull and later
Alsys" [2] (tradução livre: "A definição da linguagem Ada 83 foi desenvolvida
pela Cii Honeywell Bull e, depois, pela Alsys"). O nome homenageia a
matemática do século XIX Ada Lovelace: "The decision was to name the language
in honor of Augusta Ada Byron, Countess of Lovelace" [1] (tradução livre: "A
decisão foi dar à linguagem o nome em homenagem a Augusta Ada Byron,
condessa de Lovelace"), escolha que o DoD fez "in 1979" [3] (tradução livre:
"em 1979").

O primeiro padrão, o Ada 83, foi publicado como padrão militar dos Estados
Unidos ("1983 Mil Std 1815 published (Ada 83)", em tradução livre: "Mil Std
1815 publicado em 1983 (Ada 83)") e adotado pela ISO em 1987 [4]. O Ada 95
acrescentou a orientação a objetos [1]. O Ada 2012 trouxe "pre- and
postconditions for subprograms, type invariants, and subtype predicates"
[5] (tradução livre: "pré e pós-condições para subprogramas, invariantes de
tipo e predicados de subtipo"), que permitem ao
programador escrever um contrato ao lado do código. A edição atual, o Ada
2022, "was published as ISO/IEC 8652:2023 in May 2023" [6] (tradução livre:
"foi publicada como ISO/IEC 8652:2023 em maio de 2023").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1974 | Começa o "common high order language program" do DoD | [2] |
| 1978 | Requisitos finais: a especificação Steelman | [2] |
| 1979 | A linguagem recebe o nome "Ada", em homenagem a Ada Lovelace (nascida em 1815-12-10) | [1][3] |
| 1983 | Ada 83: publicação do Mil Std 1815 | [4] |
| 1987 | A ISO adota o Ada 83 sem alterações como ISO 8652:1987 | [4] |
| 1995 | Ada 95 (ISO/IEC 8652:1995): "first internationally standardized object oriented language" (tradução livre: "primeira linguagem orientada a objetos padronizada internacionalmente") | [1][4] |
| 2007 | Ada 2005 (Emenda 1 ao Ada 95) | [4] |
| 2012 | Ada 2012 (ISO/IEC 8652:2012): contratos (pré e pós-condições) | [4][5] |
| 2023-05 | Ada 2022 publicado como ISO/IEC 8652:2023; a edição usada em [cli](cli/) | [6] |
| 2026-05-29 | Alire 2.1.1, o gerenciador de pacotes usado aqui | [7] |

## Uso de mercado hoje
Cada número abaixo traz sua data e sua fonte. Eles mudam todos os anos.

- **Índice TIOBE, outubro de 2026:** a Ada ocupa a 21ª posição, com uma
  avaliação de 0,82%, fora das 20 primeiras [8].
- **Stack Overflow Developer Survey 2026:** 1,2% de todos os respondentes da
  pergunta sobre linguagens de programação usaram Ada (172 de 14.099) [9].
- **Onde é usada:** "Specific domains seeing Ada usage include
  Aerospace & Defense, civil aviation, rail, and many others. These
  applications require a high degree of safety" [10] (tradução livre: "Os
  domínios específicos em que a Ada é usada incluem aeroespacial e defesa,
  aviação civil, ferrovias e muitos outros. Essas aplicações exigem um alto
  grau de segurança"). O ada-lang.io resume isso como "40 years of
  reliability in planes, trains, and satellites" [11] (tradução livre: "40
  anos de confiabilidade em aviões, trens e satélites").

Esses são percentuais pequenos em pesquisas gerais com desenvolvedores. O
uso da Ada se concentra nos domínios especializados citados acima, que uma
pesquisa geral alcança apenas em parte.

## Importância antes e agora
- **Antes (década de 1980):** a Ada era a "common high order language" do DoD
  [2] (tradução livre: "linguagem comum de alto nível"). Foi projetada a
  partir de requisitos escritos (Steelman [2]) por meio de uma concorrência
  [1], e não desenvolvida a partir de uma linguagem existente, e tornou-se
  um padrão militar em 1983 e um padrão ISO em 1987 [4].
- **Agora:** o foco em segurança continua no SPARK, que
  "is a subset of Ada, designed so that the code written in SPARK is
  amenable to automatic proof" [10] (tradução livre: "é um subconjunto da
  Ada, projetado para que o código escrito em SPARK seja passível de prova
  automática"). Os contratos do Ada 2012 [5] colocam as
  regras de um subprograma em sua declaração, onde o compilador e essas
  ferramentas podem verificá-las.
- **No ensino:** a Ada mostra o quanto um compilador pode verificar. Compare
  o Hello World com o de [C](../c/cli/hello.c): a Ada explicita onde termina
  cada bloco (`end Hello;`), nomeia o pacote de cada chamada
  (`Ada.Text_IO.Put_Line`) e tem uma etapa de ligação (bind) separada, que
  verifica se o programa inteiro é consistente antes da linkedição (veja o
  [passo a passo da cli](cli/README.md#step-by-step-walkthrough)).

## Comparação entre as categorias
A Ada tem aqui uma única categoria, cli, de modo que a comparação útil é com
as outras duas linguagens mais antigas deste repositório que compilam para um
executável nativo:

| | [COBOL cli](../cobol/cli/) | [Fortran cli](../fortran/cli/) | [Ada cli](cli/) |
|---|---|---|---|
| Instrução que imprime | `DISPLAY "Hello, World!".` | `print '(a)', "Hello, World!"` | `Ada.Text_IO.Put_Line ("Hello, World!");` |
| Estrutura do programa | 2 divisões (IDENTIFICATION, PROCEDURE) | `program hello` ... `end program hello` | `procedure Hello is begin ... end Hello;` |
| Comando de compilação | `cobc -x` (COBOL → C → código de máquina) | `gfortran` | `alr build` (GPRbuild: compilar, **ligar (bind)**, linkar) |
| Padrão usado | COBOL-85 (formato fixo) | Fortran 2008 (formato livre) | Ada 2022 |
| Biblioteca de runtime | `libcob`, carregada em tempo de execução | `libgfortran`, carregada em tempo de execução | incorporada ao executável |

## Por que não há versão desktop nem web
Este repositório não tem versão desktop nem web da Ada. Uma categoria só é
mantida se existir para ela uma toolchain mantida, de uso comum e
razoavelmente simples em todas as plataformas-alvo. Existem bibliotecas Ada
para ambas, e elas são mantidas, mas nenhuma se encaixa em "the most simple
and direct way" (tradução livre: "a forma mais simples e direta"):

- **Desktop: GtkAda** é, segundo a AdaCore, "Ada bindings for the GTK+
  graphical library" [12] (tradução livre: "bindings Ada para a biblioteca
  gráfica GTK+"). O crate dela no Alire afirma "This crate requires Gtk3+ >=
  3.24.24" [13] (tradução livre: "Este crate requer Gtk3+ >= 3.24.24"); assim,
  o estudante precisa primeiro instalar a biblioteca C GTK 3 e suas
  ferramentas de build em cada sistema operacional, antes do código Ada (a
  versão [C desktop](../c/desktop/) mostra o que a instalação do GTK envolve).
  É um binding para um toolkit em C, e não uma biblioteca de GUI própria da
  Ada.
- **Web: AWS (Ada Web Server)** "is a small yet powerful HTTP component to
  embed in any applications" [14] (tradução livre: "é um componente HTTP
  pequeno, porém poderoso, para incorporar em qualquer aplicação"). O crate
  dele no Alire depende de `gnatcoll`, `xmlada` e OpenSSL
  (`openssl >=1.1.0`) [15]: uma compilação muito maior que o próprio Hello
  World.
- **Adequação ao uso da linguagem:** a Ada é usada em sistemas embarcados e
  de segurança crítica, como "Aerospace & Defense, civil aviation,
  rail" [10] (tradução livre: "aeroespacial e defesa, aviação civil,
  ferrovias"), em que um programa de linha de comando ou embarcado é a forma
  típica.

Assim, o Hello World em Ada continua sendo um programa cli. As categorias
desktop e web aparecem com toolchains de uso comum nas outras linguagens
deste repositório (veja o [README da raiz](../../README.md)).

## Fontes
1. Introduction to Ada, part 1 (history). Ada Information Clearinghouse (Ada Resource Association). <https://www.adaic.org/learn/materials/intro/part1/> (acessado em 2026-11-01)
2. Ada Reference Manual, 2022 Edition: Introduction (Language Summary, Acknowledgements). Ada Resource Association. <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-0-2.html> (acessado em 2026-11-01)
3. Celebrating Ada Lovelace: The Pioneer of Programming. AdaCore press release. <https://www.adacore.com/press/celebrating-ada-lovelace-the-pioneer-of-programming> (acessado em 2026-11-01)
4. Ada Standards Timeline. Ada Information Clearinghouse. <https://www.adaic.org/ada-resources/standards/ada-standards-timeline/> (acessado em 2026-11-01)
5. Ada 2012. Ada Information Clearinghouse. <https://www.adaic.org/advantages/ada-2012/> (acessado em 2026-11-01)
6. Ada Reference Manual, 2022 Edition: Foreword. <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-0-1.html> (acessado em 2026-11-01)
7. Alire releases, v2.1.1. GitHub, `alire-project/alire`. <https://github.com/alire-project/alire/releases/tag/v2.1.1> (acessado em 2026-11-01)
8. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-01)
9. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-01)
10. Introduction to Ada: Introduction. AdaCore (learn.adacore.com). <https://learn.adacore.com/courses/intro-to-ada/chapters/introduction.html> (acessado em 2026-11-01)
11. Ada Programming Language (home page). ada-lang.io. <https://ada-lang.io/> (acessado em 2026-11-01)
12. `AdaCore/gtkada`. GitHub. <https://github.com/AdaCore/gtkada> (acessado em 2026-11-01)
13. `gtkada` crate. Alire. <https://alire.ada.dev/crates/gtkada> (acessado em 2026-11-01)
14. `AdaCore/aws`. GitHub. <https://github.com/AdaCore/aws> (acessado em 2026-11-01)
15. `aws` crate. Alire. <https://alire.ada.dev/crates/aws> (acessado em 2026-11-01)
