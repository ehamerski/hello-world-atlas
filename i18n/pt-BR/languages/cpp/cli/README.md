---
source: languages/cpp/cli/README.md
source_sha: 194c3978aad4209168217c399042ae17ffdc8270
---
# C++ · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [C++](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É um único arquivo, `hello.cpp`, compilado como **ISO C++20**
(ISO/IEC 14882:2020 [1]) e construído com o **CMake**, um gerador de
sistemas de build muito usado em C++.

É o gêmeo em C++ da [versão `cli` de C](../../c/cli/): mesma família de
compilador (Apple clang), mesmo tipo de executável nativo. Os comentários de
`hello.cpp` e o passo a passo abaixo mostram, linha a linha, o que o C++
muda.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Um compilador C++ (`c++`) | Apple clang 21.0.0 (Command Line Tools) | compila e vincula `hello.cpp` |
| CMake | 4.4.5 (Homebrew) | gera os arquivos de build (`CMakeLists.txt`) |

`std::cout` vem da biblioteca padrão do C++, que acompanha todo compilador
C++ (`libc++` com o Clang no macOS).

## Início rápido
```sh
./install.sh   # check for c++ and CMake (asks before installing)
./build.sh     # configure and build into build/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica `c++ --version` e `cmake --version`. Se um deles não existir, oferece `xcode-select --install` / `brew install cmake` (macOS) ou `sudo apt-get install -y build-essential` / `cmake` (Debian/Ubuntu), ou imprime os comandos do MSYS2 (Windows), e só os executa se a resposta for `y`. | O C++ é compilado; portanto, precisa de um compilador, e o CMake descreve o build. |
| `build.sh` | Executa `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release` (configurar) e depois `cmake --build build` (compilar), imprimindo os dois comandos. | O CMake primeiro escreve os arquivos de build em `build/` e depois os executa. |
| `run.sh` | Executa `./build/hello-cli`. `--verify` faz o mesmo (um programa CLI termina sozinho). | O executável é código de máquina; portanto, o sistema operacional o executa diretamente. |

**O CMake em duas etapas.** O CMake "is a tool to manage building of source
code" [2] (tradução livre: "é uma ferramenta para gerenciar a compilação de
código-fonte"); mais exatamente, `cmake` é "the command-line interface of the
cross-platform buildsystem generator CMake" [3] (tradução livre: "a interface
de linha de comando do gerador de sistemas de build multiplataforma CMake").
Ele mesmo não compila nada:
- `cmake -S . -B build` usa `-S` como o "root directory of the CMake
  project" (tradução livre: "diretório raiz do projeto CMake") e `-B` como o
  "root of build directory" (tradução livre: "raiz do diretório de build")
  ("If the directory doesn't already exist CMake will make it" [3], tradução
  livre: "Se o diretório ainda não existir, o CMake o criará"). Esta etapa
  lê `CMakeLists.txt`, encontra o compilador e escreve Makefiles em
  `build/`.
- `cmake --build build` executa esses arquivos gerados, que chamam `c++` [3].

**O que `CMakeLists.txt` solicita.** `CMAKE_CXX_STANDARD 20` solicita o
padrão C++ "whose features are requested to build this target. For some
compilers, this results in adding a flag such as `-std=gnu++11`" [4]
(tradução livre: "cujos recursos são solicitados para compilar este alvo.
Em alguns compiladores, isso resulta na adição de uma opção como
`-std=gnu++11`"). `CMAKE_CXX_EXTENSIONS OFF` desativa as "compiler specific
extensions" [5] (tradução livre: "extensões específicas do compilador"),
que vêm ativadas por padrão [5]; assim, a opção passa a ser `-std=c++20`
em vez de `-std=gnu++20`. `CMAKE_CXX_STANDARD_REQUIRED ON` faz o CMake
parar em vez de "decaying" (tradução livre: "regredir") a um padrão mais
antigo [4]. O resultado, de `build/CMakeFiles/hello-cli.dir/flags.make` na
máquina de teste:
```text
CXX_FLAGS = -O3 -DNDEBUG -std=c++20 -Wall -Wextra -pedantic-errors
```
É a mesma ideia de `-std=c89 -pedantic-errors` no
[cli de C](../../c/cli/README.md#scripts-explained): aceitar apenas a
linguagem ISO, sem extensões.

## Estrutura de pastas
```text
cli/
├── README.md        this file
├── install.sh       checks / installs c++ and CMake
├── build.sh         configures and builds with CMake
├── run.sh           runs build/hello-cli
├── CMakeLists.txt   the CMake project: C++20, one executable
├── hello.cpp        the program
└── build/           created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- O C++, como o C, não tem layout de projeto oficial. O CMake lê
  `CMakeLists.txt` da pasta de código-fonte indicada com `-S` [3]; projetos
  maiores costumam acrescentar as pastas `src/` e `include/`.
- `build/` contém tudo o que o CMake gera (um build "out-of-source", fora da
  pasta de código-fonte); portanto, apagá-la reinicia o build. Ela é
  ignorada pelo `.gitignore` da raiz.

## Passo a passo
Abra [`hello.cpp`](hello.cpp) ao lado desta lista e
[`../../c/cli/hello.c`](../../c/cli/hello.c) ao lado dele.

1. **Os comentários** são escritos com `//` (ou `/* ... */`). O C só
   adicionou `//` no C99, e é por isso que a versão `cli` de C, compilada
   como C89, o rejeita [6].
2. **`#include <iostream>`** cola o cabeçalho que declara `std::cout`,
   exatamente como o `#include <stdio.h>` do C: o C++ manteve o
   pré-processador do C. Os cabeçalhos padrão do C++ não têm `.h`. Os
   cabeçalhos do C continuam disponíveis com um `c` na frente: `<cstdio>`
   tem "the same" (tradução livre: "o mesmo") conteúdo do `stdio.h` do C,
   mas suas declarações ficam no espaço de nomes `std` [7].
3. **`int main()`**: o ponto de entrada é `main`, como em C. Em C++, um `()`
   vazio significa nenhum parâmetro: "If the parameter-declaration-clause is
   empty, the function takes no arguments" [8] (tradução livre: "Se a
   cláusula de declaração de parâmetros estiver vazia, a função não recebe
   argumentos"). O C precisa de `(void)` para isso (até o C23); por isso, a
   versão em C escreve `int main(void)`.
4. **`std::cout << "Hello, World!\n";`**: `std::` é um *espaço de nomes*
   (*namespace*), um escopo nomeado que mantém os nomes da biblioteca padrão
   separados dos nomes do programador. O C não tem espaços de nomes; por
   isso, as bibliotecas C usam prefixos como `gtk_` ou `MHD_`. `std::cout`
   é um objeto de fluxo global que controla a saída para um buffer de
   fluxo [9]. `<<` é um *operador sobrecarregado*: a biblioteca define uma
   versão para cada tipo, e o compilador a escolhe a partir do tipo do valor.
   Não há string de formato como em `printf("%s", ...)`; portanto, um
   código `%` incompatível não pode ocorrer. Como no `printf`, `\n` é a
   quebra de linha.
5. **Sem `return 0;`**: "If control flows off the end of the
   compound-statement of main, the effect is equivalent to a return with
   operand 0" [10] (tradução livre: "Se o fluxo de controle atingir o fim do
   comando composto de main, o efeito equivale a um return com operando 0").
   O C tem a mesma regra desde o C99, mas a versão `cli` de C é C89 e,
   portanto, escreve o `return`.
6. **Tamanho e bibliotecas.** `build/hello-cli` tem 14.248 bytes na máquina
   de teste (macOS Intel), contra 8.440 da versão em C. `otool -L
   build/hello-cli` lista `/usr/lib/libc++.1.dylib` (a biblioteca padrão do
   C++) e `/usr/lib/libSystem.B.dylib` (a biblioteca C); a versão em C carrega
   apenas a segunda. Ambas são vinculadas dinamicamente; assim, o código de
   `std::cout` e de `printf` permanece nas bibliotecas compartilhadas do
   sistema.

## Por que esta toolchain
- **C++20.** Esta pasta tem como alvo o C++20. É um padrão ISO publicado
  ("published in 2020 as ISO/IEC 14882:2020" [1], tradução livre:
  "publicado em 2020 como ISO/IEC 14882:2020"), e o atual é o C++23
  (ISO/IEC 14882:2024) [1][11]. O Clang aceita `-std=c++20` e classifica seu
  suporte ao C++20 como parcial [12]; o GCC oferece suporte "mostly 2020"
  (tradução livre: "majoritariamente 2020") [1]. Este programa não usa nada
  novo, mas as mesmas opções são usadas nas três pastas, e
  [../desktop](../desktop/) e [../web](../web/) usam lambdas, que o C não
  tem.
- **CMake em vez de chamar `c++` diretamente.** Para um só arquivo, o CMake é
  mais do que o necessário (a versão `cli` de C chama `cc` diretamente). Ele
  é usado aqui porque o Qt 6, necessário em [../desktop](../desktop/),
  documenta seus builds com o CMake e fornece comandos CMake como
  `qt_add_executable` [13]. Usar a mesma ferramenta nas três pastas também as
  mantém comparáveis.
- **O compilador do sistema.** Apple clang no macOS, `g++` no Linux e `g++`
  do MSYS2 no Windows; todos aceitam aqui as mesmas opções [1][12].

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | Apple clang 21.0.0 (Command Line Tools, sem o aplicativo Xcode), CMake 4.4.5 do Homebrew. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. O executável é gerado para arm64. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `build-essential` (quando `c++` não existe) e `cmake` (quando não existe) com o apt [14][15]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o MSYS2 em `C:\msys64` e instala os pacotes UCRT64 `gcc`, `cmake` e `ninja` com o `pacman` quando faltam [16]. O CMake usa o gerador Ninja. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: build/hello-cli is machine code; the operating system runs it directly.
Hello, World!
```
O programa em si imprime apenas a última linha; as demais linhas vêm de
`run.sh`.

## Fontes
1. Language Standards Supported by GCC (C++ Language). GCC, the GNU Compiler Collection. <https://gcc.gnu.org/onlinedocs/gcc/Standards.html> (acessado em 2026-11-01)
2. CMake Documentation (index; "CMake is a tool to manage building of source code"). Kitware. <https://cmake.org/cmake/help/latest/> (acessado em 2026-11-01)
3. cmake(1) manual (-S, -B, --build). Kitware. <https://cmake.org/cmake/help/latest/manual/cmake.1.html> (acessado em 2026-11-01)
4. CXX_STANDARD (target property). Kitware. <https://cmake.org/cmake/help/latest/prop_tgt/CXX_STANDARD.html> (acessado em 2026-11-01)
5. CXX_EXTENSIONS (target property). Kitware. <https://cmake.org/cmake/help/latest/prop_tgt/CXX_EXTENSIONS.html> (acessado em 2026-11-01)
6. ISO/IEC 9899:TC3, committee draft WG14/N1256 (C99; Foreword, list of changes: "// comments"). ISO/IEC JTC1/SC22/WG14, 2007. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (acessado em 2026-10-31)
7. C++ working draft, [headers] (C++ headers for C library facilities). ISO/IEC JTC1/SC22/WG21 draft, edição HTML. <https://eel.is/c++draft/headers> (acessado em 2026-11-01)
8. C++ working draft, [dcl.fct] (Functions). WG21 draft, edição HTML. <https://eel.is/c++draft/dcl.fct> (acessado em 2026-11-01)
9. `std::cout`, `std::wcout`. cppreference.com. <https://en.cppreference.com/w/cpp/io/cout> (acessado em 2026-11-01)
10. C++ working draft, [basic.start.main] (main function). WG21 draft, edição HTML. <https://eel.is/c++draft/basic.start.main> (acessado em 2026-11-01)
11. The Standard ("The current ISO C++ standard is C++23 ... ISO/IEC 14882:2024"). Standard C++ Foundation (isocpp.org). <https://isocpp.org/std/the-standard> (acessado em 2026-11-01)
12. C++ Support in Clang. The Clang Team. <https://clang.llvm.org/cxx_status.html> (acessado em 2026-11-01)
13. Getting started with CMake (Qt 6). The Qt Company. <https://doc.qt.io/qt-6/cmake-get-started.html> (acessado em 2026-11-01)
14. Package build-essential (stable). Debian. <https://packages.debian.org/stable/build-essential> (acessado em 2026-11-01)
15. Package `cmake` (stable). Debian. <https://packages.debian.org/stable/cmake> (acessado em 2026-11-01)
16. MSYS2. Projeto MSYS2. <https://www.msys2.org/> (acessado em 2026-11-01)
