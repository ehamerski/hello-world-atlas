---
source: languages/lua/cli/README.md
source_sha: 395dc3d1e972b78f308fcbafa05b5535fccfa767
---
# Lua · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Lua](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e uma
quebra de linha, e então termina. O programa inteiro é uma linha de Lua:
`print("Hello, World!")`.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Lua (`lua`; `lua5.4` no Debian e no Ubuntu) | 5.5.1 (fórmula `lua` do Homebrew) | o interpretador que executa o `hello.lua` |

Qualquer versão 5.x do Lua funciona, porque este programa usa apenas `print`.
O Lua 5.5 é a versão atual, e a 5.5.1 é o seu release atual [1]. A fórmula
`lua` do Homebrew a instala [2].

## Início rápido
```sh
./install.sh   # check / install Lua (asks before installing)
./run.sh       # run it
```
Não há `build.sh`. O Lua é executado a partir do código-fonte, de modo que o
arquivo-fonte é executado diretamente (veja [Por que não há etapa de build](#por-que-não-há-etapa-de-build)).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica se o interpretador (`lua`, ou `lua5.4` no Linux) está no `PATH`. Se estiver faltando, mostra o comando de instalação para o sistema operacional (Homebrew ou apt) e só o executa se você responder `y`. | O programa não pode ser executado sem o interpretador. |
| `run.sh` | Executa `lua hello.lua`. `--verify` faz o mesmo, porque um programa cli já termina por conta própria. | Um único comando para executar o programa, com uma explicação do que acontece. |

Os dois scripts aceitam `LUA=<comando>` para usar outro interpretador, por
exemplo `LUA=lua5.4 ./run.sh`.

## Estrutura de pastas
```text
cli/
├── README.md      this file
├── install.sh     checks / installs Lua
├── run.sh         runs the program
└── hello.lua      the program (one line of code plus teaching comments)
```
Um único arquivo `.lua` é um programa Lua completo. O manual de referência
chama de *chunk* uma unidade de código Lua e diz que "a chunk can be stored
in a file or in a string inside the host program" [3] (tradução livre: "um
chunk pode ser armazenado em um arquivo ou em uma string dentro do programa
hospedeiro"). O programa `lua` é o programa hospedeiro "stand-alone"
(autônomo) que executa um arquivo [3]. Um projeto só precisa de mais
estrutura quando usa módulos, como a implementação [web](../web/README.md)
faz com o LuaRocks.

## Passo a passo
Abra o [`hello.lua`](hello.lua) ao lado desta lista.

1. **Comentários.** "A comment starts with a double hyphen (`--`) anywhere
   outside a string" [3] (tradução livre: "Um comentário começa com um hífen
   duplo (`--`) em qualquer lugar fora de uma string"). O interpretador os
   ignora. O Python e o Perl usam `#`, e o C, o Java e o Go usam `//`.
2. **Sem ponto de entrada.** O Lua executa um arquivo de cima para baixo. A
   primeira linha de código é onde o programa começa. C, Java, C# e Go
   precisam, em vez disso, de uma função chamada `main` (em Java e C#, ela
   fica dentro de uma classe).
3. **Sem import.** `print` pertence à biblioteca base, que todo programa Lua
   tem [3]. Em C, é preciso escrever antes `#include <stdio.h>` para usar
   `printf`.
4. **A chamada.** `print("Hello, World!")` "prints their values to stdout"
   [3] (tradução livre: "imprime seus valores na saída padrão"). As strings
   podem usar aspas duplas ou simples: `'Hello, World!'` funciona do mesmo
   modo [3]. O manual acrescenta que `print` "is not intended for
   formatted output, but only as a quick way to show a value" [3] (tradução
   livre: "não se destina à saída formatada, mas apenas a uma forma rápida de
   mostrar um valor").
5. **Sem chaves, e o ponto e vírgula é opcional.** Uma linha encerra a
   instrução. O manual diz que o Lua permite separar instruções com ponto e
   vírgula [3], mas este programa não tem nenhum.

### Por que não há etapa de build
O Lua é "a powerful, efficient, lightweight, embeddable scripting language"
[4] (tradução livre: "uma linguagem de script poderosa, eficiente, leve e
embutível"). O manual explica como um chunk é executado: "Lua first loads it,
precompiling the chunk's code into instructions for a virtual machine, and
then Lua executes the compiled code with an interpreter for the virtual
machine" [3] (tradução livre: "o Lua primeiro o carrega, pré-compilando o
código do chunk em instruções para uma máquina virtual, e depois executa o
código compilado com um interpretador para a máquina virtual"). Isso acontece
na memória, a cada execução do programa. Uma linguagem compilada como o C
precisa de um `build.sh` separado que transforme o código-fonte em um
executável antes de o `run.sh` poder iniciá-lo. O Lua também pode salvar
chunks pré-compilados com o programa `luac` [3], mas este programa não
precisa deles.

## Por que esta toolchain
- **A implementação de referência.** "The Lua distribution includes a host
  program called `lua`, which uses the Lua library to offer a complete,
  standalone Lua interpreter" [3] (tradução livre: "A distribuição do Lua
  inclui um programa hospedeiro chamado `lua`, que usa a biblioteca do Lua
  para oferecer um interpretador Lua completo e independente"). A
  distribuição é "implemented in pure ISO C" [1] (tradução livre:
  "implementada em ISO C puro"). A linguagem é projetada, implementada e
  mantida na PUC-Rio [4].
- **Lua 5.5.1.** O Lua 5.5 foi lançado em 2025-12-22, e a 5.5.1 é o seu
  release atual, lançado em 2026-08-03 [5]. A fórmula `lua` do Homebrew
  empacota a 5.5.1 [2].
- **Homebrew** (macOS) e **apt** (Debian e Ubuntu) são os gerenciadores de
  pacotes padrão nesses sistemas. O Lua.org distribui o código-fonte e lista
  separadamente os binários de terceiros [1].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | `lua` 5.5.1 do Homebrew. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmo comando do Intel (`brew install lua`). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `lua5.4` com o apt quando ele não existe [6]. Os scripts chamam o `lua5.4`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O Lua.org distribui apenas o código-fonte [1]. Se o `lua` não existe, o `install.sh` instala o pacote Lua do MSYS2 (Lua 5.5) com o `pacman` (o MSYS2 já vem instalado em `C:\msys64`) e adiciona `C:\msys64\ucrt64\bin` ao final do PATH. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ lua hello.lua
Hello, World!
```
O `./run.sh` imprime primeiro a sua explicação (linhas que começam com `==>` e
`WHY:`) e depois a mesma linha.

## Fontes
1. Download. Lua.org, PUC-Rio. <https://www.lua.org/download.html> (acessado em 2026-11-04)
2. `lua` formula. Homebrew. <https://formulae.brew.sh/formula/lua> (acessado em 2026-11-04)
3. Lua 5.5 Reference Manual. Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes. <https://www.lua.org/manual/5.5/manual.html> (acessado em 2026-11-04)
4. About Lua. Lua.org, PUC-Rio. <https://www.lua.org/about.html> (acessado em 2026-11-04)
5. Version history. Lua.org, PUC-Rio. <https://www.lua.org/versions.html> (acessado em 2026-11-04)
6. `lua5.4` package (Debian stable). Debian. <https://packages.debian.org/stable/lua5.4> (acessado em 2026-11-04)
