---
source: languages/php/cli/README.md
source_sha: ad918ea03c30821a44054726ce5275c5a81a1b62
---
# PHP · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [PHP](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e uma
quebra de linha, e depois termina. O programa tem uma única instrução:
`echo "Hello, World!\n";`, após a tag de abertura `<?php` com que todo
arquivo PHP começa.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| PHP 8 (`php`) | 8.5.11 (`php` do Homebrew) | o interpretador que executa `hello.php` |

Qualquer versão suportada do PHP 8 funciona: este programa usa apenas
`echo`. Em 2026-10-31, as ramificações suportadas eram 8.2, 8.3, 8.4 e 8.5 [7].

Defina `PHP=/path/to/php` para usar outro interpretador, por exemplo uma
segunda versão do PHP.

## Início rápido
```sh
./install.sh   # check / install PHP (asks before installing)
./run.sh       # run it
```
Não há `build.sh`. O PHP é uma linguagem interpretada, portanto o arquivo de
código-fonte é executado diretamente (ver [Por que não há etapa de compilação](#por-que-não-há-etapa-de-compilação)).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica se `php` está no `PATH` e imprime sua versão. Se estiver ausente, mostra o comando de instalação para o sistema operacional do leitor (Homebrew, apt ou o download do ZIP no Windows) e só o executa se a resposta for `y`. | O programa não executa sem o interpretador. |
| `run.sh` | Executa `php hello.php`. `--verify` faz o mesmo, porque um programa cli termina por conta própria. | Um único comando para estudantes, com a explicação do que acontece. |

## Estrutura de pastas
```text
cli/
├── README.md      this file
├── install.sh     checks / installs PHP
├── run.sh         runs the program
└── hello.php      the program (one statement plus teaching comments)
```
Um único arquivo `.php` é um programa PHP completo. A primeira forma de usar
a linha de comando, segundo o manual, é "Tell PHP to execute a certain file"
(tradução livre: "Instruir o PHP a executar um determinado arquivo"), como
em `php my_script.php` [3]. Um projeto só precisa de um `composer.json` (e de
uma pasta `vendor/`) quando usa pacotes de terceiros: "Composer is a tool for
dependency management in PHP" [13] (tradução livre: "O Composer é uma
ferramenta para gerenciamento de dependências em PHP"). Este programa não usa
nenhum.

## Passo a passo
Abra [`hello.php`](hello.php) ao lado desta lista.

1. **A tag de abertura `<?php`.** "When PHP processes a file, it recognizes
   the opening and closing tags, `<?php` and `?>` to define the boundaries
   of PHP code execution" [1] (tradução livre: "Quando o PHP processa um
   arquivo, ele reconhece as tags de abertura e de fechamento, `<?php` e
   `?>`, para definir os limites da execução do código PHP"). O texto fora
   das tags é copiado para a saída sem alteração; é assim que o PHP mistura
   código ao HTML (ver a versão [web](../web/README.md)). Python, Java e Go
   não têm essa tag.
2. **Comentários.** `/* ... */` abrange várias linhas; `//` e `#` vão até o
   fim da linha. Observação: "The 'one-line' comment styles only comment
   to the end of the line or the current block of PHP code, whichever comes
   first" [4] (tradução livre: "Os estilos de comentário 'de uma linha'
   comentam apenas até o fim da linha ou do bloco atual de código PHP, o que
   ocorrer primeiro"); portanto, um `?>` dentro de um comentário `//`
   encerra o modo PHP. Por isso `hello.php` menciona a tag de fechamento
   somente dentro do bloco `/* */`.
3. **Nenhum ponto de entrada.** Como o Python, o PHP executa o arquivo de
   cima para baixo. C, Java, C# e Go exigem, em vez disso, uma função `main`.
4. **`echo`.** "`echo` is not a function but a language construct" [2]
   (tradução livre: "`echo` não é uma função, mas uma construção da
   linguagem"), portanto não precisa de parênteses. Ele "Outputs one or more
   expressions, with no additional newlines or spaces" [2] (tradução livre:
   "Envia uma ou mais expressões à saída, sem quebras de linha ou espaços
   adicionais"): diferentemente do `print()` do Python, a quebra de linha é
   escrita manualmente, como no `printf` do C.
5. **Aspas duplas e `\n`.** Em uma string entre aspas duplas, o PHP converte
   `\n` em um "linefeed (LF or 0x0A (10) in ASCII)" [5] (tradução livre:
   "avanço de linha (LF ou 0x0A (10) em ASCII)"). Em uma string entre aspas
   simples, "escape sequences for special characters will not be expanded"
   [5] (tradução livre: "sequências de escape para caracteres especiais não
   serão expandidas"), de modo que `'Hello, World!\n'` imprimiria uma barra
   invertida e um `n`.
6. **O ponto e vírgula** encerra a instrução, como em C e Java.
7. **Nenhuma tag de fechamento.** "If a file ends with PHP code, it is
   preferable to omit the PHP closing tag at the end of the file. This
   prevents accidental whitespace or new lines being added after the PHP
   closing tag" [1] (tradução livre: "Se um arquivo termina com código PHP, é
   preferível omitir a tag de fechamento do PHP no fim do arquivo. Isso
   evita que espaços em branco ou quebras de linha sejam acrescentados
   acidentalmente após a tag de fechamento do PHP").

Compare com a versão web em [../README.md](../README.md#comparing-the-categories).

### Por que não há etapa de compilação
`php hello.php` lê o código-fonte e o executa: "The PHP executable can be
used to run PHP scripts absolutely independent of the web server" [3]
(tradução livre: "O executável do PHP pode ser usado para executar scripts
PHP de forma totalmente independente do servidor web"). Internamente, o motor
ainda compila o script para bytecode antes de executá-lo; a extensão OPcache
existe para manter esse "precompiled script bytecode in shared memory,
thereby removing the need for PHP to load and parse scripts on each request"
[6] (tradução livre: "bytecode de script pré-compilado em memória
compartilhada, eliminando a necessidade de o PHP carregar e analisar os
scripts a cada requisição"). De qualquer forma, isso ocorre automaticamente.
Uma linguagem compilada como C precisa de um `build.sh` separado, que
transforma o código-fonte em um executável antes que `run.sh` possa iniciá-lo.

## Por que esta toolchain
- **O comando `php` (CLI SAPI)** é o interpretador oficial do PHP, de
  php.net, construído para a linha de comando: "The main focus of CLI SAPI is
  for developing shell applications with PHP" [12] (tradução livre: "O foco
  principal da CLI SAPI é o desenvolvimento de aplicações de shell com PHP").
  `php -v` imprime `(cli)` para indicar essa versão.
- **PHP 8.5** é a ramificação de lançamento mais recente. Foi lançada pela
  primeira vez em 2025-11-20, tem suporte ativo até 2027-12-31 e suporte de
  segurança até 2029-12-31 (php.net, consultado em 2026-10-31) [7]. A máquina
  de teste (macOS Intel) tem a 8.5.11; o `php` estável do Homebrew era a
  8.5.12 em 2026-10-31 [8]. `hello.php` também executa em versões mais
  antigas do PHP, porque `echo` não mudou.
- **Homebrew** (macOS) é o método de instalação descrito no manual do PHP:
  "An easy way to install PHP on macOS is with the Homebrew packaging
  manager" [9] (tradução livre: "Uma forma fácil de instalar o PHP no macOS é
  com o gerenciador de pacotes Homebrew"). O Linux usa os pacotes da
  distribuição [10]; o Windows usa as compilações ZIP oficiais de php.net [11].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | `php` 8.5.11 do Homebrew. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmo comando do Intel (`brew install php`); o Homebrew compila o `php` para Apple Silicon [8]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `php-cli` com o apt quando o `php` não existe [14]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o PHP: se o `php` não existe, ele imprime os passos do ZIP "VS17 x64 Non Thread Safe" de windows.php.net [11] e para. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ php hello.php
Hello, World!
```
`./run.sh` imprime primeiro sua explicação (linhas que começam com `==>` e
`WHY:`) e depois a mesma linha.

## Fontes
1. PHP tags. The PHP Group. <https://www.php.net/manual/en/language.basic-syntax.phptags.php> (acessado em 2026-10-31)
2. echo. The PHP Group. <https://www.php.net/manual/en/function.echo.php> (acessado em 2026-10-31)
3. Usage: Executing PHP files. The PHP Group. <https://www.php.net/manual/en/features.commandline.usage.php> (acessado em 2026-10-31)
4. Comments. The PHP Group. <https://www.php.net/manual/en/language.basic-syntax.comments.php> (acessado em 2026-10-31)
5. Strings. The PHP Group. <https://www.php.net/manual/en/language.types.string.php> (acessado em 2026-10-31)
6. OPcache: Introduction. The PHP Group. <https://www.php.net/manual/en/book.opcache.php> (acessado em 2026-10-31)
7. Supported Versions. The PHP Group. <https://www.php.net/supported-versions.php> (acessado em 2026-10-31)
8. `php` formula. Homebrew. <https://formulae.brew.sh/formula/php> (acessado em 2026-10-31)
9. Installation on macOS: Using Packages. The PHP Group. <https://www.php.net/manual/en/install.macosx.packages.php> (acessado em 2026-10-31)
10. Installing PHP on Debian GNU/Linux and Ubuntu. The PHP Group. <https://www.php.net/manual/en/install.unix.debian.php> (acessado em 2026-10-31)
11. Downloads (Windows). The PHP Group. <https://www.php.net/downloads.php?os=windows> (acessado em 2026-10-31)
12. Command line usage. The PHP Group. <https://www.php.net/manual/en/features.commandline.php> (acessado em 2026-10-31)
13. Introduction. Composer. <https://getcomposer.org/doc/00-intro.md> (acessado em 2026-10-31)
14. php-cli package (Debian stable). Debian. <https://packages.debian.org/stable/php-cli> (acessado em 2026-10-31)
15. Manual installation of pre-built binaries (Windows). The PHP Group. <https://www.php.net/manual/en/install.windows.manual.php> (acessado em 2026-10-31)
