---
source: languages/pascal/README.md
source_sha: 739f585ed0a46d0e1b335840c4f3ca8f9a075a7f
---
# Pascal

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** imperativo (procedural, estruturado). Niklaus Wirth projetou
a Pascal "both as a convenient basis to teach programming and as an efficient
tool to write large programs" [1] (tradução livre: "tanto como uma base
conveniente para ensinar programação quanto como uma ferramenta eficiente
para escrever programas grandes"). O Object Pascal, o dialeto do Delphi e do
Lazarus, acrescenta a orientação a objetos: o modo `objfpc` do Free Pascal
"includes classes, interfaces and exceptions" [2] (tradução livre: "inclui
classes, interfaces e exceções").

Veja também: [paradigmas](../../docs/paradigms.md#imperative) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | Free Pascal (modo ISO 7185) | ✅ |
| desktop | [desktop/](desktop/) | Lazarus LCL (`lazbuild`) | ✅ |
| web | – | não implementada, veja [Por que não há versão web](#por-que-não-há-versão-web) | – |

## História
A Pascal vem da ETH Zürich. Niklaus Wirth "became Professor of
Informatics at ETH Zurich" em 1968 [3] (tradução livre: "tornou-se professor
de Informática na ETH Zurique") e "developed the languages Pascal
between 1968 and 1970" [4] (tradução livre: "desenvolveu as linguagens
Pascal entre 1968 e 1970"). Seu relatório *The Programming Language Pascal*
é datado de novembro de 1970 [1]. Ele explica o objetivo: "emphasis was
placed on keeping the number of fundamental concepts reasonably small"
(tradução livre: "deu-se ênfase a manter razoavelmente pequeno o número de
conceitos fundamentais"), e informa a existência de um compilador funcional:
"A one-pass compiler has been constructed for
the CDC 6000 computer family; it is expressed entirely in terms of Pascal
itself" [1] (tradução livre: "Foi construído um compilador de uma passagem
para a família de computadores CDC 6000; ele é expresso inteiramente em
termos da própria Pascal").

A Pascal passou então para os computadores pessoais. "Turbo Pascal was
introduced by Borland in November 1983" [5] (tradução livre: "O Turbo Pascal
foi lançado pela Borland em novembro de 1983"), e o sucessor orientado a
objetos da Borland, o Delphi, veio em seguida: "Delphi 1 (Feb 14, 1995)" [6]
(tradução livre: "Delphi 1 (14 de fev. de 1995)"). A ISO também
padronizou a Pascal como ISO 7185 (Pascal Padrão) e ISO/IEC 10206
(Pascal Estendido). O Free Pascal tem um modo de compatibilidade para cada
um deles [2][7].

Os compiladores livres vieram depois. "Free Pascal was started by Florian
Klämpfl, Germany" (tradução livre: "O Free Pascal foi iniciado por Florian
Klämpfl, Alemanha"), com "06/1993: project start" (tradução livre: "06/1993:
início do projeto") e "07/2000: 1.0 released" [8] (tradução livre: "07/2000:
1.0 lançado"). "Lazarus was started in February of 1999" [9] (tradução livre:
"O Lazarus foi iniciado em fevereiro de 1999") para dar ao Free Pascal uma
IDE e uma biblioteca de componentes semelhantes às do Delphi. O Lazarus 1.0
foi anunciado em 2012-08-29 [10].

Wirth recebeu o Prêmio Turing da ACM de 1984 "for developing a sequence of
innovative computer languages Euler, Algol-W, Pascal, and Modula" [4]
(tradução livre: "por desenvolver uma sequência de linguagens de computador
inovadoras: Euler, Algol-W, Pascal e Modula"). Ele
"died on 1 January 2024, just weeks before his 90th birthday" [11] (tradução
livre: "faleceu em 1º de janeiro de 2024, poucas semanas antes de seu
90º aniversário").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1968–1970 | Wirth desenvolve a Pascal na ETH Zürich | [3][4] |
| 1970-11 | *The Programming Language Pascal* (relatório); primeiro compilador para o CDC 6000 | [1] |
| 1983-11 | Turbo Pascal, da Borland | [5] |
| 1984 | Prêmio Turing da ACM a Niklaus Wirth | [4][11] |
| 1993-06 | Início do projeto Free Pascal | [8] |
| 1995-02-14 | Delphi 1 (Object Pascal, formulários visuais) | [6] |
| 1999-02 | Início do projeto Lazarus | [9] |
| 2000-07 | Free Pascal 1.0 | [8] |
| 2012-08 | Lazarus 1.0 | [10] |
| 2021-05 | Free Pascal 3.2.2, ainda a versão estável mais recente; usada nas duas pastas aqui | [12] |
| 2026-06-11 | Lazarus 4.8, usado em [desktop](desktop/) | [13] |

## Uso de mercado hoje
Cada número abaixo traz sua data e sua fonte. Eles mudam todos os anos.

- **Índice TIOBE, outubro de 2026:** "Delphi/Object Pascal" ocupa a 19ª
  posição, com uma avaliação de 0,83%. Ocupava a 9ª em outubro de 2025 [14].
  O TIOBE não tem uma entrada separada para "Pascal" entre as 20 primeiras.
- **Stack Overflow Developer Survey 2026:** 1,9% de todos os respondentes
  usaram Delphi (267 respondentes). A Pascal não consta separadamente [15].

Os dois números medem coisas diferentes: o TIOBE conta resultados de
mecanismos de busca, e a pesquisa do Stack Overflow conta os desenvolvedores
que a responderam. Ambas as fontes reportam o Delphi, o produto comercial de
Object Pascal, e os números acima não distinguem o Free Pascal nem o
Lazarus.

## Importância antes e agora
- **Antes (décadas de 1970 a 1990):** a Pascal foi criada para o ensino [1].
  A ETH afirma que Wirth "achieved world fame by developing the Pascal
  programming language" [11] (tradução livre: "alcançou fama mundial ao
  desenvolver a linguagem de programação Pascal"). O Turbo Pascal e depois o
  Delphi a levaram aos programadores de PC [5][6].
- **Agora:** o Free Pascal é "a mature, versatile, open source Pascal
  compiler" [12] (tradução livre: "um compilador Pascal maduro, versátil e de
  código aberto"), e o Lazarus descreve seu alcance como "file browsers,
  image viewers, database applications, graphics editing software, games, 3D
  software, medical analysis software or any other type of software" [13]
  (tradução livre: "navegadores de arquivos, visualizadores de imagens,
  aplicações de banco de dados, software de edição gráfica, jogos, software
  3D, software de análise médica ou qualquer outro tipo de software"). O ramo
  comercial, o Delphi, é o que as pesquisas medem [14][15].
- **No ensino:** as duas pastas mostram duas formas da Pascal. A pasta
  [cli](cli/) usa a linguagem pequena e rigorosa do relatório de 1970 (modo
  ISO 7185); a pasta [desktop](desktop/) usa o Object Pascal no estilo
  Delphi, com classes, units e um arquivo de projeto de formulário.

## Comparação entre as categorias
| | [cli](cli/) | [desktop](desktop/) |
|---|---|---|
| Dialeto | Pascal Padrão ISO 7185 (`-Miso`) | Object Pascal (`{$mode objfpc}{$H+}`) |
| Compilação | `fpc` em um único arquivo | `lazbuild` em um projeto Lazarus, que chama o `fpc` |
| Arquivos-fonte | `hello.pas` | `hello.lpi`, `hello.lpr`, `mainunit.pas`, `mainunit.lfm` |
| Biblioteca | apenas a biblioteca de runtime do Free Pascal | a LCL (Lazarus Component Library) |
| Como termina | após a última instrução | quando a janela é fechada (laço de eventos) |
| Primeira compilação na máquina de desenvolvimento | menos de 1 segundo | cerca de 50 segundos (a LCL é compilada uma vez) |

Em comparação com as outras linguagens: a Pascal marca blocos com
`begin ... end`, como a [Ada cli](../ada/cli/), ao passo que C, Java e Go
usam chaves. Suas palavras-chave não diferenciam maiúsculas de minúsculas,
como as do Fortran e do COBOL. Sua versão desktop descreve a janela em um
arquivo de texto separado (`mainunit.lfm`), como faz o
[Node.js desktop](../node/desktop/) com `index.html`; as versões desktop em
[C](../c/desktop/) e [C#](../csharp/desktop/) constroem a janela no código.

## Por que não há versão web
Este repositório não tem versão web da Pascal. Uma categoria só é mantida se
existir para ela uma toolchain mantida, de uso comum e razoavelmente simples
em todas as plataformas-alvo.

A programação web em Pascal é possível, mas nenhuma das opções abaixo é uma
pilha web de uso comum, e por isso este repositório deixa a categoria web de
fora. As opções são:
- **fcl-web**, parte do Free Pascal: "Web(app) related parts of Free
  Component Libraries (FCL), FPC's OOP library" [16] (tradução livre: "partes
  relacionadas a Web(app) das Free Component Libraries (FCL), a biblioteca
  OOP do FPC"). Ela acompanha o FPC.
- **pas2js**, também do projeto Free Pascal: "an open source Pascal to
  JavaScript transpiler" [17] (tradução livre: "um transpilador de Pascal
  para JavaScript de código aberto"), para o lado do navegador, e não para
  servidor.
- **Frameworks de terceiros**, como o Brook ("Microframework which helps to
  develop web Pascal applications", em tradução livre: "Microframework que
  ajuda a desenvolver aplicações web em Pascal") [18] e o mORMot 2 (uma
  "RTL/ToolBox in modern Object Pascal, up to a Client-Server ORM/SOA/MVC
  Framework", em tradução livre: "RTL/ToolBox em Object Pascal moderno, até
  um framework cliente-servidor ORM/SOA/MVC") [19], são projetos separados,
  instalados sobre o Free Pascal.
- **Uso:** a Pascal como um todo ocupa a 19ª posição no TIOBE e é usada por
  1,9% dos respondentes do Stack Overflow 2026 (como Delphi) [14][15]; assim,
  os frameworks web em Pascal atendem a uma pequena parcela dos
  desenvolvedores.

A Pascal mantém, portanto, as versões cli e desktop, nas quais o Free Pascal
e o Lazarus são as ferramentas livres padrão.

## Fontes
1. Niklaus Wirth, *The Programming Language Pascal*, ETH Zürich, November 1970 (second edition July 1971). ETH Research Collection, DOI 10.3929/ethz-a-004150844. <https://www.research-collection.ethz.ch/server/api/core/bitstreams/8bd8f312-3c90-4bc5-9081-63943ff3902a/content> (acessado em 2026-11-01)
2. Free Pascal User's Guide, compiler modes, LaTeX source. Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/user.tex> (acessado em 2026-11-01)
3. Niklaus Wirth (profile). IEEE Computer Society. <https://www.computer.org/profiles/niklaus-wirth> (acessado em 2026-11-01)
4. Niklaus Wirth (Computer Pioneers). IEEE Computer Society History. <https://history.computer.org/pioneers/wirth.html> (acessado em 2026-11-01)
5. Turbo Pascal turns 40. Embarcadero blog. <https://blogs.embarcadero.com/turbo-pascal-turns-40/> (acessado em 2026-11-01)
6. The long and winding road to today's Delphi: happy 29th birthday. Embarcadero blog. <https://blogs.embarcadero.com/the-long-and-winding-road-to-todays-delphi-happy-29th-birthday/> (acessado em 2026-11-01)
7. `fpc -h`, a ajuda de linha de comando do Free Pascal 3.2.2 (`-Miso` "ISO 7185 mode", `-Mextendedpascal` "ISO 10206 mode"; executado na máquina de desenvolvimento, 2026-11-01).
8. Free Pascal FAQ (history). Free Pascal. <https://www.freepascal.org/faq.html> (acessado em 2026-11-01)
9. About Lazarus. Lazarus. <https://www.lazarus-ide.org/index.php?page=about> (acessado em 2026-11-01)
10. [Lazarus] Lazarus 1.0 Release (mailing list, 2012-08-29). Lazarus. <https://lists.lazarus-ide.org/pipermail/lazarus/2012-August/206047.html> (acessado em 2026-11-01)
11. Computer pioneer Niklaus Wirth has died. ETH Zürich News, January 2024. <https://ethz.ch/en/news-and-events/eth-news/news/2024/01/computer-pioneer-niklaus-wirth-has-died.html> (acessado em 2026-11-01)
12. Free Pascal (home page: "Version 3.2.2 is the latest stable version of Free Pascal", release news May 2021). <https://www.freepascal.org/> (acessado em 2026-11-01)
13. Lazarus home page (description, news "Lazarus Bugfix Release 4.8 - June 11, 2026"). Lazarus. <https://www.lazarus-ide.org/> (acessado em 2026-11-01)
14. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-01)
15. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-01)
16. fcl-web `fpmake.pp` (package description). Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/source/-/blob/main/packages/fcl-web/fpmake.pp> (acessado em 2026-11-01)
17. pas2js README. Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/pas2js/-/blob/main/README.md> (acessado em 2026-11-01)
18. risoflora/brookframework. GitHub. <https://github.com/risoflora/brookframework> (acessado em 2026-11-01)
19. synopse/mORMot2. GitHub. <https://github.com/synopse/mORMot2> (acessado em 2026-11-01)
