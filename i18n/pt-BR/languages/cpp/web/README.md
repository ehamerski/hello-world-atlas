---
source: languages/cpp/web/README.md
source_sha: defcde61a744b0fd823dbb92cdf37b4d7f666711
---
# C++ · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [C++](../README.md)

## O que é
Um servidor web em **http://localhost:8080** (altere com `PORT`) que
responde a `GET /` com o HTML `<p>Hello, World!</p>`. Qualquer outro caminho
recebe `404 Not Found`. O servidor envia o próprio HTML; não há front-end
separado. Ele usa o **cpp-httplib** 0.64.0, "A C++11 single-file
header-only cross platform HTTP/HTTPS library" [1] (tradução livre: "Uma
biblioteca HTTP/HTTPS multiplataforma, em C++11, de arquivo único e somente
de cabeçalho"), e é compilado como ISO C++20 com o CMake.

É o gêmeo em C++ da [versão `web` de C](../../c/web/), que usa o GNU
libmicrohttpd. Mesma porta, mesma resposta, mesmo endereço `127.0.0.1`:
mudam apenas a linguagem e a biblioteca.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Um compilador C++ (`c++`) | Apple clang 21.0.0 (Command Line Tools) | compila `hello.cpp` e o código do servidor em `httplib.h` |
| CMake | 4.4.5 (Homebrew) | encontra `httplib.h` e a biblioteca de threads e gera os arquivos de build |
| cpp-httplib | 0.64.0 (Homebrew) | o servidor HTTP: um único arquivo de cabeçalho, `httplib.h` |
| curl | curl do sistema | usado por `run.sh --verify` para chamar o servidor |

## Início rápido
```sh
./install.sh          # check for c++, CMake and httplib.h (asks before installing)
./build.sh            # configure and build into build/hello-web
./run.sh              # serve on http://localhost:8080 until Ctrl+C
curl http://localhost:8080/    # in another terminal
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica `c++`, `cmake` e `httplib.h`. Se algo estiver faltando, oferece `brew install cpp-httplib` (macOS) ou `sudo apt-get install -y libcpp-httplib-dev` (Debian/Ubuntu), e só o executa se a resposta for `y`. No Windows, explica como copiar `httplib.h`. | A biblioteca padrão do C++ não tem servidor HTTP nem sockets; por isso, o servidor vem de uma biblioteca. |
| `build.sh` | Executa `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release` e depois `cmake --build build`. | A configuração encontra `httplib.h`; a compilação gera tudo em um único executável. |
| `run.sh` | Exporta `PORT` (padrão 8080) e executa `./build/hello-web`. `--verify` o inicia em segundo plano, chama-o uma vez com `curl`, imprime a resposta e o encerra. | Um servidor executa até ser interrompido; a autoverificação permite que `scripts/verify-all.sh` o execute sem acompanhamento. |

**Somente cabeçalho.** Todo o cpp-httplib está em `httplib.h` (24.321 linhas
na versão 0.64.0). O compilador compila o código do servidor toda vez que
compila `hello.cpp`; assim, não há biblioteca HTTP para vincular nem para
carregar em tempo de execução. O `CMakeLists.txt` só precisa encontrar a
pasta do cabeçalho (`find_path`) e vincular a biblioteca de threads
(`Threads::Threads`): o servidor atende as conexões com um pool de threads
de trabalho (classe `ThreadPool` em `httplib.h`). O Homebrew também instala
um pacote CMake, `httplib::httplib`, mas a compilação dele tem HTTPS e
compressão ativados, o que acrescentaria OpenSSL e zlib ao build; um programa
Hello World em HTTP simples não precisa de nenhum dos dois.

## Estrutura de pastas
```text
web/
├── README.md        this file
├── install.sh       checks / installs c++, CMake and cpp-httplib
├── build.sh         configures and builds with CMake
├── run.sh           starts the server (--verify: self-check)
├── CMakeLists.txt   the CMake project: C++20, httplib.h, threads
├── hello.cpp        the server
├── screenshot.png   the page in a browser (see Expected output)
└── build/           created by build.sh; not committed
    └── hello-web
```

## Passo a passo
Abra [`hello.cpp`](hello.cpp) ao lado de
[`../../c/web/hello.c`](../../c/web/hello.c).

1. **A porta.** `std::getenv("PORT")` é o `getenv` do C; a parte do C++ é
   `std::stoi`, que converte o texto em um `int` e **lança uma exceção**
   para um texto que não seja um número. O bloco `try { ... } catch` trata
   essa exceção. O `atoi` do C não tem como informar um erro e retorna 0.
   `if (const char *text = std::getenv("PORT"))` declara uma variável dentro
   do `if`, o que o C89 não permite.
2. **`httplib::Server server;`** O servidor é um objeto na pilha. O C++ o
   destrói automaticamente quando `main` termina. A versão em C cria um
   daemon com `MHD_start_daemon` e precisa encerrá-lo com
   `MHD_stop_daemon`.
3. **O tratador é uma lambda.**
   ```cpp
   server.Get("/", [](const httplib::Request &, httplib::Response &res) {
       res.set_content("<p>Hello, World!</p>", "text/html; charset=utf-8");
   });
   ```
   `[]` inicia uma lambda: uma função sem nome escrita no próprio local, que
   o C++ compila em "an unnamed function object" [2] (tradução livre: "um
   objeto de função sem nome"). Seus parâmetros são *referências* (`&`): o
   tratador trabalha sobre os próprios objetos de requisição e de resposta
   da biblioteca, sem cópias e sem sintaxe de ponteiros. A versão em C
   escreve uma função separada com oito parâmetros
   (`answer(void *cls, struct MHD_Connection *connection, const char
   *url, ...)`) e compara o caminho por conta própria com `strcmp(url, "/")`.
   Aqui, a rota é o primeiro argumento de `Get`, e os caminhos sem
   tratador recebem 404 da própria biblioteca.
4. **`res.set_content(body, content_type)`** define o corpo e o cabeçalho
   `Content-Type`. Em C, isso exige três chamadas:
   `MHD_create_response_from_buffer_static`, `MHD_add_response_header`,
   `MHD_queue_response` e, depois, `MHD_destroy_response` para liberá-lo.
5. **`server.listen("127.0.0.1", port)`** associa-se apenas a este computador
   e atende até o programa ser interrompido; retorna `false` se a porta não
   puder ser usada. O cpp-httplib "uses 'blocking' socket I/O" e "Only
   HTTP/1.1 is supported" [1] (tradução livre: "usa E/S de socket
   'bloqueante'" e "Somente o HTTP/1.1 é suportado"). Isso basta para um
   programa Hello World. A versão em C preenche uma `struct sockaddr_in` à
   mão (`memset`, `htons`, `htonl`) para obter o mesmo endereço.
6. **Tamanho e bibliotecas.** `build/hello-web` tem 695.672 bytes na máquina
   de teste (macOS Intel): o código do servidor vindo do cabeçalho está
   compilado dentro dele. `otool -L` lista apenas `libc++` e `libSystem`. A
   versão em C tem 9.472 bytes, mas precisa da `libmicrohttpd` instalada em
   qualquer lugar onde execute. É o compromisso clássico entre bibliotecas
   somente de cabeçalho e bibliotecas compartilhadas.

## Por que esta toolchain
O **Crow** [3] e o **cpp-httplib** [1] são bibliotecas C++ para servidores
HTTP. Esta pasta usa o cpp-httplib pelos seguintes motivos:

- **Um arquivo, sem dependências.** O cpp-httplib é "single-file
  header-only" [1] (tradução livre: "de arquivo único e somente de
  cabeçalho"). A configuração do Crow no macOS pede uma segunda biblioteca, a
  Asio: executar `brew install asio` e depois adicionar caminhos de busca de
  cabeçalhos para o Crow e para a Asio [3]. Para o menor exemplo possível,
  um único cabeçalho é mais simples de explicar e de instalar.
- **O mesmo *bottle* em todo Mac.** O Homebrew distribui o cpp-httplib como um
  único *bottle* independente de plataforma (`all`) [4]; por isso, ele é
  instalado em segundos em um Mac Intel. (O Qt em [../desktop](../desktop/)
  não tinha *bottle* para Intel e foi compilado a partir do código-fonte.)
- **Empacotado no Linux:** o Debian tem `libcpp-httplib-dev` [5].
- **Licença:** MIT [1].
- **Limites:** E/S bloqueante e somente HTTP/1.1 [1]. O Crow é um framework
  "for creating HTTP or Websocket web services" [3] (tradução livre: "para
  criar serviços web HTTP ou WebSocket"). Um serviço com WebSocket ou de alta
  concorrência favoreceria o Crow; um programa Hello World não precisa de
  nenhum dos dois.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | Apple clang 21.0.0, CMake 4.4.5, cpp-httplib 0.64.0 (Homebrew). `./run.sh --verify` imprimiu `<p>Hello, World!</p>`; `curl -i` mostrou `HTTP/1.1 200 OK` e `Content-Type: text/html; charset=utf-8`, e `/nope` resultou em `404 Not Found`. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos; o *bottle* do Homebrew é o mesmo arquivo [4]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `build-essential`, `cmake` e `libcpp-httplib-dev` com o apt quando faltam [5]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o MSYS2 em `C:\msys64` e instala os pacotes UCRT64 `gcc`, `cmake` e `ninja` com o `pacman` quando faltam. O MSYS2 não tem um pacote do cpp-httplib; por isso o script baixa o `httplib.h` 0.64.0 do repositório do cpp-httplib [1], confere o SHA-256 e o coloca em `C:\msys64\ucrt64\include`. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: build/hello-web listens on 127.0.0.1 (this computer only) and answers GET /.
Listening on http://localhost:8080
<p>Hello, World!</p>
```
`Listening on ...` é impresso pelo servidor; `<p>Hello, World!</p>` é a
resposta do `curl`.

Com `./run.sh` em execução, abra <http://localhost:8080/> em um navegador:

![A página em um navegador](screenshot.png)

(Capturada em 2026-11-01 no macOS Intel com o Chrome em modo headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. cpp-httplib (README: description, blocking I/O, HTTP/1.1, examples, license, releases). Yuji Hirose. <https://github.com/yhirose/cpp-httplib> (acessado em 2026-11-01)
2. Lambda expressions. cppreference.com. <https://en.cppreference.com/w/cpp/language/lambda> (acessado em 2026-11-01)
3. Crow: home page and macOS setup. CrowCpp. <https://crowcpp.org/master/>, <https://crowcpp.org/master/getting_started/setup/macos/> (acessado em 2026-11-01)
4. cpp-httplib (Homebrew formula: version and bottles). Homebrew. <https://formulae.brew.sh/formula/cpp-httplib> (acessado em 2026-11-01)
5. Package libcpp-httplib-dev (stable). Debian. <https://packages.debian.org/stable/libcpp-httplib-dev> (acessado em 2026-11-01)
