---
source: languages/pascal/desktop/README.md
source_sha: 332a13f6169ad64da2d8d76e1d0d06e484d82780
---
# Pascal · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Pascal](../README.md)

## O que é
Um programa desktop que abre uma pequena janela intitulada "Hello, World!"
com o texto **Hello, World!** no centro. É um projeto **Lazarus**: o Lazarus
é "a Delphi compatible cross-platform IDE for Free Pascal" (tradução livre:
"um IDE multiplataforma compatível com o Delphi para o Free Pascal") que
"includes LCL which is more or less compatible with Delphi's VCL" [1]
(tradução livre: "inclui a LCL, que é mais ou menos compatível com a VCL do
Delphi"). A LCL, a "Lazarus component library" (tradução livre: "biblioteca
de componentes do Lazarus"), "contains platform independent visual
components" [2] (tradução livre: "contém componentes visuais independentes
de plataforma"): o mesmo código desenha uma janela Cocoa nativa no macOS,
uma janela Win32 no Windows e uma janela GTK ou Qt no Linux.

O projeto é compilado pela linha de comando com o **lazbuild**, a ferramenta
de build do Lazarus; assim, não é necessário abrir o IDE. O código é
**Object Pascal** (o modo `objfpc` do Free Pascal), não o Pascal Padrão ISO
de [../cli](../cli/); ver [Comparação com o cli](#comparação-com-o-cli).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Free Pascal (`fpc`) | 3.2.2, versão oficial para macOS em `~/.local/fpc-3.2.2` (como em [../cli](../cli/README.md#prerequisites)) | compila as unidades Pascal e vincula o programa |
| lazbuild + LCL | Lazarus 4.8, compilado a partir da versão oficial do código-fonte em `~/.local/lazarus-4.8` pelo `install.sh` | compila o projeto e fornece a biblioteca de GUI |
| Linkeditor da Apple e `make` | Command Line Tools (Apple clang 21.0.0) | o FPC vincula com o linkeditor do sistema; o `make` compila o lazbuild |

**Por que o Lazarus é compilado a partir do código-fonte no macOS.** O cask
`lazarus` do Homebrew está desativado desde 2026-01-27 (ele "no longer meets
the criteria for acceptable casks", em tradução livre: "não atende mais aos
critérios para casks aceitáveis"; a sua última versão foi a 3.6) [3]. O
download oficial do Lazarus 4.8 para macOS é um zip com o IDE pré-compilado,
publicado ao lado de um **release candidate 3.2.4 do Free Pascal**
(`fpc-3.2.4rc1a.intelarm64-macosx.dmg`) [17]. Este projeto usa o FPC 3.2.2
estável nas duas pastas e precisa apenas do lazbuild, não do IDE. O Lazarus
pode ser compilado a partir da sua versão de código-fonte com `make`. O seu
README indica `make clean bigide` para o IDE completo [2], e o seu
`Makefile.fpc` tem um alvo `lazbuild` separado e menor, a primeira etapa de
`bigide` [5], que é tudo de que este projeto precisa. Por isso, o script
`install.sh`:

1. instala o Free Pascal 3.2.2 se ele estiver ausente, como em
   [../cli](../cli/README.md#prerequisites) (o `fpc` do Homebrew não compila
   em Macs com Intel);
2. baixa `lazarus-4.8-0.tar.gz` do SourceForge, onde a equipe do Lazarus
   publica as suas versões [6], e verifica o seu SHA-256 (calculado a partir
   do arquivo cujo MD5 corresponde ao que o SourceForge lista; ver
   `lazarus-env.sh`);
3. o descompacta em `~/.local/lazarus-4.8` e executa `make lazbuild` ali.

Sem `sudo`: tudo vai para a pasta pessoal do usuário. Exclua
`~/.local/lazarus-4.8` (e `~/.local/fpc-3.2.2`) para desinstalar. Na máquina
de desenvolvimento, todo o `install.sh` levou cerca de 3 minutos a partir do
zero, com os downloads já em cache (2026-11-01).

O Lazarus 4.8 (2026-06-11) é a versão estável mais recente; a 5.0 está no
release candidate 1 [7].

## Início rápido
```sh
./install.sh   # check / install Free Pascal and lazbuild (asks before installing)
./build.sh     # lazbuild hello.lpi -> bin/hello-desktop (first time: also compiles the LCL)
./run.sh       # open the window; close it to end the program
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `fpc-env.sh` | O mesmo arquivo de [../cli](../cli/): versão, soma de verificação e pasta do Free Pascal; coloca `~/.local/fpc-3.2.2/bin` no `PATH` quando o FPC está instalado ali. | Cada pasta de implementação permanece independente. |
| `lazarus-env.sh` | Define `LAZARUS_VERSION`, `LAZARUS_SHA256`, `LAZARUS_DIR` (padrão `~/.local/lazarus-4.8`) e escolhe o comando do lazbuild: `$LAZARUS_DIR/lazbuild` com `--lazarusdir` e `--pcp`, se existir; caso contrário, `lazbuild` do `PATH`. | Um único lugar para a versão e a pasta do Lazarus. `--pcp` ("Primary config directory where Lazarus stores its config files", padrão `~/.lazarus` [8]; em tradução livre: "Diretório de configuração principal onde o Lazarus guarda os seus arquivos de configuração") mantém as configurações desta instalação do Lazarus separadas de qualquer outra instalação do Lazarus. |
| `install.sh` | 1. Verifica `fpc`. 2. Verifica `lazbuild`. Se estiver ausente no macOS: as etapas acima. No Debian/Ubuntu: `sudo apt-get install -y fpc` e `sudo apt-get install -y lazarus`. No Windows: imprime o link do instalador do Lazarus. Tudo é executado somente se a resposta for `y`. | O Pascal Padrão não tem janelas; a LCL acompanha o Lazarus. |
| `build.sh` | Executa `lazbuild hello.lpi` (mais as opções de `lazarus-env.sh`) e imprime o comando. `LCL_WS=qt5 ./build.sh` passa `--ws=qt5` para selecionar outro widgetset. | O lazbuild conhece o projeto inteiro: unidades, arquivo de formulário, o pacote LCL e o caminho de saída. |
| `run.sh` | Executa `./bin/hello-desktop`. Com `--verify`, define `TF_VERIFY=1`: a aplicação imprime o texto do rótulo quando a janela é exibida e se fecha após 2 segundos. | O executável é código de máquina. `--verify` permite que `scripts/verify-all.sh` verifique um programa GUI sem interação humana. |

**O que `lazbuild hello.lpi` faz.** O seu texto de ajuda: "lazbuild [options]
<project/package filename or package name>" [8]. Ele lê `hello.lpi`, vê que
o projeto precisa do pacote `LCL`, compila a LCL e os pacotes subjacentes
para o widgetset escolhido, se ainda não estiverem compilados (cerca de 280
unidades no primeiro build; 50 segundos na máquina de desenvolvimento) e,
depois, chama o `fpc` para `hello.lpr` e `mainunit.pas` e vincula
`bin/hello-desktop`. Os builds seguintes recompilam apenas o que mudou.

**Qual widgetset?** `--ws` é opcional: "Override the project widgetset
... Default: cocoa" no macOS [8] (tradução livre: "Substitui o widgetset do
projeto ... Padrão: cocoa"). No Lazarus 4.8, o padrão é `win32` no Windows,
`cocoa` no macOS e `gtk2` em outros sistemas, como o Linux [9].

## Estrutura de pastas
```text
desktop/
├── README.md        this file
├── fpc-env.sh       Free Pascal version, checksum and folder (sourced)
├── lazarus-env.sh   Lazarus version, checksum, folder, lazbuild command (sourced)
├── install.sh       checks / installs Free Pascal and lazbuild
├── build.sh         lazbuild hello.lpi
├── run.sh           runs bin/hello-desktop
├── hello.lpi        Lazarus project information (XML): units, LCL dependency, output path
├── hello.lpr        Lazarus program: the main program, starts the application
├── mainunit.pas     the form (window) class and its event handlers
├── mainunit.lfm     the form's description: size, title, label, timer
├── screenshot.png   the window on macOS (used below)
├── bin/             created by build.sh; not committed (see ../../../.gitignore)
│   └── hello-desktop
└── lib/x86_64-darwin/   compiled units (.o, .ppu); not committed
```
Este é o layout que o IDE Lazarus cria para um novo projeto "Application":
um arquivo de projeto `.lpi`, um programa principal `.lpr` e um par `.pas` +
`.lfm` por formulário. É possível abrir `hello.lpi` no IDE Lazarus (se ele
estiver instalado) e ver a mesma janela no designer de formulários.

## Passo a passo
Abra os arquivos ao lado desta lista.

1. **`hello.lpi`** é um XML que o Lazarus normalmente escreve. As partes que
   importam: `RequiredPackages` lista `LCL`; `Units` lista `hello.lpr` e
   `mainunit.pas` (com o seu formulário `MainForm`); `Target/Filename` é
   `bin/hello-desktop`; `UnitOutputDirectory` é
   `lib/$(TargetCPU)-$(TargetOS)`.
2. **`hello.lpr`** é um `program` Pascal comum. `{$mode objfpc}` seleciona o
   dialeto Object Pascal: "the same mode as FPC mode, but it also includes
   classes, interfaces and exceptions" [10] (tradução livre: "o mesmo modo
   do modo FPC, mas que também inclui classes, interfaces e exceções").
   `{$H+}` faz de `String` uma `AnsiString` [11], uma string com contagem de
   referências e de qualquer comprimento, em vez de uma "shortstring" de no
   máximo 255 caracteres [12].
3. **`uses Interfaces, Forms, MainUnit;`** `Interfaces` conecta a LCL ao
   widgetset escolhido (o modelo do Lazarus o comenta como "this includes
   the LCL widgetset" [13], em tradução livre: "isto inclui o widgetset da
   LCL"); `Forms` tem o objeto `Application`.
4. **`Application.Initialize; Application.CreateForm(...);
   Application.Run;`** cria o formulário principal e executa o laço de
   eventos, que retorna quando a janela é fechada. Compare com
   `g_application_run` no [C desktop](../../c/desktop/) ou `mainloop()` no
   [Python desktop](../../python/desktop/).
5. **`mainunit.pas`** declara `TMainForm = class(TForm)`, uma classe que
   herda de `TForm`, com dois campos, `HelloLabel` e `VerifyTimer`. Uma
   unidade tem uma parte pública, `interface`, e uma parte privada,
   `implementation`, uma divisão que o C faz entre arquivos `.h` e `.c`.
6. **`{$R *.lfm}`** coloca `mainunit.lfm` no executável como um recurso; "the
   asterisk can be used as a placeholder for the current unit/program
   filename" [11] (tradução livre: "o asterisco pode ser usado como
   marcador do nome de arquivo da unidade/programa atual"). Quando o
   formulário é criado, a LCL lê esse recurso, cria o rótulo e o temporizador
   e conecta `OnShow = FormShow` e `OnTimer = VerifyTimerTimer` pelo nome.
7. **`mainunit.lfm`** é texto simples: a janela tem 320 × 160, é intitulada
   "Hello, World!", e o rótulo a preenche (`Align = alClient`) com o texto
   centralizado (`Alignment = taCenter`, `Layout = tlCenter`).
   **Experimente:** altere o `Caption` do rótulo e execute
   `./build.sh && ./run.sh`.
8. **A autoverificação** (`FormShow`): somente com `TF_VERIFY=1`, ela imprime
   o texto do rótulo com `WriteLn` e inicia o temporizador de 2 segundos,
   cujo tratador chama `Close`. Fechar o formulário principal encerra o
   programa.

## Comparação com o cli
| | [cli](../cli/) | desktop |
|---|---|---|
| Dialeto | Pascal Padrão ISO 7185 (`-Miso`) | Object Pascal (`{$mode objfpc}{$H+}`) |
| Build | `fpc` em um único arquivo | `lazbuild` em um projeto (`.lpi`), que chama o `fpc` |
| Arquivos | `hello.pas` | `hello.lpi`, `hello.lpr`, `mainunit.pas`, `mainunit.lfm` |
| Saída | `writeln` no terminal | um rótulo em uma janela nativa |
| Termina | após a última instrução | quando a janela é fechada (laço de eventos) |

## Por que esta toolchain
- **O Lazarus é o ambiente livre e mantido ao estilo do Delphi.** O Delphi
  (1995) é um ambiente comercial de Object Pascal com projeto visual de
  formulários [14]. O Lazarus foi "started in February of 1999" [1] (tradução
  livre: "iniciado em fevereiro de 1999") para levar esse estilo ao Free
  Pascal, e a sua LCL é "more or less compatible with Delphi's VCL" [1]
  (tradução livre: "mais ou menos compatível com a VCL do Delphi").
- **Multiplataforma por recompilação.** "Unlike Java which strives to be a
  write once run anywhere, Lazarus and Free Pascal strives for write once
  compile anywhere" [1] (tradução livre: "Ao contrário do Java, que busca
  ser escreva uma vez, execute em qualquer lugar, o Lazarus e o Free Pascal
  buscam escreva uma vez, compile em qualquer lugar"). A LCL oferece suporte
  a vários widgetsets por sistema (por exemplo, "macOS (Cocoa, Carbon, Gtk2,
  Qt4, Qt5, Qt6)" e "Linux/FreeBSD (Gtk2, Gtk3, Qt4, Qt5, Qt6)") [2].
- **Atual.** O Lazarus 4.8 foi lançado em 2026-06-11 [7].
- **lazbuild em vez do IDE** mantém os scripts deste projeto iguais aos de
  todo o resto deste repositório: instalar, compilar e executar.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | FPC 3.2.2 (versão oficial) e Lazarus 4.8 compilado a partir do código-fonte, widgetset Cocoa. A vinculação imprime avisos inofensivos do linkeditor mais novo da Apple (`-macosx_version_min has been renamed...`, `-multiply_defined is obsolete`, `ignoring duplicate libraries: '-lc'`, `no platform load command found in ...hello.or`). O programa é um executável simples, não um pacote `.app` (`UseAppBundle` está desativado em `hello.lpi`); na máquina de desenvolvimento, a janela apareceu com a barra de título cinza (inativa), como na captura de tela. |
| macOS Apple Silicon | ⚠️ não verificado | O mesmo caminho do `install.sh` (a versão do FPC cobre as duas CPUs [15]); o Lazarus também oferece um download aarch64 para macOS [4]; `make lazbuild` deve funcionar do mesmo modo (não testado). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `fpc`, `lazarus` e `libgtk2.0-dev` com o apt quando faltam. O widgetset padrão é o gtk2 [9]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o Chocolatey e instala o Lazarus 4.0.0, que inclui o Free Pascal 3.2.2, com `choco install lazarus --version=4.0.0` quando o `fpc` ou o `lazbuild` não existe. O `hello.lpi` marca o programa como uma aplicação gráfica do Windows, que não tem console; por isso a saída da autoverificação de `--verify` pode não aparecer ali. O WSL não foi verificado; ele se comporta como o Linux, e uma janela exige o WSLg ou um servidor X. |

## Saída esperada
`./run.sh` abre esta janela:

![A janela da LCL do Lazarus intitulada "Hello, World!" exibindo o texto "Hello, World!"](screenshot.png)

(Captura feita em 2026-11-01 no macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura somente essa janela.)

`./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: the LCL, compiled into bin/hello-desktop, opens the window and draws the label.
    Self-check: the app prints the label text and closes after ~2 seconds.
Hello, World!
```

## Fontes
1. About Lazarus. Lazarus. <https://www.lazarus-ide.org/index.php?page=about> (acessado em 2026-11-01)
2. Lazarus README (LCL, supported widgetsets, building with make), tag `lazarus_4_8`. Lazarus, GitLab. <https://gitlab.com/freepascal.org/lazarus/lazarus/-/blob/lazarus_4_8/README.md> (acessado em 2026-11-01)
3. `lazarus` cask (disabled 2026-01-27). Homebrew Formulae. <https://formulae.brew.sh/cask/lazarus> (acessado em 2026-11-01)
4. Lazarus downloads (Windows installers with FPC 3.2.2, macOS x86-64 and aarch64). Lazarus. <https://www.lazarus-ide.org/index.php?page=downloads> (acessado em 2026-11-01)
5. Lazarus `Makefile.fpc` (`lazbuild:` and `bigide: lazbuild lcl ...`), tag `lazarus_4_8`. Lazarus, GitLab. <https://gitlab.com/freepascal.org/lazarus/lazarus/-/blob/lazarus_4_8/Makefile.fpc> (acessado em 2026-11-01)
6. Lazarus 4.8 source release files (with MD5 checksums). SourceForge. <https://sourceforge.net/projects/lazarus/files/Lazarus%20Zip%20_%20GZip/Lazarus%204.8/> (acessado em 2026-11-01)
7. Lazarus home page (news: "Lazarus Bugfix Release 4.8 - June 11, 2026", "Lazarus Release Candidate 1 of 5.0"). Lazarus. <https://www.lazarus-ide.org/> (acessado em 2026-11-01)
8. `lazbuild --help`, Lazarus 4.8 (run on the dev machine, 2026-11-01); source: `ide/lazbuild.lpr`. <https://gitlab.com/freepascal.org/lazarus/lazarus/-/blob/lazarus_4_8/ide/lazbuild.lpr> (acessado em 2026-11-01)
9. `lcl/lclplatformdef.pas` (`BuildLCLWidgetType`), tag `lazarus_4_8`. Lazarus, GitLab. <https://gitlab.com/freepascal.org/lazarus/lazarus/-/blob/lazarus_4_8/lcl/lclplatformdef.pas> (acessado em 2026-11-01)
10. Free Pascal User's Guide, compiler modes, LaTeX source. Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/user.tex> (acessado em 2026-11-01)
11. Free Pascal Programmer's Guide, directives `$H` / `$LONGSTRINGS` and `$R` / `$RESOURCE`, LaTeX source. Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/prog.tex> (acessado em 2026-11-01)
12. Free Pascal Reference Guide, string types (ShortString, AnsiString), LaTeX source. Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/ref.tex> (acessado em 2026-11-01)
13. `ide/projectdescriptortypes.pas` (the "Application" project template), tag `lazarus_4_8`. Lazarus, GitLab. <https://gitlab.com/freepascal.org/lazarus/lazarus/-/blob/lazarus_4_8/ide/projectdescriptortypes.pas> (acessado em 2026-11-01)
14. The long and winding road to today's Delphi: happy 29th birthday ("Delphi 1 (Feb 14, 1995)"). Embarcadero blog. <https://blogs.embarcadero.com/the-long-and-winding-road-to-todays-delphi-happy-29th-birthday/> (acessado em 2026-11-01)
15. Free Pascal 3.2.2 for macOS (release files). SourceForge. <https://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/3.2.2/> (acessado em 2026-11-01)
16. `fpc` (3.2.2+dfsg-46) and `lazarus` (4.0+dfsg-3) in Debian stable. Debian archive (`madison`). <https://api.ftp-master.debian.org/madison?package=fpc&s=stable>, <https://api.ftp-master.debian.org/madison?package=lazarus&s=stable> (acessado em 2026-11-01)
17. Lazarus 4.8 for macOS x86-64 (files: `lazarus-darwin-x86_64-4.8.zip`, `fpc-3.2.4rc1a.intelarm64-macosx.dmg`, README). SourceForge. <https://sourceforge.net/projects/lazarus/files/Lazarus%20macOS%20x86-64/Lazarus%204.8/> (acessado em 2026-11-01)
