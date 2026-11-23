---
source: languages/erlang/web/README.md
source_sha: 54cacb6968e914976d7e202782bc461c27c8416d
---
# Erlang · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Erlang](../README.md)

## O que é
Um servidor web em <http://localhost:8080/> que responde a `GET /` com o
HTML `<p>Hello, World!</p>`, como as outras versões web (por exemplo, a
[Elixir](../../elixir/web/)). Qualquer outro caminho recebe uma resposta
`404`.

O servidor é o **httpd**, da aplicação `inets` do Erlang/OTP. A documentação
o descreve como "An implementation of an HTTP 1.1 compliant web server, as
defined in RFC 2616" [1] (tradução livre: "Uma implementação de um servidor
web compatível com o HTTP 1.1, conforme definido na RFC 2616"). Ele
acompanha o Erlang/OTP, de modo que nada é baixado: não há etapa de
gerenciador de pacotes, ao contrário da versão [Elixir web](../../elixir/web/),
que precisa do Plug e do Bandit do Hex.

O programa é um módulo compilado, o `hello_httpd`. Ele faz duas tarefas: o
`main/0` inicia o servidor, e o `do/1` é a função que o `httpd` chama a cada
requisição. Compare primeiro com a versão [cli](../cli/): nela, um script
imprime uma linha.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Erlang/OTP (`erl`, `erlc`) | 29.1.2 (`erlang` 29.1.2 do Homebrew), como em [../cli](../cli/README.md#prerequisites) | compila o módulo e o executa na BEAM |
| Aplicação `inets` | 9.8.1, parte do Erlang/OTP 29.1.2 | contém o `httpd` |
| curl | curl do sistema | apenas para o `./run.sh --verify` e para testes manuais |

Em Macs Intel, o Homebrew compila o Erlang a partir do código-fonte, o que
levou cerca de 15 minutos, mais cerca de 7 minutos para o `wxWidgets`, uma
dependência, na máquina de teste (2026-11-01) [2]. Veja
[../cli](../cli/README.md#prerequisites).

## Início rápido
```sh
./install.sh   # check / install Erlang/OTP and inets (asks before installing)
./build.sh     # erlc: hello_httpd.erl -> ebin/hello_httpd.beam
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Em seguida, abra <http://localhost:8080/> ou execute `curl http://localhost:8080/`.
Use outra porta com `PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica `erl`, `erlc` e a aplicação `inets` (o `code:lib_dir(inets)` falha quando ela não existe). Se algo estiver faltando, oferece o comando de instalação (veja [../cli](../cli/README.md#scripts-explained)). | O programa precisa do compilador e do `inets`. |
| `build.sh` | Executa `erlc -Wall -o ebin hello_httpd.erl`. | A BEAM executa bytecode. Para um arquivo `.erl`, o `erlc` "generates a `.beam` file" [3] (tradução livre: "gera um arquivo `.beam`"), e o `-o` é "The directory where the compiler is to place the output files" [3] (tradução livre: "O diretório em que o compilador deve colocar os arquivos de saída"). O `-Wall` ativa todos os avisos (veja `erlc -h`). |
| `run.sh` | Executa `erl +Bd -noshell -pa ebin -s hello_httpd main` com `PORT` (padrão 8080). O `--verify` o inicia em segundo plano, obtém a página uma vez com o `curl` e depois o encerra. | O `-pa ebin` "Adds the specified directories to the beginning of the code path", e o `-s` "Makes `init` call the specified function" [4] (tradução livre: "Adiciona os diretórios especificados ao início do caminho de código" e "Faz o `init` chamar a função especificada"). O `main/0` nunca retorna, de modo que o servidor continua em execução. |

## Estrutura de pastas
```text
web/
├── README.md          this file
├── install.sh         checks / installs Erlang/OTP and inets
├── build.sh           erlc -> ebin/hello_httpd.beam
├── run.sh             starts the server (or checks it with --verify)
├── hello_httpd.erl    the program (teaching comments)
├── screenshot.png     the page in a browser (see Expected output)
├── .gitignore         keeps ebin/ and *.beam out of Git
└── ebin/              created by build.sh; not committed
    └── hello_httpd.beam
```
- `ebin/` é a pasta do código compilado no layout que o Erlang/OTP
  documenta: "`ebin` - Required. Contains the Erlang object code, the
  `.beam` files" [5] (tradução livre: "`ebin` - Obrigatória. Contém o código
  objeto do Erlang, os arquivos `.beam`").
- Não há arquivo de projeto nem arquivo de lock: a única dependência é o
  próprio Erlang/OTP.

## Passo a passo
Abra o [`hello_httpd.erl`](hello_httpd.erl) ao lado desta lista.

1. **`-module(hello_httpd).`** dá nome ao módulo, e
   `-export([main/0, do/1]).` torna duas funções chamáveis de fora. O `do/1`
   precisa ser exportado, ou o `httpd` não conseguiria alcançá-lo.
2. **`-include_lib("inets/include/httpd.hrl").`** lê o cabeçalho que define o
   registro `#mod{}`, os dados de uma requisição. Um registro é uma tupla com
   campos nomeados: "a record is not a true data type", porque "record
   expressions are translated to tuple expressions during compilation" [6]
   (tradução livre: "um registro não é um tipo de dado verdadeiro", porque
   "expressões de registro são traduzidas para expressões de tupla durante a
   compilação").
3. **Lendo `PORT` com `case`.** `os:getenv("PORT")` devolve o texto, ou
   `false` quando a variável não está definida. A expressão `case` compara
   esse valor com padrões, de cima para baixo: `false -> 8080` ou
   `Text -> list_to_integer(Text)`. "The expression `Expr` is evaluated and
   the patterns `Pattern` are sequentially matched against the result" [7]
   (tradução livre: "A expressão `Expr` é avaliada e os padrões `Pattern` são
   comparados sequencialmente com o resultado"). O nome `Text` começa com
   letra maiúscula, de modo que é uma variável que recebe qualquer outro
   valor. Com `PORT=abc`, o `list_to_integer/1` falha e o servidor não
   inicia.
4. **`ok = inets:start(),`** inicia a aplicação `inets`. Uma aplicação é um
   componente do Erlang/OTP [8]. O `ok =` à esquerda é uma asserção por
   correspondência de padrões: "If the matching fails, a `badmatch` run-time
   error occurs" [7] (tradução livre: "Se a correspondência falha, ocorre um
   erro de execução `badmatch`"). Se `start/0` devolvesse qualquer coisa
   diferente de `ok`, o programa pararia com um erro claro. O código Erlang
   normalmente não verifica erros manualmente.
5. **`inets:start(httpd, Properties)`** inicia um servidor HTTP. As
   propriedades são uma lista de tuplas `{Key, Value}`:
   - `port` é onde ele escuta. `server_root` e `document_root` são
     obrigatórias: a documentação lista `port`, `server_root` e
     `document_root` como as propriedades exigidas [1]. Este servidor não
     envia nenhum arquivo, de modo que a pasta atual, `"."`, é suficiente.
   - `server_name` é o nome que o servidor informa. Se não for fornecido,
     "defaults to `net_adm:localhost()`" [1] (tradução livre: "assume por
     padrão `net_adm:localhost()`").
   - `bind_address` é `{127, 0, 0, 1}`, um endereço IP como uma tupla de seus
     quatro números. O padrão é `any` [1]. Com `{127, 0, 0, 1}`, outros
     computadores não conseguem se conectar.
   - `modules` "Defines which modules the HTTP server uses when handling
     requests" [1] (tradução livre: "Define quais módulos o servidor HTTP usa
     ao tratar requisições"). Sua lista padrão tem `mod_get`, `mod_dir` e
     outros. Aqui a lista tem uma entrada, `?MODULE`, uma macro que o
     compilador substitui por `hello_httpd`.
6. **Esperando.** `io:format("Listening on http://localhost:~w/~n", [Port])`
   imprime a porta: o `~w` "Writes data with the standard syntax" [9]
   (tradução livre: "Escreve dados com a sintaxe padrão"). Em seguida,
   `receive never -> ok end` bloqueia para sempre, porque nenhuma mensagem
   corresponde ao padrão `never`. O `httpd` roda em outros processos, de modo
   que este processo só precisa permanecer vivo. O Ctrl+C encerra o
   programa.
7. **`do/1`, o callback.** "When a valid request reaches `httpd`, it calls
   `do/1` in each module, defined by the configuration option of `Module`"
   [1] (tradução livre: "Quando uma requisição válida chega ao `httpd`, ele
   chama `do/1` em cada módulo, definido pela opção de configuração de
   `Module`"). A primeira cláusula,
   `do(#mod{method = "GET", request_uri = "/"})`, extrai dois campos do
   registro no cabeçalho da função, e corresponde apenas a um `GET` de `/`.
   A segunda cláusula, `do(_ModData)`, corresponde a todo o resto: o Erlang
   tenta as cláusulas de cima para baixo.
8. **A resposta.** O valor de retorno é `{proceed, [{response, {response,
   Head, Body}}]}`. A documentação lista os valores de retorno e os dados
   `{response, Head, Body}`, e diz: "It is strongly advised to use
   NewDataFormat in the return value of `do/1`" [1] (tradução livre: "É
   fortemente recomendado usar NewDataFormat no valor de retorno de
   `do/1`"). `Head` é uma lista de tuplas `{Key, Value}`: o status `code`, o
   `content_type` e o `content_length`. O corpo é uma string, que é uma lista
   de caracteres [6].
9. **Processos.** No Erlang, "each thread of execution is called a process",
   e os processos "share no data" [10] (tradução livre: "cada linha de
   execução é chamada de processo", e os processos "não compartilham
   dados"). O programa não inicia nenhum processo próprio para as
   requisições: o `httpd` roda em outros processos, de modo que o processo de
   `main/0` só precisa permanecer vivo.

**Experimente:** altere o corpo para `<h1>Hello, World!</h1>`, ou acrescente uma cláusula para `"/hello"` antes da última, e execute
`./build.sh && ./run.sh`.

## Por que esta toolchain
- **O `httpd` acompanha o Erlang/OTP** [1], de modo que esta versão é o
  menor programa web do repositório em dependências: nenhum download, nenhum
  arquivo de lock.
- **Um módulo e o `erlc`** são a forma normal de compilar código Erlang, o
  que o escript da versão [cli](../cli/) esconde.
- **O custo: a API é de baixo nível.** O programa monta os cabeçalhos
  manualmente, o que um framework faria por ele. O Erlang tem frameworks,
  mas este repositório se limita à distribuição padrão.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Erlang/OTP 29.1.2, `inets` 9.8.1 do Homebrew. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. O Homebrew instala um bottle [2]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `erlang` com o apt quando `erl`, `erlc` ou a aplicação `inets` não existe, como em [../cli](../cli/README.md#platform-notes). |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` extrai o zip oficial de 64 bits do Erlang/OTP em `~/.local/otp-29.1.2` quando ele não existe, como em [../cli](../cli/README.md#platform-notes). O zip inclui o `inets`. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
O `./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: erl runs hello_httpd:main(), which starts inets and its httpd server on
         127.0.0.1 (this computer only) and waits.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Listening on http://localhost:8080/
```

Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Date: Wed, 04 Nov 2026 23:55:29 GMT
Server: inets/9.8.1
Content-Type: text/html; charset=UTF-8
Content-Length: 20

<p>Hello, World!</p>
```
O navegador mostra: **Hello, World!**

A autoverificação:
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: erl runs hello_httpd:main(), which starts inets and its httpd server on
         127.0.0.1 (this computer only) and waits.
Listening on http://localhost:8080/
<p>Hello, World!</p>
```
A última linha é a página, obtida pelo `curl` no `run.sh`. Quando o
`run.sh` encerra o servidor, o Erlang registra `SIGTERM received - shutting
down`.

![Uma página de navegador exibindo "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 em macOS Intel com o Chrome headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. httpd. Erlang/OTP documentation, inets. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/inets/httpd.html> (acessado em 2026-11-04)
2. `erlang` formula. Homebrew. <https://formulae.brew.sh/formula/erlang> (acessado em 2026-11-04)
3. erlc. Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/erlc_cmd.html> (acessado em 2026-11-04)
4. `erl` (`-pa`, `-s`, `-noshell`). Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/erl_cmd.html> (acessado em 2026-11-04)
5. Applications (directory structure, `ebin`). Erlang/OTP documentation, Design Principles. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/applications.html> (acessado em 2026-11-04)
6. Data types (atom, record, string). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/data_types.html> (acessado em 2026-11-04)
7. Expressions (`case`, pattern matching). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/expressions.html> (acessado em 2026-11-04)
8. Design principles (applications, supervision trees). Erlang/OTP documentation. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/design_principles.html> (acessado em 2026-11-04)
9. `io` (control sequence `~w`). Erlang/OTP documentation, stdlib. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/stdlib/io.html> (acessado em 2026-11-04)
10. Conc prog (processes). Erlang/OTP documentation, Getting Started. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/conc_prog.html> (acessado em 2026-11-04)
