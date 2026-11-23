---
source: languages/haskell/README.md
source_sha: 7c100bffa969c5aa772b5ea409c8ac2a1512879a
---
# Haskell

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** puramente funcional, preguiçoso (não estrito), com tipagem
estática e inferência de tipos. O Relatório Haskell 2010 diz "Haskell is a
general purpose, purely functional programming language" (tradução livre:
"Haskell é uma linguagem de programação funcional pura, de propósito
geral") com "higher-order functions, non-strict semantics, static
polymorphic typing" (tradução livre: "funções de ordem superior,
semântica não estrita, tipagem polimórfica estática") e "a monadic I/O
system" (tradução livre: "um sistema de E/S monádico") [1].

Veja também: [paradigmas](../../docs/paradigms.md#functional) (como este
paradigma se compara aos outros) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as demais).

O que estas palavras significam aqui:

- **Funcional:** um programa é construído a partir de expressões e funções,
  e não de uma lista de comandos que alteram variáveis. haskell.org: "Every
  function in Haskell is a function in the mathematical sense (i.e.,
  "pure")" (tradução livre: "Toda função em Haskell é uma função no sentido
  matemático (isto é, "pura")"), e "There are no statements or
  instructions, only expressions which cannot mutate variables (local or
  global) nor access state like time or random numbers" (tradução livre:
  "Não há instruções, apenas expressões que não podem alterar variáveis
  (locais ou globais) nem acessar estado como o tempo ou números
  aleatórios") [2]. Uma função pura sempre devolve o mesmo resultado para a
  mesma entrada e não faz mais nada além disso.
- **Preguiçoso (não estrito):** um valor só é calculado quando é
  necessário. haskell.org: "Functions don't evaluate their arguments"
  (tradução livre: "As funções não avaliam seus argumentos") [2].
- **Tipagem estática, com inferência de tipos:** "Every expression in
  Haskell has a type which is determined at compile time" (tradução livre:
  "Toda expressão em Haskell tem um tipo, determinado em tempo de
  compilação"), mas "You don't have to explicitly write out every type in
  a Haskell program" (tradução livre: "Não é preciso escrever
  explicitamente todos os tipos em um programa Haskell"), pois o
  compilador os infere [2].
- **Efeitos colaterais controlados por tipos (`IO`):** imprimir é um efeito
  colateral, portanto não pode ocorrer dentro de uma função pura. Em vez
  disso, "The IO type serves as a tag for operations (actions) that
  interact with the outside world" (tradução livre: "O tipo IO serve como
  uma etiqueta para operações (ações) que interagem com o mundo externo")
  [3]. "Even side-effecting IO operations are but a description of what
  to do, produced by pure code" (tradução livre: "Até as operações de IO
  com efeitos colaterais não passam de uma descrição do que fazer,
  produzida por código puro") [2].

O programa [cli](cli/) inteiro mostra isso em duas linhas:

```haskell
main :: IO ()
main = putStrLn "Hello, World!"
```

`main :: IO ()` lê-se "`main` tem o tipo `IO ()`": é uma ação de E/S cujo
resultado é `()`, o tipo unitário, que tem apenas um valor [3]. Em outras
palavras, a ação não devolve nada de útil. `putStrLn` tem o tipo
`String -> IO ()` [4]: recebe uma string e devolve uma *ação* que a
imprime. Ela não imprime nada quando é avaliada. A regra da linguagem é
que `main` "must be a computation of type IO τ" (tradução livre: "deve ser
uma computação do tipo IO τ") e "When the program is executed, the
computation main is performed" (tradução livre: "Quando o programa é
executado, a computação main é realizada") [5]. Assim, o código Haskell
apenas descreve a impressão, e o runtime a executa. Uma função cujo tipo
não tem `IO`, como `Int -> Int`, "cannot do any side-effects whatsoever"
(tradução livre: "não pode fazer nenhum efeito colateral") [2].

## Implementações
| Categoria | Pasta | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | GHC (via GHCup) | ✅ |
| desktop | – | não implementado, veja [Por que não há versão desktop](#por-que-não-há-versão-desktop) | – |
| web | [web/](web/) | Scotty, Cabal | ✅ |

## Histórico
Haskell foi projetada por um comitê. O Prefácio do Relatório Haskell
apresenta o motivo: "In September of 1987 a meeting was held at the
conference on Functional Programming Languages and Computer Architecture
(FPCA '87) in Portland, Oregon, to discuss an unfortunate situation in
the functional programming community: there had come into being more than
a dozen non-strict, purely functional programming languages, all similar
in expressive power and semantic underpinnings" [6] (tradução livre: "Em
setembro de 1987, realizou-se uma reunião na conferência Functional
Programming Languages and Computer Architecture (FPCA '87), em Portland,
Oregon, para discutir uma situação lamentável na comunidade de
programação funcional: haviam surgido mais de uma dúzia de linguagens de
programação funcionais puras e não estritas, todas semelhantes em poder
expressivo e em fundamentos semânticos"). "It was decided that a
committee should be formed to design such a language" [6] (tradução
livre: "Decidiu-se que um comitê deveria ser formado para projetar uma
linguagem desse tipo"). Um de seus objetivos: "It should be suitable for
teaching, research, and applications, including building large systems"
[6] (tradução livre: "Ela deve ser adequada ao ensino, à pesquisa e a
aplicações, incluindo a construção de sistemas grandes").

A principal fonte deste histórico é o artigo *A History of Haskell:
Being Lazy with Class*, de Paul Hudak, John Hughes, Simon Peyton Jones e
Philip Wadler, apresentado na terceira conferência History of Programming
Languages da ACM (HOPL-III) em 2007 [7]. Ele conta que o nome foi
escolhido em uma reunião em Yale em janeiro de 1988. A primeira escolha
foi "Curry", "in honour of the mathematician and logician Haskell B.
Curry" (tradução livre: "em homenagem ao matemático e lógico Haskell B.
Curry"); no dia seguinte o comitê "settled on "Haskell" as the name for
the new language" (tradução livre: "decidiu-se por "Haskell" como o nome
da nova linguagem") [7]. O Relatório diz também que a linguagem é "named
after the logician Haskell B. Curry whose work provides the logical basis
for much of ours" [6] (tradução livre: "batizada em homenagem ao lógico
Haskell B. Curry, cujo trabalho fornece a base lógica de boa parte do
nosso").

"1 April 1990. The Haskell version 1.0 Report was published (125 pages),
edited by Hudak and Wadler" [7] (tradução livre: "1º de abril de 1990. O
Relatório Haskell versão 1.0 foi publicado (125 páginas), editado por
Hudak e Wadler"). Seguiram-se as versões 1.1 a 1.4. Haskell 1.3 (maio de
1996) foi "the most significant release of Haskell after 1.0" (tradução
livre: "a versão mais significativa de Haskell depois da 1.0"): "Monadic
I/O made its first appearance, including "do" syntax" [7] (tradução
livre: "A E/S monádica apareceu pela primeira vez, incluindo a sintaxe
"do""). "By the middle of 1997, there had been five versions of the
language design (from Haskell 1.0 – 1.4)" (tradução livre: "Em meados de
1997, já havia cinco versões do projeto da linguagem (de Haskell 1.0 a
1.4)"), e era necessária uma versão estável: "this became "Haskell 98" and
was published in February 1999" [6] (tradução livre: "esta se tornou
"Haskell 98" e foi publicada em fevereiro de 1999"). Um Relatório Haskell
98 revisado veio em 2002 [6][7]. Depois, "Haskell 2010 is the first
revision to be created in this way" (tradução livre: "Haskell 2010 é a
primeira revisão criada dessa maneira"), em pequenos passos; suas
principais adições foram uma Foreign Function Interface (FFI), nomes
hierárquicos de módulos como `Data.Bool` e pattern guards [6][8].

**O papel do GHC.** O Glasgow Haskell Compiler "was begun in January 1989
at the University of Glasgow, as soon as the initial language design was
fixed" (tradução livre: "foi iniciado em janeiro de 1989 na Universidade
de Glasgow, assim que o projeto inicial da linguagem foi fixado"), e "the
first full release (version 0.10) was made in December 1992" (tradução
livre: "a primeira versão completa (0.10) foi lançada em dezembro de
1992") [7]. Em 2007, o artigo já o chamava de "Probably the most fully
featured Haskell compiler today" (tradução livre: "Provavelmente o
compilador Haskell mais completo da atualidade") [7]. Hoje o haskell.org
chama o GHC de "flagship compiler" (tradução livre: "compilador
principal") do Haskell [2], e o GHC "supports the entire Haskell
2010 language plus a wide variety of extensions" (tradução livre: "oferece
suporte a toda a linguagem Haskell 2010 e a uma grande variedade de
extensões") [9].

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1987-09 | A reunião na FPCA '87, em Portland, Oregon, decide formar um comitê | [6][7] |
| 1988-01 | Reunião em Yale; o nome "Haskell" é escolhido | [7] |
| 1988-02-24 | Wadler propõe type classes ao comitê | [7] |
| 1989-01 | Começa o trabalho no Glasgow Haskell Compiler (GHC) | [7] |
| 1990-04-01 | Relatório Haskell 1.0, editado por Hudak e Wadler | [7] |
| 1992-12 | Primeira versão completa do GHC (versão 0.10) | [7] |
| 1996-05 | Haskell 1.3: a E/S monádica e a sintaxe `do` entram na linguagem | [7] |
| 1999-02 | Relatório Haskell 98, o primeiro Haskell "estável" | [6][7] |
| 2002 | Relatório Haskell 98 revisado | [6][7] |
| 2007-01 | O Hackage, o arquivo central de pacotes, entra no ar | [10] |
| 2010 | Relatório Haskell 2010 (FFI, módulos hierárquicos, pattern guards) | [6][8] |
| 2025-12-19 | Lançamento do GHC 9.14.1 | [9] |

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam a cada ano.

- **Índice TIOBE, outubro de 2026:** Haskell ocupa a 41ª posição, com uma
  avaliação de 0,33% [11].
- **Stack Overflow Developer Survey 2026:** 2,3% de todos os respondentes
  da pergunta sobre linguagens de programação usaram Haskell (324 de
  14.099) [12]. Na mesma pesquisa, 4,5% dos respondentes querem trabalhar
  com ela ("Desired") e 47,8% dos que a usaram querem continuar usando
  ("Admired") [12].
- **Pacotes:** a página inicial do haskell.org diz "There are 6,954
  packages freely available" (tradução livre: "Há 6.954 pacotes
  disponíveis gratuitamente") (lido em 2026-11-01) [2]. O Hackage "has
  been online since January 2007" (tradução livre: "está no ar desde
  janeiro de 2007") [10].

Os números medem coisas diferentes. O TIOBE conta resultados de
mecanismos de busca, e a pesquisa do Stack Overflow conta os
desenvolvedores que a responderam. Haskell tem uma participação pequena
em ambos. Na pesquisa, mais respondentes querem usá-la (4,5%) do que a
usam hoje (2,3%) [12].

## Importância antes e agora
- **Antes (1987–1999):** Haskell deu à comunidade de pesquisa em
  programação funcional preguiçosa uma linguagem comum. O Relatório a
  chama de "the culmination and solidification of many years of research
  on non-strict functional languages" (tradução livre: "a culminação e a
  consolidação de muitos anos de pesquisa em linguagens funcionais não
  estritas") [1]. Duas ideias se tornaram sua marca. Os autores escrevem
  que "it is perhaps type classes that are now regarded as Haskell's most
  distinctive characteristic" (tradução livre: "talvez sejam as type
  classes que hoje se consideram a característica mais distintiva de
  Haskell"), e que "Aside from type classes [...] monads are one of the
  most distinctive language design features in Haskell" (tradução livre:
  "Além das type classes [...], as mônadas são um dos recursos de projeto
  de linguagem mais distintivos de Haskell") [7]. As mônadas resolveram
  um problema real: o comitê queria manter a linguagem "pure—meaning no
  side effects" (tradução livre: "pura, isto é, sem efeitos colaterais"),
  mas ainda assim se comunicar com o mundo real [7]. Esse é o tipo `IO` do
  programa [cli](cli/).
- **Influência sobre outras linguagens:** o artigo diz "Haskell has
  influenced several other programming languages" (tradução livre:
  "Haskell influenciou várias outras linguagens de programação"), ao
  mesmo tempo que avisa que muitas vezes é "hard to ascertain whether
  there is a causal relationship" (tradução livre: "difícil determinar se
  há uma relação causal") [7]. Seus exemplos: "The generic type system
  introduced in Java 5 is based on the Hindley-Milner type system
  (introduced in ML, and promoted by Miranda and Haskell)" (tradução
  livre: "O sistema de tipos genéricos introduzido no Java 5 se baseia no
  sistema de tipos Hindley-Milner (introduzido em ML e promovido por
  Miranda e Haskell)") e seus tipos limitados são "closely related to
  type classes in Haskell" (tradução livre: "intimamente relacionados às
  type classes de Haskell"); "The LINQ (Language INtegrated Query) features
  of C# 3.0 and Visual Basic 9.0 are based on monad comprehensions from
  Haskell" (tradução livre: "Os recursos LINQ (Language INtegrated Query)
  do C# 3.0 e do Visual Basic 9.0 se baseiam em compreensões de mônadas de
  Haskell"); Scala tem recursos "similar to monad comprehensions"
  (tradução livre: "semelhantes às compreensões de mônadas") e "similar to
  type classes" (tradução livre: "semelhantes às type classes"); e Clean e
  Mercury adotaram type classes [7]. Os autores concluem: "We believe the
  most important legacy of Haskell will be how it influences the languages
  that succeed it" [7] (tradução livre: "Acreditamos que o legado mais
  importante de Haskell será a forma como ela influencia as linguagens que
  a sucederem").
- **Hoje:** Haskell é usada na indústria. O haskell.org lista depoimentos
  de empresas como HubSpot ("Haskell drives our data synchronization
  engine", tradução livre: "Haskell move nosso mecanismo de sincronização
  de dados"), Mercury ("We use Haskell to meet our customers' high
  standards for correctness and security", tradução livre: "Usamos
  Haskell para atender aos altos padrões de correção e segurança de
  nossos clientes"), finn.no ("we use Haskell in production", tradução
  livre: "usamos Haskell em produção") e NoRedInk ("The highest-traffic
  features of noredink.com are now served via Haskell", tradução livre:
  "Os recursos de maior tráfego do noredink.com agora são servidos por
  Haskell") [2]. O GHC ainda é lançado com frequência (GHC 9.12.4 em
  2026-03-27 [9]).
- **No ensino:** Haskell é o exemplo mais claro, neste repositório, de uma
  linguagem *puramente* funcional. Todos os outros programas de interface
  de linha de comando (CLI) daqui imprimem com uma instrução ou uma
  chamada de função que é executada de imediato. Em Haskell, o tipo
  `IO ()` mostra que imprimir é um efeito colateral, mantido separado do
  código puro pelo sistema de tipos.

## Comparando as categorias
| | [cli](cli/) | [web](web/) |
|---|---|---|
| Arquivo de projeto | nenhum: um único `hello.hs` | um pacote Cabal (um arquivo `.cabal`); "Cabal is a system for building and packaging Haskell libraries and programs" [13] (tradução livre: "Cabal é um sistema para compilar e empacotar bibliotecas e programas Haskell") |
| Bibliotecas | apenas o Prelude que acompanha o GHC (`putStrLn`) [4] | Scotty, "Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp" [14] (tradução livre: "framework web Haskell inspirado no Sinatra do Ruby, que usa WAI e Warp") |
| Compilado com | uma chamada: `ghc hello.hs` | `cabal build` |
| Downloads | nenhum | Scotty e suas dependências do Hackage, "the Haskell community's central package archive" [10] (tradução livre: "o arquivo central de pacotes da comunidade Haskell") |
| Primeira compilação | compila um arquivo, nada a baixar | baixa e compila o Scotty e suas dependências: 507 s (cerca de 8,5 min) com uma pasta do Cabal vazia, macOS Intel, 2026-11-01 |
| O que `main` faz | executa uma ação `putStrLn`, e depois o programa termina | inicia o servidor web Warp ("A fast, light-weight web server for WAI applications" [15], tradução livre: "Um servidor web rápido e leve para aplicações WAI") e fica bloqueado, atendendo requisições até que seja interrompido |
| Saída | `Hello, World!` na saída padrão | `<p>Hello, World!</p>` na resposta a `GET /`, em `PORT` (padrão 8080) |

O que permanece igual: ambos os programas são compilados pelo GHC para um
executável nativo, e em ambos `main` tem o tipo `IO ()`. A versão web
continua sendo Haskell puro. O Scotty apenas dá a `main` uma ação `IO`
maior para executar: "rodar um servidor" em vez de "imprimir uma linha". O
WAI, no qual o Scotty se baseia, "Provides a common protocol for
communication between web applications and web servers" [16] (tradução
livre: "Fornece um protocolo comum de comunicação entre aplicações web e
servidores web"). Compare com [Python](../python/README.md), cuja versão
web também precisa de um framework (Flask) vindo de um índice de pacotes.

## Por que não há versão desktop
Este repositório não tem uma versão desktop de Haskell: uma categoria só
permanece se existir uma toolchain mantida, convencional e razoavelmente
simples para ela em todos os sistemas operacionais de destino. As
bibliotecas gráficas de Haskell no Hackage falham, cada uma, em um destes
critérios:

- **`gi-gtk` (`haskell-gi`): mantida, mas exige o GTK instalado em todos os
  sistemas operacionais.** O `haskell-gi` gera "Haskell bindings for
  GObject Introspection capable libraries. This includes most notably GTK"
  [17] (tradução livre: "bindings Haskell para bibliotecas com suporte a
  GObject Introspection. Isso inclui, principalmente, o GTK"). O `gi-gtk`
  é mantido: a versão 4.0.12 foi enviada em 2025-01-01 e "re-exports (for
  backward compatibility) the haskell-gi generated bindings in the
  gi-gtk4 package" [18] (tradução livre: "reexporta (por compatibilidade
  retroativa) os bindings gerados pelo haskell-gi no pacote gi-gtk4").
  Mas o README diz: "To compile the bindings generated by haskell-gi, make
  sure that you have installed the necessary development packages for the
  libraries you are interested in" [19] (tradução livre: "Para compilar
  os bindings gerados pelo haskell-gi, certifique-se de ter instalado os
  pacotes de desenvolvimento necessários para as bibliotecas de seu
  interesse"). No macOS isso significa `brew install gobject-introspection
  gtk4` e mais uma definição de `PKG_CONFIG_PATH`, e o Windows tem um guia
  separado [19]. O estudante teria de instalar a biblioteca C do GTK e
  seus dados de introspecção em cada sistema operacional antes de escrever
  qualquer linha de Haskell, como na versão [C desktop](../c/desktop/). O
  próprio Hello World do README também ativa quatro extensões da
  linguagem [19].
- **wxHaskell: nenhuma versão desde 2017.** O wxHaskell "is built on top of
  wxWidgets - a comprehensive C++ library" (tradução livre: "é construído
  sobre o wxWidgets, uma biblioteca C++ abrangente"), e "This version
  works with wxWidgets 2.9 and 3.0" (tradução livre: "Esta versão
  funciona com o wxWidgets 2.9 e 3.0") [20]. Sua última versão no Hackage,
  a 0.92.3.0, foi enviada em 2017-04-28 [20].
- **threepenny-gui: não é uma janela desktop.** É um "GUI framework that
  uses the web browser as a display" (tradução livre: "framework de GUI
  que usa o navegador web como tela"): "A program written with Threepenny
  is essentially a small web server that displays the user interface as a
  web page to any browser that connects to it" [21] (tradução livre: "Um
  programa escrito com Threepenny é essencialmente um pequeno servidor web
  que exibe a interface do usuário como uma página web a qualquer
  navegador que se conecte a ele"). O README diz que ele "relies on a web
  browser being installed" (tradução livre: "depende de um navegador web
  instalado") e que uma aplicação desktop precisa do framework Electron,
  com "no fully automated support for this yet" (tradução livre: "ainda
  sem suporte totalmente automatizado para isso") [21]. O Hackage o marca:
  "This is an experimental release!" (tradução livre: "Esta é uma versão
  experimental!") [21]. Isso é, de novo, a versão [web](web/), e não uma
  versão desktop.
- **Monomer: nativo, mas exige bibliotecas C e tem pouca atividade.** O
  Monomer é "A GUI library for writing native Haskell applications" [22]
  (tradução livre: "Uma biblioteca de GUI para escrever aplicações Haskell
  nativas"). Seu guia de instalação pede as bibliotecas C SDL2 e GLEW em
  todos os sistemas operacionais (Homebrew no macOS, `pacman` dentro do
  MSYS2 do Stack no Windows) [23]. O README diz "there has not been a lot
  of activity in the past year" (tradução livre: "não houve muita
  atividade no último ano"), e a última versão no Hackage foi enviada em
  2024-01-08 [22].

Assim, um Hello World desktop em Haskell exigiria uma biblioteca de GUI em
C instalada em todos os sistemas operacionais (`gi-gtk`, Monomer),
dependeria de um binding sem versão desde 2017 (wxHaskell) ou seria uma
página web (threepenny-gui). Nenhuma mostra Haskell "the most simple and
direct way" (tradução livre: "da forma mais simples e direta").

## Fontes
1. Haskell 2010 Language Report, Chapter 1: Introduction. Simon Marlow (editor), haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch1.html> (acessado em 2026-11-01)
2. Haskell Language (home page: features and testimonials). haskell.org. <https://www.haskell.org/> (acessado em 2026-11-01)
3. Haskell 2010 Language Report, Chapter 6: Predefined Types and Classes (6.1.5 The Unit Datatype, 6.1.7 The IO and IOError Types). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch6.html> (acessado em 2026-11-01)
4. Haskell 2010 Language Report, Chapter 7: Basic Input/Output. haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch7.html> (acessado em 2026-11-01)
5. Haskell 2010 Language Report, Chapter 5: Modules. haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch5.html> (acessado em 2026-11-01)
6. Haskell 2010 Language Report, Preface. haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellli2.html> (acessado em 2026-11-01)
7. A History of Haskell: Being Lazy With Class. Paul Hudak, John Hughes, Simon Peyton Jones, Philip Wadler. HOPL-III, 2007. Microsoft Research. <https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/history.pdf> (acessado em 2026-11-01)
8. Haskell 2010 Language Report (title page and contents). Simon Marlow (editor), haskell.org. <https://www.haskell.org/onlinereport/haskell2010/> (acessado em 2026-11-01)
9. The Glasgow Haskell Compiler (home page and news). GHC developers, haskell.org. <https://www.haskell.org/ghc/> (acessado em 2026-11-01)
10. Hackage: The Haskell Package Repository. haskell.org. <https://hackage.haskell.org/> (acessado em 2026-11-01)
11. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-01)
12. 2026 Stack Overflow Developer Survey: Technology (data; languages, admired and desired). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-11-01)
13. The Haskell Cabal: Overview. haskell.org. <https://www.haskell.org/cabal/> (acessado em 2026-11-01)
14. `scotty`: Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp. Hackage. <https://hackage.haskell.org/package/scotty> (acessado em 2026-11-01)
15. warp: A fast, light-weight web server for WAI applications. Hackage. <https://hackage.haskell.org/package/warp> (acessado em 2026-11-01)
16. wai: Web Application Interface. Hackage. <https://hackage.haskell.org/package/wai> (acessado em 2026-11-01)
17. haskell-gi: Generate Haskell bindings for GObject Introspection capable libraries. Hackage. <https://hackage.haskell.org/package/haskell-gi> (acessado em 2026-11-01)
18. `gi-gtk`: Gtk 4.x bindings (compatibility layer). Hackage. <https://hackage.haskell.org/package/gi-gtk> (acessado em 2026-11-01)
19. haskell-gi/haskell-gi (README: Installation). GitHub. <https://github.com/haskell-gi/haskell-gi> (acessado em 2026-11-01)
20. wx: wxHaskell. Hackage. <https://hackage.haskell.org/package/wx> (acessado em 2026-11-01)
21. threepenny-gui: GUI framework that uses the web browser as a display. Hackage. <https://hackage.haskell.org/package/threepenny-gui> (acessado em 2026-11-01)
22. monomer: A GUI library for writing native Haskell applications. Hackage. <https://hackage.haskell.org/package/monomer> (acessado em 2026-11-01)
23. Monomer tutorial 00: Setup (Libraries: SDL2 and GLEW). fjvallarino/monomer, GitHub. <https://github.com/fjvallarino/monomer/blob/main/docs/tutorials/00-setup.md> (acessado em 2026-11-01)
