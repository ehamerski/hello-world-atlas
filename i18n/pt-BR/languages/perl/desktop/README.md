---
source: languages/perl/desktop/README.md
source_sha: df4633f30f8dcb2e201210df934ddac69d3f9918
---
# Perl · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Perl](../README.md)

## O que é
Um programa desktop que abre uma janela nativa intitulada **Hello, World!**
com o texto **Hello, World!** dentro. O programa termina quando a janela é
fechada. Ele usa o Tkx, um módulo Perl que controla o toolkit GUI Tk.

Esta pasta é uma **solução de compromisso** (🔶): ela não usa o Perl/Tk, o
binding Perl para o Tk mais conhecido, porque este precisa de um servidor X11
no macOS. Veja [Por que esta toolchain](#por-que-esta-toolchain).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Perl 5 (`perl`) | 5.34.1 (o `/usr/bin/perl` que acompanha o macOS) | executa o `hello.pl` |
| Tcl/Tk com seus arquivos de desenvolvimento | Tcl/Tk 9.1.0 (`tcl-tk` do Homebrew) | o Tk desenha a janela; o Tcl.pm é compilado contra o Tcl |
| Um compilador C e o `make` | Apple clang 21.0.0 (Command Line Tools) | o Tcl.pm tem uma parte escrita em C |
| Tcl.pm | 1.53 (CPAN, instalado em `local/`) | permite que o Perl crie um interpretador Tcl [1] |
| Tkx | 1.10 (CPAN, instalado em `local/`) | a interface Perl para o Tk [2] |
| `curl` e `shasum` | os que acompanham o macOS | baixam e conferem os tarballs do CPAN |
| uma sessão gráfica | desktop do macOS, desktop do Windows ou Linux com X11/Wayland | uma janela precisa de uma tela |

## Início rápido
```sh
./install.sh   # check Perl and Tcl/Tk, then build Tcl.pm and Tkx into local/
./run.sh       # open the window; close it to end the program
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica o `perl`. 2. Verifica se o Tcl/Tk está instalado (no macOS, a fórmula `tcl-tk` do Homebrew) e se oferece para instalá-lo. 3. Baixa do CPAN os tarballs do Tcl.pm e do Tkx, confere o checksum SHA-256 de cada um, compila-os e os instala em `local/`. Toda instalação pergunta antes. | O Perl não tem um toolkit GUI próprio. O Tcl.pm contém código C, de modo que é compilado contra o seu Tcl. Os checksums provam que os arquivos são as versões fixadas. |
| `tkx-env.sh` | Incluído (`source`) pelos outros scripts: as versões, URLs e checksums fixados, e o `PERL5LIB`. Não é executado sozinho. | Um único lugar para os valores fixados, compartilhado pelo `install.sh` e pelo `run.sh`. |
| `run.sh` | Executa `perl hello.pl` com `local/lib/perl5` no `PERL5LIB`, a lista de pastas de módulos do Perl. `--verify` define `TF_VERIFY=1`: a aplicação imprime `Hello, World!` assim que sua janela é exibida e se fecha sozinha após 2 segundos. | Um único comando para abrir a janela. A autoverificação permite que o `scripts/verify-all.sh` teste uma GUI sem que ninguém clique. |

Não há `build.sh` para o programa: o Perl é interpretado, como no
[cli](../cli/README.md#why-there-is-no-build-step). Apenas os dois módulos
são compilados, pelo `install.sh`.

## Estrutura de pastas
```text
desktop/
├── README.md      this file
├── install.sh     checks Perl and Tcl/Tk, installs Tcl.pm and Tkx
├── tkx-env.sh     pinned versions, URLs, checksums and PERL5LIB (sourced)
├── run.sh         opens the window
├── hello.pl       the program
├── .gitignore     keeps local/ out of git
└── local/         created by install.sh: tarballs in src/, modules in lib/perl5/
```
O `local/` segue o layout que o `INSTALL_BASE` produz: uma biblioteca
privada que o Perl encontra por meio do `PERL5LIB` [3][18]. Os tarballs são
conferidos após cada download, de modo que o `local/src/` pode ser apagado e
baixado de novo.

## Passo a passo
Abra o [`hello.pl`](hello.pl) ao lado desta lista.

1. **`use Tkx;`** carrega o módulo. O Tkx é "a bridge to Tcl that allows Tk
   based applications to be written in Perl" [2] (tradução livre: "uma ponte
   para o Tcl que permite escrever em Perl aplicações baseadas no Tk").
2. **`Tkx::widget->new(".")`** envolve a janela raiz do Tk, que o Tk chama de
   `.`: a janela principal da aplicação. A declaração `my $mw` é necessária
   por causa do `use strict` (veja o [cli](../cli/README.md#step-by-step-walkthrough)).
3. **`$mw->g_wm_title("Hello, World!")`** define o texto da barra de título.
   O método `g_wm_title` chama o comando `wm title` do Tk com a janela como
   primeiro argumento [2][4]. O Tkx é "a very thin wrapper on top of Tcl"
   (tradução livre: "um invólucro muito fino sobre o Tcl"), de modo que o que
   se lê no manual do Tcl/Tk é o que acontece [2].
4. **`new_ttk__label(-text => "Hello, World!", -padding => "60 40")`** cria um
   rótulo dentro da janela. O `ttk::label` "displays a textual label and/or
   image" [5] (tradução livre: "exibe um rótulo de texto e/ou uma imagem").
   Um sublinhado duplo em um nome do Tkx equivale a `::` no Tcl [2]. O `=>` é
   a "vírgula gorda" (fat comma) do Perl, que associa uma opção ao seu valor.
   O padding acrescenta espaço em volta do texto para que a janela não fique
   minúscula.
5. **`$label->g_pack`**: o `pack` é "a geometry manager that arranges the
   children of a parent by packing them in order around the edges of the
   parent" [6] (tradução livre: "um gerenciador de geometria que organiza os
   filhos de um pai empacotando-os em ordem em torno das bordas do pai"). Um
   widget que nenhum gerenciador de geometria posicionou não é exibido.
6. **A autoverificação** (`if (($ENV{TF_VERIFY} // '') eq '1')`) só é
   executada com `./run.sh --verify`. O `Tkx::update()` faz o Tk processar
   todos os eventos pendentes, o que coloca "the application 'up to date'"
   [7] (tradução livre: "a aplicação 'em dia'"), de modo que a janela é
   desenhada. O `g_winfo_viewable` é verdadeiro se a janela está mapeada
   (exibida) [8]. Em seguida, o texto do rótulo é impresso e o
   `Tkx::after(2000, sub { ... })` fecha a janela 2000 ms depois [9]. O
   `sub { ... }` é uma função anônima, um valor que guarda código. Esperar
   por um evento de "visibilidade" não funciona com o Tk 9.1 no macOS, de
   modo que o programa consulta o estado da janela depois de um `update`,
   como fazem os outros exemplos desktop com Tk.
7. **`Tkx::MainLoop()`** "will enter the Tk mainloop and start processing
   events" [2] (tradução livre: "entrará no laço principal do Tk e começará
   a processar eventos"). Esse *laço de eventos* é a grande diferença em
   relação ao [cli](../cli/hello.pl), que é executado uma vez e termina. O
   servidor [web](../web/app.pl) também tem um laço, que aguarda requisições.

## Por que esta toolchain
**Esta é uma solução de compromisso.** A maneira mais conhecida de desenhar
janelas em Perl é o Perl/Tk (a distribuição `Tk` do CPAN) [10]. Ele não é
usado aqui, pelo seguinte motivo: no macOS, ele precisa de um servidor X11. O
`README.darwin` dele para o macOS manda o leitor "install the X11 SDK ... else
the make will fail" [11] (tradução livre: "instalar o SDK do X11 ... ou o
make falhará"). O macOS não tem X11 próprio: o XQuartz, o X11 de código
aberto para o macOS, é um projeto separado e uma instalação separada, e a
Apple distribuiu o X11 apenas com o OS X 10.5 até o 10.7 [17]. A máquina de
desenvolvimento não tem X11 instalado, e uma janela desenhada por meio do X11
não seria uma janela nativa do macOS. Esta pasta, portanto, não foi
construída com o Perl/Tk, e nada aqui afirma que o Perl/Tk funciona nesta
máquina.

O **Tkx** é usado no lugar dele, e faz o mesmo trabalho por outro caminho. O
Tcl.pm embute um interpretador Tcl no Perl [1], e o Tkx se comunica com o Tk
por meio dele [2]. O Tcl/Tk é o do sistema: no macOS, o mesmo `tcl-tk` 9.1.0
do Homebrew [12] que os exemplos desktop de Python e Ruby deste repositório
usam, desenhando janelas nativas (Aqua) sem X11. Assim, a solução de
compromisso não custa nenhuma pilha GUI extra, mas tem dois preços:

- o toolkit é uma instalação do Tcl/Tk mais uma compilação em C do Tcl.pm, em
  vez de um único comando `cpan`;
- o Tkx 1.10 foi lançado em 2021 [2], e sua API é uma camada fina sobre o
  Tcl, de modo que o código se lê como a documentação do Tcl/Tk
  (`new_ttk__label`, `g_pack`) e não como um Perl típico.

Como os módulos são baixados do CPAN, o `install.sh` confere o checksum
SHA-256 de cada tarball com o valor fixado em `tkx-env.sh`. Os mesmos valores
constam nos registros de versão do MetaCPAN para o Tcl e o Tkx [1][2].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Perl 5.34.1 do sistema, Tcl/Tk 9.1.0 do `tcl-tk` do Homebrew, Tcl.pm 1.53, Tkx 1.10, Apple clang 21.0.0. O Homebrew diz "Intel macOS remains Tier 3", em que "bottles will rarely be built or published" [13] (tradução livre: "o macOS Intel continua no Tier 3", em que "bottles raramente serão compiladas ou publicadas"), de modo que o `brew install tcl-tk` compila a partir do código-fonte aqui (cerca de 5 minutos na máquina de desenvolvimento). Se o programa for iniciado sem um terminal (por exemplo, por um script sem tty), o Tk também abre sua própria janela "Console", que não faz parte deste programa. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos do Intel: `brew install tcl-tk` (o Homebrew fornece um pacote pronto para o Apple Silicon [12]) e depois `./install.sh`. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `perl` com o apt quando ele não existe e `tcl-dev` e `tk-dev` quando os arquivos de desenvolvimento do Tcl não existem [14][15]. Em seguida, compila o Tcl.pm e o Tkx contra o Tcl 8.6 em `local/`. A janela abre em um display X virtual (Xvfb). |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O Perl do Git Bash não consegue compilar módulos; por isso o `install.sh` instala os pacotes do MSYS2 para Perl, GCC, `mingw32-make`, Tcl 8.6 e Tk 8.6 com o `pacman` (o MSYS2 já vem instalado em `C:\msys64`). Em seguida, compila o Tcl.pm e o Tkx contra o Tcl/Tk do MSYS2 em `local/`. O Strawberry Perl [16] também funcionaria. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
O `./run.sh` abre uma janela pequena intitulada "Hello, World!" com o texto
"Hello, World!" no meio (macOS, modo escuro):

![A janela intitulada "Hello, World!" exibindo o texto "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 em macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura somente aquela janela. Ela exige a permissão Gravação do Áudio do Sistema e da Tela (Screen & System Audio Recording)
em Ajustes do Sistema (System Settings) → Privacidade e Segurança (Privacy & Security).)

O `./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: Tkx asks Tk to create a native window; MainLoop keeps it open.
Hello, World!
```

## Fontes
1. Tcl: Tcl extension module for Perl (release 1.53). Vadim Konovalov and others, MetaCPAN. <https://metacpan.org/pod/Tcl> (acessado em 2026-11-04)
2. Tkx: Yet another Tk interface (release 1.10). Gisle Aas and others, MetaCPAN. <https://metacpan.org/pod/Tkx> (acessado em 2026-11-04)
3. ExtUtils::MakeMaker: INSTALL_BASE. Perl 5 porters, MetaCPAN. <https://metacpan.org/pod/ExtUtils::MakeMaker#INSTALL_BASE> (acessado em 2026-11-04)
4. wm. Tcl/Tk 9.0 manual. <https://www.tcl-lang.org/man/tcl9.0/TkCmd/wm.html> (acessado em 2026-11-04)
5. ttk::label. Tcl/Tk 9.0 manual. <https://www.tcl-lang.org/man/tcl9.0/TkCmd/ttk_label.html> (acessado em 2026-11-04)
6. pack. Tcl/Tk 9.0 manual. <https://www.tcl-lang.org/man/tcl9.0/TkCmd/pack.html> (acessado em 2026-11-04)
7. update. Tcl/Tk 9.0 manual. <https://www.tcl-lang.org/man/tcl9.0/TclCmd/update.html> (acessado em 2026-11-04)
8. winfo. Tcl/Tk 9.0 manual. <https://www.tcl-lang.org/man/tcl9.0/TkCmd/winfo.html> (acessado em 2026-11-04)
9. after. Tcl/Tk 9.0 manual. <https://www.tcl-lang.org/man/tcl9.0/TclCmd/after.html> (acessado em 2026-11-04)
10. Tk: a graphical user interface toolkit for Perl (Perl/Tk, release 804.036). MetaCPAN. <https://metacpan.org/dist/Tk> (acessado em 2026-11-04)
11. README.darwin in Tk-804.036 (Perl/Tk). Perl/Tk authors, MetaCPAN. <https://metacpan.org/release/SREZIC/Tk-804.036/source/README.darwin> (acessado em 2026-11-04)
12. `tcl-tk` formula. Homebrew. <https://formulae.brew.sh/formula/tcl-tk> (acessado em 2026-11-04)
13. Support Tiers. Homebrew. <https://docs.brew.sh/Support-Tiers> (acessado em 2026-11-04)
14. `tcl-dev` package (Debian stable). Debian. <https://packages.debian.org/stable/tcl-dev> (acessado em 2026-11-04)
15. `tk-dev` package (Debian stable). Debian. <https://packages.debian.org/stable/tk-dev> (acessado em 2026-11-04)
16. Perl Download. perl.org. <https://www.perl.org/get.html> (acessado em 2026-11-04)
17. XQuartz. The XQuartz project. <https://www.xquartz.org/> (acessado em 2026-11-04)
18. perlrun: PERL5LIB. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/perlrun> (acessado em 2026-11-04)
