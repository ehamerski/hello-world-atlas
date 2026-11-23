---
source: languages/erlang/cli/README.md
source_sha: 55085ce9b2033d28f8878c385866628102aef410
---
# Erlang · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Erlang](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É um único arquivo, [`hello.erl`](hello.erl), com uma chamada de
função, executado pelo comando `escript`. O Erlang é "a programming language
used to build massively scalable soft real-time systems" "with requirements
on high availability" [1] (tradução livre: "uma linguagem de programação
usada para construir sistemas de tempo real brando massivamente escaláveis"
"com requisitos de alta disponibilidade"). Ele roda na BEAM, a máquina
virtual do Erlang, a mesma que executa a versão [Elixir](../../elixir/cli/)
deste programa.

Um *escript* é um programa Erlang que é executado como um script de shell: a
documentação do Erlang diz que o `escript` "provides support for running
short Erlang programs without having to compile them first" [2] (tradução
livre: "oferece suporte à execução de programas Erlang curtos sem precisar
compilá-los antes"). Como na [versão Python `cli`](../../python/cli/), não
há `build.sh`. As versões [desktop](../desktop/) e [web](../web/) são
módulos compilados e têm um.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Erlang/OTP (`escript`, `erl`, `erlc`) | 29.1.2 (`erlang` 29.1.2 do Homebrew) | o `escript` compila o `hello.erl` na memória e o executa na BEAM |

OTP significa Open Telecom Platform. É um "set of Erlang libraries and
design principles providing middle-ware to develop these systems" [1]
(tradução livre: "conjunto de bibliotecas Erlang e princípios de projeto que
oferece middleware para desenvolver esses sistemas"), e também é o nome da
distribuição de software do Erlang [3]. O programa usa apenas
`io:format/1`, da biblioteca padrão, de modo que outras versões atuais
devem funcionar. Somente a 29.1.2 foi testada.

Em Macs Intel, o Homebrew não tem pacote pré-compilado (bottle) para o
`erlang`: a página da fórmula lista bottles apenas para macOS em Apple
Silicon e para Linux [4]. Assim, o `brew install erlang` compila o Erlang a
partir do código-fonte. Na máquina de teste (2026-11-01), o Erlang levou
cerca de 15 minutos, mais cerca de 7 minutos para o `wxWidgets`, uma
dependência que o Homebrew compila para o Erlang [4]. Em Apple Silicon e
Linux, o mesmo comando instala um bottle.

## Início rápido
```sh
./install.sh   # check / install Erlang/OTP (asks before installing)
./run.sh       # run it
```
Não há `build.sh` (veja [Por que não há etapa de build](#por-que-não-há-etapa-de-build)).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica se `erl`, `erlc` e `escript` estão no `PATH`. Se um deles estiver faltando, oferece `brew install erlang` (macOS), `apt-get install erlang` (Debian e Ubuntu) ou explica como obter o instalador para Windows [5], e só executa uma instalação se você responder `y`. | O código Erlang precisa da BEAM e do `escript`, que vêm em um único pacote. |
| `run.sh` | Executa `escript hello.erl`. `--verify` faz o mesmo (um programa CLI termina por conta própria). | O `escript` seguido de um nome de arquivo compila esse arquivo e chama sua função `main/1`. |

## Estrutura de pastas
```text
cli/
├── README.md     this file
├── install.sh    checks / installs Erlang/OTP
├── run.sh        runs escript hello.erl
└── hello.erl     the program (one function call, teaching comments)
```
- Um arquivo `.erl` é um programa completo. Nada é gravado em disco, de modo
  que nada precisa ser ignorado pelo Git.
- As pastas [desktop](../desktop/) e [web](../web/) têm uma pasta `ebin/`
  para o código compilado, que o `.gitignore` mantém fora do Git.

## Passo a passo
Abra o [`hello.erl`](hello.erl) ao lado desta lista.

1. **A linha do interpretador.** `#!/usr/bin/env escript` é a primeira
   linha. A documentação a chama de "the interpreter line, which invokes
   `escript`" [2] (tradução livre: "a linha do interpretador, que invoca o
   `escript`"). Quando o arquivo é executado como `./hello.erl`, o sistema o
   entrega ao `escript`. Este repositório o executa como `escript
   hello.erl`, de modo que a linha é apenas uma convenção.
2. **Os comentários** começam com `%`. Um comentário em uma linha própria
   costuma ser escrito com `%%`.
3. **`-export([main/1]).`** lista as funções que outro código pode chamar.
   `main/1` significa a função de nome `main` que recebe um argumento. O
   número faz parte do nome, de modo que `main/1` e `main/2` são funções
   diferentes. Em um escript, "Both the module declaration and the export
   declaration of the `main/1` function are optional" [2] (tradução livre:
   "Tanto a declaração do módulo quanto a declaração de exportação da função
   `main/1` são opcionais"). O arquivo mantém a exportação para mostrar como
   um módulo é escrito.
4. **`main(_Args) ->`** é o ponto de entrada: "the `main/1` function is
   called with a list of strings representing the arguments specified to the
   script" [2] (tradução livre: "a função `main/1` é chamada com uma lista
   de strings que representa os argumentos especificados para o script"). Um
   nome que começa com letra maiúscula é uma variável, e "Variables start
   with an uppercase letter or underscore" [6] (tradução livre: "Variáveis
   começam com letra maiúscula ou sublinhado"). O sublinhado em `_Args`
   indica ao compilador e ao leitor que a variável não é usada. O `->`
   separa o cabeçalho da função de seu corpo, e o `.` final encerra a
   função.
5. **`io:format("Hello, World!~n").`** é o programa inteiro. `io` é um
   módulo, um grupo nomeado de funções, e `format` é uma função dele. Os dois
   pontos selecionam a função do módulo. `format/1` é "Equivalent to
   format(Format, [])" [7] (tradução livre: "Equivalente a format(Format,
   [])"). Em uma string de formato, "`~n`" "Writes a new line" [7] (tradução
   livre: "Escreve uma nova linha"). O `print` do Python e o `println` do
   Java acrescentam a quebra de linha por conta própria. O Erlang não o faz,
   de modo que o `~n` é obrigatório.
6. **Strings são listas.** `"Hello, World!"` está entre aspas duplas, mas
   "Strings are enclosed in double quotes ("), but are not a data type in
   Erlang" (tradução livre: "Strings são delimitadas por aspas duplas ("),
   mas não são um tipo de dado no Erlang"); uma string `"hello"` é uma
   abreviação de uma lista de códigos de caracteres [8].
7. **Sem atribuição.** "Erlang uses single assignment, that is, a variable
   can only be bound once" [6] (tradução livre: "O Erlang usa atribuição
   única, isto é, uma variável só pode ser vinculada uma vez"). O programa
   não tem nenhuma variável além da `_Args`, que não é usada.
8. **A BEAM.** O `escript` inicia a máquina virtual do Erlang, compila o
   arquivo e o executa. "By default, the script will be compiled by the
   Erlang compiler" [2] (tradução livre: "Por padrão, o script será
   compilado pelo compilador do Erlang"). Um escript mantém o código
   compilado na memória.

**Experimente** (a partir desta pasta, em qualquer shell):
```sh
erl -noshell -eval 'io:format("~s~n", [string:uppercase("Hello, World!")]), halt().'
erl -noshell -eval 'io:format("~w~n", [hd("Hello")]), halt().'
```
A primeira linha chama `string:uppercase/1` e imprime `HELLO, WORLD!`. A
segunda imprime `72`, o código de caractere de `H`, porque uma string é uma
lista de códigos de caracteres: o `~w` "Writes data with the standard
syntax" [7] (tradução livre: "Escreve dados com a sintaxe padrão"). O
`-noshell` "Starts an Erlang runtime system with no shell" [9] (tradução
livre: "Inicia um sistema de runtime do Erlang sem shell"), e o `halt()`
encerra a máquina virtual após a saída.

### Por que não há etapa de build
O `escript` compila o arquivo na memória a cada execução [2]. Um projeto
instalado ou compartilhado como código compilado mantém seus arquivos
`.beam` em uma pasta `ebin/` [10]. As versões [desktop](../desktop/) e
[web](../web/) fazem isso, e o `erlc` grava os arquivos, de modo que elas
têm um `build.sh`.

## Por que esta toolchain
- **O `escript`** é a forma que a documentação do Erlang descreve para
  executar um programa curto sem compilá-lo antes [2]. Ele acompanha o
  Erlang/OTP.
- **O Homebrew** é o gerenciador de pacotes que este repositório usa no
  macOS. Sua fórmula `erlang` estava na 29.1.2 em 2026-11-04 [4], a versão
  que a página de download do Erlang lista como a mais recente [5]. A página
  de download lista `brew install erlang` para macOS [5].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Erlang/OTP 29.1.2 do Homebrew, compilado a partir do código-fonte (sem bottle para Intel) [4]. |
| macOS Apple Silicon | ⚠️ não verificado | O `brew install erlang` instala um bottle pré-compilado [4]. Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `erlang` com o apt quando `erl`, `erlc` ou `escript` não existe [5]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não usa um gerenciador de pacotes. Se o Erlang/OTP não existe, ele baixa o zip oficial de 64 bits (`otp_win64_29.1.2.zip`), confere seu checksum SHA-256 e o extrai em `~/.local/otp-29.1.2` (com o 7-Zip quando o Git Bash não tem o `unzip`) [5]. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: escript compiles hello.erl in memory and calls main/1; there is no build step.
Hello, World!
```
O programa em si imprime apenas a última linha; as outras linhas vêm do
`run.sh`. Para ver os bytes exatos:
```text
$ escript hello.erl | od -c
0000000    H   e   l   l   o   ,       W   o   r   l   d   !  \n
0000016
```

## Fontes
1. Erlang/OTP home page. Ericsson AB, erlang.org. <https://www.erlang.org/> (acessado em 2026-11-04)
2. escript. Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/escript_cmd.html> (acessado em 2026-11-04)
3. A History of Erlang. Joe Armstrong, HOPL III, ACM, 2007. Author's copy. <https://lfe.io/papers/%5B2007%5D%20Armstrong%20-%20HOPL%20III%20A%20History%20of%20Erlang.pdf> (acessado em 2026-11-04)
4. `erlang` formula. Homebrew. <https://formulae.brew.sh/formula/erlang> (acessado em 2026-11-04)
5. Downloads. Ericsson AB, erlang.org. <https://www.erlang.org/downloads> (acessado em 2026-11-04)
6. Expressions (variables, single assignment). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/expressions.html> (acessado em 2026-11-04)
7. `io` (`format/1`, control sequences `~n` and `~w`). Erlang/OTP documentation, stdlib. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/stdlib/io.html> (acessado em 2026-11-04)
8. Data types (atom, list, string). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/data_types.html> (acessado em 2026-11-04)
9. `erl` (`-noshell`, `-pa`, `-s`, `+B`). Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/erl_cmd.html> (acessado em 2026-11-04)
10. Applications (directory structure, `ebin`). Erlang/OTP documentation, Design Principles. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/applications.html> (acessado em 2026-11-04)
