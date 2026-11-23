---
source: languages/clojure/web/README.md
source_sha: ee2f13b26d6f78d23383d86f65d03fbc421586d7
---
# Clojure · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Clojure](../README.md)

## O que é
Um servidor web que responde a `GET /` com o HTML `<p>Hello, World!</p>`. Ele
é construído com o **Ring**, a interface padrão de aplicações web do Clojure,
e executa no **Jetty**, um servidor web Java que o adaptador Jetty do Ring
embute. O servidor escuta em `127.0.0.1` (somente este computador), na porta
indicada pela variável de ambiente `PORT` (padrão 8080). Ele executa até que o
leitor pressione Ctrl+C.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Java runtime 21 ou superior | Eclipse Temurin 21.0.8 | executa o bytecode do Clojure, do Ring e do Jetty |
| Clojure CLI | 1.12.6.1673 (Clojure 1.12.6) | baixa as bibliotecas e inicia a JVM; veja [../cli](../cli/README.md#prerequisites) |
| `ring/ring-core` | 1.15.6 | as funções de requisição e de resposta do Ring [1] |
| `ring/ring-jetty-adapter` | 1.15.6 (traz o Jetty 12.1.14) | "a Ring adapter that uses an embedded Jetty web server" [1][2] (tradução livre: "um adaptador do Ring que usa um servidor web Jetty embutido") |

O `curl` é usado pelo `./run.sh --verify`. As bibliotecas vêm do Clojars e do
Maven Central; o `install.sh` as baixa com `clojure -P`.

## Início rápido
```sh
./install.sh   # check / install Java and the Clojure CLI, download Ring and Jetty
./run.sh       # serve http://localhost:8080/ until Ctrl+C
```
Não há `build.sh`: o Clojure compila o código-fonte quando o carrega. O motivo
está em [../cli](../cli/README.md#why-there-is-no-buildsh).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Os mesmos três passos de [../cli](../cli/README.md#scripts-explained). O passo 3, `clojure -P`, também baixa o Ring, o Jetty e suas dependências para `~/.m2`. | Assim, a primeira inicialização não precisa baixar nada. |
| `run.sh` | Exporta `PORT` (padrão 8080) e executa `clojure -M -m hello.core`, que permanece ativo. Com `--verify`, inicia o servidor em segundo plano, busca a página uma vez com o `curl` e encerra o servidor. | O `hello.core` também lê `PORT`, de modo que o script e o servidor concordam. A autoverificação permite que o `scripts/verify-all.sh` teste o servidor sem esperar pelo leitor. |
| `clojure-env.sh` | Define a versão do CLI, o checksum do instalador e `CLOJURE_DIR`. | O mesmo arquivo de [../cli](../cli/). |

## Estrutura de pastas
```text
web/
├── README.md        this file
├── install.sh       checks / installs Java and the Clojure CLI, downloads the libraries
├── run.sh           starts the server
├── clojure-env.sh   toolchain settings, sourced by the scripts
├── deps.edn         project file: source folder and the two Ring libraries
├── screenshot.png   the page in a browser, for "Expected output" below
├── .gitignore       ignores .cpcache/ (the CLI's classpath cache)
└── src/
    └── hello/
        └── core.clj   the program: namespace hello.core
```
O layout é o mesmo de [../cli](../cli/README.md#folder-structure) [3].

## Passo a passo
Abra o [`core.clj`](src/hello/core.clj) e o [`deps.edn`](deps.edn) ao lado
desta lista.

1. **`deps.edn`** nomeia as duas bibliotecas e suas versões. O CLI as baixa,
   junto com o que elas precisam, do Clojars e do Maven Central [3]. Os
   projetos Java fazem isso no `pom.xml`
   ([java/web](../../java/web/README.md#folder-structure)).
2. **`(:require [ring.adapter.jetty :as jetty])`** carrega o espaço de nomes
   (namespace) que inicia o Jetty e lhe dá o nome curto `jetty`. O `import` do
   Java e o `import ... as ...` do Python são as formas mais próximas.
3. **O modelo do Ring.** O README do Ring diz que o Ring é "inspired by
   Python's WSGI and Ruby's Rack" [1] (tradução livre: "inspirado no WSGI do
   Python e no Rack do Ruby"). A especificação do Ring diz que "Handlers are
   implemented as Clojure functions" e que "A synchronous handler takes 1
   argument, a request map, and returns a response map" [4] (tradução livre:
   "Os tratadores são implementados como funções Clojure" e "Um tratador
   síncrono recebe 1 argumento, um mapa de requisição, e retorna um mapa de
   resposta"). Um adaptador é uma função que recebe um tratador e opções e
   inicia um servidor [4]; o `run-jetty` é o adaptador do Jetty.
4. **`handler`** recebe o mapa de requisição (o parâmetro `_request` não é
   usado, e o sublinhado inicial indica isso) e retorna o mapa de resposta:
   `:status 200`, `:headers` com `Content-Type` e `:body` com a string HTML. O
   Spring Boot ([java/web](../../java/web/)) usa classes e métodos anotados
   para a mesma tarefa; aqui o tratador é uma única função e seu resultado é
   dado.
5. **`-main`.** `(System/getenv "PORT")` chama o `System.getenv` do Java. Ele
   retorna `nil` quando a variável não está definida, e então o `or` escolhe o
   padrão `"8080"`. O `parse-long` transforma o texto em número.
6. **`jetty/run-jetty`** inicia o servidor. Suas opções são um mapa [5]:
   `:host "127.0.0.1"` escuta somente neste computador, `:port` é a porta e
   `:join? true` bloqueia a thread chamadora até que o servidor termine, de
   modo que o `-main` não retorna logo após iniciar o Jetty. O adaptador do
   Jetty documenta `:host` como "the hostname to listen on", `:port` como "the
   port to listen on (defaults to 80)" e `:join?` como "blocks the thread
   until server ends" [5] (tradução livre: "o nome do host em que escutar", "a
   porta em que escutar (padrão 80)" e "bloqueia a thread até o servidor
   terminar").
7. **O cabeçalho da resposta.** O tratador define `text/html; charset=UTF-8`.
   O Jetty o envia como `text/html;charset=utf-8`, o que significa o mesmo
   (veja "Saída esperada").
8. **`./run.sh --verify`** inicia o servidor em segundo plano, consulta a URL
   com o `curl`, imprime o corpo e encerra o servidor.

## Por que esta toolchain
- **O Ring é a interface de aplicações web do Clojure.** Seu README o chama de
  "a Clojure web applications library inspired by Python's WSGI and Ruby's
  Rack" que permite que as aplicações web "be constructed of modular
  components that can be shared among a variety of applications, web servers,
  and web frameworks" [1] (tradução livre: "uma biblioteca de aplicações web
  em Clojure inspirada no WSGI do Python e no Rack do Ruby" e "sejam
  construídas com componentes modulares que podem ser compartilhados entre
  diversas aplicações, servidores web e frameworks web"). Ele faz o papel do
  Express no [Node.js](../../node/web/README.md) e do Flask no
  [Python](../../python/web/README.md): uma biblioteca pequena, e a página tem
  poucas linhas.
- **O Jetty por meio do adaptador do Ring.** O adaptador embute o Jetty no
  programa, de modo que não há servidor web separado para instalar, como no
  Tomcat embutido do Spring Boot em [java/web](../../java/web/).
- **Versões.** O Clojars lista a 1.15.6 como a versão mais recente tanto do
  `ring-core` quanto do `ring-jetty-adapter` [2][6], e o README do Ring indica
  `ring/ring-core {:mvn/version "1.15.6"}` em sua seção de instalação [1]. As
  duas bibliotecas são usadas na mesma versão porque são lançadas juntas.
- **O `ring/ring-core` está listado embora o código não o chame.** O README do
  Ring o descreve como o que contém "core functions and middleware for Ring
  handlers, requests and responses" [1] (tradução livre: "funções centrais e
  middleware para tratadores, requisições e respostas do Ring"). O adaptador do
  Jetty já depende dele, de modo que a linha apenas torna a dependência
  visível.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Temurin 21.0.8, Clojure CLI 1.12.6.1673 (Clojure 1.12.6), Ring 1.15.6, Jetty 12.1.14. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` faz o mesmo que em [../cli](../cli/README.md#platform-notes). O `clojure -P` baixa o Ring e o Jetty. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` faz o mesmo que em [../cli](../cli/README.md#platform-notes). O `clojure -P` baixa o Ring e o Jetty. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
O `./run.sh --verify` imprimiu, em 2026-11-04 (as três linhas `SLF4J` vêm da
biblioteca de log do Jetty, que não encontra um back-end de log e permanece
silenciosa):
```text
==> Start the web server on http://localhost:8080
    WHY: Ring starts the embedded Jetty server on 127.0.0.1 (this computer only).
SLF4J(W): No SLF4J providers were found.
SLF4J(W): Defaulting to no-operation (NOP) logger implementation
SLF4J(W): See https://www.slf4j.org/codes.html#noProviders for further details.
<p>Hello, World!</p>
```
Enquanto o `./run.sh` executa, o `curl -i http://localhost:8080/` imprimiu:
```text
HTTP/1.1 200 OK
Server: Jetty(12.1.14)
Date: Wed, 04 Nov 2026 16:13:22 GMT
Content-Type: text/html;charset=utf-8
Content-Length: 20

<p>Hello, World!</p>
```
O navegador exibe: **Hello, World!**

![A página em http://localhost:8080/ exibindo "Hello, World!"](screenshot.png)

(Captura feita em 2026-11-04 com o Chrome headless:
`Google Chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`
enquanto o servidor executava.)

## Fontes
1. Ring README (libraries, installation, "inspired by Python's WSGI and Ruby's Rack"). ring-clojure, GitHub. <https://github.com/ring-clojure/ring> (acessado em 2026-11-04)
2. ring/ring-jetty-adapter (latest version 1.15.6). Clojars. <https://clojars.org/ring/ring-jetty-adapter> (acessado em 2026-11-04)
3. Deps and CLI Reference. clojure.org. <https://clojure.org/reference/deps_and_cli> (acessado em 2026-11-04)
4. The Ring Specification (SPEC.md). ring-clojure, GitHub. <https://github.com/ring-clojure/ring/blob/master/SPEC.md> (acessado em 2026-11-04)
5. `ring.adapter.jetty/run-jetty` source and docstring (options `:host`, `:port`, `:join?`). ring-clojure, GitHub. <https://github.com/ring-clojure/ring/blob/master/ring-jetty-adapter/src/ring/adapter/jetty.clj> (acessado em 2026-11-04)
6. ring/ring-core (latest version 1.15.6). Clojars. <https://clojars.org/ring/ring-core> (acessado em 2026-11-04)
