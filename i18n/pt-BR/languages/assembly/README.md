---
source: languages/assembly/README.md
source_sha: d8f649504790e7e7fabcdca062198cc914eafc4a
---
# Assembly (x86-64)

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** imperativo, de baixo nível, específico da máquina. Um
programa em linguagem de montagem (assembly) é uma lista de instruções da
CPU, uma por linha, cada uma com um nome escrito (um *mnemônico*) no lugar
de seu código numérico. O manual da Intel descreve o formato como "label:
mnemonic argument1, argument2, argument3", por exemplo `LOADREG: MOV EAX,
SUBTOTAL` [1]. O programa é executado de cima para baixo, alterando
registradores e memória: o paradigma imperativo sem nada no meio.
"Assembly" não é uma linguagem única: cada conjunto de instruções
(x86-64, AArch64, ...) tem a sua, e até a mesma CPU admite notações
diferentes (veja [sintaxe Intel vs AT&T](cli/README.md#step-by-step-walkthrough)).
Esta pasta usa **x86-64**, a forma de 64 bits da família x86 da Intel, na
sintaxe do **NASM**.

Veja também: [paradigmas](../../docs/paradigms.md#imperative) (como este
paradigma se compara aos outros) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as demais).

## Implementações
| Categoria | Pasta | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | NASM + `cc` (macOS x86-64) | ✅ |
| desktop | – | não implementado, veja [Por que não há versão desktop nem web](#por-que-não-há-versão-desktop-nem-web) | – |
| web | – | não implementado, mesma seção | – |

## Histórico
- **Codificação à mão:** Andrew Booth e Kathleen Britten escreveram o
  relatório *Coding for the A.R.C.* (seu Automatic Relay Computer) no
  Institute for Advanced Study, em Princeton, "in the summer of 1947" [2]
  (tradução livre: "no verão de 1947").
- **O primeiro montador (assembler) em uso:** em Cambridge, o EDSAC executou seu
  primeiro programa em 1949-05-06. Suas "Initial Orders, (a primitive
  assembler) were hard wired on to rotary telephone switches" [3]
  (tradução livre: "Initial Orders (um montador primitivo) eram fixadas
  por fiação em chaves rotativas de telefone"). David Wheeler as definiu e
  as aperfeiçoou [3]. Wilkes, Wheeler e Gill descreveram esse modo de
  trabalhar em *The Preparation of Programs for an Electronic Digital
  Computer* (1951), "the first book on programming to be published" [3]
  (tradução livre: "o primeiro livro sobre programação a ser publicado").
- **x86:** o 8086 da Intel (1978) deu início à família usada nesta pasta
  [1][4]. O Intel386 (1985) "was the first 32-bit processor in the IA-32
  architecture family" [1] (tradução livre: "foi o primeiro processador de
  32 bits da família de arquiteturas IA-32"). O manual da Intel destaca a
  compatibilidade: "object code created for processors released as early
  as 1978 still executes on the latest processors" [1] (tradução livre:
  "o código objeto criado para processadores lançados já em 1978 ainda é
  executado nos processadores mais recentes").
- **x86-64:** a AMD estendeu o x86 para 64 bits. Em 2003-04-22, ela
  "introduced the AMD Opteron processor, the world's first 64-bit
  processor" compatível com x86 [5] (tradução livre: "apresentou o
  processador AMD Opteron, o primeiro processador de 64 bits do mundo").
  A versão da Intel, a "Intel 64 architecture", apareceu nos processadores
  Pentium 4 [1]. É por isso que a mesma arquitetura de conjunto de
  instruções tem três nomes: x86-64, AMD64 e Intel 64.
- **NASM:** "originally developed by Simon Tatham and Julian Hall, and is
  now maintained by a team led by H. Peter Anvin" [6] (tradução livre:
  "desenvolvido originalmente por Simon Tatham e Julian Hall, e agora
  mantido por uma equipe liderada por H. Peter Anvin"). Sua primeira
  versão, a 0.90, foi lançada em outubro de 1996 [7].

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1947 | *Coding for the A.R.C.* (Britten e Booth), Princeton | [2] |
| 1949-05-06 | O EDSAC executa seu primeiro programa; suas Initial Orders são "a primitive assembler" | [3] |
| 1951 | Wilkes, Wheeler e Gill, *The Preparation of Programs for an Electronic Digital Computer* | [3] |
| 1978 | Intel 8086, o primeiro da família x86 | [1][4] |
| 1985 | Intel386, o primeiro x86 de 32 bits (IA-32) | [1] |
| 1996 | NASM 0.90, primeira versão | [7] |
| 2003-04-22 | A AMD apresenta o Opteron, seu primeiro processador x86 de 64 bits (AMD64) | [5] |
| 2020-06-22 | A Apple anuncia a transição do Mac para chips próprios, o Apple Silicon | [8] |
| 2026-06-29 | NASM 3.02, usado por [cli/](cli/) | [6] |

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam a cada ano.

- **Índice TIOBE, outubro de 2026:** "Assembly language" ocupa a **23ª**
  posição, com uma avaliação de 0,76% [9]. O TIOBE conta todas as
  linguagens de montagem juntas, como uma única entrada. O índice é "an
  indicator of the popularity of programming languages" (tradução livre:
  "um indicador da popularidade das linguagens de programação"), calculado
  a partir de mecanismos de busca [9].
- **Stack Overflow Developer Survey 2026:** 7,2% de todos os respondentes
  (1.020 de 14.099) disseram ter feito trabalho extensivo de
  desenvolvimento em Assembly no último ano [10].
- **Vendo sem escrever:** toda linguagem compilada deste repositório
  termina como código de máquina, e um compilador pode exibi-lo como
  assembly. Execute `cc -S -masm=intel ../c/cli/hello.c` para ver o
  assembly que o clang escreve para o Hello World em C
  (comparado [adiante](#comparando-as-categorias)).

## Importância antes e agora
- **Antes (décadas de 1940 a 1970):** as Initial Orders do EDSAC, "a
  primitive assembler", faziam parte da máquina desde seu primeiro
  programa em 1949 [3]. O assembly era o que as linguagens de sistemas
  precisavam substituir. Dennis Ritchie explica assim o sucesso de C: "it
  evidently satisfied a need for a system implementation language
  efficient enough to displace assembly language, yet sufficiently
  abstract and fluent to describe algorithms and interactions in a wide
  variety of environments" [11] (tradução livre: "ela evidentemente
  satisfazia a necessidade de uma linguagem de implementação de sistemas
  eficiente o bastante para deslocar a linguagem de montagem, mas
  suficientemente abstrata e fluente para descrever algoritmos e
  interações em uma grande variedade de ambientes").
- **Hoje:** poucos programas são escritos em assembly (23ª posição no
  TIOBE, outubro de 2026 [9]; 7,2% no Stack Overflow 2026 [10]). Sua
  importância está na compreensão: é aquilo em que os programas compilados
  deste repositório se transformam. A parte específica da máquina voltou a
  ter importância desde a mudança da Apple para chips próprios, em 2020
  [8]: os Macs atuais usam um de dois conjuntos de instruções (x86-64 nos
  Macs Intel, ARM64 nos Macs Apple Silicon [13]), e um programa x86-64 só
  roda no Apple Silicon por meio do Rosetta, que "allows users to run Mac
  apps that contain x86_64 instructions on Apple silicon" [12] (tradução
  livre: "permite que os usuários executem apps de Mac que contêm
  instruções x86_64 no Apple silicon").
- **No ensino:** o assembly torna visível o que as linguagens de alto
  nível escondem: registradores, a pilha e seu alinhamento, convenções de
  chamada, arquivos objeto, símbolos e o linker. É o nível mais baixo de
  toda comparação neste repositório.

## Comparando as categorias
O assembly tem aqui uma única categoria, `cli`. A comparação útil é com o
[C cli](../c/cli/), porque ambos terminam como o mesmo tipo de executável,
ligado à mesma biblioteca C, na mesma máquina:

| | [Assembly `cli`](cli/) | [C `cli`](../c/cli/) |
|---|---|---|
| Linhas de código-fonte (sem comentários e sem linhas em branco) | 18 | 6 |
| Impressão | `call _write` com 3 argumentos em RDI, RSI, RDX | `printf("Hello, World!\n");` |
| Quem escolhe os registradores e o layout da pilha | o programador | o compilador |
| Tradução | `nasm` (montar) + `cc` (apenas ligar) | `cc` (pré-processar, compilar, montar, ligar) |
| Bibliotecas carregadas em tempo de execução (`otool -L`) | `libSystem` | `libSystem` |
| Tamanho do executável (`ls -l`, macOS Intel, 2026-11-02) | 12.584 bytes | 8.440 bytes |
| Executa em | apenas x86-64 macOS | qualquer plataforma com um compilador C (recompilado) |

O compilador C escreve quase o mesmo código. `cc -S -O0 -masm=intel` em
`c/cli/hello.c` (Apple clang 21) gera, sem as diretivas:
```text
_main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	dword ptr [rbp - 4], 0
	lea	rdi, [rip + L_.str]
	mov	al, 0
	call	_printf
	xor	eax, eax
	add	rsp, 16
	pop	rbp
	ret
```
Mesmo ponto de entrada `_main`, mesmo `push rbp`, mesmo `lea` com
endereçamento relativo ao RIP, mesma `call` para a `libSystem`, mesmo
`xor eax, eax` / `ret` para "return 0". A diferença é a portabilidade: o
código-fonte C compila sem alterações para arm64 ou Linux, enquanto o
código-fonte em assembly precisa ser reescrito (veja as
[Notas por plataforma](cli/README.md#platform-notes) do cli).

## Por que não há versão desktop nem web
Este repositório tem apenas a versão cli de assembly. Uma categoria só é
incluída se existir uma toolchain mantida, convencional e razoavelmente
simples para ela, e se o resultado ensinar algo sobre a linguagem:

- **Nada de novo sobre o assembly.** O cli já mostra todo o mecanismo da
  linguagem: colocar argumentos em registradores e chamar (`call`) uma
  função de biblioteca. Uma janela desktop ou um servidor web em assembly
  seria o mesmo mecanismo repetido muitas vezes, chamando as mesmas
  bibliotecas que um programa em C chama (um toolkit de GUI ou a API de
  sockets), com cada chamada escrita à mão.
- **Nenhum toolkit de assembly para escolher.** Não existe framework de
  GUI nem web para assembly; as duas versões seriam chamadas escritas à
  mão para bibliotecas C ou Objective-C. As versões [C desktop](../c/desktop/)
  e [C web](../c/web/) mostram essas bibliotecas, com o compilador
  cuidando dos registradores.
- **Ainda menos portável.** O cli já precisa ser reescrito para cada
  conjunto de instruções e sistema operacional [1][13]. Uma versão com GUI
  ainda o prenderia ao sistema de GUI de uma única plataforma.

## Fontes
1. Intel 64 and IA-32 Architectures Software Developer's Manual, Volume 1: Basic Architecture (order no. 253665-093US, September 2026; 1.3.2.1 Instruction Operands, 2.1 Brief History of Intel 64 and IA-32 Architectures, 2.2 More on Intel 64). Intel. <https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html> (acessado em 2026-11-02)
2. The Booth-Britten reports (1947: "Coding for the A.R.C."). MacTutor History of Mathematics, University of St Andrews. <https://mathshistory.st-andrews.ac.uk/Extras/Booth-Britten_reports/> (acessado em 2026-11-02)
3. EDSAC 99: a brief history of EDSAC (1949-05-06; Initial Orders; Wilkes, Wheeler and Gill, 1951). University of Cambridge Computer Laboratory. <https://www.cl.cam.ac.uk/events/EDSAC99/history.html> (acessado em 2026-11-02)
4. 1978: The 8086 ushers in the x86 era. Intel Timeline. <https://timeline.intel.com/1978/the-8086-ushers-in-the-x86-era> (acessado em 2026-11-02)
5. AMD press release, 2003-07-16 (Exhibit 99.1 to Form 8-K: "On April 22, AMD introduced the AMD Opteron processor"). Advanced Micro Devices, via U.S. SEC EDGAR. <https://www.sec.gov/Archives/edgar/data/2488/000119312503020249/dex991.htm> (acessado em 2026-11-02)
6. NASM home page (authors; stable version 3.02, 2026-06-29). The NASM Authors. <https://www.nasm.us/> (acessado em 2026-11-02)
7. NASM manual, Appendix C: NASM Version History ("Version 0.90 released October 1996"). The NASM Authors. <https://www.nasm.us/doc/nasmac.html> (acessado em 2026-11-02)
8. Apple announces Mac transition to Apple silicon (2020-06-22). Apple Newsroom. <https://www.apple.com/newsroom/2020/06/apple-announces-mac-transition-to-apple-silicon/> (acessado em 2026-11-02)
9. TIOBE Index for October 2026 (positions 21–50; definition of the index). TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-02)
10. 2026 Stack Overflow Developer Survey: Technology, programming languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-02)
11. The Development of the C Language. Dennis M. Ritchie, HOPL-II, ACM, 1993 (author's reprint, archived copy of bell-labs.com, 2015-12-31). <https://web.archive.org/web/20151231162516/http://www.bell-labs.com/usr/dmr/www/chist.html> (acessado em 2026-11-02)
12. About the Rosetta translation environment. Apple. <https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment> (acessado em 2026-11-02)
13. Writing ARM64 code for Apple platforms. Apple. <https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms> (acessado em 2026-11-02)
