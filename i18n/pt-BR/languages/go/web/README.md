---
source: languages/go/web/README.md
source_sha: 2bd3d2d338150fcb7d36fc5ab3369a740de314da
---
# Go · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Go](../README.md)

## O que é
Um servidor web em <http://localhost:8080/> que responde a `GET /` com o
HTML `<p>Hello, World!</p>`. O navegador mostra **Hello, World!**

Tudo vem da **biblioteca padrão** do Go: o `net/http` é o servidor web e o
`html/template` preenche o HTML. Diferentemente das versões
[Python web](../../python/web/) (Flask) e [Java web](../../java/web/)
(Spring Boot), nenhum framework web é baixado. O próprio servidor envia o
HTML pronto; compare com [../web-vue](../web-vue/), em que o navegador
monta a página.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Go 1.22 ou superior | Go 1.27.3 (Homebrew) | compila o servidor; o `net/http` e o `html/template` já vêm com ele |
| `curl` | `curl` do sistema | apenas para o `./run.sh --verify` e para testes manuais |

O Go 1.22 é necessário porque o `main.go` usa um método no padrão de URL
(`"GET /{$}"`), recurso que o Go 1.22 acrescentou ao `net/http` [3].

## Início rápido
```sh
./install.sh   # check / install Go (asks before installing)
./build.sh     # compile into bin/hello-web
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Abra <http://localhost:8080/> em um navegador. Outra porta: `PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica o Go 1.22+ (`go env GOVERSION`). Se o Go não estiver instalado, mostra o comando de instalação (Homebrew, o arquivo oficial no Linux ou winget) e só o executa se você responder `y`. | O comando `go` é a única ferramenta necessária. O servidor web faz parte da biblioteca padrão: "Package http provides HTTP client and server implementations" [1] (tradução livre: "O pacote http fornece implementações de cliente e servidor HTTP"). |
| `build.sh` | Executa `go build -o bin/hello-web .` | Como em [../cli](../cli/README.md#scripts-explained): o `go build` compila o pacote e suas dependências [4] em um único executável nativo. Aqui as dependências são o `net/http` e o `html/template`, de modo que o executável contém o servidor HTTP. |
| `run.sh` | Executa `./bin/hello-web` (com `exec`, de modo que Ctrl+C encerra o servidor). `--verify`: inicia-o em segundo plano, busca `/` uma vez com o `curl`, imprime a resposta e o encerra (um `trap` garante que ele seja encerrado). | O servidor precisa estar em execução para que um navegador o acesse. Não há um programa servidor separado para iniciar, como o Tomcat ou o `flask run`: o executável *é* o servidor. |

## Estrutura de pastas
```text
web/
├── README.md        this file
├── install.sh       checks / installs Go
├── build.sh         compiles with go build
├── run.sh           starts the server
├── screenshot.png   the page in a browser, for "Expected output" below
├── go.mod           the module file: name and minimum Go version
├── main.go          the server
└── bin/             created by build.sh; not committed
    └── hello-web
```
- A mesma estrutura de "comando básico" da [../cli](../cli/README.md#folder-structure) [5].
  Sem `go.sum`, porque nada é baixado.
- O template HTML tem uma única linha, de modo que fica no `main.go`.
  Aplicações maiores mantêm os templates em arquivos `.html` próprios e os
  carregam com `template.ParseFiles`, ou os incorporam ao executável com a
  diretiva `//go:embed` [2][6].

## Passo a passo
Abra o [`main.go`](main.go) ao lado desta lista.

1. **O template**:
   `var page = template.Must(template.New("page").Parse("<p>{{.}}</p>"))`.
   O `{{.}}` ("ponto") representa os dados informados quando o template é
   executado. O `Must` "panics if the error is non-nil" e "is intended for
   use in variable initializations" como esta [2] (tradução livre: "entra
   em pânico se o erro for não nulo" e "destina-se ao uso em inicializações
   de variáveis"), de modo que um template defeituoso interrompe o programa
   na inicialização, e não na primeira requisição.
2. **Por que `html/template` e não `text/template`?** Ele "implements
   data-driven templates for generating HTML output safe against code
   injection", e "the escaping is contextual" [2] (tradução livre:
   "implementa templates orientados a dados para gerar saída HTML segura
   contra injeção de código"; "o escape é contextual"). Experimente: com os
   dados `<script>alert(1)</script>`, a saída é
   `<p>&lt;script&gt;alert(1)&lt;/script&gt;</p>`, um texto que o navegador
   exibe em vez de executar. As versões em Python e em Java devolvem uma
   string fixa, de modo que não precisam de escape.
3. **O tratador**: `func hello(w http.ResponseWriter, r *http.Request)`.
   O `net/http` o chama para cada requisição correspondente. A resposta é
   escrita em `w`; `r` descreve a requisição. `*http.Request` é um tipo
   **ponteiro**: o tratador recebe o endereço da requisição, e não uma
   cópia.
4. **`page.Execute(w, "Hello, World!")`** preenche o template e o escreve em
   `w`. Não é necessário definir o status nem o tipo de conteúdo: quando
   nada foi definido, o `Write` "calls WriteHeader(http.StatusOK)" e "adds
   a Content-Type set to the result of passing the initial 512 bytes of
   written data to DetectContentType" [1] (tradução livre: "chama
   WriteHeader(http.StatusOK)" e "adiciona um Content-Type definido com o
   resultado de passar os 512 bytes iniciais dos dados escritos para
   DetectContentType"). É daí que vem o `text/html; charset=utf-8` na saída
   do `curl -i` abaixo.
5. **Erros são valores.** O `Execute` devolve um `error`; `if err := ...; err
   != nil` o verifica em uma linha. O Go não tem exceções, o que seu FAQ
   explica: "coupling exceptions to a control structure, as in the
   try-catch-finally idiom, results in convoluted code" [7] (tradução
   livre: "acoplar exceções a uma estrutura de controle, como no idioma
   try-catch-finally, resulta em código confuso"). O `http.Error`
   então "replies to the request with the specified error message and HTTP
   code" [1] (tradução livre: "responde à requisição com a mensagem de erro
   e o código HTTP especificados").
6. **A rota**: `http.HandleFunc("GET /{$}", hello)`. Desde o Go 1.22, "Go
   1.22 brings two enhancements to the net/http package's router: method
   matching and wildcards" [3] (tradução livre: "o Go 1.22 traz dois
   aprimoramentos para o roteador do pacote net/http: correspondência de
   método e curingas"). Um padrão com `GET` "matches both GET and HEAD
   requests", e "the pattern "/{$}" matches only the path "/", whereas the
   pattern "/" matches every path" [1] (tradução livre: "corresponde tanto
   a requisições GET quanto HEAD"; "o padrão "/{$}" corresponde somente ao
   caminho "/", ao passo que o padrão "/" corresponde a todos os
   caminhos"). Assim, `/other` recebe `404 Not Found` e `POST /` recebe
   `405 Method Not Allowed` (ver a saída do `curl` abaixo).
7. **`http.ListenAndServe("127.0.0.1:"+port, nil)`** "listens on the TCP
   network address addr", e com um tratador `nil` "DefaultServeMux is
   used" [1] (tradução livre: "escuta no endereço de rede TCP addr"; "usa-se
   o DefaultServeMux"): o roteador em que o `HandleFunc` registrou o
   tratador. `127.0.0.1` significa que apenas este computador pode se
   conectar. A função "always returns a non-nil error" [1] (tradução livre:
   "sempre devolve um erro não nulo") (por exemplo, quando a porta já está
   em uso), e o `log.Fatal` o imprime e encerra o programa.

## Por que esta toolchain
- **A biblioteca padrão é suficiente.** O `net/http` é um servidor HTTP
  completo [1] e, desde o Go 1.22, seu roteador reconhece métodos e curingas
  de caminho [3]. O `html/template` torna o HTML seguro contra injeção de
  código [2]. Este repositório usa `net/http` + `html/template` porque, com
  eles, a menor aplicação web em Go não precisa de nenhuma dependência.

- **Go 1.22 como mínimo:** lançado em 2024-02-06 [8]. A linha `go 1.22` no
  `go.mod` faz as toolchains mais antigas recusarem o módulo [9], em vez de
  falharem no padrão em tempo de execução.
- **A porta 8080** coincide com as demais pastas `web` deste repositório.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Go 1.27.3. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos (`brew install go`). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` não instala o Go: se o Go 1.22 ou posterior não existe, ele imprime os passos do arquivo de go.dev [6] e para. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Go: se o Go 1.22 ou posterior não existe, ele imprime `winget install --id GoLang.Go -e` [12] e para. |

## Saída esperada
`./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: bin/hello-web listens on 127.0.0.1 (this computer only) and answers GET /.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
2026/10/31 13:46:59 Listening on http://localhost:8080/
```
Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Date: Sat, 31 Oct 2026 16:46:38 GMT
Content-Length: 20
Content-Type: text/html; charset=utf-8

<p>Hello, World!</p>
$ curl -s -o /dev/null -w '%{http_code}\n' http://localhost:8080/other
404
$ curl -s -o /dev/null -w '%{http_code}\n' -X POST http://localhost:8080/
405
```
O navegador mostra: **Hello, World!**

![A página em http://localhost:8080/ exibindo "Hello, World!"](screenshot.png)

(Capturada em 2026-10-31 com o Google Chrome headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. Package net/http (ServeMux patterns, HandleFunc, ListenAndServe, ResponseWriter.Write, Error). The Go Authors. <https://pkg.go.dev/net/http> (acessado em 2026-10-31; também lido com `go doc` para o Go 1.27.3)
2. Package html/template (and template.Must). The Go Authors. <https://pkg.go.dev/html/template> (acessado em 2026-10-31)
3. Routing Enhancements for Go 1.22. Jonathan Amsterdam, The Go Blog, 2024-02-13. <https://go.dev/blog/routing-enhancements> (acessado em 2026-10-31)
4. Command go (go build). The Go Authors. <https://pkg.go.dev/cmd/go> (acessado em 2026-10-31)
5. Organizing a Go module. The Go Authors. <https://go.dev/doc/modules/layout> (acessado em 2026-10-31)
6. Package embed. The Go Authors. <https://pkg.go.dev/embed> (acessado em 2026-10-31)
7. Frequently Asked Questions (Why does Go not have exceptions?). The Go Authors. <https://go.dev/doc/faq> (acessado em 2026-10-31)
8. Release History. The Go Authors. <https://go.dev/doc/devel/release> (acessado em 2026-10-31)
9. Go Modules Reference (go directive). The Go Authors. <https://go.dev/ref/mod#go-mod-file-go> (acessado em 2026-10-31)
