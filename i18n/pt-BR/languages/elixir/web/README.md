---
source: languages/elixir/web/README.md
source_sha: 2d6afaaa9bdee25cbba68cbec588d9f9b5e8eea6
---
# Elixir · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Elixir](../README.md)

## O que é
Um servidor web em <http://localhost:8080/> que responde a `GET /` com o HTML
`<p>Hello, World!</p>`, como as demais versões web (por exemplo, a em
[Haskell](../../haskell/web/)). Qualquer outro caminho recebe um simples `404
Not Found`.

É um projeto **Mix**: "Mix is a build tool that ships with Elixir" [1]
(tradução livre: "O Mix é uma ferramenta de build que acompanha o Elixir").
Ele usa duas bibliotecas do Hex, o repositório de pacotes da comunidade Erlang
e Elixir. O **Plug** é descrito no Hex como "Compose web applications with
functions" [2] (tradução livre: "Componha aplicações web com funções"), e sua
documentação define um plug como "any function that receives a connection and
a set of options and returns a connection" [3] (tradução livre: "qualquer
função que receba uma conexão e um conjunto de opções e devolva uma
conexão"). O **Bandit** é "A pure-Elixir HTTP server built for Plug & WebSock
apps" [4] (tradução livre: "Um servidor HTTP em Elixir puro, feito para
aplicações Plug e WebSock"). Não há um framework web como o Phoenix: o Plug
basta para uma rota.

Compare primeiro com o [cli](../cli/): lá, um script imprime uma linha. Aqui,
um supervisor inicia o servidor web, e o servidor chama um plug a cada
requisição.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Elixir e Mix | 1.20.5 (Homebrew), sobre Erlang/OTP 29.1.2 | compilam e executam o projeto; veja [../cli](../cli/README.md#prerequisites) |
| Hex | 2.6.0 (instalado por `mix local.hex --force`) | o gerenciador de pacotes que baixa as bibliotecas |
| Plug | 1.20.4 (fixada em `mix.lock`) | a especificação de plug e o `Plug.Router` |
| Bandit | 1.14.1 (fixada em `mix.lock`) | o servidor HTTP |
| curl | curl do sistema | apenas para `./run.sh --verify` e para testes manuais |

O Plug 1.20.4 foi publicado no Hex em 2026-11-17 [2], e o Bandit 1.14.1 em
2026-10-28 [4]. O Plug é licenciado sob Apache-2.0 [2] e o Bandit sob MIT [4].
O Plug e o Bandit precisam de mais seis pacotes, que o `mix.lock` também fixa:
`hpax`, `mime`, `plug_crypto`, `telemetry`, `thousand_island` e `websock`.

## Início rápido
```sh
./install.sh   # check Elixir, install Hex, download the libraries (asks before installing)
./build.sh     # compile (about 11 s on the test machine)
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Em seguida, abra <http://localhost:8080/> ou execute `curl
http://localhost:8080/`. Para usar outra porta, execute `PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica `elixir` e `mix`; se estiverem faltando, oferece o comando de instalação (veja [../cli](../cli/README.md#scripts-explained)). 2. `mix local.hex --force`: "Installs Hex locally" [5] (tradução livre: "Instala o Hex localmente"); `--force` "forces installation without a shell prompt" [5] (tradução livre: "força a instalação sem pedir confirmação no shell"). 3. `mix deps.get`, após perguntar, quando o `mix deps` informa uma dependência ausente ou desatualizada: baixa para `deps/` as versões fixadas em `mix.lock`. | Esta versão usa bibliotecas, de modo que precisa do Hex para obtê-las. |
| `build.sh` | `mix compile`: compila as dependências (apenas no primeiro build) e `lib/*.ex` em arquivos `.beam` em `_build/`. | Diferentemente do [../cli](../cli/), um projeto Mix é compilado uma vez e o resultado é mantido; os builds seguintes recompilam apenas o que mudou. |
| `run.sh` | `mix run --no-halt` com `PORT` (padrão 8080). `--verify` o inicia em segundo plano, busca a página uma vez com `curl` e depois o encerra. | O `mix run` "will be compiled if it has not been compiled yet or it is outdated" [6] (tradução livre: "será compilado se ainda não tiver sido compilado ou se estiver desatualizado"), inicia a aplicação, e `--no-halt` "does not halt the system after running the command" [6] (tradução livre: "não encerra o sistema após executar o comando"). |

**O que o `install.sh` grava fora desta pasta.** O `mix local.hex --force`
coloca o arquivo do Hex na pasta pessoal do Mix, `~/.mix` por padrão: a
documentação do Mix diz que `MIX_HOME` "stores configuration files and scripts
used by Mix (default: `~/.mix`)" (tradução livre: "guarda arquivos de
configuração e scripts usados pelo Mix (padrão: `~/.mix`)") e que
`MIX_ARCHIVES` é o diretório dos arquivos (padrão: `~/.mix/archives`) [7]. Na
máquina de teste, `mix local.hex --force` imprimiu `creating
/Users/<user>/.mix/archives/hex-2.6.0`. O primeiro `mix deps.get` também
imprimiu `creating /Users/<user>/.mix/elixir/1-20-otp-29/rebar3`: uma cópia do
rebar3, uma ferramenta de build do Erlang que o Mix mantém na mesma pasta e de
que algumas dependências do Erlang precisam (aqui, a `telemetry`). O script
explica isso antes de executar o comando e pergunta antes, a menos que
`TF_ASSUME_YES=1` esteja definido. Não se usa `sudo`.

**Telemetria.** A documentação do `mix hex.config` do Hex lista 22 chaves de
configuração e 19 variáveis de ambiente `HEX_*` [8]. Nenhuma delas trata de
telemetria, de análise de uso ou de relatório de uso, e a página de variáveis
de ambiente do Mix [7] também não tem nenhuma. Por isso, esta implementação
não define nenhuma opção de desativação. (O Bandit, uma biblioteca, emite
eventos de `telemetry` dentro do programa, mas eles ficam no programa, a menos
que algum código se inscreva neles.)

**Versões fixadas.** O `mix.lock` registra a versão exata e o checksum de
cada pacote. O `mix deps.get` o lê, de modo que todo estudante compila o mesmo
código.

## Estrutura de pastas
```text
web/
├── README.md              this file
├── install.sh             checks Elixir, installs Hex, mix deps.get
├── build.sh               mix compile
├── run.sh                 starts the server (or checks it with --verify)
├── screenshot.png         the page in a browser (see Expected output)
├── mix.exs                the project file: name, version, dependencies
├── mix.lock               the exact version and checksum of every package
├── .gitignore             keeps _build/ and deps/ out of Git
├── lib/
│   └── hello_web/
│       ├── application.ex starts Bandit under a supervisor
│       └── router.ex      the plug that answers GET /
├── deps/                  created by mix deps.get; not committed
└── _build/                created by mix compile; not committed
```
- Este é o layout que o `mix new` gera: `mix.exs` no topo e o código-fonte
  em `lib/`. O guia do Mix diz que "All compilation artifacts are placed
  inside the `_build` directory" (tradução livre: "Todos os artefatos de
  compilação são colocados dentro do diretório `_build`") e que o `mix.exs`
  tem "its main responsibility is to configure our project" [9] (tradução
  livre: "como principal responsabilidade configurar o nosso projeto"). O
  `.gitignore` da pasta lista `/_build/` e `/deps/`, as mesmas linhas que o
  `mix new` escreve em seu `.gitignore`. O `.gitignore` da raiz deste
  repositório não tem regra para eles.
- **`mix.exs`, bloco a bloco.** `project/0` devolve uma lista de palavras-chave
  (keyword list): `app: :hello_web` nomeia a aplicação, `elixir: "~> 1.20"`
  exige o Elixir 1.20 ou posterior na série 1.x, e `deps: deps()` lista as
  bibliotecas. `application/0` tem `mod: {HelloWeb.Application, []}`, que
  nomeia o módulo que é iniciado primeiro, e `extra_applications: [:logger]`.
  `deps/0` lista `{:plug, "~> 1.20"}` e `{:bandit, "~> 1.14"}`.

## Passo a passo
Abra o [`lib/hello_web/application.ex`](lib/hello_web/application.ex) e o
[`lib/hello_web/router.ex`](lib/hello_web/router.ex) ao lado desta lista.

1. **Módulos e `do ... end`.** `defmodule HelloWeb.Application do ... end`
   define um módulo, um grupo nomeado de funções. Um bloco abre com `do` e
   fecha com `end`; o Elixir não tem chaves para blocos.
2. **`use Application` e `@impl true`.** Uma *aplicação* OTP é um componente
   que o Mix inicia. `start/2` é o seu callback: o Mix o chama uma vez. OTP é
   o conjunto de bibliotecas e convenções que acompanha o Erlang, de modo que
   esta é a mesma estrutura de um programa [Erlang](../../erlang/web/). A
   documentação do Elixir diz que `start/2` "should start the top-level
   process of the application (which should be the top supervisor of the
   application's supervision tree ...)" [10] (tradução livre: "deve iniciar o
   processo de nível superior da aplicação (que deve ser o supervisor de topo
   da árvore de supervisão da aplicação ...)").
3. **Lendo `PORT` com `case`.** `System.get_env("PORT")` devolve o texto ou
   `nil`. A expressão `case` compara esse valor com padrões, de cima para
   baixo: `nil -> 8080` ou `text -> String.to_integer(text)`. A correspondência
   de padrões (pattern matching) é a ideia central do Elixir: um padrão testa
   a forma de um valor e, ao mesmo tempo, dá nome às suas partes. O
   [`Maybe`](../../haskell/web/README.md#step-by-step-walkthrough) do Haskell
   resolve o mesmo problema do "não definido" com um tipo, e o Elixir com um
   valor, `nil`. Com `PORT=abc`, `String.to_integer/1` levanta um erro e o
   servidor não inicia.
4. **A especificação de filho (child specification).** `{Bandit, plug:
   HelloWeb.Router, ip: :loopback, port: port}` diz qual processo iniciar e com
   quais opções. A documentação do Bandit as lista: `:plug` é "The Plug to use
   to handle connections" (tradução livre: "O Plug a usar para tratar as
   conexões"), `:port` é "The TCP port to listen on" (tradução livre: "A porta
   TCP em que escutar") e `:ip` é "The interface(s) to listen on" (tradução
   livre: "A(s) interface(s) em que escutar"), com `:loopback` para "local
   loopback (ie: `127.0.0.1`)" [11] (tradução livre: "loopback local (ou
   seja, `127.0.0.1`)"). Sem `:port`, o Bandit usa 4000 por padrão para HTTP
   [11]. Com `:loopback`, outros computadores não conseguem se conectar. O
   próprio exemplo da documentação coloca `{Bandit, plug: MyApp.MyPlug}` na
   lista de filhos de um supervisor [11].
5. **O supervisor.** `Supervisor.start_link(children, strategy: :one_for_one,
   name: HelloWeb.Supervisor)` inicia um *supervisor*, "a process which
   supervises other processes" (tradução livre: "um processo que supervisiona
   outros processos"). Com `:one_for_one`, "if a child process terminates,
   only that process is restarted" [12] (tradução livre: "se um processo
   filho termina, apenas esse processo é reiniciado"). Ele devolve `{:ok,
   pid}`, que é como o Mix fica sabendo que a inicialização deu certo.
6. **O operador pipe.** Em `router.ex`, `conn |> put_resp_content_type("text/html")
   |> send_resp(200, "...")` equivale a `send_resp(put_resp_content_type(conn,
   "text/html"), 200, "...")`. O operador "introduces the expression on the
   left-hand side as the first argument to the function call on the right-hand
   side" [13] (tradução livre: "introduz a expressão do lado esquerdo como o
   primeiro argumento da chamada de função do lado direito"). Os dados são
   imutáveis: cada função devolve uma nova conexão e a própria `conn` não
   muda.
7. **`Plug.Router`.** `use Plug.Router` acrescenta as macros de rota. `plug
   :match` encontra a rota e `plug :dispatch` a executa: a documentação do
   Plug diz que "`:match` is responsible for finding a matching route which is
   then forwarded to `:dispatch`" [14] (tradução livre: "`:match` é
   responsável por encontrar uma rota correspondente, que é então encaminhada
   a `:dispatch`"). `get "/" do ... end` é uma rota, e `match _ do ... end`
   captura todo o resto com um `404`.
8. **Um `|>` depois de um `defp`.** Nada em `lib/` é privado, mas o `mix.exs`
   mostra `defp`: "Defines a private function with the given name and body"
   (tradução livre: "Define uma função privada com o nome e o corpo dados"),
   visível apenas dentro do seu módulo [13]. `def` define uma pública.

## Por que esta toolchain
- **O Plug é a base dos programas web em Elixir.** Sua especificação é
  pequena: um plug recebe uma conexão e devolve uma conexão [3]. O
  `Plug.Router` dá uma rota em uma linha, e o roteador é um único arquivo.
- **O Bandit é um servidor Plug escrito em Elixir** [4]. O projeto Plug lista
  o Cowboy, um servidor em Erlang, como outra opção; este repositório usa o
  Bandit porque toda a pilha, exceto a máquina virtual, é código Elixir que o
  estudante pode ler.
- **Mix e Hex são as ferramentas padrão.** O Mix acompanha o Elixir [1]; o
  Hex é o gerenciador de pacotes que o Mix usa para baixar dependências [5].
- **O custo: o primeiro build.** Na máquina de teste (2026-11-04), o
  `install.sh` levou cerca de 9 s (incluindo a instalação do Hex) e o
  primeiro `build.sh`, que compila o Plug, o Bandit e suas dependências, cerca
  de 11 s. Os dois precisam de acesso à rede na primeira vez. O próprio Elixir
  leva muito mais tempo para ser instalado em um Mac Intel (veja
  [../cli](../cli/README.md#prerequisites)).

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Elixir 1.20.5, Erlang/OTP 29.1.2, Hex 2.6.0. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos; o Homebrew instala bottles para o Elixir e o Erlang [../cli](../cli/README.md#platform-notes). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o Elixir com o script de instalação oficial quando ele não existe, como em [../cli](../cli/README.md#platform-notes). Em seguida, executa `mix local.hex --force` e `mix deps.get`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` instala o Elixir com o script de instalação oficial quando ele não existe, como em [../cli](../cli/README.md#platform-notes). Em seguida, executa `mix local.hex --force` e `mix deps.get`. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
`./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: mix run starts HelloWeb.Application, which starts Bandit on 127.0.0.1
         (this computer only) and keeps the Erlang VM alive with --no-halt.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.

13:10:03.068 [info] Running HelloWeb.Router with Bandit 1.14.1 at 127.0.0.1:8080 (http)
```
A última linha é o log de inicialização do Bandit, escrito por meio do
`Logger` do Elixir; seu horário é o horário local da execução [11].

Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
date: Wed, 04 Nov 2026 16:10:07 GMT
content-length: 20
vary: accept-encoding
cache-control: max-age=0, private, must-revalidate
content-type: text/html; charset=utf-8

<p>Hello, World!</p>
```
O navegador exibe: **Hello, World!**

A autoverificação:
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: mix run starts HelloWeb.Application, which starts Bandit on 127.0.0.1
         (this computer only) and keeps the Erlang VM alive with --no-halt.

13:09:41.620 [info] Running HelloWeb.Router with Bandit 1.14.1 at 127.0.0.1:8080 (http)
<p>Hello, World!</p>
```
A última linha é a página, buscada pelo `curl` no `run.sh`. Quando o `run.sh`
encerra o servidor, o Elixir registra `[notice] SIGTERM received - shutting
down`.

![A browser page showing "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 no macOS Intel com o Chrome headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. Introduction to Mix (Mix and OTP). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/introduction-to-mix.html> (acessado em 2026-11-04)
2. `plug` package (version 1.20.4). Hex. <https://hex.pm/packages/plug> (acessado em 2026-11-19)
3. Plug: the plug specification (version 1.20.4). Plug team, hexdocs.pm. <https://plug.hexdocs.pm/Plug.html> (acessado em 2026-11-19)
4. `bandit` package (version 1.14.1). Hex. <https://hex.pm/packages/bandit> (acessado em 2026-11-04)
5. `mix local.hex`. Mix documentation, hexdocs.pm. <https://mix.hexdocs.pm/Mix.Tasks.Local.Hex.html> (acessado em 2026-11-04)
6. `mix run`. Mix documentation, hexdocs.pm. <https://mix.hexdocs.pm/Mix.Tasks.Run.html> (acessado em 2026-11-04)
7. Mix (module documentation, environment variables). Mix documentation, hexdocs.pm. <https://mix.hexdocs.pm/Mix.html> (acessado em 2026-11-04)
8. `mix hex.config`. Hex documentation, hexdocs.pm. <https://hex.hexdocs.pm/Mix.Tasks.Hex.Config.html> (acessado em 2026-11-04)
9. Introduction to Mix (project layout, `_build`, `mix.exs`). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/introduction-to-mix.html> (acessado em 2026-11-04)
10. `Application` callback `start/2`. Elixir v1.20.5 documentation, hexdocs.pm. <https://elixir.hexdocs.pm/Application.html#c:start/2> (acessado em 2026-11-04)
11. Bandit (module documentation: options, supervision tree). Bandit team, hexdocs.pm. <https://bandit.hexdocs.pm/Bandit.html> (acessado em 2026-11-04)
12. `Supervisor` (strategies). Elixir v1.20.5 documentation, hexdocs.pm. <https://elixir.hexdocs.pm/Supervisor.html> (acessado em 2026-11-04)
13. `Kernel` (`|>/2`, `def/2`, `defp/2`). Elixir v1.20.5 documentation, hexdocs.pm. <https://elixir.hexdocs.pm/Kernel.html> (acessado em 2026-11-04)
14. `Plug.Router`. Plug team, hexdocs.pm. <https://plug.hexdocs.pm/Plug.Router.html> (acessado em 2026-11-04)
