---
source: languages/ruby/cli/README.md
source_sha: 4df68a9fd7f3190473fb1bcce6fbcacd5b04b2ee
---
# Ruby · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Ruby](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e uma
quebra de linha, e então termina. O programa é uma única instrução:
`puts "Hello, World!"`.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Ruby (`ruby`) | 4.0.7 (`ruby` do Homebrew) | o interpretador que executa o `hello.rb` |

Este programa usa apenas `puts`, de modo que qualquer versão do Ruby o
executa. Defina `RUBY=/path/to/ruby` para usar outro interpretador, por
exemplo uma segunda versão do Ruby.

## Início rápido
```sh
./install.sh   # check / install Ruby (asks before installing)
./run.sh       # run it
```
Não há `build.sh`. O Ruby é uma linguagem interpretada, de modo que o
arquivo-fonte é executado diretamente (veja [Por que não há etapa de build](#por-que-não-há-etapa-de-build)).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica se o `ruby` está no `PATH` e imprime a sua versão. Se estiver faltando, mostra o comando de instalação para o sistema operacional (Homebrew, apt ou RubyInstaller no Windows) e só o executa se você responder `y`. | O programa não pode ser executado sem o interpretador. |
| `run.sh` | Executa `ruby hello.rb`. `--verify` faz o mesmo, porque um programa cli já termina por conta própria. | Um único comando para os estudantes, com uma explicação do que acontece. |

## Estrutura de pastas
```text
cli/
├── README.md      this file
├── install.sh     checks / installs Ruby
├── run.sh         runs the program
└── hello.rb       the program (one statement plus teaching comments)
```
Um único arquivo `.rb` é um programa Ruby completo. Um projeto só precisa de um `Gemfile` quando usa bibliotecas de terceiros
(gems); este programa não usa nenhuma (a versão [web](../web/README.md) usa).

## Passo a passo
Abra o [`hello.rb`](hello.rb) ao lado desta lista.

1. **Comentários.** Uma linha que começa com `#` é um comentário. O Python e o
   Perl usam o mesmo símbolo; o C, o Java e o Go usam `//`.
2. **Sem ponto de entrada.** O Ruby executa o arquivo de cima para baixo. C,
   Java, C# e Go precisam, em vez disso, de uma função `main`.
3. **`puts`** é um método que todo objeto Ruby pode chamar. O `Kernel#puts` é
   documentado como "Equivalent to `$stdout.puts(objects)`" [2] (tradução
   livre: "Equivalente a `$stdout.puts(objects)`"), ou seja, escreve na saída
   padrão. O `IO#puts` "Writes a newline after each that does not already end
   with a newline sequence" [3] (tradução livre: "Escreve uma quebra de linha
   após cada um que ainda não termine com uma sequência de quebra de linha").
   Ao contrário do `printf` do C, a quebra de linha não precisa de `\n`; como
   o `println` do Java, ela é adicionada automaticamente.
4. **Sem import.** O `puts` está sempre disponível, de modo que nada precisa
   ser carregado antes. O C precisa de `#include <stdio.h>` para usar `printf`.
5. **A string** `"Hello, World!"` está entre aspas duplas.
6. **Sem parênteses e sem ponto e vírgula.** "In many cases, parenthesis are
   not necessary when sending a message" [5] (tradução livre: "Em muitos
   casos, os parênteses não são necessários ao enviar uma mensagem"), e uma
   quebra de linha encerra a instrução. O Python 3 exige parênteses em
   `print("...")`.

Compare com as outras categorias em [../README.md](../README.md#comparing-the-categories).

### Por que não há etapa de build
O `ruby hello.rb` lê o código-fonte e o executa. Internamente, a implementação
de referência ainda compila o código para instruções da sua máquina virtual: a
classe `InstructionSequence` "represents a compiled sequence of instructions
for the Virtual Machine used in MRI" [4] (tradução livre: "representa uma
sequência compilada de instruções para a Máquina Virtual usada no MRI"). Isso
acontece automaticamente a cada execução, de modo que não há uma etapa de
compilação separada a executar. Uma linguagem compilada como o C precisa de um
`build.sh` que gere um executável antes de o `run.sh` poder iniciá-lo.

## Por que esta toolchain
- **O comando `ruby`** é o interpretador do projeto Ruby (ruby-lang.org). A
  página de instalação do projeto diz que "Ruby versions 2.0 and above are
  included by default in macOS releases since at least El Capitan (10.11)"
  (tradução livre: "As versões 2.0 e posteriores do Ruby são incluídas por
  padrão nas versões do macOS desde pelo menos o El Capitan (10.11)") e avisa
  que "It is possible that major package managers will install older Ruby
  versions instead of the latest release" [1] (tradução livre: "É possível que
  os principais gerenciadores de pacotes instalem versões mais antigas do Ruby
  em vez do release mais recente"). Por isso o `install.sh` usa o Homebrew,
  cuja fórmula traz um release atual [6].
- **O Homebrew** (macOS) é o método de instalação que a página de instalação do
  Ruby lista para o macOS: `brew install ruby` [1]. O Linux usa os pacotes da
  distribuição [1]; o Windows usa o RubyInstaller [1].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | `ruby` 4.0.7 do Homebrew. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmo comando do Intel (`brew install ruby`). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `ruby-full` com o apt quando o `ruby` não existe [1]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` usa o Ruby que já está no PATH. Se o `ruby` não existe, ele instala o pacote Ruby 4.0 do MSYS2 com o `pacman` (o MSYS2 já vem instalado em `C:\msys64`). O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ruby hello.rb
Hello, World!
```
O `./run.sh` imprime primeiro a sua explicação (linhas que começam com `==>` e
linhas `WHY:` indentadas) e depois a saída do programa:
```text
==> Run the program
    WHY: 'ruby hello.rb' starts the interpreter, which runs the file top to bottom.
Hello, World!
```

## Fontes
1. Installing Ruby. Ruby community. <https://www.ruby-lang.org/en/documentation/installation/> (acessado em 2026-11-04)
2. Kernel#puts. Ruby documentation (master). <https://docs.ruby-lang.org/en/master/Kernel.html#method-i-puts> (acessado em 2026-11-04)
3. IO#puts. Ruby documentation (master). <https://docs.ruby-lang.org/en/master/IO.html#method-i-puts> (acessado em 2026-11-04)
4. RubyVM::InstructionSequence. Ruby documentation (master). <https://docs.ruby-lang.org/en/master/RubyVM/InstructionSequence.html> (acessado em 2026-11-04)
5. Calling methods. Ruby documentation (master). <https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html> (acessado em 2026-11-04)
6. ruby (Homebrew formula). Homebrew. <https://formulae.brew.sh/formula/ruby> (acessado em 2026-11-04)
