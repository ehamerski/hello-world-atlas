---
source: languages/perl/cli/README.md
source_sha: c8f36d4b60bf9cd6dd80b9bb0139ad909455bb70
---
# Perl · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Perl](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e uma
quebra de linha, e então termina. O programa é uma instrução de Perl, mais as
duas linhas de "rede de segurança" que o próprio tutorial do Perl recomenda
no início de todo programa [1].

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Perl 5 (`perl`) | 5.34.1 (o `/usr/bin/perl` que acompanha o macOS) | o interpretador que executa o `hello.pl` |

O programa usa apenas `print` e dois pragmas, de modo que qualquer Perl 5
deve executá-lo (verificado aqui somente com o 5.34.1). A página de download
do perl.org diz: "Mac OS X already has Perl installed" (tradução livre: "O
Mac OS X já tem o Perl instalado") e, para outros sistemas do tipo Unix, "You
may already have perl installed" (tradução livre: "Talvez você já tenha o
perl instalado") [2]. O Windows "does not have Perl installed by
default" [2] (tradução livre: "não tem o Perl instalado por padrão").

## Início rápido
```sh
./install.sh   # check / install Perl (asks before installing)
./run.sh       # run it
```
Não há `build.sh`. O Perl é executado diretamente a partir do arquivo de
código-fonte (veja [Por que não há etapa de compilação](#por-que-não-há-etapa-de-compilação)).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica se o `perl` está no `PATH` e imprime sua versão. Se estiver faltando, mostra o comando de instalação para o seu sistema operacional (Homebrew, apt ou Strawberry Perl no Windows) e só o executa se você responder `y`. | O programa não pode ser executado sem o interpretador. No macOS, normalmente não há nada a instalar [2]. |
| `run.sh` | Executa `perl hello.pl`. `--verify` faz o mesmo, porque um programa cli já termina por conta própria. | Um único comando para executar o programa, com uma explicação do que acontece. |

## Estrutura de pastas
```text
cli/
├── README.md      this file
├── install.sh     checks / installs the Perl interpreter
├── run.sh         runs the program
└── hello.pl       the program
```
Um programa Perl é um arquivo de texto simples, normalmente com a extensão
`.pl`. O tutorial mostra como executá-lo: `perl progname.pl` [1]. Um único
script não precisa de outra estrutura. Programas com dependências usam uma
pasta de bibliotecas local ao projeto, como em [../web](../web/README.md).

## Passo a passo
Abra o [`hello.pl`](hello.pl) ao lado desta lista.

1. **`use strict;`** ativa uma restrição: ele "disables certain Perl
   expressions that could behave unexpectedly or are difficult to debug,
   turning them into errors" [3] (tradução livre: "desativa certas
   expressões do Perl que poderiam se comportar de modo inesperado ou são
   difíceis de depurar, transformando-as em erros").
2. **`use warnings;`** pede ao Perl que imprima uma mensagem quando o código
   parece um erro. O tutorial diz "Perl by default is very forgiving"
   (tradução livre: "O Perl, por padrão, é muito tolerante") e recomenda
   começar "every program" (tradução livre: "todo programa") com as duas
   linhas, porque "they check different things so you need both" [1][4]
   (tradução livre: "elas verificam coisas diferentes, então você precisa
   das duas").
3. **`print "Hello, World!\n";`** escreve o texto na saída padrão. O `print`
   "prints a string or a list of strings" [5] (tradução livre: "imprime uma
   string ou uma lista de strings"). Ele só acrescenta uma quebra de linha se
   a variável especial `$\` estiver definida, e por padrão ela não está [5],
   de modo que o programa escreve o `\n` por conta própria, como o `printf`
   do C. O `print()` do Python e o `puts` do Ruby acrescentam a quebra de
   linha automaticamente.
4. **O ponto e vírgula** encerra a instrução, como em C e Java. O Perl não
   tem função `main`: as instruções do arquivo são executadas em ordem.
   Compare com as outras linguagens em [../../../docs/comparisons.md](../../../docs/comparisons.md).

### Por que não há etapa de compilação
O `perl` lê o código-fonte e o executa. O Perl faz "compile the entire
program to an internal form" (tradução livre: "compila o programa inteiro
para uma forma interna") primeiro e, se houver erros de compilação,
"execution of the program is not attempted" [6] (tradução livre: "a execução
do programa não é tentada"). Isso acontece dentro de cada execução, na
memória, de modo que nunca se executa um comando de compilação separado. Uma
linguagem compilada como C precisa de um `build.sh` separado, que produz um
executável antes de o `run.sh` poder iniciá-lo.

## Por que esta toolchain
- **O `perl` que já está no seu computador.** O Perl do sistema do macOS
  (5.34.1 na máquina de desenvolvimento) não precisa de instalação [2]. Isso
  mantém o primeiro programa livre de downloads extras. A versão
  [web](../web/README.md) também é executada nele.
- O **Homebrew** (`brew install perl`) instala um Perl atual (5.44.0 na
  fórmula consultada em 2026-11-04) [7] e o **apt** (`sudo apt-get install perl`)
  instala o do Debian (5.40.1 no Debian 13 "trixie") [8]. O perl.org
  recomenda o **Strawberry Perl** para o Windows [2].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | O `/usr/bin/perl` do sistema, versão 5.34.1 (`perl -v`). |
| macOS Apple Silicon | ⚠️ não verificado | O mesmo: o macOS inclui o Perl [2]. `brew install perl` para uma versão mais nova [7]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `perl` com o apt quando ele não existe [8]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O Git Bash vem com um Perl, portanto o `install.sh` o encontra. Se o `perl` não existe, ele imprime os passos do Strawberry Perl [2] e para. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ perl hello.pl
Hello, World!
```
O `./run.sh` imprime primeiro sua explicação (linhas que começam com `==>` e
`WHY:`) e depois a mesma linha.

## Fontes
1. perlintro: a brief introduction and overview of Perl. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/perlintro> (acessado em 2026-11-04)
2. Perl Download. perl.org. <https://www.perl.org/get.html> (acessado em 2026-11-04)
3. strict: Perl pragma to restrict unsafe constructs. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/strict> (acessado em 2026-11-04)
4. warnings: Perl pragma to control optional warnings. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/warnings> (acessado em 2026-11-04)
5. print. Perl 5 porters, perldoc.perl.org (perlfunc). <https://perldoc.perl.org/functions/print> (acessado em 2026-11-04)
6. perlrun: how to execute the Perl interpreter. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/perlrun> (acessado em 2026-11-04)
7. perl formula. Homebrew. <https://formulae.brew.sh/formula/perl> (acessado em 2026-11-04)
8. Package perl (trixie). Debian. <https://packages.debian.org/stable/perl> (acessado em 2026-11-04)
