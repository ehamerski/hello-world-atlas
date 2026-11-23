---
source: languages/c/web/README.md
source_sha: c7259da162f9eabb135f61f97dc8e0de4e66903a
---
# C · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [C](../README.md)

## O que é
Um servidor web em <http://localhost:8080/> que responde a `GET /` com o
HTML `<p>Hello, World!</p>`, como as demais versões web (por exemplo, o
[Go](../../go/web/)). Qualquer outro caminho recebe `404` e
`<p>Not Found</p>`.

A biblioteca padrão do C não tem nenhum recurso de rede, de modo que a parte
HTTP vem da **GNU libmicrohttpd**: "a small C library that makes it easy to
run an HTTP server as part of another application" [1] (tradução livre:
"uma pequena biblioteca C que facilita executar um servidor HTTP como parte
de outra aplicação"). O `hello.c` a chama, e o `build.sh` a liga em
`bin/hello-web`.

O código é compilado como **C99** (`-std=c99 -pedantic-errors`), e não como
C89, como em [../cli](../cli/): o cabeçalho da libmicrohttpd exige C99
(consulte [Por que C99 aqui](#por-que-c99-aqui)).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Um compilador C (`cc`) | Apple clang 21.0.0 (Command Line Tools 26.6) | compila o `hello.c` |
| pkg-config | pkgconf 3.0.10 (Homebrew) | imprime onde estão o cabeçalho e a biblioteca da libmicrohttpd |
| GNU libmicrohttpd | 1.0.10 (Homebrew) | a biblioteca do servidor HTTP |
| curl | 8.7.1 (acompanha o macOS) | somente para `./run.sh --verify` |

A libmicrohttpd "is free software ... under the GNU LGPL v2.1 or at your
option any later version" e é "part of the GNU project" [1] (tradução livre:
"é software livre ... sob a GNU LGPL v2.1 ou, à sua escolha, qualquer
versão posterior" e "parte do projeto GNU"). Sua página diz: "GNU
libmicrohttpd 1.x is the stable version, and GNU libmicrohttpd 2.x is
experimental" [1] (tradução livre: "A GNU libmicrohttpd 1.x é a versão
estável, e a GNU libmicrohttpd 2.x é experimental"); por isso, esta pasta
usa a 1.x.

## Início rápido
```sh
./install.sh   # check cc, pkg-config and libmicrohttpd (asks before installing)
./build.sh     # compile hello.c as C99 and link libmicrohttpd into bin/hello-web
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Em seguida, abra <http://localhost:8080/> ou execute
`curl http://localhost:8080/`. Use outra porta com `PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica o `cc`. 2. Verifica o `pkg-config`. 3. Verifica `pkg-config --exists libmicrohttpd`. O que estiver ausente é oferecido com seu comando de instalação (`brew install libmicrohttpd`, `sudo apt-get install -y libmicrohttpd-dev` ou a linha `pacman` do MSYS2 no Windows) e só é executado se a resposta for `y`. | O C não tem gerenciador de pacotes próprio (nada de Maven, de módulos do Go ou de npm). As bibliotecas vêm do gerenciador de pacotes do sistema operacional [2][3][4]. No Linux, a biblioteca é dividida: o pacote `-dev` contém o cabeçalho e o arquivo `.pc` de que o compilador e o `pkg-config` precisam. |
| `build.sh` | Executa `cc -std=c99 -pedantic-errors -Wall -Wextra $(pkg-config --cflags libmicrohttpd) -o bin/hello-web hello.c $(pkg-config --libs libmicrohttpd)` e imprime o comando expandido (`set -x`). | O `pkg-config --cflags` fornece as pastas `-I` em que está o `microhttpd.h`; o `--libs` fornece `-L<pasta> -lmicrohttpd` para o linker. As opções para o C estrito são explicadas em [../cli](../cli/README.md#scripts-explained). |
| `run.sh` | Executa `./bin/hello-web` com `PORT` (padrão 8080). `--verify` o inicia em segundo plano, obtém a página uma vez com o `curl` e o encerra. | O programa é o servidor: não há processo de servidor separado (compare com o Tomcat do Spring Boot em [../../java/web](../../java/web/)). |

**Ligado, não copiado.** O `otool -L bin/hello-web` (macOS; `ldd` no Linux)
lista `/usr/local/opt/libmicrohttpd/lib/libmicrohttpd.12.dylib` ao lado da
biblioteca C: a biblioteca é carregada quando o programa inicia, de modo que
precisa permanecer instalada. O executável em si tem 9.472 bytes. Um servidor
Go, em vez disso, copia seu código HTTP para dentro do executável
([13,6 MB](../../go/README.md#comparing-the-categories)).

## Estrutura de pastas
```text
web/
├── README.md     this file
├── install.sh    checks cc, pkg-config and libmicrohttpd
├── build.sh      compiles and links
├── run.sh        starts the server (or checks it with --verify)
├── hello.c       the program: request handler + main
├── screenshot.png   the page in a browser (see Expected output)
└── bin/          created by build.sh; not committed
    └── hello-web
```
Como em [../cli](../cli/README.md#folder-structure), um único arquivo `.c`
não precisa de arquivo de projeto. O HTML é uma string em `hello.c`; uma
única linha não precisa de um arquivo de template.

## Passo a passo
Abra [`hello.c`](hello.c) ao lado desta lista.

1. **Cabeçalhos.** `<stdio.h>`, `<stdlib.h>` e `<string.h>` são do C
   padrão. `<netinet/in.h>` não é: é do POSIX, a interface de rede do
   sistema operacional. No Windows, os mesmos tipos vêm do Winsock, de modo
   que as linhas `#ifndef _WIN32 ... #endif` fazem o pré-processador pular
   essa inclusão ali. `<microhttpd.h>` é a API da libmicrohttpd; todo nome
   nela começa com `MHD_`, porque o C não tem espaços de nomes (namespaces).
2. **A página** é `static const char page[] = "<p>Hello, World!</p>";`.
   Uma string C é um vetor de `char` que termina com um byte `'\0'`
   invisível, de modo que `sizeof page - 1` é o comprimento do texto.
3. **`answer(...)`, o tratador.** A libmicrohttpd o chama a cada
   requisição. Sua longa lista de parâmetros é fixada pela biblioteca: o
   tratador de exemplo da página do projeto tem os mesmos oito parâmetros
   [1]. Este programa usa apenas `connection` e `url`; as linhas
   `(void) cls;` indicam que os demais não são usados de propósito, o que
   mantém o `-Wextra` em silêncio.
   - `strcmp(url, "/") != 0`: as strings são comparadas com `strcmp`, que
     retorna 0 quando são iguais. O `==` compararia dois endereços.
   - `MHD_create_response_from_buffer_static(length, body)` envolve o texto
     em uma resposta sem copiá-lo. O cabeçalho documenta a regra: "The
     buffer must be valid for the lifetime of the response. The easiest way
     to achieve this is to use a statically allocated buffer" [5] (tradução
     livre: "O buffer deve ser válido durante todo o tempo de vida da
     resposta. A forma mais fácil de conseguir isso é usar um buffer alocado
     estaticamente"). O texto é um vetor `static`, de modo que a regra é
     cumprida.
   - `MHD_add_response_header` define `Content-Type: text/html; charset=utf-8`.
   - `MHD_queue_response(connection, status, response)` a envia, e
     `MHD_destroy_response(response)` libera de imediato o handle desta
     função. O tutorial faz o mesmo [6], e o cabeçalho explica por que isso é
     seguro: "libmicrohttpd may keep some of the resources around if the
     response is still in the queue for some clients" [5] (tradução livre:
     "a libmicrohttpd pode manter alguns dos recursos se a resposta ainda
     estiver na fila para alguns clientes"). Sem coletor de lixo, o código C
     libera o que cria.
4. **`main`: a porta.** `getenv("PORT")` retorna `NULL` quando `PORT` não
   está definida; `atoi` transforma o texto em número. A verificação de
   faixa (1 a 65535) encerra com um erro em vez de escutar em uma porta
   inválida.
5. **`main`: o endereço.** `struct sockaddr_in` é preenchida com
   `127.0.0.1` (`INADDR_LOOPBACK`), de modo que somente este computador pode
   se conectar. `memset` a zera antes, porque o C não inicializa variáveis
   locais. `htons`/`htonl` convertem os números para a ordem de bytes da
   rede.
6. **`MHD_start_daemon(...)`** inicia o servidor. Depois da porta vêm dois
   callbacks com seus dados (`NULL, NULL`: sem verificação de acesso; depois
   `&answer, NULL`) e, em seguida, *opções* em pares, encerradas por
   `MHD_OPTION_END`. `MHD_OPTION_SOCK_ADDR_LEN` "Bind[s] daemon to the
   supplied 'struct sockaddr'" e é "followed by two parameters: 'socklen_t'
   the size of memory at the next pointer and the pointer" [5] (tradução
   livre: "Associa o daemon à 'struct sockaddr' fornecida" e é "seguida de
   dois parâmetros: 'socklen_t', o tamanho da memória no ponteiro seguinte, e
   o ponteiro"). Esta é uma chamada *variádica* do C, como o `printf`: o
   compilador não consegue verificar os tipos após os parâmetros fixos, de
   modo que um erro na ordem só aparece em tempo de execução.
   `MHD_USE_ERROR_LOG` faz a biblioteca "print error messages and warnings
   to stderr" [7] (tradução livre: "imprimir mensagens de erro e avisos no
   stderr") (por exemplo, "Address already in use").
7. **O laço: `for (;;) MHD_run_wait(daemon, -1);`.** Nenhuma opção de
   threads foi passada, de modo que o servidor executa nesta thread, e
   `MHD_run_wait` faz o trabalho: espera eventos de rede ("If set to '-1'
   then function waits for events indefinitely", isto é, "Se for '-1', a
   função espera indefinidamente por eventos"), trata-os e retorna [5]. O
   cabeçalho a chama de "useful for quick and simple (lazy) webserver
   implementation if application needs to run a single thread only" [5]
   (tradução livre: "útil para uma implementação rápida e simples (preguiçosa)
   de servidor web, se a aplicação precisar executar em uma única thread").
   O tutorial oficial, em vez disso, inicia uma thread do servidor e espera a
   tecla Enter com `getchar()` antes de `MHD_stop_daemon` [6]. Isso faria o
   servidor parar de imediato quando executa em segundo plano sem teclado,
   como o `run.sh --verify` faz, de modo que esta versão repete o laço
   indefinidamente e é encerrada com Ctrl+C. O sistema operacional então
   fecha o socket.

### Por que C99 aqui
Compile o `hello.c` como C89 e o compilador aponta para o próprio cabeçalho
da libmicrohttpd:
```text
$ cc -std=c89 -pedantic $(pkg-config --cflags libmicrohttpd) -fsyntax-only hello.c
.../microhttpd.h:3231:18: warning: 'long long' is an extension when C99 mode is not enabled [-Wlong-long]
```
`long long` (e `<stdint.h>`, que o cabeçalho inclui) surgiu no C99: a lista de
mudanças do C99 inclui "the long long int type and library functions" [8]
(tradução livre: "o tipo long long int e as funções de biblioteca"). Assim,
o cabeçalho precisa de C99, e o `build.sh` usa `-std=c99 -pedantic-errors`.
O próprio `hello.c` ainda segue hábitos do C89: comentários `/* */` e
declarações no início de cada bloco.

## Por que esta toolchain
- **GNU libmicrohttpd** para a versão web. Ela foi projetada para este caso:
  um servidor HTTP embutido em um programa C [1].
- **Pequena e em C puro.** Um cabeçalho, uma biblioteca, nenhum framework,
  nenhum gerador de código. O servidor inteiro é uma chamada de função mais
  um tratador.
- **Mantida e portável.** A página do projeto lista "GNU/Linux, FreeBSD,
  OpenBSD, NetBSD, Android, Darwin (macOS), W32, OpenIndiana/Solaris, and
  z/OS" como plataformas suportadas [1]. O Homebrew empacota a 1.0.10 [2], o
  Debian stable a 1.0.1 [3], e o MSYS2 a fornece para o Windows [4].
  `MHD_create_response_from_buffer_static` e `MHD_OPTION_SOCK_ADDR_LEN`
  exigem a versão 0.9.77 ou mais nova (`MHD_VERSION 0x00097701` e
  `0x00097706` no cabeçalho [5]); a 1.0.1 tem ambas.
- **Nem CGI, nem framework.** Um programa C também poderia ser executado
  atrás de outro servidor web como um script CGI. Isso exigiria um segundo
  programa (por exemplo, o Apache ou o nginx) antes de qualquer coisa ser
  exibida, de modo que esta pasta embute o servidor no próprio programa.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Apple clang 21.0.0, libmicrohttpd 1.0.10 e pkgconf 3.0.10 do Homebrew (com bottle para Intel [2]). |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos; o Homebrew tem bottles para arm64 [2]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `build-essential`, `pkg-config` e `libmicrohttpd-dev` com o apt quando faltam [3]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o MSYS2 em `C:\msys64` e instala os pacotes UCRT64 `gcc`, `pkgconf` e `libmicrohttpd` com o `pacman` quando faltam [4]. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: bin/hello-web listens on 127.0.0.1 (this computer only) and answers GET /.
Listening on http://localhost:8080/
<p>Hello, World!</p>
```
E com o servidor em execução (`./run.sh` em outro terminal):
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Connection: close
Content-Type: text/html; charset=utf-8
Content-Length: 20

<p>Hello, World!</p>
```
(O `curl -i` também imprime um cabeçalho `Date:`, omitido aqui.)

![A página em um navegador](screenshot.png)

(Capturada em 2026-11-01 no macOS Intel com o Chrome em modo headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. GNU libmicrohttpd (project page: description, license, platforms, stable/experimental versions, example handler). GNU Project. <https://www.gnu.org/software/libmicrohttpd/> (acessado em 2026-10-31; cópia arquivada: <https://web.archive.org/web/20261113123927/http://www.gnu.org/software/libmicrohttpd/>, acessado em 2026-11-22)
2. libmicrohttpd (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/libmicrohttpd> (acessado em 2026-10-31)
3. Package libmicrohttpd-dev (stable). Debian. <https://packages.debian.org/stable/libmicrohttpd-dev> (acessado em 2026-10-31)
4. mingw-w64-libmicrohttpd. MSYS2 Packages. <https://packages.msys2.org/base/mingw-w64-libmicrohttpd> (acessado em 2026-10-31)
5. `microhttpd.h` from libmicrohttpd 1.0.10 (API documentation comments: `MHD_run_wait`, `MHD_create_response_from_buffer_static`, `MHD_destroy_response`, `MHD_OPTION_SOCK_ADDR_LEN`). Installed by Homebrew at `/usr/local/include/microhttpd.h`; the same file is in the release tarball at <https://ftp.gnu.org/gnu/libmicrohttpd/> (acessado em 2026-10-31)
6. A Tutorial for GNU libmicrohttpd (chapter "Hello browser example"). GNU Project. <https://www.gnu.org/software/libmicrohttpd/tutorial.html> (acessado em 2026-10-31; cópia arquivada: <https://web.archive.org/web/20260219200524/https://www.gnu.org/software/libmicrohttpd/tutorial.html>, acessado em 2026-11-22)
7. The GNU libmicrohttpd Reference Manual (`MHD_USE_ERROR_LOG`, `MHD_OPTION_SOCK_ADDR`). GNU Project. <https://www.gnu.org/software/libmicrohttpd/manual/libmicrohttpd.html> (acessado em 2026-10-31; cópia arquivada: <https://web.archive.org/web/20250330001954/https://www.gnu.org/software/libmicrohttpd/manual/libmicrohttpd.html>, acessado em 2026-11-22)
8. ISO/IEC 9899:TC3, committee draft WG14/N1256 (C99; Foreword list of changes). ISO/IEC JTC1/SC22/WG14, 2007-09-07. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (acessado em 2026-10-31)
