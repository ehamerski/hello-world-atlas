---
source: languages/clojure/README.md
source_sha: d1f0cc670b9d62140191d21e01d7c81d933cab18
---
# Clojure

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** funcional, com suporte nativo à concorrência. A história da
linguagem, escrita por Rich Hickey, diz que o Clojure "was designed to be a
general-purpose, practical functional language, suitable for use by
professionals wherever its host language, e.g., Java, would be" (tradução
livre: "foi projetado para ser uma linguagem funcional prática e de propósito
geral, adequada ao uso por profissionais onde quer que sua linguagem
hospedeira, por exemplo o Java, fosse"), e que ele "complements programming
with pure functions of immutable data with concurrency-safe state management
constructs that support writing correct multithreaded programs without the
complexity of mutex locks" [1] (tradução livre: "complementa a programação com
funções puras sobre dados imutáveis com construções de gerenciamento de estado
seguras para a concorrência, que permitem escrever programas multithread
corretos sem a complexidade dos mutex locks"). É um dialeto do Lisp, de modo
que o código é escrito como listas, e executa sobre um hospedeiro: neste
repositório, a Java Virtual Machine (JVM) [1].

Veja também: [paradigmas](../../docs/paradigms.md#functional) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | Clojure CLI 1.12.6.1673 | ✅ |
| desktop | [desktop/](desktop/) | Swing via interoperabilidade com Java, Clojure CLI | ✅ |
| web | [web/](web/) | Ring + Jetty, Clojure CLI | ✅ |

Nenhuma das três pastas tem um `build.sh`. O Clojure é compilado, mas o
compilador roda quando o programa é carregado; o motivo está no
[README do cli](cli/README.md#why-there-is-no-buildsh).

## História
**Quem e por quê.** Rich Hickey escreveu a linguagem. Ele trabalhava como
desenvolvedor comercial desde 1987, "first in C++, then Java and C#" (tradução
livre: "primeiro em C++, depois em Java e C#"), e depois usou o Common Lisp em
dois sistemas [1]. Dessa experiência, escreveu: "It was a revelation. Huge
layers of unnecessary complexity simply vanished" [1] (tradução livre: "Foi uma
revelação. Enormes camadas de complexidade desnecessária simplesmente
desapareceram"). No primeiro dos dois sistemas, o programa "had to be
rewritten in C++ in order to be acceptable for deployment" (tradução livre:
"teve de ser reescrito em C++ para ser aceitável para implantação"), e no
segundo "Common Lisp was not acceptable for deployment" (tradução livre: "o
Common Lisp não era aceitável para implantação") também [1]. O objetivo do
Clojure, nas palavras dele: "I wanted a language as acceptable as Java or C#,
but supporting a much simpler programming model, to use for the kinds of
information system development I had been doing professionally" [1] (tradução
livre: "Eu queria uma linguagem tão aceitável quanto Java ou C#, mas com um
modelo de programação muito mais simples, para usar nos tipos de
desenvolvimento de sistemas de informação que eu vinha fazendo
profissionalmente"). A justificativa (rationale) do clojure.org a resume como o
desejo de "A Lisp for Functional Programming symbiotic with an established
Platform designed for Concurrency" [2] (tradução livre: "Um Lisp para
Programação Funcional simbiótico com uma Plataforma estabelecida, projetado
para a Concorrência").

**Quando e onde.** "I started working on Clojure in 2005, during a sabbatical
I funded out of retirement savings" [1] (tradução livre: "Comecei a trabalhar
no Clojure em 2005, durante um período sabático que financiei com as
economias da aposentadoria"). Ele o anunciou em 2007-10-17 aos membros de uma
lista de discussão, como "Clojure, a dialect of Lisp for the JVM. It’s
currently alpha, but fairly complete" [1] (tradução livre: "Clojure, um
dialeto do Lisp para a JVM. Atualmente está em alfa, mas bastante completo"),
e "announced and released the first version of Clojure, as an open source
project, in the fall of 2007" [1] (tradução livre: "anunciou e lançou a
primeira versão do Clojure, como projeto de código aberto, no outono de
2007"). Ele fez "100% of the implementation work" (tradução livre: "100% do
trabalho de implementação") até o lançamento, e "more than 90% through the 1.2
release in 2010" (tradução livre: "mais de 90% até a versão 1.2, em 2010")
[1]. Depois disso a comunidade contribuiu, e o autor é aceito como "benevolent
dictator for life" [1] (tradução livre: "ditador benevolente vitalício").

**Que tipo de Lisp.** O resumo do artigo diz que "Clojure is a dialect of
Lisp, but is not a direct descendant of any prior Lisp" [1] (tradução livre:
"Clojure é um dialeto do Lisp, mas não é um descendente direto de nenhum Lisp
anterior"). A justificativa lista o que ele mantém (código como dado, pouca
sintaxe, um núcleo pequeno) e o que ele muda: para os Lisps padrão, ela lista
"Core data structures mutable, not extensible" e "No concurrency in specs" [2]
(tradução livre: "Estruturas de dados centrais mutáveis, não extensíveis" e
"Nenhuma concorrência nas especificações"). O Clojure usa estruturas de dados
imutáveis e persistentes e oferece suporte nativo à concorrência, "software
transactional memory and asynchronous agents" [2] (tradução livre: "memória
transacional por software e agentes assíncronos").

**Hospedado.** O Clojure "is intentionally hosted, in that it compiles to and
runs on the runtime of another language, such as the JVM" [1] (tradução livre:
"é intencionalmente hospedado, no sentido de que compila para o runtime de
outra linguagem, como a JVM, e executa nele"). Na JVM, "Clojure is always
compiled (on the JVM, to Java bytecode), there is no interpreter" [1]
(tradução livre: "o Clojure é sempre compilado (na JVM, para bytecode Java),
não há interpretador"). Os programas chamam bibliotecas Java diretamente. A
versão [desktop](desktop/) usa o Swing dessa maneira, e a versão [web](web/)
executa no Jetty, um servidor web Java.

## Marcos
| Ano | Marco | Fonte |
|---|---|---|
| 2005 | Rich Hickey inicia o trabalho em um período sabático autofinanciado | [1] |
| 2007-10-17 | Primeiro anúncio: "Clojure, a dialect of Lisp for the JVM", em estágio alfa | [1] |
| 2009-05 | Clojure 1.0; o primeiro livro sobre Clojure aparece ao mesmo tempo | [1] |
| 2009-12 | Clojure 1.1: sequências em blocos (chunked sequences) e transients | [1] |
| 2010 | Primeira pesquisa anual com a comunidade Clojure (487 respondentes); o Clojure 1.2 acrescenta protocolos, `reify`, `deftype` e `defrecord` | [1] |
| 2011 | ClojureScript, uma implementação do Clojure que executa em engines de JavaScript | [1] |
| 2013 | A Cognitect é formada e se torna "the de facto corporate sponsor of Clojure" | [1] |
| 2015-06 | Clojure 1.7: reader conditionals e transducers | [1][3] |
| 2020-06 | O "A History of Clojure", de Hickey, é publicado para a quarta conferência sobre a História das Linguagens de Programação (HOPL IV) | [1][4] |
| 2024-09 | Clojure 1.12.0: nova interoperabilidade com o Java, entre outros recursos (métodos qualificados como `Class/method`, conversão de interfaces funcionais) | [3][5] |
| 2026-09-02 | Clojure 1.12.6, a versão estável no momento da redação, com o Java 25 recomendado e o Java 8 como mínimo | [6] |

O artigo data o Clojure 1.0 de "May of 2009" [1] (tradução livre: "maio de
2009"), enquanto a página "Older Downloads" do clojure.org lista "Clojure 1.0.0
(Jul, 2009)" [3]. Esta página segue o relato do autor e registra a diferença.

## Uso de mercado hoje
Cada número abaixo traz sua data e sua fonte. Eles mudam todos os anos.

- **Stack Overflow Developer Survey 2026:** 1,3% de todos os respondentes da
  pergunta sobre linguagens de programação fizeram desenvolvimento extensivo
  em Clojure no último ano (187 de 14.099) [7]. Na mesma pesquisa, 48,7% dos
  respondentes que já usaram Clojure querem continuar a usá-lo ("admired"), e
  2,5% de todos os respondentes querem usá-lo no próximo ano ("desired") [7].
- **Índice TIOBE, outubro de 2026:** o Clojure não está entre os 50 primeiros.
  O TIOBE o lista apenas pelo nome, em ordem alfabética, entre as linguagens
  classificadas de 51 a 100 [8].
- **Pesquisa State of Clojure 2025 (resultados publicados em 2026-02-18):** os
  respondentes vieram de 80 países, e cerca de dois terços usam o Clojure como
  linguagem principal. O uso profissional (71%) lidera, e 52% o usam em
  projetos de lazer. Serviços financeiros, software corporativo e saúde são os
  principais setores [9]. 70% dos respondentes "said they were very likely to
  recommend Clojure" [9] (tradução livre: "disseram ser muito prováveis de
  recomendar o Clojure").
- **Pesquisa anterior, 2019:** 2.461 respondentes; 60% das empresas que usam
  Clojure também usavam o ClojureScript [1]. O artigo acrescenta que "Clojure
  is in production at hundreds of companies" [1] (tradução livre: "o Clojure
  está em produção em centenas de empresas").

A pesquisa State of Clojure consulta usuários de Clojure, de modo que seus
respondentes não são uma amostra de todos os programadores [9]. Para a
profissão como um todo, o número do Stack Overflow é a melhor referência.

## Importância antes e agora
- **Antes (2005–2009):** o autor escreveu que "the year 2005 may have
  represented the nadir of language diversity in commercial software
  development" (tradução livre: "o ano de 2005 pode ter representado o ponto
  mais baixo da diversidade de linguagens no desenvolvimento comercial de
  software"), com muitas empresas "considering themselves either Java or .Net
  ‘shops’" [1] (tradução livre: "considerando-se ‘casas’ Java ou .Net"). O
  conselho de desenvolvedores profissionais era que o Lisp "it’s dead"
  (tradução livre: "está morto"), a programação funcional era "what’s that?"
  (tradução livre: "o que é isso?") e escrever uma nova linguagem era "you’re
  crazy" (tradução livre: "você é maluco") [1]. O Clojure respondeu com um Lisp
  que executa na plataforma que essas empresas já tinham aprovado, a JVM, "with
  immutable persistent data structures" e concorrência nativa [2] (tradução
  livre: "com estruturas de dados persistentes imutáveis"). A justificativa
  diz que "pervasive, unmoderated mutation simply has to go" para o futuro
  concorrente [2] (tradução livre: "a mutação generalizada e sem moderação
  simplesmente precisa acabar").
- **Agora:** o Clojure continua sendo uma linguagem pequena em uso (1,3% na
  pesquisa do Stack Overflow de 2026, fora dos 50 primeiros do TIOBE) [7][8],
  com uma comunidade fiel: 48,7% de seus usuários na pesquisa do Stack
  Overflow o usariam novamente [7], e a pesquisa da comunidade de 2025 mostra
  o uso profissional como a finalidade principal [9]. O resumo do artigo lista
  a adoção "in industries as diverse as finance, climate science, retail,
  databases, analytics, publishing, healthcare, advertising and genomics" [1]
  (tradução livre: "em setores tão diversos quanto finanças, ciência do clima,
  varejo, bancos de dados, análise de dados, editoração, saúde, publicidade e
  genômica"). A linguagem ainda é desenvolvida: a 1.12.6 é a versão estável, e
  pré-lançamentos da 1.13 são publicados [6].
- **No ensino:** um Hello World em Clojure é um espaço de nomes (namespace) e
  uma função. Compare com a versão Java do programa [cli](../java/cli/), que
  precisa de uma classe e de um `public static void main` antes da primeira
  linha de saída.

## Comparação entre as categorias
| | [cli](cli/) | [desktop](desktop/) | [web](web/) |
|---|---|---|---|
| Linhas de Clojure (sem comentários, sem linhas em branco; a forma `ns` conta) | 3 | 25 (9 são a autoverificação) | 9 |
| Biblioteca | nenhuma (`println`) | Swing (no JDK), por meio de interop | Ring 1.15.6 + Jetty 12.1.14 |
| `:deps` do `deps.edn` | vazio | vazio | `ring/ring-core`, `ring/ring-jetty-adapter` |
| Ponto de entrada | o `-main` imprime e retorna | o `-main` chama `invokeLater`; a janela é construída na event dispatch thread | o `-main` chama `run-jetty`, que bloqueia |
| Saída da compilação | nenhuma; o código é compilado em memória | nenhuma | nenhuma |
| Como executa | `clojure -M -m hello.core` | o mesmo | o mesmo, atende até o Ctrl+C |
| Saída | texto no stdout | uma janela nativa | HTML vindo do servidor |
| Instalação extra | nenhuma | nenhuma | nenhuma (o CLI baixa o Ring e o Jetty) |

O que permanece igual: toda versão é um projeto `deps.edn` com o código em
`src/hello/core.clj`, iniciado por `clojure -M -m hello.core`. Nenhuma versão
tem um `build.sh` ou uma pasta `target/`; apenas o `.cpcache/` do CLI aparece.
Compare com o [Java](../java/README.md#comparing-the-categories), em que cada
versão é um projeto Maven que o `javac` compila primeiro.

O que difere é a biblioteca e qual código executa o laço principal. O cli
executa o `-main` e termina. Na versão desktop, a event dispatch thread do
Swing espera eventos da janela. Na versão web, o Jetty espera requisições
HTTP. A parte em Clojure também muda de estilo. O cli é uma única chamada. A
versão desktop é em sua maior parte interop com o Java (`(JFrame. ...)`,
`(.pack frame)`), de modo que se lê como a [versão Java](../java/desktop-swing/)
com os parênteses movidos. A versão web é a mais próxima do estilo Clojure: o
tratador é uma função que retorna um mapa, como a especificação do Ring o
define [10].

As três categorias estão implementadas para o Clojure, de modo que a página
não tem uma seção "por que não há categoria".

## Fontes
1. A History of Clojure. Rich Hickey, Proc. ACM Program. Lang. 4, HOPL, Article 71, June 2020 (author's PDF as linked from clojure.org/about/history; Internet Archive copy, because download.clojure.org redirects to dl.acm.org, which refuses automated downloads). <https://web.archive.org/web/2023/https://download.clojure.org/papers/clojure-hopl-iv-final.pdf> (acessado em 2026-11-04). The published version: <https://doi.org/10.1145/3386321>.
2. Rationale. Rich Hickey, clojure.org. <https://clojure.org/about/rationale> (acessado em 2026-11-04)
3. Older Downloads (release dates of Clojure 1.0.0 to 1.12.x). clojure.org. <https://clojure.org/releases/downloads_older> (acessado em 2026-11-04)
4. History. clojure.org (about the HOPL IV paper). <https://clojure.org/about/history> (acessado em 2026-11-04)
5. Changes to Clojure in Version 1.12.0. Clojure core team, GitHub. <https://github.com/clojure/clojure/blob/master/changes.md> (acessado em 2026-11-04)
6. Clojure Downloads (stable release 1.12.6, Sep 2, 2026; development release 1.13.0-alpha11; Java recommendation). clojure.org. <https://clojure.org/releases/downloads> (acessado em 2026-11-04)
7. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-11-04)
8. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-04)
9. State of Clojure 2025 Results. Christoph Neumann, clojure.org, 2026-02-18. <https://clojure.org/news/2026/02/18/state-of-clojure-2025> (acessado em 2026-11-04)
10. The Ring Specification (SPEC.md). ring-clojure, GitHub. <https://github.com/ring-clojure/ring/blob/master/SPEC.md> (acessado em 2026-11-04)
