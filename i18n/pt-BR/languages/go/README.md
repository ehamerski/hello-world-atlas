---
source: languages/go/README.md
source_sha: 6ba33517b67c9fc7d2d041cfb04c91fb1ea2d28a
---
# Go

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** imperativo, com concorrência embutida. A especificação
chama o Go de "a general-purpose language designed with systems programming
in mind. It is strongly typed and garbage-collected and has explicit
support for concurrent programming" [1] (tradução livre: "uma linguagem de
propósito geral projetada com a programação de sistemas em mente. É
fortemente tipada, tem coleta de lixo e oferece suporte explícito à
programação concorrente"). Sobre a questão de o Go ser orientado a objetos,
o FAQ responde: "Yes and no. Although Go has types and methods and allows
an object-oriented style of programming, there is no type hierarchy" [2]
(tradução livre: "Sim e não. Embora o Go tenha tipos e métodos e permita um
estilo de programação orientado a objetos, não existe hierarquia de
tipos"). Não há classes: compare com as versões em [Java](../java/README.md),
em que até um programa de uma linha precisa de uma. A versão
[desktop](desktop/) usa a concorrência do Go uma vez, com uma goroutine.

Ver também: [paradigmas](../../docs/paradigms.md#imperative) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | toolchain do Go | ✅ |
| desktop | [desktop/](desktop/) | Fyne | ✅ |
| web | [web/](web/) | `net/http` + `html/template` (biblioteca padrão) | ✅ |
| web + front-end separado | [web-vue/](web-vue/) | API em Go + Vue (Vite) | ✅ |

## História
O Go foi projetado no Google. O FAQ informa a data exata de seu início:
"Robert Griesemer, Rob Pike and Ken Thompson started sketching the goals
for a new language on the white board on September 21, 2007" [2] (tradução
livre: "Robert Griesemer, Rob Pike e Ken Thompson começaram a esboçar, no
quadro branco, os objetivos de uma nova linguagem em 21 de setembro de
2007"). "By January 2008, Ken had started work on a compiler with which to
explore ideas; it generated C code as its output." (tradução livre: "Em
janeiro de 2008, Ken havia começado a trabalhar em um compilador para
explorar ideias; ele gerava código C como saída.") Em maio de 2008, Ian
Taylor iniciou um front-end do GCC para o Go, e "Russ Cox joined in late
2008 and helped move the language and libraries from prototype to reality"
[2] (tradução livre: "Russ Cox entrou no final de 2008 e ajudou a levar a
linguagem e as bibliotecas do protótipo à realidade").

O FAQ apresenta o motivo de uma nova linguagem: "Go was born out of
frustration with existing languages and environments for the work we were
doing at Google. ... One had to choose either efficient compilation,
efficient execution, or ease of programming; all three were not available
in the same mainstream language" [2] (tradução livre: "O Go nasceu da
frustração com as linguagens e os ambientes existentes para o trabalho que
fazíamos no Google. ... Era preciso escolher entre compilação eficiente,
execução eficiente ou facilidade de programação; as três não estavam
disponíveis na mesma linguagem de uso corrente"). A palestra de abertura de
Rob Pike em 2012 afirma: "Go is a programming language designed by Google
to help solve Google's problems, and Google has big problems" (tradução
livre: "O Go é uma linguagem de programação projetada pelo Google para
ajudar a resolver os problemas do Google, e o Google tem grandes
problemas"), e, entre esses problemas, cita "slow builds" (compilações
lentas) e "uncontrolled dependencies" (dependências descontroladas) [3].

"Go became a public open source project on November 10, 2009" [2] (tradução
livre: "O Go tornou-se um projeto público de código aberto em 10 de
novembro de 2009"). Nesse dia, o Google Open Source Blog anunciou "an
experimental new language called Go" [4] (tradução livre: "uma nova
linguagem experimental chamada Go"). O Go 1 veio em 28 de março de 2012,
definindo "a language and a set of core libraries to provide a stable
foundation for creating reliable products, projects, and publications" [5]
(tradução livre: "uma linguagem e um conjunto de bibliotecas centrais para
oferecer uma base estável para a criação de produtos, projetos e
publicações confiáveis"). Sua promessa de compatibilidade continua
valendo: "programs written to the Go 1 specification will continue to
compile and run correctly, unchanged, over the lifetime of that
specification" [6] (tradução livre: "os programas escritos conforme a
especificação do Go 1 continuarão a compilar e a executar corretamente, sem
alterações, durante a vida útil dessa especificação"). Por isso, todas as
versões desde então têm número de versão 1.x [7].

O Go compila para código de máquina nativo, e "the linker in the gc
toolchain creates statically-linked binaries by default" [2] (tradução
livre: "o linker da toolchain gc cria, por padrão, binários ligados
estaticamente"). Todo programa ainda carrega um runtime, que "implements
garbage collection, concurrency, stack management, and other critical
features" (tradução livre: "implementa a coleta de lixo, a concorrência, o
gerenciamento de pilha e outros recursos críticos"), mas "Go's runtime does
not include a virtual machine, such as is provided by the Java runtime" [2]
(tradução livre: "o runtime do Go não inclui uma máquina virtual, como a
fornecida pelo runtime do Java").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 2007-09-21 | Griesemer, Pike e Thompson esboçam os objetivos da linguagem em um quadro branco | [2] |
| 2008-01 | Ken Thompson inicia o primeiro compilador (que gerava código C) | [2] |
| 2009-11-10 | O Go se torna um projeto de código aberto | [2][4] |
| 2012-03-28 | Go 1: uma linguagem e uma biblioteca padrão estáveis, com a promessa de compatibilidade do Go 1 | [5][6][7] |
| 2015-08-19 | Go 1.5: "The compiler and runtime are now written entirely in Go (with a little assembler)" (o compilador e o runtime agora são escritos inteiramente em Go, com um pouco de montador) | [7][8] |
| 2018-08-24 | Go 1.11: "preliminary support for a new concept called "modules"" (suporte preliminar a um novo conceito chamado "módulos") | [7][9] |
| 2021-02-16 | Go 1.16: modo com reconhecimento de módulos ativado por padrão; `//go:embed` | [7][10] |
| 2022-03-15 | Go 1.18: tipos genéricos ("an implementation of generic features as described by the Type Parameters Proposal", isto é, uma implementação dos recursos genéricos descritos pela Type Parameters Proposal) | [7][11] |
| 2023-08-08 | Go 1.21: a linha `go` do `go.mod` passa a ser um requisito, não uma recomendação | [7][12] |
| 2024-02-06 | **Go 1.22, o mínimo usado neste repositório**: padrões de método e de curinga no roteador do `net/http` | [7][13] |
| 2026-08-19 | Go 1.27, a versão principal mais recente em 2026-10-31 (1.27.3 em 2026-10-19) | [7] |

O Go não tem versões de suporte de longo prazo: "Each major Go release is
supported until there are two newer major releases" [7] (tradução livre:
"Cada versão principal do Go é suportada até que existam duas versões
principais mais novas"). As versões principais recentes saíram em fevereiro
e em agosto: Go 1.25 em 2025-08-12, Go 1.26 em 2026-02-10 e Go 1.27 em
2026-08-19 [7].

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam todos os anos.

- **Índice TIOBE, outubro de 2026:** o Go ocupa a posição 11, com
  avaliação de 1,39%. Estava na posição 8 em outubro de 2025 [14]. O TIOBE
  observa que incluiu termos de busca em mandarim nesse mês, de modo que
  as classificações entre meses devem ser comparadas com cautela [14].
- **Stack Overflow Developer Survey 2026:** 16,5% de todos os respondentes
  da pergunta sobre linguagens de programação usaram Go (2.332 de 14.099)
  [15]. Entre os que o usaram, 49,5% querem continuar usando ("admired");
  17,7% de todos os respondentes querem usá-lo ("desired") [15]. Na
  pergunta sobre frameworks web, 17,2% usaram Vue.js (base de 10.281) [15].
- **Onde o Go é usado:** "Go is used widely in production inside Google"
  (tradução livre: "O Go é amplamente usado em produção dentro do Google")
  e "a couple of major cloud infrastructure projects written in Go are
  Docker and Kubernetes, but there are many more" (tradução livre: "alguns
  dos principais projetos de infraestrutura em nuvem escritos em Go são o
  Docker e o Kubernetes, mas há muitos outros"), declaração da equipe do Go
  em seu FAQ [2]. A página de estudos de caso do Go lista empresas como
  American Express, Cloudflare, Dropbox, Microsoft, Monzo, Netflix, PayPal,
  Twitch e Uber [16]; a ByteDance afirma que "70% of microservices within
  ByteDance are written by Go" [16] (tradução livre: "70% dos microsserviços
  da ByteDance são escritos em Go"). São depoimentos de empresas reunidos
  pelo projeto Go, e não medições independentes.

## Importância antes e agora
- **Antes (2007–2012):** o Go foi uma reação às compilações lentas e às
  linguagens complexas do Google. Seus autores queriam "the efficiency, the
  safety, and the fluidity in a single language" [2] (tradução livre: "a
  eficiência, a segurança e a fluidez em uma única linguagem"). O Go
  "addressed these issues by attempting to combine the ease of programming
  of an interpreted, dynamically typed language with the efficiency and
  safety of a statically typed, compiled language", com "support for
  networked and multicore computing" [2] (tradução livre: "tratou dessas
  questões tentando combinar a facilidade de programação de uma linguagem
  interpretada e de tipagem dinâmica com a eficiência e a segurança de uma
  linguagem compilada e de tipagem estática", com "suporte à computação em
  rede e multinúcleo").
- **Estabilidade:** desde 2012, a promessa do Go 1 mantém programas antigos
  compilando [6]. O código deste repositório escrito para o Go 1.22 compila
  sem alterações com o Go 1.27.
- **Agora:** o Go é uma linguagem de serviços em rede e de infraestrutura
  em nuvem (Docker e Kubernetes, segundo o FAQ [2]). Foi usado por 16,5% dos
  respondentes do Stack Overflow em 2026 [15] e ocupa a posição 11 no TIOBE
  (outubro de 2026) [14].
- **No ensino:** um Hello World em Go é uma cláusula de pacote, um import e
  uma função `main`: mais curto que em Java, mais longo que em Python. A
  linguagem é estrita de maneiras que ajudam iniciantes a perceber erros
  cedo: "Go refuses to compile programs with unused variables or imports"
  [2] (tradução livre: "O Go se recusa a compilar programas com variáveis
  ou imports não usados"), e o `gofmt` dá a todo código Go um único layout
  [17].

## Comparação entre as categorias
| | [`cli`](cli/) | [`desktop`](desktop/) | [`web`](web/) | [`web-vue`](web-vue/) |
|---|---|---|---|---|
| Linhas de Go (sem comentários, sem linhas em branco) | 5 | 27 (9 são a autoverificação) | 23 | 25 (+ 26 linhas de Vue/JavaScript) |
| Biblioteca | `fmt` (biblioteca padrão) | Fyne v2.8.2 (baixada) | `net/http`, `html/template` (biblioteca padrão) | `net/http`, `encoding/json` + Vue 3.5, Vite 8 |
| Requer um compilador C (cgo) | não | **sim** | não | não |
| Módulos Go baixados (`go.sum`) | nenhum | Fyne e suas dependências | nenhum | nenhum (o npm instala os pacotes do front-end) |
| Resultado da compilação (`build.sh`) | `bin/hello-cli` (2,5 MB) | `bin/hello-desktop` (34,2 MB) | `bin/hello-web` (13,6 MB) | `backend/bin/hello-api` (10,0 MB) + `frontend/dist/` |
| Primeira compilação na máquina de teste (macOS Intel) | alguns segundos | cerca de 55 s (código C do Fyne) | alguns segundos | alguns segundos (Go + Vite) |
| Quem controla o laço | ninguém: `main` imprime e retorna | o laço de eventos do Fyne (`ShowAndRun`) | `http.ListenAndServe` | o servidor Go e, no navegador, o Vue |
| Saída | texto na saída padrão (stdout) | uma janela nativa | HTML vindo do servidor | JSON vindo do servidor; HTML desenhado pelo Vue |

Os tamanhos dos executáveis vêm de `ls -l` no macOS Intel com o Go 1.27.3
(2026-10-31). Eles mostram o que significa a ligação estática: cada
executável contém todo o seu runtime e todos os pacotes que usa, e o
executável desktop contém também o Fyne.

O que permanece igual: toda pasta é um módulo Go com um `go.mod` e um
`main.go` em sua raiz, e todo `build.sh` executa
`go build -o bin/<name> .`. O resultado é sempre um único executável nativo,
que roda sem o Go instalado. Compare com o [Java](../java/README.md), em que
toda versão precisa de uma JVM em tempo de execução, e com o
[Python](../python/README.md), que não tem etapa de compilação.

O Go tem uma implementação em cada uma de suas quatro categorias, de modo
que esta página não tem seção que explique uma categoria ausente.


## Fontes
1. The Go Programming Language Specification (Introduction). The Go Authors. <https://go.dev/ref/spec> (acessado em 2026-10-31)
2. Frequently Asked Questions (FAQ). The Go Authors. <https://go.dev/doc/faq> (acessado em 2026-10-31)
3. Go at Google: Language Design in the Service of Software Engineering. Rob Pike, SPLASH 2012 keynote (2012-10-25). <https://go.dev/talks/2012/splash.article> (acessado em 2026-10-31)
4. Hey! Ho! Let's Go!. Google Open Source Blog, 2009-11-10. <https://opensource.googleblog.com/2009/11/hey-ho-lets-go.html> (acessado em 2026-10-31)
5. Go version 1 is released. Andrew Gerrand, The Go Blog, 2012-03-28. <https://go.dev/blog/go1> (acessado em 2026-10-31)
6. Go 1 and the Future of Go Programs. The Go Authors. <https://go.dev/doc/go1compat> (acessado em 2026-10-31)
7. Release History. The Go Authors. <https://go.dev/doc/devel/release> (acessado em 2026-10-31)
8. Go 1.5 Release Notes. The Go Authors. <https://go.dev/doc/go1.5> (acessado em 2026-10-31)
9. Go 1.11 Release Notes. The Go Authors. <https://go.dev/doc/go1.11> (acessado em 2026-10-31)
10. Go 1.16 Release Notes. The Go Authors. <https://go.dev/doc/go1.16> (acessado em 2026-10-31)
11. Go 1.18 Release Notes. The Go Authors. <https://go.dev/doc/go1.18> (acessado em 2026-10-31)
12. Go Modules Reference (go directive). The Go Authors. <https://go.dev/ref/mod#go-mod-file-go> (acessado em 2026-10-31)
13. Routing Enhancements for Go 1.22. Jonathan Amsterdam, The Go Blog, 2024-02-13. <https://go.dev/blog/routing-enhancements> (acessado em 2026-10-31)
14. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-10-31)
15. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
16. Case Studies. The Go Authors. <https://go.dev/solutions/case-studies> (acessado em 2026-10-31)
17. Effective Go (Formatting). The Go Authors. <https://go.dev/doc/effective_go#formatting> (acessado em 2026-10-31)
