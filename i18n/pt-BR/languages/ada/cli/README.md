---
source: languages/ada/cli/README.md
source_sha: 9228cca2dd8042dc1a69e9bcfa39cee4f6933219
---
# Ada · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Ada](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. O programa é um único procedimento Ada,
[`src/hello.adb`](src/hello.adb), compilado como **Ada 2022**
(ISO/IEC 8652:2023 [1]) pelo **GNAT**, o compilador Ada do GCC [2]. A pasta
é um **crate do Alire**: o Alire é "a source-based package manager for the
Ada and SPARK programming languages" [3] (tradução livre: "um gerenciador de
pacotes baseado em código-fonte para as linguagens de programação Ada e
SPARK"). Ele baixa o compilador e compila o programa, de modo semelhante ao
que o Cargo faz em [Rust](../../rust/cli/).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Alire (`alr`) | 2.1.1 (arquivo oficial da versão, em `~/.local/bin`) | instala a toolchain e compila o crate |
| GNAT (`gnat_native`, instalado pelo Alire) | 16.2.0 | o compilador Ada |
| GPRbuild (`gprbuild`, instalado pelo Alire) | 26.0.1 | a ferramenta de compilação que lê o `hello.gpr` |
| curl e unzip | ferramentas do sistema macOS | apenas para baixar o Alire na primeira vez |

O Alire mantém a toolchain em uma pasta própria (`~/.local/share/alire`;
cerca de 700 MB na máquina de desenvolvimento), e não em pastas do sistema,
de modo que nada exige `sudo`. O compilador não está no PATH: o `alr` o
chama. O comando `alr exec -- gnat --version` o exibe.

## Início rápido
```sh
./install.sh   # check / install Alire and the GNAT toolchain (asks first)
./build.sh     # alr build: compile, bind and link into bin/hello
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Se o `alr` estiver ausente, mostra os comandos `curl` e `unzip` que colocam a versão oficial 2.1.1 do Alire em `~/.local/bin` e só os executa se a resposta for `y` (Windows: aponta para o instalador oficial). 2. Se `alr toolchain` não mostrar um `gnat_native` padrão, oferece `alr -n toolchain --select`, que baixa o GNAT e o GPRbuild. | Documentação do Alire: "Once the archive is extracted you have to add `alr` in the environment `PATH`" [3] (tradução livre: "Depois de extraído o arquivo, é preciso adicionar o `alr` à variável de ambiente `PATH`"). ada-lang.io: "By far the easiest way to get hold of an Ada toolchain is to use the Ada package manager Alire" [4] (tradução livre: "De longe, a forma mais fácil de obter uma toolchain Ada é usar o gerenciador de pacotes Ada Alire"). |
| `build.sh` | Executa `alr -n build` (`-n`: não interativo, aceita as respostas padrão). | O Alire regenera `config/` a partir de `alire.toml`; em seguida, o GPRbuild compila, faz o bind e o link. |
| `run.sh` | Executa `./bin/hello`. `--verify` faz o mesmo (um programa cli termina por conta própria). | O executável é código de máquina, de modo que o sistema operacional o executa diretamente. |

O `alr run` compilaria e executaria em uma só etapa: "This will build and
then launch the resulting executable" [3] (tradução livre: "Isso compilará e
depois iniciará o executável resultante"). O `run.sh` executa o arquivo em
vez disso, para mostrar que ele não precisa de mais nada.

## Estrutura de pastas
```text
cli/
├── README.md       this file
├── install.sh      checks / installs Alire and GNAT
├── build.sh        alr build
├── run.sh          runs bin/hello
├── alire.toml      Alire manifest: crate name, executable, Ada 2022
├── hello.gpr       GNAT project file: sources, main, output folders
├── .gitignore      generated folders (made by alr init)
├── src/
│   └── hello.adb   the program
└── (generated, not committed)
    ├── config/     settings generated from alire.toml on each build
    ├── obj/        compiled units: hello.o, hello.ali
    ├── alire/      Alire's local state for this crate
    └── bin/hello   the executable
```
- Este é o layout que o `alr init --bin hello` cria, conforme a
  documentação do Alire o descreve [3]. A pasta foi criada com
  `alr init --in-place --bin hello`. Em seguida, o `alire.toml` foi
  reduzido e todos os arquivos receberam comentários.
- O `hello.gpr` é um arquivo de projeto do GNAT: "A text file expressed in
  an Ada-like syntax, generally with the .gpr extension", que "defines
  build-related characteristics of an application" [5] (tradução livre: "Um
  arquivo de texto expresso em uma sintaxe semelhante à do Ada,
  geralmente com a extensão .gpr", que "define características de uma
  aplicação relacionadas à compilação").
- A nomenclatura de arquivos do GNAT: "The file extension is .ads for a spec
  and .adb for a body", e o nome do arquivo é o nome da unidade "using
  lowercase for all letters" [6] (tradução livre: "A extensão de arquivo é
  .ads para uma especificação e .adb para um corpo", e o nome do arquivo é o
  nome da unidade "usando minúsculas em todas as letras"). Por isso,
  `procedure Hello` fica em `hello.adb`.

## Passo a passo
Abra [`src/hello.adb`](src/hello.adb) ao lado desta lista.

1. **Os comentários** começam com `--` e vão até o fim da linha. O Ada não
   tem comentário de bloco.
2. **`with Ada.Text_IO;`** é uma cláusula de contexto: "with is used to
   reference external modules that are needed in the procedure" [7]
   (tradução livre: "with é usado para referenciar módulos externos
   necessários ao procedimento"). `Ada.Text_IO` é o pacote padrão de
   entrada e saída de texto. Compare com o `#include <stdio.h>` do C, que
   cola texto, e com o `import "fmt"` do Go.
3. **`procedure Hello is ... begin ... end Hello;`** é o programa principal.
   O padrão diz "an implementation is required to support all main
   subprograms that are public parameterless library procedures" [8]
   (tradução livre: "uma implementação deve oferecer suporte a todos os
   subprogramas principais que sejam procedimentos de biblioteca públicos e
   sem parâmetros"). Não há um nome fixo como o `main` do C: o `hello.gpr`
   diz `for Main use ("hello.adb");`. As declarações ficariam entre `is` e
   `begin`. O `end Hello` repete o nome, de modo que o compilador verifica
   se o bloco correto foi fechado.
4. **`Ada.Text_IO.Put_Line ("Hello, World!");`** "Calls the procedure Put
   for the given string, and then the procedure New_Line with a spacing of
   one" [9] (tradução livre: "Chama o procedimento Put para a string dada e,
   em seguida, o procedimento New_Line com espaçamento um"): escreve o texto
   e uma quebra de linha, como o `print` do Python. O nome completo indica de
   qual pacote vem o `Put_Line`. Uma cláusula `use Ada.Text_IO;` permitiria
   o nome curto.
5. **Compilação: compile, bind, link.** O `alr build` mostra três fases:
   `Compile` (o GNAT transforma `hello.adb` em `hello.o` e `hello.ali`, um
   arquivo com as informações de dependência da unidade), `Bind` e `Link`.
   O binder, `gnatbind`, "Checks that a program is consistent, in accordance
   with the rules in Chapter 10 of the Ada Reference Manual" e "Generates a
   main program incorporating the given elaboration order" [12] (tradução
   livre: "Verifica se um programa é consistente, de acordo com as regras do
   Capítulo 10 do Ada Reference Manual" e "Gera um programa principal que
   incorpora a ordem de elaboração dada"). A etapa de bind é própria do Ada;
   C, Fortran e COBOL vão direto da compilação para o link.
6. **Observe o resultado.** `otool -L bin/hello` mostra apenas
   `/usr/lib/libSystem.B.dylib`: o runtime Ada do GNAT é ligado ao
   executável (408.808 bytes na máquina de desenvolvimento), de modo que ele
   não precisa das bibliotecas do compilador para executar. Compare com o
   [COBOL](../../cobol/cli/), que carrega a `libcob` em tempo de execução.
7. **Experimente:** em `src/hello.adb`, troque `Put_Line` por `Put_Lin` e
   execute `./build.sh`. O GNAT para com `"Put_Lin" not declared in
   "Text_IO"` e até sugere `possible misspelling of "Put_Line"`. Restaure o
   nome e compile novamente.

**As opções do compilador.** O `alire.toml` pede `ada_version = "Ada2022"`,
que se torna a opção `-gnat2022` do GNAT no arquivo gerado
`config/hello_config.gpr`. O perfil de desenvolvimento padrão do Alire
também adiciona todos os avisos (`-gnatwa`), verificações de validade
(`-gnatVa`) e verificações de estilo (`-gnaty...`: recuo de 3, capitalização
das palavras-chave, ...). É por isso que o `hello.adb` tem recuo de 3
espaços: com recuo de 2 em `Put_Line`, a compilação imprime
`(style) bad indentation` (um aviso; a compilação continua com sucesso).

## Por que esta toolchain
- **O GNAT é o compilador Ada livre e mantido.** Ele faz parte do GCC: "The
  GNU Compiler Collection includes front ends for C, C++, Objective-C,
  Objective-C++, Fortran, Ada, Go, D, Modula-2" [2] (tradução livre: "A GNU
  Compiler Collection inclui front-ends para C, C++, Objective-C,
  Objective-C++, Fortran, Ada, Go, D, Modula-2"). A AdaCore, que o mantém,
  "was born following a 16-year gestation at New York University" [10]
  (tradução livre: "nasceu após uma gestação de 16 anos na Universidade de
  Nova York").
- **O Alire é a forma recomendada de obtê-lo.** O site da comunidade
  ada-lang.io diz que o Alire é "by far the easiest way to get hold of an
  Ada toolchain" [4] (tradução livre: "de longe, a forma mais fácil de obter
  uma toolchain Ada"), e seu guia de primeiros passos usa `alr toolchain
  --select` para escolher `gnat_native` e `gprbuild` [4]. O Homebrew não tem
  fórmula do Alire (verificado em 2026-11-01), de modo que se usa o arquivo
  oficial da versão [11].
- **Ada 2022, a edição atual.** Este repositório adota Ada 2012/2022. O
  padrão atual "was published as ISO/IEC 8652:2023 in May 2023" e "replaces
  the edition of 2012" [1] (tradução livre: "foi publicado como
  ISO/IEC 8652:2023 em maio de 2023" e "substitui a edição de 2012").
  Nada em um Hello World difere entre as duas edições. Ele *não* é, porém,
  Ada 83 válido: compilado com `-gnat83`, o GNAT informa `(Ada 83) child
  units not allowed` para `Ada.Text_IO`. No Ada 83, o pacote se chamava
  `Text_IO`. O padrão atual ainda aceita o nome antigo por meio de uma
  renomeação, `package Text_IO renames Ada.Text_IO;`, listada no Anexo J,
  "Obsolescent Features" [13].
- **Contexto da época.** O Ada foi projetado para o Departamento de Defesa
  dos EUA no final da década de 1970 (consulte o
  [README da linguagem](../README.md#history)). O GNAT é um compilador
  mantido que ainda aceita as edições antigas (o GNAT tem os modos
  `-gnat83`, `-gnat95`, `-gnat2005`, `-gnat2012` e `-gnat2022` [12]).

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | Alire 2.1.1 (`alr-2.1.1-bin-x86_64-macos.zip`), GNAT 16.2.0, GPRbuild 26.0.1. A ligação usa as Command Line Tools da Apple. |
| macOS Apple Silicon | ⚠️ não verificado | O `install.sh` escolhe `alr-2.1.1-bin-aarch64-macos.zip` [11]. Mesmos comandos. |
| Linux (x86_64 / aarch64) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` baixa `alr-2.1.1-bin-x86_64-linux.zip` das versões do Alire, extrai o `alr` em `~/.local/bin` e executa `alr -n toolchain --select` quando nenhuma toolchain padrão está definida. Ele exige `curl`, `unzip` e `~/.local/bin` no PATH. O aarch64 (`alr-2.1.1-bin-aarch64-linux.zip`) e o AppImage continuam não verificados [11]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` baixa `alr-2.1.1-bin-x86_64-windows.zip` [11], confere o SHA-256, extrai-o com o PowerShell, copia o `alr.exe` para `~/.local/bin` e executa `alr -n toolchain --select` quando nenhuma toolchain padrão está definida. O instalador `.exe` não é usado. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello is machine code; the operating system runs it directly.
Hello, World!
```
O próprio programa imprime apenas a última linha; as demais linhas vêm do
`run.sh`.

## Fontes
1. Ada Reference Manual, 2022 Edition: Foreword. Ada Resource Association / ISO/IEC JTC1/SC22/WG9. <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-0-1.html> (acessado em 2026-11-01)
2. GCC, the GNU Compiler Collection (home page). Free Software Foundation. <https://gcc.gnu.org/> (acessado em 2026-11-01)
3. Alire documentation (installation, getting started, toolchains). Alire project. <https://alire.ada.dev/docs/> (acessado em 2026-11-01)
4. Getting started: Installation. ada-lang.io. <https://ada-lang.io/docs/learn/getting-started/installation> (acessado em 2026-11-01)
5. GPRbuild and GPR Companion Tools User's Guide: GNAT Project Manager. AdaCore. <https://docs.adacore.com/gprbuild-docs/html/gprbuild_ug/gnat_project_manager.html> (acessado em 2026-11-01)
6. GNAT User's Guide: The GNAT Compilation Model (File Naming Rules). AdaCore. <https://docs.adacore.com/gnat_ugn-docs/html/gnat_ugn/gnat_ugn/the_gnat_compilation_model.html> (acessado em 2026-11-01)
7. Introduction to Ada: Imperative Language. AdaCore (learn.adacore.com). <https://learn.adacore.com/courses/intro-to-ada/chapters/imperative_language.html> (acessado em 2026-11-01)
8. Ada Reference Manual, 2022 Edition: 10.2 Program Execution. <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-10-2.html> (acessado em 2026-11-01)
9. Ada Reference Manual, 2022 Edition: A.10.7 Input-Output of Characters and Strings. <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-A-10-7.html> (acessado em 2026-11-01)
10. 20 Years On... AdaCore blog. <https://www.adacore.com/blog/20-years-on> (acessado em 2026-11-01)
11. Alire releases, v2.1.1 (2026-05-29). GitHub, `alire-project/alire`. <https://github.com/alire-project/alire/releases/tag/v2.1.1> (acessado em 2026-11-01)
12. GNAT User's Guide: Building Executable Programs with GNAT (compiler switches -gnat83 ... -gnat2022; Binding with `gnatbind`). AdaCore. <https://docs.adacore.com/gnat_ugn-docs/html/gnat_ugn/gnat_ugn/building_executable_programs_with_gnat.html> (acessado em 2026-11-01)
13. Ada Reference Manual, 2022 Edition: Annex J Obsolescent Features, "J.1 Renamings of Library Units". <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-J-1.html> (acessado em 2026-11-01)
