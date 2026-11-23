---
source: languages/prolog/web/README.md
source_sha: 1e6b6b1dc9ed9a66d24cfd6ff3dbaf6eb0649d88
---
# Prolog · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Prolog](../README.md)

## O que é
Um pequeno servidor web escrito em Prolog. Quando um navegador solicita
`http://localhost:8080/`, o servidor responde com o HTML
`<p>Hello, World!</p>`, que o navegador exibe como o texto **Hello, World!**.
É um único arquivo, [`server.pl`](server.pl), executado pelo SWI-Prolog. O
servidor HTTP vem das próprias bibliotecas do SWI-Prolog, portanto nada é
baixado além do próprio SWI-Prolog.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| SWI-Prolog (`swipl`) | 10.0.2 (`swi-prolog` 10.0.2 do Homebrew) | executa `server.pl`; inclui as bibliotecas do servidor HTTP |
| `curl` | o `curl` do sistema | apenas para `./run.sh --verify` e para testes manuais |

As bibliotecas `library(http/thread_httpd)` e `library(http/http_dispatch)`
fazem parte do pacote HTTP do SWI-Prolog [1]; estavam presentes na instalação
do Homebrew sem nenhuma etapa adicional. As notas de instalação do próprio
SWI-Prolog (sem bottle do Homebrew para Macs Intel [2]) estão no
[README da versão cli](../cli/README.md#prerequisites).

## Início rápido
```sh
./install.sh   # check / install SWI-Prolog (asks before installing)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Abra <http://localhost:8080/> em um navegador ou, em um segundo terminal,
execute `curl http://localhost:8080/`. Para usar outra porta, execute
`PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Mesma verificação da [versão `cli`](../cli/README.md#scripts-explained): executa `swipl --version` e, se estiver ausente, oferece o comando de instalação para o sistema operacional do leitor e só o executa se a resposta for `y`. | O SWI-Prolog é a única coisa a instalar; as bibliotecas HTTP vêm com ele. |
| `run.sh` | Exporta `PORT` (padrão 8080) e executa `swipl server.pl`. `--verify` o inicia em segundo plano, obtém a página uma vez com `curl` e depois o encerra. | `server.pl` lê a mesma variável `PORT`, de modo que script e servidor concordam. A autoverificação permite que `scripts/verify-all.sh` teste o servidor sem esperar por Ctrl+C. |

Não há `build.sh`: o SWI-Prolog compila o arquivo em memória ao carregá-lo,
como explicado em [../cli](../cli/README.md#why-there-is-no-build-step).

## Estrutura de pastas
```text
web/
├── README.md       this file
├── install.sh      checks / installs SWI-Prolog
├── run.sh          starts the server (or --verify)
├── screenshot.png  the page in a browser (see Expected output)
└── server.pl       the web server: one handler, one main/0
```
- Um arquivo basta. O esqueleto de servidor do próprio manual do SWI-Prolog
  é um único arquivo: "If this file is loaded as main file (using e.g.,
  `swipl server.pl`) it creates a simple server that listens on port 8080"
  [1] (tradução livre: "Se este arquivo for carregado como arquivo principal
  (usando, por exemplo, `swipl server.pl`), ele cria um servidor simples que
  escuta na porta 8080"). Este repositório usa o mesmo nome de arquivo.
- Nada é gerado, portanto nada precisa ser ignorado pelo Git.
  `screenshot.png` serve apenas a este README.

## Passo a passo
Abra [`server.pl`](server.pl) ao lado desta lista. Leia primeiro o
[passo a passo da versão `cli`](../cli/README.md#step-by-step-walkthrough):
ele explica cláusulas, regras, objetivos e `initialization(main, main)`.

1. **Carregar as bibliotecas.** `:- use_module(library(http/thread_httpd)).`
   é uma diretiva que carrega uma biblioteca. Todos os predicados que ela
   exporta "are imported into the module from which this predicate is called"
   [3] (tradução livre: "são importados para o módulo a partir do qual este
   predicado é chamado"), como `import` em Java ou Python. `thread_httpd`
   "is responsible for accepting and managing connections" (tradução livre:
   "é responsável por aceitar e gerenciar conexões"); `http_dispatch`
   "associates the path of the HTTP request with a handler that services this
   particular path" [1] (tradução livre: "associa o caminho da requisição HTTP
   a um tratador que atende esse caminho específico").
2. **`:- initialization(main, main).`** funciona como na versão `cli`: após o
   carregamento, o Prolog prova `main` [4]. A diferença está no passo 5: este
   `main` nunca termina.
3. **Registrar o tratador: `:- http_handler(root(.), say_hello, []).`**
   Esta diretiva é executada enquanto o arquivo é carregado e adiciona uma
   rota. `http_handler/3` vai "Register Closure as a handler for HTTP
   requests" [5] (tradução livre: "Registrar Closure como tratador de
   requisições HTTP"). `root(.)` é o caminho `/` (a raiz do servidor); o
   caminho pode ser "an absolute path such as `'/home.html'` or a term
   Alias(Relative)" [5] (tradução livre: "um caminho absoluto como
   `'/home.html'` ou um termo Alias(Relative)"). O segundo argumento é apenas
   o nome do predicado `say_hello`, sem argumentos. Para cada requisição
   correspondente, "Closure is called as below, where Request is the parsed
   HTTP request: `call(Closure, Request)`" [5] (tradução livre: "Closure é
   chamado como abaixo, em que Request é a requisição HTTP analisada:
   `call(Closure, Request)`"). Assim, o servidor constrói o objetivo
   `say_hello(Request)` e o prova. O último argumento, `[]`, é a lista
   (vazia) de opções. O Express (`app.get("/", ...)`) e o Flask
   (`@app.route("/")`) fazem o mesmo trabalho com uma função; no Prolog, o
   tratador é um predicado.
4. **O tratador é uma regra:**
   ```prolog
   say_hello(_Request) :-
       format("Content-type: text/html; charset=UTF-8~n~n"),
       format("<p>Hello, World!</p>").
   ```
   Lê-se "`say_hello(Request)` é verdadeiro se estes dois objetivos `format`
   forem verdadeiros". Quando o servidor o chama, a cabeça
   `say_hello(_Request)` é *unificada* com o objetivo `say_hello(Request)`, de
   modo que a variável `_Request` fica ligada à requisição. Nomes que começam
   com letra maiúscula ou `_` são variáveis [6]; o `_` também indica ao leitor
   que esta não é usada. O tratador é chamado "with the parsed request ... as
   argument and `current_output` set to a temporary buffer" (tradução livre:
   "com a requisição analisada ... como argumento e `current_output`
   direcionado a um buffer temporário"). Como um script CGI, "it must write a
   header declaring at least the Content-type field and a body" [1] (tradução
   livre: "deve escrever um cabeçalho que declare ao menos o campo
   Content-type e um corpo"). O primeiro `format` escreve esse cabeçalho e uma
   linha vazia (`~n~n`), e o segundo escreve o corpo. A resposta é um *efeito
   colateral* da prova do objetivo, não um valor de retorno.
5. **`main/0`** tem três partes:
   - **Ler a porta.** `( getenv('PORT', Value) -> atom_number(Value,
     Port) ; Port = 8080 )` é o if-then-else do Prolog. `getenv/2` vai "Get
     environment variable" e "Fails silently if the variable does not exist"
     [7] (tradução livre: "Obter variável de ambiente" e "Falha
     silenciosamente se a variável não existir"). Se for bem-sucedido,
     `atom_number/2` converte o texto em número [8]. Se falhar, o Prolog segue
     o ramo else, e `Port = 8080` *unifica* `Port` com 8080. Uma variável
     Prolog não pode ser alterada depois: "After binding a variable, it cannot
     be modified" [9] (tradução livre: "Depois que uma variável é ligada, ela
     não pode ser modificada"). Falhar não é um erro aqui; é a forma de um
     teste dizer "não".
   - **Iniciar o servidor.** `http_server(http_dispatch,
     [port(localhost:Port)])`. `http_server/2` vai "Create the server"
     (tradução livre: "Criar o servidor"), formado por "a small Prolog thread
     accepting new connection on Port and dispatching these to a pool of
     workers" (tradução livre: "uma pequena thread Prolog que aceita novas
     conexões na porta Port e as despacha para um pool de workers"); a opção de
     porta pode ser "a port (integer) or a term Host : Port" [10] (tradução
     livre: "uma porta (inteiro) ou um termo Host : Port"). Com
     `localhost:Port`, o servidor escuta apenas neste computador: o `lsof`
     mostrou `TCP 127.0.0.1:<port> (LISTEN)` na máquina de teste. O pool padrão
     tem "five workers" [10] (tradução livre: "cinco workers").
     `http_dispatch` é o objetivo ao qual cada requisição é passada; ele
     procura o tratador registrado no passo 3.
   - **Esperar.** `http_server/2` retorna imediatamente e, quando `main` é
     bem-sucedido, o programa terminaria "with status 0" [4] (tradução livre:
     "com status 0"), interrompendo o servidor. Por isso `main` termina com
     `thread_get_message(_)`, que "blocks execution until a term that unifies
     to Term arrives in the queue" [11] (tradução livre: "bloqueia a execução
     até que um termo que unifica com Term chegue à fila"). Nenhuma mensagem é
     enviada, portanto ele espera até que o leitor pressione Ctrl+C.

Compare com a [versão `cli`](../cli/hello.pl): lá, `main` é bem-sucedido
imediatamente e o Prolog termina; aqui, as threads do servidor assumem o
trabalho e `main` precisa bloquear.

## Por que esta toolchain
- **As bibliotecas HTTP do SWI-Prolog** são o servidor que o manual do
  SWI-Prolog documenta e usa em seus próprios exemplos [1]. Elas acompanham o
  SWI-Prolog; assim, a versão web não precisa de gerenciador de pacotes, de
  download nem de etapa de instalação adicional.
- **`format/1` em vez de `library(http/html_write)`**: `html_write`
  "translates a Prolog term into an HTML document" (tradução livre: "traduz
  um termo Prolog em um documento HTML"), e os exemplos do manual constroem
  páginas com seu `reply_html_page/2` [1]. Este servidor escreve o cabeçalho
  e o HTML com `format/1`, porque isso mostra de que é feita uma resposta
  HTTP, sem nenhuma biblioteca HTML no meio. O manual diz que "writing an HTML
  reply this way is deprecated" (tradução livre: "escrever uma resposta HTML
  dessa forma está obsoleto"), porque o código que copia dados da requisição
  para a página "is subject to injection attacks" [1] (tradução livre: "está
  sujeito a ataques de injeção"). Este tratador escreve apenas uma string
  fixa, portanto esse risco não se aplica; uma aplicação maior deve usar
  `html_write`.
- **A porta 8080** é a convenção do repositório para toda implementação web e
  também a porta do servidor de exemplo do próprio manual [1].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | SWI-Prolog 10.0.2 do Homebrew, compilado a partir do código-fonte (sem bottle para Intel) [2]. |
| macOS Apple Silicon | ⚠️ não verificado | `brew install swi-prolog` instala um bottle pré-compilado [2]. Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `swi-prolog-nox` com o apt quando o `swipl` não existe. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o MSYS2 em `C:\msys64` e instala os pacotes UCRT64 `swi-prolog-core` e `swi-prolog-packages` com o `pacman` quando o `swipl` não existe. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
`./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: swipl loads server.pl and proves 'main', which starts SWI-Prolog's
         HTTP server on 127.0.0.1 (this computer only) and waits.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
% Started server at http://localhost:8080/
Listening on http://localhost:8080/
```
A linha que começa com `%` é impressa pela biblioteca de servidor do
SWI-Prolog; a linha `Listening on ...` vem de `main` em `server.pl`.

Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Date: Sun, 01 Nov 2026 22:49:45 GMT
Content-Type: text/html; charset=UTF-8
Connection: Keep-Alive
Content-Length: 20

<p>Hello, World!</p>
```
O navegador exibe: **Hello, World!**

A autoverificação:
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: swipl loads server.pl and proves 'main', which starts SWI-Prolog's
         HTTP server on 127.0.0.1 (this computer only) and waits.
% Started server at http://localhost:8080/
Listening on http://localhost:8080/
<p>Hello, World!</p>
```

![Uma página de navegador exibindo "Hello, World!"](screenshot.png)

(Captura feita em 2026-11-02 no macOS Intel com o Chrome sem interface gráfica:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. SWI-Prolog HTTP support: 3 The HTTP server libraries. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=httpserver> (acessado em 2026-11-01)
2. `swi-prolog` formula. Homebrew. <https://formulae.brew.sh/formula/swi-prolog> (acessado em 2026-11-01)
3. SWI-Prolog Reference Manual: use_module/1. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=use_module/1> (acessado em 2026-11-01)
4. SWI-Prolog Reference Manual: initialization/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/doc_for?object=initialization/2> (acessado em 2026-11-01)
5. http_handler/3. SWI-Prolog (`library(http/http_dispatch)`). <https://www.swi-prolog.org/pldoc/doc_for?object=http_handler/3> (acessado em 2026-11-01)
6. SWI-Prolog Reference Manual: 2.15 The SWI-Prolog syntax (variables). SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=syntax> (acessado em 2026-11-01)
7. SWI-Prolog Reference Manual: getenv/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=getenv/2> (acessado em 2026-11-01)
8. SWI-Prolog Reference Manual: atom_number/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=atom_number/2> (acessado em 2026-11-01)
9. SWI-Prolog Reference Manual: Glossary of Terms. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=glossary> (acessado em 2026-11-01)
10. http_server/2. SWI-Prolog (`library(http/thread_httpd)`). <https://www.swi-prolog.org/pldoc/doc_for?object=http_server/2> (acessado em 2026-11-01)
11. SWI-Prolog Reference Manual: thread_get_message/1. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=thread_get_message/1> (acessado em 2026-11-01)
