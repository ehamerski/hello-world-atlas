---
source: languages/fortran/cli/README.md
source_sha: 969ac6a23b2c5e8f89b8d2a8a71fd0eabe2ca13d
---
# Fortran · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Fortran](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É um único arquivo, [`hello.f90`](hello.f90), escrito em
**Fortran** moderno de **formato livre** e compilado como **Fortran 2008**
(ISO/IEC 1539:2010 [1]) pelo **GFortran** (o comando `gfortran`), o
compilador Fortran do GCC [2].

Como na versão [`cli` de C](../../c/cli/), o programa é compilado
antecipadamente em um executável nativo, `bin/hello-cli`, e o `build.sh`
chama o compilador diretamente com uma opção que impõe um único padrão
(`-std=f2008` aqui, `-std=c89` em C).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| GFortran (`gfortran`) | 16.2.0 (`gcc` 16.2.0 do Homebrew) | compila e vincula `hello.f90` |
| Linker da Apple | Command Line Tools (Apple clang 21.0.0) | o `gfortran` usa o linker do sistema no macOS |

No macOS, o GFortran vem dentro da fórmula `gcc` do Homebrew ("Also known
as: gcc@16, gfortran" [3], tradução livre: "Também conhecido como: gcc@16,
gfortran"); as ferramentas da própria Apple não têm compilador Fortran. Em
Macs Intel, o Homebrew não tem pacote `gcc` pré-compilado (*bottle*) para as
versões atuais do macOS [3]; por isso, `brew install gcc` compila o GCC a
partir do código-fonte. Na máquina de teste (macOS Intel), isso levou cerca
de 4,5 horas (2026-11-01). Os Macs Apple Silicon e o Linux recebem um pacote
pré-compilado.

## Início rápido
```sh
./install.sh   # check / install gfortran (asks before installing)
./build.sh     # compile hello.f90 as Fortran 2008 into bin/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Executa `gfortran --version`. Se o `gfortran` não existir, oferece `brew install gcc` (macOS; avisa que os Macs Intel compilam a partir do código-fonte) ou `sudo apt-get install -y gfortran` (Debian/Ubuntu), ou imprime os comandos do MSYS2 (Windows), e só executa um comando se a resposta for `y`. | O Fortran é compilado; portanto, um compilador Fortran é a única ferramenta necessária. O site da Fortran-lang indica os mesmos comandos [4]. |
| `build.sh` | Executa `gfortran -std=f2008 -Wall -Wextra -o bin/hello-cli hello.f90` e imprime esse comando (`set -x`). `FC=gfortran-16 ./build.sh` escolhe outro comando de compilador. | Transforma o código-fonte em código de máquina. As opções são explicadas a seguir. |
| `run.sh` | Executa `./bin/hello-cli`. `--verify` faz o mesmo (um programa cli termina sozinho). | O executável é código de máquina; portanto, o sistema operacional o executa diretamente. |

**As opções, uma a uma:**
- `-std=f2008`: "Specify the standard to which the program is expected to
  conform, which may be one of 'f95', 'f2003', 'f2008', 'f2018', 'f2023',
  'gnu', or 'legacy'. The default value for std is 'gnu', which specifies a
  superset of the latest Fortran standard" [5] (tradução livre: "Especifica o
  padrão ao qual se espera que o programa esteja em conformidade, que pode ser
  um entre 'f95', 'f2003', 'f2008', 'f2018', 'f2023', 'gnu' ou 'legacy'. O
  valor padrão de std é 'gnu', que especifica um superconjunto do padrão
  Fortran mais recente"). Sem esta opção, o compilador aceita extensões GNU
  sem emitir aviso.
- `-Wall -Wextra`: avisos adicionais sobre código suspeito (as mesmas
  opções do C).
- `-o bin/hello-cli`: dá nome à saída; sem ela, o arquivo é `a.out`.
- Nenhuma opção escolhe a forma do código-fonte: "Source files with .f90,
  .f95, .f03, .f08, .F90, .F95, .F03 and .F08 extensions are treated as free
  form" (tradução livre: "Arquivos-fonte com as extensões .f90, .f95, .f03,
  .f08, .F90, .F95, .F03 e .F08 são tratados como formato livre"), enquanto
  `.f`, `.for` e semelhantes "are treated as fixed form" [6] (tradução livre:
  "são tratados como formato fixo").

## Estrutura de pastas
```text
cli/
├── README.md     this file
├── install.sh    checks / installs gfortran
├── build.sh      compiles hello.f90 as Fortran 2008
├── run.sh        runs bin/hello-cli
├── hello.f90     the program
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- Um programa Fortran de um só arquivo não precisa de arquivo de projeto.
  Projetos maiores usam um `Makefile`, o CMake ou o Fortran Package Manager
  (`fpm`, com um `fpm.toml` e as pastas `app/` e `src/`) [7]; para um só
  arquivo, o `build.sh` mostra a linha do compilador.
- `bin/` e os arquivos de módulo do Fortran (`*.mod`) são ignorados pelo
  `.gitignore` da raiz.

## Passo a passo
Abra [`hello.f90`](hello.f90) ao lado desta lista.

1. **Os comentários** começam com `!` e vão até o fim da linha, como `//` em
   C99, Java ou Go.
2. **`program hello` ... `end program hello`** é o programa principal. O nome
   é apenas um rótulo: não existe uma função chamada `main`, como em C. O
   Fortran ignora a diferença entre maiúsculas e minúsculas; portanto,
   `PROGRAM HELLO` é equivalente.
3. **`implicit none`** desliga uma regra antiga. Sem ele, "the default
   ... is default integer if the letter is I, J, ..., or N and default
   real otherwise" [8] (tradução livre: "o padrão ... é inteiro padrão se a
   letra for I, J, ... ou N e real padrão nos demais casos"): um nome não
   declarado, como `count`, viraria silenciosamente um número real. "An
   IMPLICIT NONE statement can indicate that no implicit typing rules are to
   apply" [8] (tradução livre: "Uma instrução IMPLICIT NONE pode indicar que
   nenhuma regra de tipagem implícita se aplica"). Este programa não tem
   variáveis, mas a linha pertence a todo programa.
4. **`print '(a)', "Hello, World!"`** escreve o texto e uma quebra de linha
   na saída padrão. O primeiro item é o *formato*: `(a)` significa "uma
   cadeia de caracteres, tal como é".
5. **Por que não `print *`?** A linha comum dos livros didáticos é
   `print *, "Hello, World!"`. O `*` "indicates list-directed
   formatting" [8] (tradução livre: "indica formatação dirigida por lista"),
   na qual o compilador escolhe o layout, e na saída dirigida por lista "each
   output record begins with a blank character" [8] (tradução livre: "cada
   registro de saída começa com um caractere em branco"). Esse programa
   imprime ` Hello, World!` com um espaço inicial, que não é exatamente
   `Hello, World!`. **Experimente:** altere a linha para
   `print *, "Hello, World!"`, execute `./build.sh && ./run.sh | od -c |
   head -n 1` e procure o espaço antes do `H`. Depois, desfaça a alteração.
6. **Compilar e vincular.** O `build.sh` faz as duas etapas em uma só
   chamada. `otool -L bin/hello-cli` mostra que o programa carrega
   `libgfortran.5.dylib` (além de `libquadmath` e `libgcc_s`) do `gcc` do
   Homebrew em tempo de execução: a biblioteca de runtime do Fortran faz a
   saída propriamente dita.

## Por que esta toolchain
- **Contexto da época.** O FORTRAN surgiu em 1957 como o compilador da IBM
  para o IBM 704 [9]. Essa máquina e o seu compilador já não existem há
  muito tempo, mas o código da era do formato fixo (arquivos `.f` [6]) ainda
  é compilado pelos compiladores atuais.
- **O GFortran é livre, mantido e está disponível em todas as plataformas
  deste repositório.** O site da Fortran-lang afirma: "GNU Fortran Compiler
  (gfortran) is a mature compiler, part of the GNU Compiler Collection" [10]
  (tradução livre: "O GNU Fortran Compiler (gfortran) é um compilador maduro,
  parte da GNU Compiler Collection"). Ele "implements the Fortran 77, 90 and
  95 standards completely" [11] (tradução livre: "implementa completamente
  os padrões Fortran 77, 90 e 95") e "supports almost all of ISO/IEC 1539-1:2004
  (Fortran 2003) and ISO/IEC 1539-1:2010 (Fortran 2008)" [12] (tradução livre:
  "oferece suporte a quase todo o ISO/IEC 1539-1:2004 (Fortran 2003) e ao
  ISO/IEC 1539-1:2010 (Fortran 2008)"); assim, compila código antigo e novo.
  Outros compiladores atuais incluem o `ifx` da Intel e o LFortran [10].
- **Fortran 2008 e formato livre, de propósito.** Este repositório tem como
  alvo o Fortran 2008 ou posterior. O Fortran 2008 é o padrão mais recente
  que o GFortran suporta quase por completo [12]; o padrão atual é o
  Fortran 2023 [1]. O formato livre é o layout moderno, e a versão
  [`cli` de COBOL](../../cobol/cli/) já mostra o formato fixo dos cartões
  perfurados.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | GFortran 16.2.0 do `gcc` 16.2.0 do Homebrew, compilado a partir do código-fonte (sem *bottle* para Intel) [3]. |
| macOS Apple Silicon | ⚠️ não verificado | `brew install gcc` instala um *bottle* pré-compilado [3]. Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `gfortran` com o apt quando ele não existe [13][4]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala um compilador: se o `gfortran` não existe, ele imprime os passos do MSYS2 (`pacman -S mingw-w64-ucrt-x86_64-gcc-fortran`) [14] e para. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly
         and loads libgfortran, the Fortran runtime library.
Hello, World!
```
O programa em si imprime apenas a última linha; as demais linhas vêm de
`run.sh`.

## Fontes
1. Fortran Standards: Fortran 2008 / Fortran 2023. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/f2008.html>, <https://wg5-fortran.org/f2023.html> (acessado em 2026-11-01)
2. GCC, the GNU Compiler Collection (home page). Free Software Foundation. <https://gcc.gnu.org/> (acessado em 2026-11-01)
3. `gcc` formula. Homebrew. <https://formulae.brew.sh/formula/gcc> (acessado em 2026-11-01)
4. Installing GFortran. Fortran-lang. <https://fortran-lang.org/learn/os_setup/install_gfortran/> (acessado em 2026-11-01)
5. GNU Fortran: Options controlling Fortran dialect (-std). GCC. <https://gcc.gnu.org/onlinedocs/gfortran/Fortran-Dialect-Options.html> (acessado em 2026-11-01)
6. GNU Fortran and GCC (source form by file extension). GCC. <https://gcc.gnu.org/onlinedocs/gfortran/GNU-Fortran-and-GCC.html> (acessado em 2026-11-01)
7. Fortran Package Manager: First steps. Fortran-lang. <https://fpm.fortran-lang.org/tutorial/hello-fpm.html> (acessado em 2026-11-01)
8. Fortran 2018 working draft J3/18-007r1 (8.7 IMPLICIT statement; 12.6.2 Format specification; 13.10.4 List-directed output). INCITS/Fortran (J3). <https://j3-fortran.org/doc/year/18/18-007r1.pdf> (acessado em 2026-11-01)
9. Fortran. IBM Heritage. <https://www.ibm.com/history/fortran> (acessado em 2026-11-01)
10. Compilers. Fortran-lang. <https://fortran-lang.org/compilers/> (acessado em 2026-11-01)
11. About GNU Fortran. GCC. <https://gcc.gnu.org/onlinedocs/gfortran/About-GNU-Fortran.html> (acessado em 2026-11-01)
12. GNU Fortran: Standards. GCC. <https://gcc.gnu.org/onlinedocs/gfortran/Standards.html> (acessado em 2026-11-01)
13. Package `gfortran` (trixie). Debian. <https://packages.debian.org/stable/gfortran> (acessado em 2026-11-01)
14. Package `mingw-w64-ucrt-x86_64-gcc-fortran`. MSYS2. <https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-gcc-fortran> (acessado em 2026-11-01)
