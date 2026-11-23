---
source: languages/elixir/cli/README.md
source_sha: c84dff188fd6112b718cd9f17e06ab7674c8f7fd
---
# Elixir · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Elixir](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É um único arquivo, [`hello.exs`](hello.exs), com uma chamada de
função, executado pelo comando `elixir`. O Elixir é "a dynamic, functional
language designed for building scalable and maintainable applications" [1]
(tradução livre: "uma linguagem dinâmica e funcional projetada para construir
aplicações escaláveis e de fácil manutenção"). Ele é executado na máquina
virtual do Erlang (a BEAM), a mesma que executa a versão em
[Erlang](../../erlang/cli/) deste programa.

Como na [versão Python cli](../../python/cli/), não há `build.sh`: o `elixir`
compila o script em memória a cada vez que é iniciado.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Elixir (`elixir`) | 1.20.5 (`elixir` 1.20.5 do Homebrew) | compila o `hello.exs` em memória e o executa |
| Erlang/OTP | 29.1.2 (`erlang` 29.1.2 do Homebrew, instalado como dependência) | a máquina virtual e o runtime em que o Elixir é executado |

A página de instalação do Elixir diz que "Elixir v1.20.5 requires Erlang 27.0
or later" [2] (tradução livre: "O Elixir v1.20.5 requer o Erlang 27.0 ou
posterior"). O programa usa apenas `IO.puts/1`, que faz parte da biblioteca
padrão do Elixir, de modo que outras versões atuais devem funcionar. Apenas a
1.20.5 foi testada.

Em Macs Intel, o Homebrew não tem pacote pré-compilado (bottle) para o
`elixir` nem para o `erlang`: as páginas das fórmulas listam bottles apenas
para o macOS em Apple Silicon e para o Linux [3][4]. Assim, `brew install
elixir` compila o Erlang e o Elixir a partir do código-fonte. Na máquina de
teste (2026-11-01), o Erlang levou cerca de 15 minutos, mais cerca de 7
minutos para o `wxWidgets`, uma dependência que o Homebrew compila para o
Erlang, e o Elixir levou 1 minuto e 41 segundos. Em Apple Silicon e no Linux,
o mesmo comando instala bottles.

## Início rápido
```sh
./install.sh   # check / install Elixir (asks before installing)
./run.sh       # run it
```
Não há `build.sh` (veja [Por que não há etapa de build](#por-que-não-há-etapa-de-build)).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Executa `elixir --version`. Se ele estiver faltando, oferece `brew install elixir` (macOS), os comandos `apt` da página de instalação (Ubuntu) ou mostra o comando `choco install elixir` (Windows) [2], e só executa uma instalação se você responder `y`. | O código Elixir precisa do comando Elixir e do Erlang/OTP para ser executado. A fórmula do Homebrew instala os dois. |
| `run.sh` | Executa `elixir hello.exs`. `--verify` faz o mesmo (um programa CLI termina por conta própria). | `elixir` seguido de um nome de arquivo executa esse arquivo como script: a linha de uso impressa por `elixir --help` é `elixir [options] [.exs file] [data]`. |

## Estrutura de pastas
```text
cli/
├── README.md     this file
├── install.sh    checks / installs Elixir
├── run.sh        runs elixir hello.exs
└── hello.exs     the program (one function call, teaching comments)
```
- Um arquivo `.exs` é um programa completo. O guia do Elixir diz que "`.ex`
  files are meant to be compiled while `.exs` files are used for scripting"
  (tradução livre: "os arquivos `.ex` são destinados a ser compilados, enquanto
  os arquivos `.exs` são usados para scripts"), e que o Elixir "treats both
  files exactly the same way, the only difference is in intention" [5]
  (tradução livre: "trata os dois arquivos exatamente da mesma maneira, a
  única diferença está na intenção").
- Nada é gravado em disco, de modo que nada precisa ser ignorado pelo Git.

## Passo a passo
Abra o [`hello.exs`](hello.exs) ao lado desta lista.

1. **Comentários** começam com `#` e vão até o fim da linha, como em Python e
   Ruby.
2. **`IO.puts("Hello, World!")`** é o programa inteiro. `IO` é um *módulo*,
   um grupo nomeado de funções, e `puts` é uma função dele. O ponto seleciona
   a função do módulo. O Elixir não tem objetos aqui: `IO.puts` é uma chamada
   de função simples. Ela grava seu argumento na saída padrão e acrescenta uma
   quebra de linha.
3. **A string** `"Hello, World!"` está entre aspas duplas. Em Elixir, "A
   string is a UTF-8 encoded binary" [6] (tradução livre: "Uma string é um
   binário codificado em UTF-8").
4. **Os parênteses** em uma chamada com argumentos são opcionais em Elixir,
   de modo que `IO.puts "Hello, World!"` também é válido [7]. Os parênteses
   são obrigatórios em chamadas sem argumentos [7].
5. **Sem `main`.** O arquivo é executado de cima para baixo, como um script
   Python. Compare com a versão [Haskell](../../haskell/cli/), em que `main` é
   um valor nomeado, e com a versão [C](../../c/cli/), em que `main` é a
   função que o runtime chama.
6. **A BEAM.** O comando `elixir` inicia a máquina virtual do Erlang, compila
   o script em bytecode na memória e o executa. O bytecode que o `elixirc`
   grava em disco fica em arquivos `.beam` [5].

**Experimente** (a partir desta pasta, em qualquer shell):
```sh
elixir -e '"Hello, World!" |> String.upcase() |> IO.puts()'
elixir -e 'IO.puts(:binary.first("Hello"))'
```
A primeira linha usa o operador pipe `|>`. Sua documentação diz que ele
"introduces the expression on the left-hand side as the first argument to the
function call on the right-hand side" [8] (tradução livre: "introduz a
expressão do lado esquerdo como o primeiro argumento da chamada de função do
lado direito"): ela imprime `HELLO, WORLD!`. A segunda linha chama um módulo
do Erlang, `:binary`, a partir do Elixir. O nome de um módulo do Erlang é um
átomo, de modo que começa com dois-pontos [9]. Ela imprime `72`, o valor em
bytes de `H`.

### Por que não há etapa de build
O guia do Elixir mostra um script executado com `elixir` e explica: "Because
we used `elixir` instead of `elixirc`, the module was compiled and loaded into
memory, but no `.beam` file was written to disk" [5] (tradução livre: "Como
usamos `elixir` em vez de `elixirc`, o módulo foi compilado e carregado na
memória, mas nenhum arquivo `.beam` foi gravado em disco"). `elixirc` é o
comando que compila arquivos em arquivos `.beam`. A versão [web](../web/) é um
projeto Mix: o Mix a compila e guarda o resultado em `_build/`.

## Por que esta toolchain
- **O comando `elixir`** é a forma que a equipe do Elixir documenta para
  executar um script [5]. Ele acompanha a linguagem e não precisa de nada além
  do Erlang/OTP [2].
- **O Homebrew** é o gerenciador de pacotes que este repositório usa no macOS.
  Sua fórmula `elixir` estava na 1.20.5 em 2026-11-04 [3], a versão que a
  página de releases do GitHub lista como a mais recente (2026-10-29) [10]. A
  página de instalação da equipe do Elixir lista `brew install elixir` para o
  macOS [2].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Elixir 1.20.5 sobre Erlang/OTP 29.1.2 do Homebrew, compilados a partir do código-fonte (sem bottle para Intel) [3][4]. |
| macOS Apple Silicon | ⚠️ não verificado | `brew install elixir` instala bottles pré-compilados [3][4]. Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` não usa o apt, porque o pacote do Ubuntu tem o Elixir 1.18 e o `mix.exs` exige a 1.20 ou posterior. Se o `elixir` não existe, ele baixa o script de instalação oficial do elixir-lang.org, confere seu checksum SHA-256 e o executa. O script coloca o Elixir 1.20.5 e o Erlang/OTP 29.1 em `~/.elixir-install/installs` sem sudo [2]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. Se o `elixir` não existe, o `install.sh` executa o script de instalação oficial do elixir-lang.org depois de conferir seu checksum SHA-256, como no Linux [2]. O Git Bash não tem o `unzip`; por isso o `install.sh` coloca no PATH, só para si, um `unzip` simples que chama o 7-Zip. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: elixir compiles hello.exs in memory, runs it on the BEAM, and exits
         when the script ends.
Hello, World!
```
O programa em si imprime apenas a última linha; as demais linhas vêm do
`run.sh`. Para ver os bytes exatos:
```text
$ elixir hello.exs | od -c
0000000    H   e   l   l   o   ,       W   o   r   l   d   !  \n
0000016
```

## Fontes
1. Elixir v1.0 released. José Valim, elixir-lang.org, 2014-09-18. <https://elixir-lang.org/blog/2014/09/18/elixir-v1-0-0-released/> (acessado em 2026-11-04)
2. Install Elixir. The Elixir team, elixir-lang.org. <https://elixir-lang.org/install/> (acessado em 2026-11-04)
3. `elixir` formula. Homebrew. <https://formulae.brew.sh/formula/elixir> (acessado em 2026-11-04)
4. `erlang` formula. Homebrew. <https://formulae.brew.sh/formula/erlang> (acessado em 2026-11-04)
5. Modules and functions (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/1.18.1/modules-and-functions.html> (acessado em 2026-11-04)
6. Binaries, strings, and charlists (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/binaries-strings-and-charlists.html> (acessado em 2026-11-04)
7. Syntax reference. Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/syntax-reference.html> (acessado em 2026-11-04)
8. `Kernel.|>/2`. Elixir v1.20.5 documentation, hexdocs.pm. <https://elixir.hexdocs.pm/Kernel.html#%7C%3E/2> (acessado em 2026-11-04)
9. Erlang libraries (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/erlang-libraries.html> (acessado em 2026-11-04)
10. Releases. elixir-lang/elixir, GitHub. <https://github.com/elixir-lang/elixir/releases> (acessado em 2026-11-04)
