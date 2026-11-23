---
source: languages/assembly/cli/README.md
source_sha: 21cb006bb4c711218bfa344a2c8fb74eb1e29990
---
# Assembly (x86-64) · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Assembly](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina, escrito em **linguagem de montagem (assembly) x86-64** para o
**macOS em um Mac Intel**. É um único arquivo, `hello.asm`, na sintaxe do
**NASM**, o Netwide Assembler.

Todas as demais pastas deste repositório escondem a máquina atrás de uma
instrução de impressão ou de uma chamada equivalente de biblioteca. Aqui,
cada linha é uma instrução da CPU: colocar três números em três
registradores, executar `call` em uma função, colocar 0 em outro
registrador, executar `ret`. A função chamada é `write()`, da biblioteca C,
que um programa C compilado também usa por baixo. As decisões por trás
desse projeto são explicadas em
[Por que esta toolchain](#por-que-esta-toolchain).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| NASM (`nasm`) | 3.02 (Homebrew) | monta o `hello.asm` em um arquivo-objeto |
| Um driver de linker (`cc`) | Apple clang 21.0.0 (Command Line Tools) | liga o arquivo-objeto à biblioteca C, usando o linker do sistema `ld` |

## Início rápido
```sh
./install.sh   # check for cc and nasm (asks before installing NASM)
./build.sh     # assemble hello.asm and link bin/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica `cc --version` e `nasm -v`. Se o NASM estiver ausente, oferece `brew install nasm` (macOS) ou `sudo apt-get install -y nasm` (Debian/Ubuntu) e só o executa se a resposta for `y`. Se o `cc` estiver ausente, oferece `xcode-select --install`. | Um montador e um linker são as únicas ferramentas necessárias. |
| `build.sh` | Executa `nasm -f macho64 -o bin/hello.o hello.asm`, depois `cc -o bin/hello-cli bin/hello.o`, e imprime os dois comandos (`set -x`). No Linux e no Windows, ele para e remete a esta página, porque o `hello.asm` é código para macOS. | Montar e ligar são duas etapas separadas. Um compilador C as esconde em uma única chamada; este script mostra as duas. |
| `run.sh` | Executa `./bin/hello-cli`. `--verify` faz o mesmo (um programa cli termina por conta própria). | O executável é código de máquina; a CPU o executa diretamente. |

**Os comandos, um a um:**
- `nasm -f macho64` escolhe o formato de saída. O NASM escreve muitos
  formatos de arquivo-objeto; `macho64` é o "Mach-O", o formato do macOS de
  64 bits, e `elf64` seria o do Linux [1].
- `-o bin/hello.o` dá nome ao arquivo-objeto: código de máquina em que
  `_write` ainda é um nome não resolvido (`nm bin/hello.o` mostra
  `U _write`).
- `cc -o bin/hello-cli bin/hello.o`: ao receber apenas um arquivo-objeto, o
  clang não compila nada. Ele executa o linker do sistema, que acrescenta a
  biblioteca C (`libSystem`) e o código de inicialização que chama
  `_main`. Chamar o `ld` diretamente também funciona, mas exige informar à
  mão o caminho do SDK e as opções de biblioteca; o `cc` as fornece.

## Estrutura de pastas
```text
cli/
├── README.md     this file
├── install.sh    checks cc, checks / installs NASM
├── build.sh      assembles and links
├── run.sh        runs bin/hello-cli
├── hello.asm     the program
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    ├── hello.o       the object file (assembler output)
    └── hello-cli     the executable (linker output)
```
- O NASM não tem arquivo de projeto nem estrutura obrigatória. `.asm` é a
  extensão usual do código-fonte do NASM (os códigos-fonte do GNU `as`
  costumam usar `.s` ou `.S`).
- `bin/` é ignorado pelo `.gitignore` da raiz: a saída da compilação nunca
  recebe commit.

## Passo a passo
Abra [`hello.asm`](hello.asm) ao lado desta lista.

1. **Os comentários** começam com `;`, como no Lisp, e vão até o fim da
   linha.
2. **As diretivas** falam com o montador, não com a CPU:
   - `build_version macos, 11, 0` grava a plataforma de destino e a versão
     mínima do macOS no arquivo-objeto. Manual do NASM: ele "generates a
     LC_BUILD_VERSION load command in the Mach-O header ... Newer Xcode
     linker versions warn if this is not present in object files" [1]
     (tradução livre: "gera um comando de carga LC_BUILD_VERSION no
     cabeçalho Mach-O ... As versões mais novas do linker do Xcode emitem
     aviso se ele não estiver presente nos arquivos-objeto"). Removida a
     linha, o `./build.sh` imprime `ld: warning: no platform load command
     found ... assuming: macOS`. O executável em si recebe a versão que o
     `cc` passa ao linker: `otool -l bin/hello-cli` mostra `minos 26.0` na
     máquina de desenvolvimento, o mesmo valor de um programa C compilado
     ali.
   - `default rel` faz de `[message]` um endereço relativo ao ponteiro de
     instrução (RIP). Por padrão, os endereços do NASM são "absolute unless
     overridden with the REL specifier" [2] (tradução livre: "absolutos, a
     menos que sejam substituídos pelo especificador REL"). O código que
     encontra seus dados pela distância funciona onde quer que o sistema o
     carregue na memória (código independente de posição). **Experimente:**
     apague a linha e execute `./build.sh`. O NASM 3.02 para com `error:
     Mach-O 64-bit format does not support 32-bit absolute addresses`.
   - `global _main` exporta o ponto de entrada para que o linker o enxergue;
     `extern _write` declara um nome definido em outro lugar. No macOS, uma
     função C `main` se chama `_main` nos arquivos-objeto: compile qualquer
     arquivo C com `cc -c` e o `nm` lista `T _main`. O manual do NASM
     observa que o C "requires it in some, but not all, system calling
     conventions" (tradução livre: "o exige em algumas convenções de
     chamada de sistema, mas não em todas"), e o NASM só acrescenta o
     sublinhado quando solicitado (`--gprefix _`) [4]; por isso, aqui ele é
     escrito à mão. A variante para Linux, abaixo, não tem sublinhado.
3. **As seções** agrupam bytes do mesmo tipo:
   - `section .data` contém dados inicializados. `message: db "Hello,
     World!", 10` armazena 13 caracteres e o byte 10 (avanço de linha,
     `\n`). Não há zero terminador, porque `write()` recebe um
     comprimento, e não uma string C.
   - `message_len equ $ - message`: `$` é "o endereço atual" (*the current
     address*), de modo que este é o comprimento, 14, calculado pelo
     montador. Ele não usa memória.
   - `section .text` contém as instruções. O NASM a coloca na seção
     `__TEXT,__text` do Mach-O (consulte `objdump -d bin/hello.o`).
4. **O ponto de entrada** `_main` é um rótulo: um nome para um endereço. O
   código de inicialização do C o chama como qualquer função C.
5. **A convenção de chamada.** Apple: "Apple platforms typically follow the
   data representation and procedure call rules" do psABI System V para
   AMD64 [3] (tradução livre: "As plataformas Apple normalmente seguem as
   regras de representação de dados e de chamada de procedimento"). Para
   este programa, isso significa [5]:
   - os argumentos inteiros e ponteiros vão em **RDI, RSI, RDX**, RCX, R8,
     R9, nessa ordem;
   - o valor de retorno volta em **RAX** (para um `int`, sua metade inferior
     **EAX**);
   - o **RSP** (o ponteiro de pilha) deve ser múltiplo de 16 em cada `call`.
     Na entrada de `_main`, ele está deslocado em 8, porque o `call` empilhou
     um endereço de retorno de 8 bytes; o `push rbp` corrige isso. O RBP é
     *callee-saved* (preservado pela função chamada), de modo que o `pop rbp`
     o devolve antes do `ret`.
6. **A chamada** `write(1, message, 14)`:
   - `mov edi, 1`: o descritor de arquivo 1 é a saída padrão [6]. Escrever
     em um registrador de 32 bits (`EDI`) zera a metade superior do
     registrador de 64 bits (RDI) [7], e a instrução é mais curta.
   - `lea rsi, [message]`: "load effective address" (carregar endereço
     efetivo) calcula o endereço sem ler a memória.
   - `mov edx, message_len`: 14 bytes.
   - `call _write`: empilha o endereço de retorno e salta. O `write()`
     devolve em RAX o número de bytes escritos, ou -1 em caso de erro [6];
     como a maioria dos Hello World em C, este programa o ignora.
7. **Retornar 0.** `xor eax, eax` define EAX como 0 (sucesso). Retornar de
   `main` equivale a chamar `exit()` com esse valor [8].
8. **Veja o código de máquina.** O programa inteiro tem 27 bytes de
   instruções. O comando `objdump -d --x86-asm-syntax=intel bin/hello.o` na
   máquina de desenvolvimento imprime:
   ```text
   0000000000000000 <_main>:
          0: 55                           push  rbp
          1: bf 01 00 00 00               mov   edi, 0x1
          6: 48 8d 35 00 00 00 00         lea   rsi, [rip]
          d: ba 0e 00 00 00               mov   edx, 0xe
         12: e8 00 00 00 00               call  0x17 <_main+0x17>
         17: 31 c0                        xor   eax, eax
         19: 5d                           pop   rbp
         1a: c3                           ret
   ```
   Os bytes `00 00 00 00` são lacunas: as distâncias até `message` e até
   `_write` ainda não são conhecidas. O linker as preenche (realocação).
9. **O mesmo código na sintaxe AT&T.** Sem `--x86-asm-syntax=intel`, o
   `objdump` imprime a outra sintaxe x86, a padrão dos montadores GNU e da
   Apple:
   ```text
   pushq %rbp
   movl  $0x1, %edi
   leaq  (%rip), %rsi
   movl  $0xe, %edx
   callq 0x17 <_main+0x17>
   xorl  %eax, %eax
   popq  %rbp
   retq
   ```
   Os mesmos bytes, texto diferente: a origem vem antes do destino, `%`
   antes dos registradores, `$` antes das constantes e uma letra de tamanho
   no mnemônico (`q` = 64 bits, `l` = 32 bits) [9]. O manual do GNU resume:
   "AT&T and Intel syntax use the opposite order for source and destination
   operands. Intel 'add eax, 4' is 'addl $4, %eax'" [9] (tradução livre:
   "As sintaxes AT&T e Intel usam a ordem oposta para os operandos de origem
   e de destino. O 'add eax, 4' da Intel é 'addl $4, %eax'"). O manual da
   própria Intel escreve `MOV EAX, SUBTOTAL` com EAX como "the destination
   operand" (o operando de destino) e adverte que "some assembly languages
   put the source and destination in reverse order" [7] (tradução livre:
   "algumas linguagens de montagem colocam a origem e o destino em ordem
   inversa").

## Por que esta toolchain
**Alvo: macOS x86-64 (Mach-O).** A máquina de desenvolvimento é um Mac
Intel, de modo que este é o único alvo que pode ser verificado. A linguagem
de montagem está presa a um conjunto de instruções *e* às convenções de um
sistema operacional (formato de objeto, nomes de símbolos, como um programa
começa e faz a saída).

**Montador: NASM, sintaxe Intel.** A alternativa é o montador embutido no
Apple clang (`cc -c hello.s`), que lê a sintaxe AT&T/GAS.
- O NASM é "an 80x86 and x86-64 assembler designed for portability and
  modularity" [11] (tradução livre: "um montador 80x86 e x86-64 projetado
  para portabilidade e modularidade"). Uma única sintaxe cobre o macOS
  (`macho64`), o Linux (`elf64`) e o Windows (`win64`) [1]; assim, entre as
  plataformas mudam apenas as convenções do sistema operacional, e não a
  notação.
- A sintaxe Intel (`mov destino, origem`) é a notação do manual da Intel
  [7], de modo que cada instrução aqui pode ser consultada ali exatamente
  como está escrita.
- O NASM é mantido (3.02, lançado em 2026-06-29 [12]) e empacotado pelo
  Homebrew e pelo Debian [13][14].
- O custo: o NASM é uma instalação adicional, ao passo que o montador do
  clang já está presente em todo Mac com as Command Line Tools.

**Saída: chamar a biblioteca C, não o kernel.** Um programa pode pedir
diretamente ao kernel com a instrução `syscall`; a variante para Linux em
[Notas por plataforma](#notas-por-plataforma) funciona assim. No macOS, a
Apple desaconselha essa prática. Seu Technical Q&A sobre binários ligados
estaticamente (que ignoram as bibliotecas do sistema) explica: "A statically
linked binary assumes binary compatibility at the kernel system call
interface, and we do not make any guarantees on that front. Rather, we
strive to ensure binary compatibility in each dynamically linked system
library and framework" [15] (tradução livre: "Um binário ligado
estaticamente pressupõe compatibilidade binária na interface de chamadas de
sistema do kernel, e não damos nenhuma garantia a esse respeito. Em vez
disso, procuramos garantir a compatibilidade binária em cada biblioteca e
framework de sistema ligado dinamicamente"). A biblioteca do sistema que
este programa usa é a `libSystem`, a única que `otool -L bin/hello-cli`
lista. Um binário com chamadas de sistema diretas pode quebrar com uma
atualização do macOS. Chamar `write()` usa o mesmo caminho suportado de todo
programa C e custa um `extern` e um `call`.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel (x86-64) | ✅ verificado (2026-11-02) | NASM 3.02 (Homebrew), Apple clang 21.0.0, macOS 26.7.2. |
| macOS Apple Silicon (arm64) | ⚠️ não verificado | A CPU tem outro conjunto de instruções (AArch64), de modo que o `hello.asm` não pode executar nativamente. O `build.sh` o liga com `cc -arch x86_64`, o que produz um executável x86-64 que o Rosetta traduz [16]. Uma versão nativa precisa ser reescrita em linguagem de montagem AArch64 (a ABI da Apple para ela está descrita em [17]), e o NASM não monta AArch64. |
| Linux x86-64 (ELF) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `build-essential` (quando `cc` não existe) e `nasm` com o apt. O `build.sh` monta o `hello_linux.asm` com `nasm -f elf64` e o liga com `cc`. |
| Windows x64 | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o MSYS2 em `C:\msys64` e instala `gcc` e `nasm` (UCRT64) com o `pacman` quando faltam. O `build.sh` monta o `hello_windows.asm` com `nasm -f win64` e o liga com o `gcc`. |

**Variante para Linux x86-64 (não verificada).** Ela foi verificada apenas
quanto à montagem (`nasm -f elf64` na máquina de desenvolvimento), sem ser
ligada nem executada:
```nasm
        default rel
        global  _start              ; ld's default entry point, no C runtime
        section .data
message: db "Hello, World!", 10
message_len equ $ - message
        section .text
_start:
        mov     eax, 1              ; system call number 1 = write
        mov     edi, 1              ; fd 1 = standard output
        lea     rsi, [message]      ; buffer address
        mov     edx, message_len    ; byte count
        syscall                     ; enter the kernel
        mov     eax, 60             ; system call number 60 = exit
        xor     edi, edi            ; exit status 0
        syscall
```
Compile com `nasm -f elf64 -o hello.o hello.asm && ld -o hello hello.o`.
Os números 1 (`write`) e 60 (`exit`) vêm da tabela de chamadas de sistema
x86-64 do kernel [10]; o kernel recebe o número em RAX e os argumentos em
RDI, RSI e RDX [5].

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system loads it and the CPU runs it.
Hello, World!
```
O próprio programa imprime apenas a última linha; as demais linhas vêm do
`run.sh`.

## Fontes
1. NASM manual, 9.9 macho32 and macho64 (9.9.6 `build_version`); chapter 9 Output Formats. The NASM Authors. <https://www.nasm.us/doc/nasm09.html#section-9.9.6> (acessado em 2026-11-02)
2. NASM manual, 8.2 DEFAULT: Change the assembler defaults. The NASM Authors. <https://www.nasm.us/doc/nasm08.html#section-8.2> (acessado em 2026-11-02)
3. Writing 64-bit Intel code for Apple Platforms. Apple. <https://developer.apple.com/documentation/xcode/writing-64-bit-intel-code-for-apple-platforms> (acessado em 2026-11-02)
4. NASM manual, 2.1.28 --prefix, --gprefix. The NASM Authors. <https://www.nasm.us/doc/nasm02.html#section-2.1.28> (acessado em 2026-11-02)
5. System V Application Binary Interface, AMD64 Architecture Processor Supplement (psABI), 3.2 Function Calling Sequence and A.2 AMD64 Linux Kernel Conventions. x86-64 psABI maintainers. <https://gitlab.com/x86-psABIs/x86-64-ABI> (acessado em 2026-11-02)
6. write (The Open Group Base Specifications Issue 8, POSIX.1-2024). The Open Group / IEEE. <https://pubs.opengroup.org/onlinepubs/9799919799/functions/write.html> (acessado em 2026-11-02)
7. Intel 64 and IA-32 Architectures Software Developer's Manual, Volume 1: Basic Architecture (order no. 253665-093US, September 2026; 1.3.2.1 Instruction Operands, 2.1 Brief History, 3.4.1.1 General-Purpose Registers in 64-Bit Mode). Intel. <https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html> (acessado em 2026-11-02)
8. ISO/IEC 9899:TC3, committee draft WG14/N1256 (5.1.2.2.3 Program termination). ISO/IEC JTC1/SC22/WG14, 2007-09-07. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (acessado em 2026-11-02)
9. Using as: 9.16.3 i386 Syntactical Considerations, AT&T Syntax versus Intel Syntax. GNU Binutils. <https://sourceware.org/binutils/docs/as/i386_002dVariations.html> (acessado em 2026-11-02)
10. Linux kernel, arch/x86/entry/syscalls/syscall_64.tbl ("1 common write", "60 common exit"). The Linux kernel developers. <https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl> (acessado em 2026-11-02)
11. NASM manual, 1.1 What Is NASM?. The NASM Authors. <https://www.nasm.us/doc/nasm01.html#section-1.1> (acessado em 2026-11-02)
12. NASM home page (stable version 3.02, 2026-06-29). The NASM Authors. <https://www.nasm.us/> (acessado em 2026-11-02)
13. `nasm` (Homebrew formula). Homebrew. <https://formulae.brew.sh/formula/nasm> (acessado em 2026-11-02)
14. Package `nasm` (stable). Debian. <https://packages.debian.org/stable/nasm> (acessado em 2026-11-02)
15. Technical Q&A QA1118: Statically linked binaries on Mac OS X (archived, last updated 2011-09-20). Apple. <https://developer.apple.com/library/archive/qa/qa1118/_index.html> (acessado em 2026-11-02)
16. About the Rosetta translation environment. Apple. <https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment> (acessado em 2026-11-02)
17. Writing ARM64 code for Apple platforms. Apple. <https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms> (acessado em 2026-11-02)
18. x64 calling convention. Microsoft Learn. <https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention> (acessado em 2026-11-02)
