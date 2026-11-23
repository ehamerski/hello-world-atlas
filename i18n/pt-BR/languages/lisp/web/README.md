---
source: languages/lisp/web/README.md
source_sha: ff1c1a6bbb76ef9afeef23346ddcca29f32b5dcb
---
# Common Lisp · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Common Lisp](../README.md)

## O que é
Um servidor web em <http://localhost:8080/> que responde a `GET /` com o
HTML `<p>Hello, World!</p>`, como as demais versões web (por exemplo, a de
[Python](../../python/web/)). Qualquer outro caminho recebe a própria página
`404 Not Found` do Hunchentoot.

O servidor é o **Hunchentoot**, "a web server written in Common Lisp and at
the same time a toolkit for building dynamic websites" [1] (tradução livre:
"um servidor web escrito em Common Lisp e, ao mesmo tempo, um kit de
ferramentas para construir sites dinâmicos"). Ele é uma biblioteca, não faz
parte do SBCL; por isso, vem do **Quicklisp**, "a library manager for Common
Lisp" (tradução livre: "um gerenciador de bibliotecas para Common Lisp") que
pode "download, install, and load any of over 1,500 libraries" [3]
(tradução livre: "baixar, instalar e carregar qualquer uma de mais de 1.500
bibliotecas"). O Quicklisp é o equivalente em Common Lisp do `pip` do Python
ou do `npm` do Node.js.

Como em [../cli](../cli/), o `build.sh` carrega tudo em um SBCL em execução
e salva esse Lisp como um único executável, `bin/hello-web`. Este contém o
SBCL, o Hunchentoot, as bibliotecas de que o Hunchentoot precisa e o arquivo
[`server.lisp`](server.lisp).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| SBCL | 2.6.10 (`sbcl` do Homebrew) | compila o Hunchentoot e `server.lisp` e, depois, salva o executável; instalado exatamente como para [../cli](../cli/README.md#prerequisites) |
| Quicklisp | instalador `quicklisp.lisp` do site do Quicklisp, em `~/quicklisp/`; lista de bibliotecas ("dist") de 2026-01-01 | baixa o Hunchentoot e as suas bibliotecas durante `build.sh` |
| Hunchentoot | 1.3.1 (do Quicklisp) | a biblioteca de servidor web |
| `curl` | 8.7.1 (acompanha o macOS) | baixa o instalador do Quicklisp; usado por `./run.sh --verify` |

A página do Quicklisp diz "The libraries were last updated on January 1,
2026" (tradução livre: "As bibliotecas foram atualizadas pela última vez em
1º de janeiro de 2026"), e a página do Hunchentoot diz "The current version
is 1.3.1" (tradução livre: "A versão atual é a 1.3.1") [3][1]. O Quicklisp
não é um programa no `PATH`: é código Lisp em uma pasta, que o SBCL carrega
com `(load "~/quicklisp/setup.lisp")` [3]. O instalador usa por padrão
`quicklisp/` na pasta pessoal do usuário [4], e o `install.sh` mantém esse
padrão. O Quicklisp e a rede são necessários apenas para **compilar**; o
`run.sh` não precisa de nenhum dos dois.

## Início rápido
```sh
./install.sh   # check SBCL, install Quicklisp into ~/quicklisp/ (asks first)
./build.sh     # download + load Hunchentoot, load server.lisp, save bin/hello-web
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Em seguida, abra <http://localhost:8080/> ou execute
`curl http://localhost:8080/`. Para usar outra porta, execute
`PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica `sbcl` (se estiver ausente, executa [../cli/install.sh](../cli/install.sh)). 2. Verifica se há `~/quicklisp/setup.lisp`. 3. Se o Quicklisp estiver ausente, pergunta e, em seguida, baixa `https://beta.quicklisp.org/quicklisp.lisp`, verifica o seu SHA-256 e executa `sbcl --non-interactive --no-sysinit --no-userinit --load quicklisp.lisp --eval '(quicklisp-quickstart:install :path "<home>/quicklisp/")'`. Sem `sudo`. | O Quicklisp se instala sozinho: "To install Quicklisp, download `quicklisp.lisp` and load it" (tradução livre: "Para instalar o Quicklisp, baixe `quicklisp.lisp` e carregue-o") e, depois, avalie `(quicklisp-quickstart:install)` [3]. A soma de verificação é a publicada na página do Quicklisp [3]; assim, um arquivo alterado é recusado. O `install.sh` não executa `(ql:add-to-init-file)`, que "append code to your Lisp's init file" [3] (tradução livre: "acrescentaria código ao arquivo de inicialização do Lisp"); o `build.sh` carrega o Quicklisp por conta própria. |
| `quicklisp-env.sh` | Define `QUICKLISP_HOME` (padrão `~/quicklisp`), a URL do instalador e o seu SHA-256. É lido por `install.sh` e `build.sh`, não é executado isoladamente. | Os dois scripts precisam concordar sobre onde o Quicklisp está. `QUICKLISP_HOME=/some/path ./install.sh` usa outra pasta. |
| `build.sh` | Executa `sbcl --non-interactive --no-sysinit --no-userinit --eval '(push :hunchentoot-no-ssl *features*)' --load ~/quicklisp/setup.lisp --eval '(ql:quickload :hunchentoot)' --load server.lisp --eval '(sb-ext:save-lisp-and-die "bin/hello-web" :executable t :toplevel (function hello-web:main))'` e o imprime (`set -x`). | `ql:quickload` é a etapa que baixa: "Quicklisp will automatically download any supporting software it needs to load the system" [3] (tradução livre: "O Quicklisp baixará automaticamente qualquer software de apoio de que precisar para carregar o sistema"). O primeiro build baixa o Hunchentoot e as suas bibliotecas para `~/quicklisp/dists/`; os builds seguintes as reutilizam. As opções do SBCL são explicadas em [../cli](../cli/README.md#scripts-explained). |
| `run.sh` | Exporta `PORT` (padrão 8080) e executa `./bin/hello-web`. `--verify` o inicia em segundo plano, obtém a página uma vez com `curl` e o encerra. | O executável é o servidor: não há programa servidor separado para iniciar. A autoverificação permite que `scripts/verify-all.sh` teste o servidor sem aguardar Ctrl+C. |

**Por que `:hunchentoot-no-ssl`.** A documentação do Hunchentoot diz: "You can
compile Hunchentoot without SSL support - and thus without the need to
have CL+SSL - if you add :HUNCHENTOOT-NO-SSL to *FEATURES* before you
compile it" [1] (tradução livre: "É possível compilar o Hunchentoot sem
suporte a SSL, e portanto sem a necessidade do CL+SSL, se :HUNCHENTOOT-NO-SSL
for adicionado a *FEATURES* antes de compilá-lo"). `*features*` é "a list of
symbols, called features, that correspond to some aspect of the
implementation or environment" [14] (tradução livre: "uma lista de símbolos,
chamados de features, que correspondem a algum aspecto da implementação ou
do ambiente"). O arquivo de sistema do Hunchentoot, então, deixa de fora o
`cl+ssl` e o seu arquivo `ssl` (`:if-feature (:not :hunchentoot-no-ssl)` em
`hunchentoot.asd` [2]). Um servidor em `127.0.0.1` para um Hello World não
precisa de HTTPS. É por isso que o `push` vem **antes** de `ql:quickload` no
`build.sh`.

## Estrutura de pastas
```text
web/
├── README.md          this file
├── install.sh         checks SBCL, installs Quicklisp
├── quicklisp-env.sh   where Quicklisp lives + installer checksum (sourced)
├── build.sh           loads Hunchentoot and server.lisp, saves bin/hello-web
├── run.sh             starts the server (or checks it with --verify)
├── server.lisp        the program: package, handler, main
├── screenshot.png     the page in a browser (see Expected output)
└── bin/               created by build.sh; not committed (see ../../../.gitignore)
    └── hello-web
```
Fora do repositório, o `install.sh` cria `~/quicklisp/` (o próprio
Quicklisp), e o `build.sh` adiciona as bibliotecas baixadas a
`~/quicklisp/dists/quicklisp/software/`. Exclua `~/quicklisp/` para
removê-las todas; a pasta é compartilhada por todos os projetos Lisp do
computador.

## Passo a passo
Abra [`server.lisp`](server.lisp) ao lado desta lista. Leia antes
[../cli](../cli/README.md#step-by-step-walkthrough): listas, `defun` e
`format` funcionam do mesmo modo aqui.

1. **Um pacote.** `(defpackage :hello-web (:use :cl) (:export #:main))`
   cria um espaço de nomes (namespace); `defpackage` "creates a package as specified and
   returns the package" [8] (tradução livre: "cria um pacote conforme
   especificado e retorna o pacote"). `(:use :cl)` torna os nomes padrão
   (`defun`, `format` e outros) utilizáveis sem prefixo, e `:export` torna
   `main` público, de modo que o `build.sh` possa escrever
   `hello-web:main`. `(in-package :hello-web)` o torna "the current package"
   [9] (tradução livre: "o pacote atual") pelo resto do arquivo. Os nomes do
   Hunchentoot mantêm o prefixo (`hunchentoot:start`) para que se veja de
   onde vêm.
2. **O tratador é uma chamada de macro.**
   `(hunchentoot:define-easy-handler (say-hello :uri "/") () ...)`
   "Defines a handler as if by DEFUN and optionally registers it with a
   URI" [1] (tradução livre: "Define um tratador como se fosse por DEFUN e,
   opcionalmente, o registra em uma URI"). É uma macro: o Lisp lhe passa o
   código como listas, e ela retorna um novo código, "a form to be evaluated
   in place of the original argument form" [10] (tradução livre: "uma forma
   a ser avaliada no lugar da forma original do argumento"). Aqui, esse novo
   código define uma função `say-hello` e a registra para `/`. Isso só
   funciona porque o código Lisp são dados. A lista vazia `()` significa que
   o tratador não lê parâmetros da requisição.
3. **O corpo é a resposta.** Os tratadores funcionam "by eventually returning
   the response body in the form of a string" [1] (tradução livre: "por fim,
   retornando o corpo da resposta na forma de uma string"). A última forma,
   `"<p>Hello, World!</p>"`, é o valor da função e, portanto, a página. Não
   há `print` nem `return`: em Lisp, o valor da última expressão é o
   resultado, como nas linguagens funcionais.
4. **Um efeito colateral: o cabeçalho.**
   `(setf (hunchentoot:content-type*) "text/html; charset=utf-8")`.
   `setf` "changes the value of place to be newvalue" [11] (tradução livre:
   "altera o valor de place para newvalue"); aqui, o place é o cabeçalho
   Content-Type da resposta. O padrão do Hunchentoot já é `"text/html"` [2];
   escrevê-lo mostra onde os cabeçalhos são definidos.
5. **`main`: a porta.** `let*` associa variáveis locais uma após a outra
   [12]. `(sb-ext:posix-getenv "PORT")` retorna o valor de `PORT`, "or nil
   if there is none" [5] (tradução livre: "ou nil, se não houver"); `(or ...
   "8080")` escolhe então o valor padrão, e `parse-integer` converte o texto
   em número [13]. O padrão não tem função para variáveis de ambiente; por
   isso, esta é uma extensão do SBCL (`sb-ext`).
6. **`main`: o objeto servidor.** `make-instance` "creates and returns a new
   instance of the given class" [15] (tradução livre: "cria e retorna uma
   nova instância da classe indicada"), aqui um `easy-acceptor` do
   Hunchentoot. Este é o CLOS, o sistema de objetos do Common Lisp: o
   terceiro paradigma em um único arquivo pequeno. `:address "127.0.0.1"`
   significa "the server only receives connections for that address" [2]
   (tradução livre: "o servidor recebe conexões apenas para esse endereço");
   assim, somente este computador pode se conectar.
7. **`main`: iniciar e, depois, esperar.** `hunchentoot:start` "Starts
   acceptor so that it begins accepting connections. Returns the acceptor"
   [1] (tradução livre: "Inicia o acceptor para que ele comece a aceitar
   conexões. Retorna o acceptor"): ele não bloqueia. Em um Lisp com threads,
   como este SBCL, o taskmaster padrão "starts one thread for listening to
   incoming requests and one thread for each incoming connection" [1]
   (tradução livre: "inicia uma thread para escutar as requisições recebidas
   e uma thread para cada conexão recebida"). Por isso, `main` não pode
   retornar; ele dorme em um laço, `(loop (sleep 60))`.
8. **Ctrl+C.** `handler-case` executa o laço com um tratador, como um
   try/catch: quando uma condição correspondente é sinalizada, "control is
   transferred to the body of the relevant error-clause" [16] (tradução
   livre: "o controle é transferido para o corpo da error-clause
   correspondente"). A cláusula de `sb-sys:interactive-interrupt`, a
   condição que este programa captura para Ctrl+C, chama
   `hunchentoot:stop`, que "Stops the acceptor so that it no longer accepts
   requests" [1] (tradução livre: "Interrompe o acceptor para que ele não
   aceite mais requisições"), e, depois, `(sb-ext:exit :code 0 :abort t)`.
   Com `:abort t`, "SBCL exits immediately" (tradução livre: "o SBCL sai
   imediatamente"), sem desfazer as demais threads [5]. Na máquina de teste,
   enviar Ctrl+C (SIGINT) a `bin/hello-web` o encerrou com código de saída
   0.
9. **A imagem, de novo.** Os passos 1 a 8 foram executados dentro do SBCL
   durante o `build.sh`, e `save-lisp-and-die` salvou o resultado com
   `hello-web:main` como função de inicialização, como em
   [../cli](../cli/README.md#scripts-explained). Durante o desenvolvimento,
   o código seria carregado no REPL, e o trabalho no servidor seria feito
   enquanto ele está em execução. O Common-Lisp.net descreve "a flexible
   run-time environment that allows modification and debugging of running
   applications (excellent for server-side development ...)" [17] (tradução
   livre: "um ambiente de execução flexível que permite modificar e depurar
   aplicações em execução (excelente para o desenvolvimento no lado do
   servidor ...)").

## Por que esta toolchain
- O **Hunchentoot** é um servidor web completo em Lisp: sem biblioteca em C
  e sem processo servidor separado. A sua documentação inicia um servidor
  com uma linha, `(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port
  4242))` [1], e `define-easy-handler` adiciona uma página em três linhas.
- O **Quicklisp** instala bibliotecas Common Lisp. A sua página mostra como
  carregar sistemas com `(ql:quickload "system-name")` e que ele funciona
  "with your existing Common Lisp implementation" [3] (tradução livre: "com
  a implementação de Common Lisp já existente"), aqui o SBCL.
- **Compilar uma vez, executar offline.** Fazer o trabalho do Quicklisp no
  `build.sh` permite que o `run.sh` inicie um executável pronto, sem
  Quicklisp e sem rede. O preço é o tamanho: `bin/hello-web` tem 48.175.232
  bytes na máquina de teste, porque todo o sistema Lisp está dentro dele.
- **Porta 8080 em 127.0.0.1**: a convenção do repositório para toda versão
  web. O padrão do próprio Hunchentoot é a porta 80 ("Use the :port initarg
  if you don't want to listen on the default http port 80" [1], em tradução
  livre: "Use o initarg :port se não quiser escutar na porta http padrão,
  80"), e "depending on your operating system you might need special
  privileges to listen on port 80" [2] (tradução livre: "dependendo do
  sistema operacional, pode ser necessário ter privilégios especiais para
  escutar na porta 80").

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | SBCL 2.6.10 do Homebrew (compilado a partir do código-fonte, sem bottle para Intel [6]), Quicklisp em `~/quicklisp`, Hunchentoot 1.3.1. `otool -L bin/hello-web` lista `libSystem.B.dylib` e `libzstd.1.dylib` do Homebrew (o SBCL do Homebrew depende do `zstd` [6]). |
| macOS Apple Silicon | ⚠️ não verificado | `brew install sbcl` instala um bottle pré-compilado [6]. Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` executa o `install.sh` do cli (que instala o `sbcl` com o apt quando ele não existe), depois baixa o `quicklisp.lisp`, confere o SHA-256 e instala o Quicklisp em `~/quicklisp`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o MSYS2 em `C:\msys64` e instala o pacote UCRT64 `sbcl` com o `pacman` quando o `sbcl` não existe (por meio do `install.sh` do cli). Em seguida, baixa o `quicklisp.lisp`, confere o SHA-256 e instala o Quicklisp em `~/quicklisp`. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: bin/hello-web starts Hunchentoot on 127.0.0.1 (this computer only); it
         answers GET / and logs each request to the terminal.
Listening on http://localhost:8080/
127.0.0.1 - [2026-11-01 19:43:43] "GET / HTTP/1.1" 200 20 "-" "curl/8.7.1"
<p>Hello, World!</p>
```
A linha `127.0.0.1 - [...]` é o log de acesso do Hunchentoot; a última linha é
a página que o `curl` recebeu.

Com o servidor em execução (`./run.sh` em outro terminal):
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Length: 20
Date: Sun, 01 Nov 2026 22:43:51 GMT
Server: Hunchentoot 1.3.1
Content-Type: text/html; charset=utf-8

<p>Hello, World!</p>
```
`curl -i http://localhost:8080/nope` recebe `HTTP/1.1 404 Not Found` e uma
pequena página de erro em HTML do Hunchentoot. Pressione Ctrl+C no terminal
do servidor para encerrá-lo.

![Uma página do navegador exibindo "Hello, World!"](screenshot.png)

(Captura feita em 2026-11-02 no macOS Intel com o Chrome headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. Hunchentoot - The Common Lisp web server formerly known as TBNL (home page and reference: installation, `easy-acceptor`, `define-easy-handler`, request handlers, `start`, `stop`, taskmasters). Edi Weitz, edicl. <https://edicl.github.io/hunchentoot/> (acessado em 2026-11-01)
2. Hunchentoot v1.3.1 source: `specials.lisp` (`*default-content-type*`), `acceptor.lisp` (`:address`, `:port`), `hunchentoot.asd` (`:hunchentoot-no-ssl`). edicl, GitHub. <https://github.com/edicl/hunchentoot/tree/v1.3.1> (acessado em 2026-11-01)
3. Quicklisp beta. Quicklisp. <https://www.quicklisp.org/beta/> (acessado em 2026-11-01)
4. Quicklisp installer `quicklisp.lisp` (`*home*` and `install :path`). Quicklisp. <https://beta.quicklisp.org/quicklisp.lisp> (acessado em 2026-11-01)
5. SBCL 2.6.10 User Manual (`sb-ext:posix-getenv`; `sb-ext:exit`; 3.6.1 Saving a Core Image). SBCL. <https://www.sbcl.org/manual/> (acessado em 2026-11-01)
6. `sbcl` formula. Homebrew. <https://formulae.brew.sh/formula/sbcl> (acessado em 2026-11-01)
7. Download (platform table). SBCL. <https://www.sbcl.org/platform-table.html> (acessado em 2026-11-01)
8. Common Lisp HyperSpec, Macro DEFPACKAGE. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_defpkg.htm> (acessado em 2026-11-01)
9. Common Lisp HyperSpec, Macro IN-PACKAGE. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_in_pkg.htm> (acessado em 2026-11-01)
10. Common Lisp HyperSpec, Glossary: M ("macro function"). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/26_glo_m.htm> (acessado em 2026-11-01)
11. Common Lisp HyperSpec, Macro SETF, PSETF. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_setf_.htm> (acessado em 2026-11-01)
12. Common Lisp HyperSpec, Special Operator LET, LET*. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/s_let_l.htm> (acessado em 2026-11-01)
13. Common Lisp HyperSpec, Function PARSE-INTEGER. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/f_parse_.htm> (acessado em 2026-11-01)
14. Common Lisp HyperSpec, Variable *FEATURES*. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/v_featur.htm> (acessado em 2026-11-01)
15. Common Lisp HyperSpec, Standard Generic Function MAKE-INSTANCE. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/f_mk_ins.htm> (acessado em 2026-11-01)
16. Common Lisp HyperSpec, Macro HANDLER-CASE. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_hand_1.htm> (acessado em 2026-11-01)
17. Common-Lisp.net (home page: "What is Common Lisp?"). Common-Lisp.net. <https://common-lisp.net/> (acessado em 2026-11-01)
18. Package `sbcl` (trixie). Debian. <https://packages.debian.org/stable/sbcl> (acessado em 2026-11-01)
