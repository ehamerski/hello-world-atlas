---
source: languages/cpp/desktop/README.md
source_sha: 8b3d3964b010bfab6ea178663660bac6e63449bb
---
# C++ · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [C++](../README.md)

## O que é
Um programa desktop que abre uma janela nativa com o título "Hello, World!"
e mostra o texto `Hello, World!` em seu centro. A janela é desenhada pelo
**Qt 6 Widgets**. O Qt é um toolkit de GUI escrito em C++, e o código é
compilado como ISO C++20 com o CMake.

É o gêmeo em C++ do [desktop de C](../../c/desktop/), que usa o GTK 4. Os
dois programas fazem a mesma coisa: criam um objeto de aplicação, criam um
rótulo, o exibem e executam o laço de eventos. A diferença é a linguagem. O
GTK emula classes em C com structs, macros de conversão (*cast*) e callbacks
`void *`. O Qt tem classes de verdade, objetos na pilha e lambdas.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Um compilador C++ (`c++`) | Apple clang 21.0.0 (Command Line Tools) | compila `hello.cpp` |
| CMake | 4.4.5 (Homebrew) | encontra o Qt e gera os arquivos de build |
| Qt 6 base (`qtbase`) | 6.12.0 (Homebrew) | os módulos Qt Widgets, Qt GUI e Qt Core |

"Qt 6 requires a compiler supporting C++ version 17 or newer" [1] (tradução
livre: "O Qt 6 exige um compilador com suporte à versão 17 do C++ ou
posterior"); esta pasta usa o C++20.

## Início rápido
```sh
./install.sh   # check for c++, CMake and Qt 6 (asks before installing)
./build.sh     # configure and build into build/hello-desktop
./run.sh       # open the window (close it to quit)
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica `c++`, `cmake` e o Qt 6. Para o Qt, procura `Qt6Config.cmake`, o arquivo que `find_package(Qt6)` carrega. Se algo estiver faltando, oferece `brew install qtbase` (macOS) ou `sudo apt-get install -y qt6-base-dev` (Debian/Ubuntu), ou imprime os comandos do MSYS2 (Windows), e só os executa se a resposta for `y`. | O C++ padrão não tem janelas; por isso, a GUI vem de uma biblioteca. O C++ não tem gerenciador de pacotes próprio. |
| `build.sh` | Executa `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release` e depois `cmake --build build`. | A configuração encontra o Qt; a compilação compila e vincula. |
| `run.sh` | Executa `./build/hello-desktop`. `--verify` define `TF_VERIFY=1`: a aplicação imprime o texto do rótulo e encerra após 2 s. | Uma aplicação desktop normalmente espera pelo usuário; a autoverificação permite que `scripts/verify-all.sh` a execute sem acompanhamento. |

**Apenas o `qtbase`.** O Qt é dividido em módulos. A fórmula `qtbase` do
Homebrew contém o Qt Core, o Qt GUI e o Qt Widgets, que é tudo o que este
programa usa. Em Macs Intel, o Homebrew não tem `qtbase` pronto (*bottled*):
os *bottles* dele para macOS existem apenas para Apple Silicon [2]. Por
isso, na máquina de teste, `brew install qtbase` compilou o Qt a partir do
código-fonte, o que leva muito mais tempo do que baixar um *bottle*. No
Apple Silicon e no Linux, o pacote é baixado já pronto.

**O que `CMakeLists.txt` faz.** Ele segue o padrão do guia "Getting started
with CMake" do Qt [1]:
```cmake
find_package(Qt6 REQUIRED COMPONENTS Widgets)   # find Qt through Qt6Config.cmake
qt_standard_project_setup()                     # Qt's default project settings
qt_add_executable(hello-desktop hello.cpp)      # Qt's wrapper of add_executable
target_link_libraries(hello-desktop PRIVATE Qt6::Widgets)
```
`find_package` faz o trabalho que `pkg-config --cflags --libs gtk4` faz no
[desktop de C](../../c/desktop/README.md): informa ao compilador onde estão
os cabeçalhos e as bibliotecas. `Qt6::Widgets` também traz o Qt GUI e o Qt
Core. O log do build mostra `Automatic MOC and UIC`: `qt_standard_project_setup`
ativa os geradores de código do Qt (`moc`, para classes com sinais e slots).
Este programa não define nenhuma classe desse tipo; portanto, eles não têm
nada a fazer.

## Estrutura de pastas
```text
desktop/
├── README.md        this file
├── install.sh       checks / installs c++, CMake and Qt 6
├── build.sh         configures and builds with CMake
├── run.sh           opens the window (--verify: self-check)
├── CMakeLists.txt   the CMake project: C++20, links Qt6::Widgets
├── hello.cpp        the program
├── screenshot.png   the window, for "Expected output" below
└── build/           created by build.sh; not committed
    └── hello-desktop
```
O guia do Qt coloca o `CMakeLists.txt` ao lado dos arquivos-fonte, como aqui
[1]. Uma aplicação Qt maior acrescenta arquivos `.ui` (formulários criados no
Qt Designer) e um par `.cpp` / `.h` por classe de janela.

## Passo a passo
Abra [`hello.cpp`](hello.cpp) ao lado de
[`../../c/desktop/hello.c`](../../c/desktop/hello.c).

1. **Cabeçalhos.** Um cabeçalho por classe: `<QApplication>`, `<QLabel>`,
   `<QTimer>`. `<cstdlib>` e `<cstring>` do C são os cabeçalhos `stdlib.h` e
   `string.h` com seus nomes no espaço de nomes (namespace) `std` [3]. O GTK traz tudo
   com um único `<gtk/gtk.h>`.
2. **`QApplication app(argc, argv);`** "The QApplication class manages the
   GUI application's control flow and main settings" [4] (tradução livre: "A
   classe QApplication gerencia o fluxo de controle e as configurações
   principais da aplicação com GUI"). `app` é um objeto declarado como um
   `int`, na pilha. Quando `main` retorna, o C++ chama automaticamente o
   *destrutor* dele e o Qt faz a limpeza. Isso é o RAII ("resource
   acquisition is initialization", aquisição de recurso é inicialização). A
   versão em C precisa chamar `g_object_unref(app)` por conta própria.
3. **`QLabel label("Hello, World!");`** "The QLabel widget provides a
   text or image display" [5] (tradução livre: "O widget QLabel exibe texto
   ou imagem"). Um widget criado sem pai se torna uma janela própria; assim,
   não é necessário um objeto de janela separado. O GTK precisa de
   `gtk_application_window_new` mais `gtk_window_set_child`.
4. **Funções-membro.** `label.setWindowTitle(...)`,
   `label.setAlignment(Qt::AlignCenter)`, `label.resize(320, 160)`,
   `label.show()`. O objeto vem antes do ponto. Na API em C do GTK, o objeto
   é o primeiro argumento e antes precisa ser convertido com uma macro:
   `gtk_window_set_title(GTK_WINDOW(window), ...)`. Em C++, o compilador sabe
   que um `QLabel` é um `QWidget` (herança); portanto, nenhuma conversão é
   necessária.
5. **Autoverificação (`TF_VERIFY=1`).** O programa imprime `label.text()` e
   chama `QTimer::singleShot(2000, [&app] { app.quit(); });`. A função
   `singleShot` "calls functor after interval" [6] (tradução livre: "chama o
   functor após o intervalo"). O functor aqui é uma **lambda**: uma função sem
   nome escrita no próprio local, que captura `app` por referência
   (`[&app]`). A versão em C precisa de uma função nomeada à parte,
   `quit_app`, e passa a aplicação a ela como um `gpointer` (um `void *`).
6. **`return app.exec();`** "Enters the main event loop and waits until
   exit() is called" [4] (tradução livre: "Entra no laço de eventos
   principal e aguarda até que exit() seja chamada"). O laço de eventos
   "receives events from the window system and dispatches these to the
   application widgets" [4] (tradução livre: "recebe eventos do sistema de
   janelas e os despacha para os widgets da aplicação"). Equivale ao
   `g_application_run` do GTK.
7. **Sinais e slots.** O Qt conecta objetos com *sinais e slots*: "In Qt, we
   have an alternative to the callback technique: We use signals and slots"
   [7] (tradução livre: "No Qt, há uma alternativa à técnica de callback:
   usamos sinais e slots"). O Qt afirma que isso é "type safe: The signature
   of a signal must match the signature of the receiving slot" [7] (tradução
   livre: "seguro quanto a tipos: a assinatura de um sinal deve corresponder
   à assinatura do slot receptor"). Um tratador de sinal do GTK recebe seus
   dados por meio de `gpointer`, que o compilador não consegue verificar.
   Este programa Hello World não precisa de sinal; `singleShot` é o único
   callback.
8. **Tamanho e bibliotecas.** `build/hello-desktop` tem 32.840 bytes na
   máquina de teste (macOS Intel); `otool -L` lista os frameworks QtWidgets,
   QtGui e QtCore do Homebrew, frameworks de sistema da Apple (AppKit,
   Metal, ...), `libc++` e `libSystem`. Como a versão em C, o programa é
   pequeno porque o toolkit é vinculado dinamicamente.

## Por que esta toolchain
- **Qt 6 Widgets.** O Qt é escrito em C++; assim, a API dele é a API própria
  do toolkit, e não uma *binding*. O Widgets é o módulo clássico de
  controles desktop do Qt (rótulos, botões, janelas); ele faz parte do
  `qtbase`, de modo que nada além do módulo base é necessário.
- **Licença.** "Qt licensed under the GNU Lesser General Public License
  (LGPL) version 3 is appropriate for the development of Qt applications
  provided you can comply with the terms and conditions of the GNU LGPL
  version 3 (or GNU GPL version 3)" [8] (tradução livre: "O Qt licenciado
  sob a GNU Lesser General Public License (LGPL) versão 3 é apropriado para
  o desenvolvimento de aplicações Qt, desde que seja possível cumprir os
  termos e as condições da GNU LGPL versão 3 (ou da GNU GPL versão 3)").
- **CMake.** O Qt 6 documenta o CMake para compilar projetos Qt e fornece
  seus próprios comandos CMake (`qt_add_executable`,
  `qt_standard_project_setup`) [1]. O Qt também exige um CMake recente: os
  projetos "are required to set version 3.16 or newer in the
  cmake_minimum_required command" [9] (tradução livre: "devem definir a
  versão 3.16 ou posterior no comando cmake_minimum_required"); este define
  a 3.20, como as outras pastas C++.
- **`qtbase` do Homebrew em vez do instalador online do Qt.** No macOS, este
  repositório instala as toolchains com o Homebrew. A fórmula `qtbase`
  contém apenas os módulos base, enquanto a fórmula completa `qt` depende
  também de todas as outras fórmulas de módulos do Qt [2][12].

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | Apple clang 21.0.0, CMake 4.4.5, Qt 6.12.0 (`qtbase`, compilado a partir do código-fonte pelo Homebrew: sem *bottle* para Intel [2]). `./run.sh --verify` imprimiu `Hello, World!`; o programa é um executável simples, não um pacote `.app`. |
| macOS Apple Silicon | ⚠️ não verificado | `brew install qtbase` baixa um *bottle* [2]; mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `build-essential`, `cmake` e `qt6-base-dev` com o apt quando faltam [10]. Uma janela exige uma sessão gráfica. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o MSYS2 em `C:\msys64` e instala os pacotes UCRT64 `gcc`, `cmake`, `ninja` e `qt6-base` com o `pacman` quando faltam [11]. O WSL não foi verificado; ele se comporta como o Linux, e uma janela exige o WSLg ou um servidor X. |

## Saída esperada
`./run.sh` abre uma janela com o título "Hello, World!" e o texto
`Hello, World!` no meio. Feche-a para encerrar o programa.

![A janela do Qt 6 com o título "Hello, World!" mostrando o texto "Hello, World!"](screenshot.png)

(Capturada em 2026-11-01 no macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura apenas essa janela.)

`./run.sh --verify` (usado por `scripts/verify-all.sh`):
```text
==> Open the Hello World window
    WHY: Qt, loaded by build/hello-desktop, opens the window and draws the label.
    Self-check: the app prints the label text and closes after ~2 seconds.
Hello, World!
```

## Fontes
1. Getting started with CMake (Qt 6; C++17 requirement, example CMakeLists.txt). The Qt Company. <https://doc.qt.io/qt-6/cmake-get-started.html> (acessado em 2026-11-01)
2. `qtbase` (Homebrew formula: version and bottles). Homebrew. <https://formulae.brew.sh/formula/qtbase> (acessado em 2026-11-01)
3. C++ working draft, [headers] (C++ headers for C library facilities). ISO/IEC JTC1/SC22/WG21 draft, edição HTML. <https://eel.is/c++draft/headers> (acessado em 2026-11-01)
4. QApplication Class (Qt 6). The Qt Company. <https://doc.qt.io/qt-6/qapplication.html> (acessado em 2026-11-01)
5. QLabel Class (Qt 6). The Qt Company. <https://doc.qt.io/qt-6/qlabel.html> (acessado em 2026-11-01)
6. QTimer Class (Qt 6; `singleShot`). The Qt Company. <https://doc.qt.io/qt-6/qtimer.html> (acessado em 2026-11-01)
7. Signals & Slots (Qt 6). The Qt Company. <https://doc.qt.io/qt-6/signalsandslots.html> (acessado em 2026-11-01)
8. Qt Licensing (Qt 6). The Qt Company. <https://doc.qt.io/qt-6/licensing.html> (acessado em 2026-11-01)
9. Supported CMake Versions (Qt 6). The Qt Company. <https://doc.qt.io/qt-6/cmake-supported-cmake-versions.html> (acessado em 2026-11-01)
10. Package qt6-base-dev (stable). Debian. <https://packages.debian.org/stable/qt6-base-dev> (acessado em 2026-11-01)
11. mingw-w64-qt6-base (MSYS2 package). Projeto MSYS2. <https://packages.msys2.org/base/mingw-w64-qt6-base> (acessado em 2026-11-01)
12. `qt` (Homebrew formula: dependencies). Homebrew. <https://formulae.brew.sh/formula/qt> (acessado em 2026-11-03)
