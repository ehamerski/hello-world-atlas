---
source: README.md
source_sha: 9118e7db04da53f662b8fd66b555fc327fa93ab1
---
# Hello World em várias linguagens de programação

Um repositório didático. Mostra como cada linguagem de programação escreve o
programa Hello World da forma mais simples e direta, como um programa de
linha de comando (**cli**), uma janela **desktop**, uma aplicação **web**
(algumas com front-end separado) e, para algumas linguagens, uma aplicação
**mobile**. Também aborda a história, os marcos, o uso no mercado e a importância de cada
linguagem.

**Site:** cada página deste repositório também é uma página do site.
Compile e visualize-o localmente com `scripts/build-site.sh --preview`
(consulte [como o site é construído](site/README.md)).

## Início rápido
Toda pasta de implementação tem os mesmos scripts, e cada um explica o que
faz e por que o faz enquanto é executado:
```sh
cd languages/<language>/<category>   # e.g. languages/python/cli
./install.sh                         # check the toolchain; asks before installing anything
./build.sh                           # compile (compiled languages only)
./run.sh                             # run it
```
Verifique todas as implementações de uma só vez com `scripts/verify-all.sh` e
todos os links relativos dos READMEs com `scripts/check-links.sh`.
Encerre tudo o que este repositório deixou em execução (servidores web,
janelas, uma execução de verificação) com `scripts/stop-all.sh`, ou
`scripts/stop-all.sh java` para uma só linguagem (`--list` apenas os lista).

**Plataformas:** verificado em macOS Intel, a máquina de desenvolvimento (as
Notas por plataforma de cada README informam a data). A última execução de CI com o
GitHub Actions, em 2026-11-06, verificou 67 implementações no Linux (Ubuntu) e
66 no Windows (Git Bash); as implementações adicionadas depois dela não foram
verificadas no CI. macOS Apple Silicon e WSL estão documentados em cada README,
mas marcados como **não verificados**
([Suporte a plataformas](docs/platform-support.md)).

## Linguagens
<!-- BEGIN GENERATED: language-table -->
<!-- Do not edit by hand: run python3 scripts/gen-readme.py (source: languages/*/meta.yml). -->
**101 implementações** em **47 linguagens**: 100 são executadas por `scripts/verify-all.sh` e 1 é somente documentada.

Situação: ✅ verificado · 🔶 compromisso · ⚠️ não verificado · 📄 somente documentado · – não implementado (o README da linguagem explica o motivo).

| Linguagem | Ano | Projetistas | Paradigma | cli | desktop | web | web + front-end separado | mobile |
|---|---|---|---|---|---|---|---|---|
| [Ada](languages/ada/README.md) | 1983 | Jean D. Ichbiah | [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/ada/cli/) | – | – | – | – |
| [ALGOL 68](languages/algol68/README.md) | 1968 | A. van Wijngaarden, B. J. Mailloux, J. E. L. Peck, C. H. A. Koster | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/algol68/cli/) | – | – | – | – |
| [Assembly (x86-64)](languages/assembly/README.md) | 1949 | David Wheeler | [imperative](docs/paradigms.md#imperative) / low-level | ✅ [cli](languages/assembly/cli/) | – | – | – | – |
| [Bash](languages/bash/README.md) | 1989 | Brian Fox | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/bash/cli/) | – | – | – | – |
| [BASIC](languages/basic/README.md) | 1964 | John Kemeny, Thomas Kurtz | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/basic/cli/) | – | – | – | – |
| [C (ANSI C)](languages/c/README.md) | 1972 | Dennis Ritchie | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/c/cli/) | ✅ [desktop](languages/c/desktop/) | ✅ [web](languages/c/web/) | – | – |
| [C#](languages/csharp/README.md) | 2000 | Anders Hejlsberg | [object-oriented](docs/paradigms.md#object-oriented) / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/csharp/cli/) | ✅ [desktop](languages/csharp/desktop/) | ✅ [web](languages/csharp/web/) | ✅ [Angular](languages/csharp/web-angular/) | – |
| [C++](languages/cpp/README.md) | 1985 | Bjarne Stroustrup | multi-paradigm / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/cpp/cli/) | ✅ [desktop](languages/cpp/desktop/) | ✅ [web](languages/cpp/web/) | – | – |
| [Clipper](languages/clipper/README.md) | 1985 | Brian Russell, Barry ReBell | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/clipper/cli/) | – | – | – | – |
| [Clojure](languages/clojure/README.md) | 2007 | Rich Hickey | [functional](docs/paradigms.md#functional) / concurrent | ✅ [cli](languages/clojure/cli/) | ✅ [Swing](languages/clojure/desktop/) | ✅ [Ring](languages/clojure/web/) | – | – |
| [COBOL](languages/cobol/README.md) | 1959 | CODASYL | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/cobol/cli/) | – | – | – | – |
| [Common Lisp](languages/lisp/README.md) | 1958 | John McCarthy | multi-paradigm / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/lisp/cli/) | – | ✅ [web](languages/lisp/web/) | – | – |
| [Dart](languages/dart/README.md) | 2011 | Lars Bak | [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/dart/cli/) | – | ✅ [web](languages/dart/web/) | – | ✅ [mobile-flutter](languages/dart/mobile-flutter/) |
| [dBASE](languages/dbase/README.md) | 1981 | Wayne Ratliff | [imperative](docs/paradigms.md#imperative) | 🔶 [cli](languages/dbase/cli/) | – | – | – | – |
| [Delphi (Object Pascal dialect)](languages/delphi/README.md) | 1995 | Anders Hejlsberg | [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) | 🔶 [cli](languages/delphi/cli/) | 🔶 [desktop](languages/delphi/desktop/) | – | – | – |
| [Eiffel](languages/eiffel/README.md) | 1986 | Bertrand Meyer, Jean-Marc Nerson | [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/eiffel/cli/) | – | – | – | – |
| [Elixir](languages/elixir/README.md) | 2012 | José Valim | [functional](docs/paradigms.md#functional) / concurrent | ✅ [cli](languages/elixir/cli/) | – | ✅ [web](languages/elixir/web/) | – | – |
| [Erlang](languages/erlang/README.md) | 1986 | Joe Armstrong, Robert Virding, Mike Williams | [functional](docs/paradigms.md#functional) / concurrent | ✅ [cli](languages/erlang/cli/) | ✅ [desktop](languages/erlang/desktop/) | ✅ [web](languages/erlang/web/) | – | – |
| [F#](languages/fsharp/README.md) | 2002 | Don Syme | [functional](docs/paradigms.md#functional) / multi-paradigm | ✅ [cli](languages/fsharp/cli/) | – | – | – | – |
| [Fortran](languages/fortran/README.md) | 1957 | John Backus | [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/fortran/cli/) | – | – | – | – |
| [Go](languages/go/README.md) | 2009 | Robert Griesemer, Rob Pike, Ken Thompson | [imperative](docs/paradigms.md#imperative) / concurrent | ✅ [cli](languages/go/cli/) | ✅ [desktop](languages/go/desktop/) | ✅ [web](languages/go/web/) | ✅ [Vue](languages/go/web-vue/) | – |
| [Haskell](languages/haskell/README.md) | 1990 | Haskell committee | [functional](docs/paradigms.md#functional) | ✅ [cli](languages/haskell/cli/) | – | ✅ [web](languages/haskell/web/) | – | – |
| [Java](languages/java/README.md) | 1995 | James Gosling | [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/java/cli/) | ✅ [JavaFX](languages/java/desktop/) · ✅ [Swing](languages/java/desktop-swing/) | ✅ [web](languages/java/web/) | ✅ [React](languages/java/web-react/) | – |
| [Julia](languages/julia/README.md) | 2012 | Jeff Bezanson, Stefan Karpinski, Viral B. Shah, Alan Edelman | multi-paradigm / [imperative](docs/paradigms.md#imperative) / [functional](docs/paradigms.md#functional) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/julia/cli/) | – | – | – | – |
| [Kotlin](languages/kotlin/README.md) | 2011 | JetBrains | [object-oriented](docs/paradigms.md#object-oriented) / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/kotlin/cli/) | ✅ [Compose](languages/kotlin/desktop/) | ✅ [Ktor](languages/kotlin/web/) | – | ✅ [Android](languages/kotlin/mobile-android/) |
| [Lua](languages/lua/README.md) | 1993 | Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes | multi-paradigm / [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/lua/cli/) | 🔶 [desktop](languages/lua/desktop/) | ✅ [web](languages/lua/web/) | – | – |
| [Node.js (JavaScript)](languages/node/README.md) | 2009 | Ryan Dahl | multi-paradigm / event-driven | ✅ [cli](languages/node/cli/) | ✅ [desktop](languages/node/desktop/) | ✅ [web](languages/node/web/) | – | – |
| [Objective-C](languages/objectivec/README.md) | – | Brad Cox, Tom Love | [object-oriented](docs/paradigms.md#object-oriented) / [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/objectivec/cli/) | ✅ [desktop](languages/objectivec/desktop/) | ✅ [web](languages/objectivec/web/) | – | – |
| [OCaml](languages/ocaml/README.md) | 1996 | Xavier Leroy, Damien Doligez, Jérôme Vouillon, Didier Rémy | [functional](docs/paradigms.md#functional) / [object-oriented](docs/paradigms.md#object-oriented) / [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/ocaml/cli/) | – | – | – | – |
| [Pascal](languages/pascal/README.md) | 1970 | Niklaus Wirth | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/pascal/cli/) | ✅ [desktop](languages/pascal/desktop/) | – | – | – |
| [Perl](languages/perl/README.md) | 1987 | Larry Wall | multi-paradigm / [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/perl/cli/) | 🔶 [desktop](languages/perl/desktop/) | ✅ [web](languages/perl/web/) | – | – |
| [PHP](languages/php/README.md) | 1995 | Rasmus Lerdorf | [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/php/cli/) | – | ✅ [web](languages/php/web/) | – | – |
| [Prolog](languages/prolog/README.md) | 1972 | Alain Colmerauer, Philippe Roussel | [logic](docs/paradigms.md#logic) | ✅ [cli](languages/prolog/cli/) | – | ✅ [web](languages/prolog/web/) | – | – |
| [Pseudocode](languages/pseudocode/README.md) | – | – | [imperative](docs/paradigms.md#imperative) / teaching | ✅ [Portugol](languages/pseudocode/portugol/) · ✅ [PSeInt](languages/pseudocode/pseint/) · 📄 [CLRS](languages/pseudocode/clrs/) | – | – | – | – |
| [Python](languages/python/README.md) | 1991 | Guido van Rossum | multi-paradigm / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/python/cli/) | ✅ [desktop](languages/python/desktop/) | ✅ [web](languages/python/web/) | – | – |
| [QCL (Quantum Computation Language)](languages/qcl/README.md) | 1998 | Bernhard Oemer | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/qcl/cli/) | – | – | – | – |
| [R](languages/r/README.md) | 1993 | Ross Ihaka, Robert Gentleman | [functional](docs/paradigms.md#functional) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/r/cli/) | – | – | – | – |
| [Racket](languages/racket/README.md) | 1995 | PLT (the Racket project team) | [functional](docs/paradigms.md#functional) / [object-oriented](docs/paradigms.md#object-oriented) / language-oriented | ✅ [cli](languages/racket/cli/) | – | – | – | – |
| [Ruby](languages/ruby/README.md) | 1995 | Yukihiro Matsumoto | [object-oriented](docs/paradigms.md#object-oriented) / [imperative](docs/paradigms.md#imperative) / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/ruby/cli/) | ✅ [desktop](languages/ruby/desktop/) | ✅ [web](languages/ruby/web/) · ✅ [Rails](languages/ruby/web-rails/) | – | – |
| [Rust](languages/rust/README.md) | 2015 | Graydon Hoare | multi-paradigm / systems | ✅ [cli](languages/rust/cli/) | ✅ [desktop](languages/rust/desktop/) | ✅ [web](languages/rust/web/) | – | – |
| [Scala](languages/scala/README.md) | 2003 | Martin Odersky | multi-paradigm / [functional](docs/paradigms.md#functional) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/scala/cli/) | – | – | – | – |
| [Simula](languages/simula/README.md) | 1967 | Ole-Johan Dahl, Kristen Nygaard | [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/simula/cli/) | – | – | – | – |
| [Smalltalk](languages/smalltalk/README.md) | 1972 | Adele Goldberg, Dan Ingalls, Ted Kaehler, Larry Tesler, Xerox PARC | [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/smalltalk/cli/) | ✅ [desktop](languages/smalltalk/desktop/) | ✅ [web](languages/smalltalk/web/) | – | – |
| [Swift](languages/swift/README.md) | 2014 | Chris Lattner | multi-paradigm / [object-oriented](docs/paradigms.md#object-oriented) / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/swift/cli/) | ✅ [desktop](languages/swift/desktop/) | ✅ [web](languages/swift/web/) | – | ✅ [mobile-ios](languages/swift/mobile-ios/) |
| [TypeScript](languages/typescript/README.md) | 2012 | Anders Hejlsberg | multi-paradigm / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/typescript/cli/) | – | ✅ [web](languages/typescript/web/) | – | – |
| [Visual Basic (VB.NET)](languages/visual-basic/README.md) | 2002 | Microsoft | [object-oriented](docs/paradigms.md#object-oriented) / [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/visual-basic/cli/) | – | ✅ [web](languages/visual-basic/web/) | – | – |
| [Zig](languages/zig/README.md) | 2016 | Andrew Kelley | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/zig/cli/) | – | – | – | – |
<!-- END GENERATED: language-table -->

Todas as pastas, com sua toolchain e o passo a passo, estão listadas em
[Todas as implementações](languages/README.md#all-implementations). A tabela
acima é gerada a partir do `meta.yml` de cada linguagem
([esquema](languages/README.md#metayml-schema)).

## Para ir além
- [Paradigmas](docs/paradigms.md): os quatro paradigmas principais
  (imperativo, orientado a objetos, funcional e lógico), além da
  concorrência e da programação quântica, o que cada um significa e quais
  linguagens os representam
- [Comparações](docs/comparisons.md): as implementações lado a lado:
  todos os Hello World em cli, modelos de compilação, servidores web,
  toolkits desktop e um roteiro de leitura guiado
- [A IA e um novo paradigma](docs/ai-new-paradigm.md): a IA dará origem a um
  novo paradigma de programação? O ensaio defende que sim (programação
  orientada a intenções), explica como ele funcionaria e apresenta os
  contra-argumentos
- [Suporte a plataformas](docs/platform-support.md): onde os programas são
  verificados e como
- [Como contribuir](CONTRIBUTING.md): convenções e como contribuir

## Fontes
O README de cada linguagem e de cada implementação tem uma seção própria de
**Fontes**, conforme as regras de [Sobre as fontes](docs/sources.md).

## Licença
Duas licenças cobrem o trabalho próprio do projeto, copyright (c) 2026
Eduardo Hamerski:
- O **código** (arquivos-fonte, scripts, configuração e os blocos de código
  dos documentos) é distribuído sob a **Licença MIT**, no
  [arquivo LICENSE](LICENSE).
- A **prosa e as imagens** (o texto dos documentos Markdown e do site feito
  a partir deles, as capturas de tela e o ícone do site) são distribuídas
  sob a
  **[Licença Creative Commons Atribuição 4.0 Internacional (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)**,
  no [arquivo LICENSE-docs](LICENSE-docs).

Alguns arquivos vêm de outros projetos e mantêm suas próprias licenças: o
Gradle Wrapper e os arquivos do template do Flutter em
`languages/dart/mobile-flutter/`, e as fontes tipográficas que o site
inclui. O [arquivo NOTICE](NOTICE) os relaciona.

Para citar este repositório, use seu [arquivo de citação](CITATION.cff) (o
GitHub o exibe como "Cite this repository").
