---
source: languages/python/cli/README.md
source_sha: f23d456510d57852cfa0fd7c1771d602753e4c45
---
# Python · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Python](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e uma
quebra de linha, e depois termina. O programa inteiro é uma linha de Python:
`print("Hello, World!")`.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| Python 3 (`python3.14` no macOS, `python3` nos demais) | 3.14.10 (`python@3.14` do Homebrew) | o interpretador que executa `hello.py` |

Qualquer versão suportada do Python 3 funciona, porque este programa usa
apenas `print()`. As versões suportadas estão listadas no Python Developer's
Guide [3].

No macOS, os scripts chamam `python3.14`, e não `python3`. O `python@3.14` do
Homebrew coloca no PATH apenas nomes com versão; "Unversioned names such as
`python` ... are installed into `$(brew --prefix python)/libexec/bin`" [10]
(tradução livre: "Nomes sem versão, como `python` ..., são instalados em
`$(brew --prefix python)/libexec/bin`"), e um `python3` simples no macOS
costuma ser o `/usr/bin/python3` da Apple, mais antigo. O instalador do
python.org também fornece `python3.14`. Defina `PYTHON=python3` (ou qualquer
outro comando) para alterar esse comportamento.

## Início rápido
```sh
./install.sh   # check / install Python 3 (asks before installing)
./run.sh       # run it
```
Não há `build.sh`. O Python é uma linguagem interpretada, portanto o arquivo
de código-fonte é executado diretamente (ver [Por que não há etapa de compilação](#por-que-não-há-etapa-de-compilação)).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica se o interpretador (`python3.14` no macOS, `python3` nos demais) está no PATH. Se estiver ausente, mostra o comando de instalação para o sistema operacional do leitor (Homebrew, apt ou o gerenciador de instalação do Python para Windows) e só o executa se a resposta for `y`. | O programa não executa sem o interpretador. |
| `run.sh` | Executa `python3.14 hello.py` (macOS) ou `python3 hello.py`. `--verify` faz o mesmo, porque um programa cli termina por conta própria. | Um comando para executar o programa, com a explicação do que acontece. |

Ambos os scripts aceitam `PYTHON=<command>` para usar outro interpretador, por
exemplo `PYTHON=python ./run.sh` no Windows.

## Estrutura de pastas
```text
cli/
├── README.md      this file
├── install.sh     checks / installs Python 3
├── run.sh         runs the program
└── hello.py       the program (one line of code plus teaching comments)
```
Um único arquivo `.py` é um programa Python completo: "the most common use
case is, of course, a simple invocation of a script: `python myscript.py`"
[9] (tradução livre: "o caso de uso mais comum é, naturalmente, a simples
invocação de um script: `python myscript.py`"). Um projeto precisa de mais
estrutura (um `pyproject.toml` e uma pasta de pacote) apenas quando é
empacotado e distribuído, como mostra o Python Packaging User Guide [6]. Um
programa Hello World não é distribuído; portanto, não precisa de nada disso.

## Passo a passo
Abra [`hello.py`](hello.py) ao lado desta lista.

1. **Comentários.** As linhas que começam com `#` são comentários. O
   interpretador as ignora. C, Java e Go usam `//` em seu lugar.
2. **Nenhum ponto de entrada.** O Python executa um arquivo de cima para
   baixo. A primeira linha de código é onde o programa começa. C, Java, C# e
   Go precisam, em vez disso, de uma função chamada `main` (em Java e C#, ela
   fica dentro de uma classe).
3. **Nenhuma importação.** `print` é uma função embutida, sempre disponível
   [4]. Em C, é preciso escrever antes `#include <stdio.h>` para usar
   `printf`.
4. **A chamada.** `print("Hello, World!")` escreve a string na saída padrão e
   depois o final de linha padrão `"\n"` [4]. As strings podem usar aspas
   duplas ou simples em Python: `'Hello, World!'` funciona da mesma forma.
5. **Sem ponto e vírgula, sem chaves.** Uma linha encerra a instrução. Os
   blocos (que este programa não usa) são marcados por indentação, e não por
   `{ }`.

Para as outras versões em Python, ver [../README.md](../README.md#comparing-the-categories).

### Por que não há etapa de compilação
O Python é "an interpreted, interactive, object-oriented programming
language" [1] (tradução livre: "uma linguagem de programação interpretada,
interativa e orientada a objetos"). O glossário do Python afirma que "source
files can be run directly without explicitly creating an executable" [7]
(tradução livre: "arquivos de código-fonte podem ser executados diretamente,
sem criar explicitamente um executável"). O CPython ainda compila antes o
código-fonte para *bytecode*, mas faz isso automaticamente a cada execução de
um arquivo [7]. Uma linguagem compilada como C precisa de um `build.sh`
separado, que transforma o código-fonte em um executável antes que `run.sh`
possa iniciá-lo.

## Por que esta toolchain
- O **CPython** é "the canonical implementation of the Python programming
  language, as distributed on python.org" [7] (tradução livre: "a
  implementação canônica da linguagem de programação Python, conforme
  distribuída em python.org"). É o interpretador que a fórmula do Homebrew e o
  gerenciador de instalação do Windows instalam [2][8].
- O **Python 3.14** é uma versão suportada em estado "bugfix", com fim de vida
  previsto para 2030-10 (Python Developer's Guide, consultado em 2026-10-30)
  [3]. O Python 3.15 foi lançado em 2026-10-09 e também é suportado [3]. Este
  repositório é verificado com a 3.14, a versão instalada na máquina de
  desenvolvimento. O arquivo `hello.py` executa sem alterações em ambas as
  versões.
- O **Homebrew** (macOS) e o **gerenciador de instalação do Python**
  (Windows) são os métodos de instalação da documentação oficial [2][8].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | `python@3.14` 3.14.10 do Homebrew. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos do Intel (`brew install python@3.14`). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `python3` com o apt quando ele não existe [5]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Python: se o interpretador (`PYTHON`, padrão `python3`) não existe, ele imprime os passos do `winget` e de `py install 3.14` e para. [8] O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ python3 hello.py
Hello, World!
```
`./run.sh` imprime primeiro sua explicação (linhas que começam com `==>` e
`WHY:`) e depois a mesma linha.

## Fontes
1. General Python FAQ. Python Software Foundation. <https://docs.python.org/3/faq/general.html> (acessado em 2026-10-30)
2. python@3.14 formula. Homebrew. <https://formulae.brew.sh/formula/python@3.14> (acessado em 2026-10-30)
3. Status of Python versions. Python Developer's Guide. <https://devguide.python.org/versions/> (acessado em 2026-10-30)
4. Built-in Functions: print(). Python Software Foundation. <https://docs.python.org/3/library/functions.html#print> (acessado em 2026-10-30)
5. Using Python on Unix platforms. Python Software Foundation. <https://docs.python.org/3/using/unix.html> (acessado em 2026-10-30)
6. Packaging Python Projects. Python Packaging Authority. <https://packaging.python.org/en/latest/tutorials/packaging-projects/> (acessado em 2026-10-30)
7. Glossary: bytecode, interpreted. Python Software Foundation. <https://docs.python.org/3/glossary.html> (acessado em 2026-10-30)
8. Using Python on Windows. Python Software Foundation. <https://docs.python.org/3/using/windows.html> (acessado em 2026-10-30)
9. Command line and environment. Python Software Foundation. <https://docs.python.org/3/using/cmdline.html> (acessado em 2026-10-30)
10. Language Runtimes and Packages. Homebrew. <https://docs.brew.sh/Language-Runtimes-and-Packages> (acessado em 2026-10-31)
