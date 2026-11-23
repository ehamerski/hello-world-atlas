---
source: languages/c/cli/README.md
source_sha: a340b1da613bb101e23fb07c93b2e0ee09bea0a6
---
# C · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [C](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É um único arquivo, `hello.c`, escrito em **ANSI C**: o C do
primeiro padrão, ANSI X3.159-1989, também publicado pela ISO como
ISO/IEC 9899:1990 e geralmente chamado de C89 ou C90 [1]. O `build.sh` o
compila com `-std=c89 -pedantic-errors`, de modo que o compilador rejeita
tudo o que não seja C89.

Como a [versão `cli` do Go](../../go/cli/), o programa é compilado
antecipadamente para um executável nativo, `bin/hello-cli`. Diferentemente
do Go, o C não tem ferramenta de compilação nem sistema de módulos próprios:
o `build.sh` chama o compilador diretamente.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Um compilador C (`cc`) | Apple clang 21.0.0 (Command Line Tools 26.6) | compila e liga o `hello.c` |

Nenhuma outra ferramenta é necessária. O `printf` vem da biblioteca padrão
do C, que toda instalação de compilador C já inclui. No macOS, o `cc` é o
Apple clang; no Linux, geralmente é o GCC. Ambos aceitam as opções usadas
aqui [2][3].

## Início rápido
```sh
./install.sh   # check for a C compiler (asks before installing)
./build.sh     # compile hello.c as C89 into bin/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Executa `cc --version`. Se nenhum compilador funcionar, oferece `xcode-select --install` (macOS) ou `sudo apt-get install -y build-essential` (Debian/Ubuntu), ou imprime os comandos do MSYS2 (Windows), e só os executa se a resposta for `y`. | O C é compilado, de modo que um compilador é a única ferramenta necessária. |
| `build.sh` | Executa `cc -std=c89 -pedantic-errors -Wall -Wextra -o bin/hello-cli hello.c` e imprime esse comando (`set -x`). `CC=gcc ./build.sh` escolhe outro compilador. | Transforma o código-fonte em código de máquina. As opções são explicadas abaixo. |
| `run.sh` | Executa `./bin/hello-cli`. `--verify` faz o mesmo (um programa CLI termina por conta própria). | O executável é código de máquina, de modo que o sistema operacional o executa diretamente. |

**As opções, uma a uma:**
- `-std=c89` seleciona a linguagem de 1989. Manual do GCC: "The original
  ANSI C standard (X3.159-1989) was ratified in 1989 and published in 1990.
  This standard was ratified as an ISO standard (ISO/IEC 9899:1990) later in
  1990. There were no technical differences between these
  publications" [1] (tradução livre: "O padrão ANSI C original
  (X3.159-1989) foi ratificado em 1989 e publicado em 1990. Esse padrão foi
  ratificado como padrão ISO (ISO/IEC 9899:1990) mais tarde, em 1990. Não
  havia diferenças técnicas entre essas publicações"). O Clang aceita os
  mesmos nomes de modo (`c89`, `c99`, `c11`, `c17`, `c23`, ...) [3].
- `-pedantic-errors`: o `-std` sozinho não basta. GCC: "to obtain all the
  diagnostics required by the standard, you should also specify -pedantic
  (or -pedantic-errors if you want them to be errors rather than
  warnings)" [1] (tradução livre: "para obter todos os diagnósticos exigidos
  pelo padrão, deve-se especificar também -pedantic (ou -pedantic-errors,
  para que sejam erros e não avisos)"). Descrição curta do Clang: "Error on
  language extensions" [3] (tradução livre: "Erro em extensões da
  linguagem").
- `-Wall`: "all the warnings about constructions that some users consider
  questionable, and that are easy to avoid" (tradução livre: "todos os
  avisos sobre construções que alguns usuários consideram questionáveis e
  que são fáceis de evitar"); `-Wextra`: "some extra warning flags that are
  not enabled by -Wall" (tradução livre: "algumas opções de aviso extras que
  não são habilitadas por -Wall") [2].
- `-o bin/hello-cli` dá nome à saída; sem ele, o arquivo se chama `a.out`.

Sem `-std`, o compilador usa seu próprio dialeto padrão, que é mais novo e
tem extensões: "If no -std option is specified, clang defaults to gnu17
mode" [3] (tradução livre: "Se nenhuma opção -std for especificada, o clang
adota por padrão o modo gnu17"); o padrão do GCC é `-std=gnu23` [1].

**Experimente:** acrescente uma linha `// hi` ao `hello.c` e execute
`./build.sh`. A compilação falha com `error: // comments are not allowed in
this language`. Os comentários de uma linha surgiram no C99: a lista de
mudanças do padrão C99 inclui "// comments" [4] (comentários `//`). Remova a
linha e a compilação volta a funcionar.

## Estrutura de pastas
```text
cli/
├── README.md     this file
├── install.sh    checks / installs a C compiler
├── build.sh      compiles hello.c as C89
├── run.sh        runs bin/hello-cli
├── hello.c       the program
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- O C não tem estrutura de projeto oficial nem arquivo de projeto: nada de
  `go.mod`, nada de `pom.xml`. Um programa de um único arquivo consiste
  apenas no arquivo `.c`. Projetos maiores costumam acrescentar um
  `Makefile` (ou arquivos CMake/Meson), `src/` para os arquivos `.c` e
  `include/` para os cabeçalhos; um único arquivo não precisa disso.
- `bin/` é ignorado pelo `.gitignore` da raiz: a saída da compilação nunca
  recebe commit.

## Passo a passo
Abra [`hello.c`](hello.c) ao lado desta lista.

1. **Os comentários** são escritos `/* ... */`. Essa é a única forma de
   comentário do C89; `//` é do C99 (consulte "Experimente" acima). Java,
   Go e C++ herdaram as duas formas.
2. **`#include <stdio.h>`** é uma *diretiva de pré-processador*. Antes de o
   compilador propriamente dito executar, o pré-processador substitui a
   linha pelo conteúdo do cabeçalho `stdio.h`, que declara o `printf`.
   Ritchie escreve que "many other changes occurred around 1972-3, but the
   most important was the introduction of the preprocessor" [5] (tradução
   livre: "muitas outras mudanças ocorreram por volta de 1972-73, mas a mais
   importante foi a introdução do pré-processador"). Ele copia texto; não é
   a importação de um módulo (compare com o `import "fmt"` do Go). O código
   do `printf` está na biblioteca C, que o linker acrescenta: `otool -L
   bin/hello-cli` mostra que a única biblioteca carregada é
   `/usr/lib/libSystem.B.dylib`, a biblioteca C do macOS.
3. **`int main(void)`**: a execução começa em `main`. Ela retorna um `int`,
   o status de saída para o sistema operacional. `(void)` significa "sem
   parâmetros". No C antigo, parênteses vazios `()` significavam "parâmetros
   não especificados"; o C23 "mandated function declarations whose parameter
   list is empty be treated the same as a parameter list which only contain
   a single void" [6] (tradução livre: "determinou que as declarações de
   função cuja lista de parâmetros é vazia sejam tratadas da mesma forma que
   uma lista de parâmetros que contém apenas um void"). Compare com o `func
   main()` do Go (sem valor de retorno) e com o `main(String[] args)` do
   Java dentro de uma classe.
4. **`printf("Hello, World!\n");`** escreve a string na saída padrão. `\n` é
   a quebra de linha: o `printf` não acrescenta nenhuma por conta própria, ao
   contrário do `print` do Python ou do `Println` do Go. Toda instrução
   termina com `;`.
5. **`return 0;`** encerra `main` com status 0 (sucesso). O C99 diz "reaching
   the } that terminates the main function returns a value of 0" [4]
   (tradução livre: "alcançar o } que encerra a função main retorna o valor
   0"), mas o C89 não tem essa regra, de modo que um programa C89 escreve o
   `return`.
6. **Compilar, ligar, executar.** O `build.sh` realiza todas essas etapas em
   uma única chamada. Para vê-las separadamente:
   ```sh
   cc -std=c89 -E hello.c | tail -n 5     # only preprocess: stdio.h is pasted in
   cc -std=c89 -c hello.c -o hello.o      # compile to an object file
   cc hello.o -o bin/hello-cli            # link with the C library
   ```
   (Apague o `hello.o` depois; os arquivos `*.o` são ignorados pelo Git.)
   `file bin/hello-cli` informa `Mach-O 64-bit executable x86_64` na máquina
   de teste (macOS Intel). O arquivo tem 8.440 bytes, contra 2,5 MB da
   [versão `cli` do Go](../../go/README.md#comparing-the-categories): a
   biblioteca do C é compartilhada por todo o sistema em vez de copiada para
   cada programa.

## Por que esta toolchain
- **O compilador C do sistema, chamado diretamente.** Toda plataforma tem
  um: o Apple clang acompanha as Command Line Tools da Apple, o GCC é
  empacotado por distribuições Linux como o Debian [8], e o MSYS2 fornece o
  GCC no Windows [7]. Tanto o Clang quanto o GCC têm um modo `-std` para
  cada padrão do C, do C89 ao C23 [1][3].
- **C89 de propósito.** Este repositório tem como alvo o ANSI C (C89 estrito
  ou C99). O C89 é o padrão ANSI original [1], e os compiladores atuais
  ainda o aceitam por meio de `-std=c89` [1][3]. Esta pasta pode usar C89
  porque precisa apenas de `<stdio.h>`. [../desktop](../desktop/) e
  [../web](../web/) precisam de C99 porque os cabeçalhos de suas
  bibliotecas o exigem.
- **Sem Makefile.** O `make` é a ferramenta de compilação clássica do C,
  mas, para um único arquivo, ele apenas repetiria a linha do `cc`. O
  `build.sh` mostra essa linha em seu lugar.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Apple clang 21.0.0 das Command Line Tools (sem o aplicativo Xcode). |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. O executável é compilado para arm64. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `build-essential` com o apt quando `cc` não existe [8]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala um compilador: se `cc` não existe, ele imprime os passos do MSYS2 (`pacman -S mingw-w64-ucrt-x86_64-gcc`) [7] e para. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly.
Hello, World!
```
O próprio programa imprime apenas a última linha; as demais linhas vêm do
`run.sh`.

## Fontes
1. Language Standards Supported by GCC (C Language). GCC, the GNU Compiler Collection. <https://gcc.gnu.org/onlinedocs/gcc/Standards.html> (acessado em 2026-10-31)
2. Options to Request or Suppress Warnings (-Wall, -Wextra, -Wpedantic, -pedantic-errors). GCC. <https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html> (acessado em 2026-10-31)
3. Clang Compiler User's Manual (C language modes, default mode, -pedantic-errors). The Clang Team. <https://clang.llvm.org/docs/UsersManual.html> (acessado em 2026-10-31)
4. ISO/IEC 9899:TC3, committee draft WG14/N1256 (C99 with corrigenda; Foreword list of changes, 5.1.2.2.3 Program termination). ISO/IEC JTC1/SC22/WG14, 2007-09-07. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (acessado em 2026-10-31)
5. The Development of the C Language. Dennis M. Ritchie, HOPL-II, ACM, 1993 (author's reprint, archived copy of bell-labs.com, 2015-12-31). <https://web.archive.org/web/20151231162516/http://www.bell-labs.com/usr/dmr/www/chist.html> (acessado em 2026-10-31)
6. ISO/IEC 9899:2024, working draft WG14/N3220 (C23; Annex M, list of changes). ISO/IEC JTC1/SC22/WG14. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3220.pdf> (acessado em 2026-10-31)
7. MSYS2 (and package mingw-w64-gcc). MSYS2 project. <https://www.msys2.org/>, <https://packages.msys2.org/base/mingw-w64-gcc> (acessado em 2026-10-31)
8. Package build-essential (stable). Debian. <https://packages.debian.org/stable/build-essential> (acessado em 2026-10-31)
