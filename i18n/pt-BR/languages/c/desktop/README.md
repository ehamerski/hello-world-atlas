---
source: languages/c/desktop/README.md
source_sha: c09a6ea35ce83edd8f7fedfc0a28f583271af5de
---
# C · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [C](../README.md)

## O que é
Um programa desktop que abre uma pequena janela intitulada "Hello, World!"
com o texto **Hello, World!** no centro. A janela é desenhada pelo
**GTK 4**, "a free and open-source cross-platform widget toolkit" mantido
pelo GNOME [1] (tradução livre: "um toolkit de widgets multiplataforma,
livre e de código aberto"). O GTK "is written in C but has been designed to
support a wide range of languages" [1] (tradução livre: "é escrito em C, mas
foi projetado para oferecer suporte a uma ampla gama de linguagens"); assim,
o C é sua linguagem nativa: o `hello.c` chama a API do próprio GTK, sem
camada de *binding* no meio.

Compare com [../cli](../cli/): o `main` já não imprime e retorna. Ele
entrega o controle ao laço de eventos do GTK, que espera eventos da janela
até que ela seja fechada.

O código é compilado como **C99** (`-std=c99 -pedantic`), e não como C89,
como em [../cli](../cli/), porque os cabeçalhos do GTK não são C89 válido
(consulte [Por que C99 aqui](#por-que-c99-aqui)).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Um compilador C (`cc`) | Apple clang 21.0.0 (Command Line Tools 26.6) | compila o `hello.c` |
| pkg-config | pkgconf 3.0.10 (Homebrew) | imprime as opções para o GTK e para as bibliotecas sob ele |
| GTK 4 | 4.24.1, compilado a partir da versão-fonte do GNOME pelo `install.sh` (veja abaixo) | o toolkit de GUI |
| Dependências do GTK | GLib 2.90, Pango 1.58, Cairo 1.18, HarfBuzz, Graphene, libepoxy, ... (Homebrew) | o GTK é construído sobre elas; o `pkg-config` as adiciona automaticamente |
| Somente macOS Intel: Meson, Ninja | Meson 1.12.1, Ninja 1.13.2 (Homebrew) | para compilar o GTK a partir do código-fonte |

**O macOS Intel exige compilar o GTK a partir do código-fonte.** A fórmula
`gtk4` do Homebrew tem pacotes prontos (*bottles*) apenas para Apple Silicon
e Linux, e não para Macs Intel [2]. Sem um bottle, o Homebrew compila a
partir do código-fonte, e sua fórmula lista o `dart-sass` como dependência
de compilação [3]. Na máquina de teste (somente Command Line Tools, sem o
aplicativo Xcode), essa compilação falhou com:
```text
dartaotruntime: A full installation of Xcode.app is required to compile
this software. Installing just the Command Line Tools is not sufficient.
```
O tarball de versão do GTK não precisa do Sass: o `meson.build` do GTK só
compila seu tema com o Sass "For git checkouts, but not for tarballs"
(tradução livre: "Para checkouts do git, mas não para tarballs"), porque o
tarball já contém os arquivos CSS compilados [4]. Por isso, em Macs Intel, o
`install.sh` oferece compilar o próprio GTK a partir do tarball, seguindo as
instruções do próprio GTK ("meson setup --prefix /opt/gtk builddir", depois
compilar e instalar) [5]:

1. `brew install` das dependências de runtime do GTK (a lista da fórmula do
   Homebrew [3]) e das ferramentas de compilação Meson e Ninja. A maioria
   tem bottles para Intel; algumas podem ser compiladas pelo Homebrew, o que
   demora mais.
2. Baixar o `gtk-4.24.1.tar.xz` de `download.gnome.org` e verificar seu
   SHA-256 em relação ao valor publicado pelo GNOME [6].
3. `meson setup` com apenas a biblioteca habilitada (sem demos, testes,
   documentação, introspecção, GStreamer nem Vulkan) e, depois, `meson
   install` em `~/.local/gtk-4.24.1`. Sem `sudo`: tudo vai para a pasta
   pessoal do usuário. Basta apagar essa pasta para desinstalar.

O `gtk4-env.sh` guarda a versão, o checksum e a pasta, e adiciona o
`lib/pkgconfig` da pasta ao `PKG_CONFIG_PATH`, de modo que o `pkg-config` (e
o `build.sh`) encontrem este GTK. Na máquina de teste, a compilação do GTK
levou cerca de 3,5 minutos (2026-10-31, do `meson setup` ao fim do `meson
install`), além do tempo de que o Homebrew precisou para as dependências.
Com o aplicativo Xcode completo, espera-se que o `brew install gtk4`
funcione em seu lugar (não testado).

## Início rápido
```sh
./install.sh   # check cc, pkg-config and GTK 4 (asks before installing; may build GTK)
./build.sh     # compile hello.c as C99 and link GTK into bin/hello-desktop
./run.sh       # open the window; close it to end the program
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `gtk4-env.sh` | Carregado (`source`) pelos outros três: define `GTK4_VERSION`, `GTK4_SHA256`, `GTK4_PREFIX` (padrão `~/.local/gtk-4.24.1`) e antepõe `$GTK4_PREFIX/lib/pkgconfig` ao `PKG_CONFIG_PATH`. | Um único lugar para a versão e a pasta do GTK. |
| `install.sh` | 1. Verifica o `cc`. 2. Verifica o `pkg-config`. 3. Verifica `pkg-config --exists gtk4`. Se o GTK estiver ausente: `brew install gtk4` no Apple Silicon, a compilação a partir do código-fonte descrita acima no Intel, `sudo apt-get install -y libgtk-4-dev` no Debian/Ubuntu e o comando do MSYS2 no Windows. Tudo só é executado se a resposta for `y`. | O C não tem gerenciador de pacotes próprio; o GTK vem do gerenciador de pacotes do sistema operacional ou do código-fonte. |
| `build.sh` | Executa `cc -std=c99 -pedantic -Wall -Wextra <as opções -I do GTK como -isystem> -o bin/hello-desktop hello.c $(pkg-config --libs gtk4)` e imprime o comando expandido (consulte [Por que C99 aqui](#por-que-c99-aqui) para o `-isystem`). | A própria página de primeiros passos do GTK compila seu exemplo da mesma forma: "gcc $( pkg-config --cflags gtk4 ) -o example-0 example-0.c $( pkg-config --libs gtk4 )" [7]. O comando expandido é longo: os cabeçalhos do GTK incluem os do GLib, do Pango, do Cairo e outros, e o `pkg-config` lista todas as suas pastas. |
| `run.sh` | Executa `./bin/hello-desktop`. `--verify` define `TF_VERIFY=1`: a aplicação imprime o texto do rótulo assim que a janela é exibida e encerra após cerca de 2 s. | O GTK é ligado dinamicamente: o carregador do sistema encontra as bibliotecas do GTK quando o programa inicia. |

**Ligado, não copiado.** O `otool -L bin/hello-desktop` lista 13 bibliotecas
compartilhadas: `libgtk-4`, Pango, HarfBuzz, gdk-pixbuf, Cairo, Graphene,
GIO, GObject, GLib, `libintl` e `libSystem`. O executável tem 9.888 bytes;
compare com os 34,2 MB da
[versão Go/Fyne](../../go/README.md#comparing-the-categories), que copia seu
toolkit para dentro do executável.

## Estrutura de pastas
```text
desktop/
├── README.md        this file
├── gtk4-env.sh      GTK version, checksum and install folder (sourced by the scripts)
├── install.sh       checks cc, pkg-config and GTK 4 (may build GTK on Intel Macs)
├── build.sh         compiles and links with GTK
├── run.sh           opens the window
├── screenshot.png   the window, for "Expected output" below
├── hello.c          the program
└── bin/             created by build.sh; not committed
    └── hello-desktop
```
Um único arquivo `.c`, como em
[../cli](../cli/README.md#folder-structure). As aplicações GTK maiores
costumam ser compiladas com o Meson (o próprio GTK o é) e guardam sua
interface de usuário em arquivos XML `.ui`; um único rótulo não precisa de
nenhum dos dois.

## Passo a passo
Abra [`hello.c`](hello.c) ao lado desta lista. A estrutura é o primeiro
exemplo do próprio GTK, de sua página de primeiros passos, com um rótulo
acrescentado [7].

1. **`#include <gtk/gtk.h>`** traz todo o GTK e, sob ele, o GLib. Os nomes
   do GTK começam com `gtk_`/`Gtk`, os do GLib com `g_`/`G`: o C não tem
   espaços de nomes (namespaces), de modo que os prefixos mantêm os nomes separados.
2. **`main`** agora recebe `int argc, char **argv`: o número de argumentos
   de linha de comando e os próprios argumentos, que são repassados ao GTK.
3. **`gtk_application_new("com.example.HelloDesktop", G_APPLICATION_DEFAULT_FLAGS)`**
   cria a aplicação. O GNOME usa "'reverse DNS' style identifiers for
   applications" e recomenda um nome "based on the global public DNS system"
   [8] (tradução livre: "identificadores de aplicações no estilo 'DNS
   reverso'" e "baseado no sistema DNS público global"); o `example.com` é
   reservado para exemplos [9], de modo que este ID não pertence a ninguém.
4. **`g_signal_connect(app, "activate", G_CALLBACK(activate), NULL)`**
   conecta um *sinal* a uma função. "The activate signal will be emitted
   when your application is launched with g_application_run()" [7] (tradução
   livre: "O sinal activate será emitido quando a aplicação for iniciada com
   g_application_run()"). A `activate` é passada pelo nome: em C, isso é um
   ponteiro para a função. A `G_CALLBACK` a converte para o tipo genérico de
   callback do GLib.
5. **`g_application_run(...)`** "Runs the application"; ela "is intended to
   be run from main() and its return value is intended to be returned by
   main()" [10] (tradução livre: "Executa a aplicação"; ela "se destina a ser
   executada a partir de main() e seu valor de retorno se destina a ser
   retornado por main()"). Ela só retorna quando a janela é fechada: o mesmo
   padrão do `mainloop()` do `tkinter` do Python e do `ShowAndRun()` do Fyne.
6. **`activate(...)`** constrói a janela:
   - `gtk_application_window_new(app)` cria uma janela que pertence à
     aplicação.
   - `GTK_WINDOW(window)` é uma conversão verificada (*cast*). Todo widget é
     um `GtkWidget *`; o GTK implementa classes e herança em C puro, e essas
     macros convertem um ponteiro para o tipo mais específico.
   - `gtk_window_set_title` e `gtk_window_set_default_size` definem o título
     e um tamanho inicial (320 × 160).
   - `gtk_label_new("Hello, World!")` "Creates a new label with the given
     text inside it" [11] (tradução livre: "Cria um novo rótulo com o texto
     dado em seu interior"); `gtk_window_set_child` "Sets the child widget of
     the window" [11] (tradução livre: "Define o widget filho da janela").
   - `gtk_window_present` exibe a janela [7].
7. **A autoverificação** (somente com `TF_VERIFY=1`, usada por `./run.sh
   --verify`): imprime o texto do rótulo com `gtk_label_get_text`, e
   `g_timeout_add_seconds(2, quit_app, app)` chama `quit_app` após 2 s. Um
   timeout do GLib "is called repeatedly until it returns G_SOURCE_REMOVE"
   [12] (tradução livre: "é chamado repetidamente até retornar
   G_SOURCE_REMOVE"); `quit_app` retorna exatamente isso depois de chamar
   `g_application_quit`. Observe o terceiro argumento, `app`: o C não tem
   closures, de modo que os dados de que um callback precisa viajam com ele
   como um `void *` (o GLib o chama de `gpointer`).
8. **`g_object_unref(app)`** descarta a referência à aplicação. Os objetos
   do GTK têm contagem de referências; o C não tem coletor de lixo.

### Por que C99 aqui
Compile o `hello.c` como C89 e os erros vêm dos cabeçalhos do GLib, e não do
`hello.c`:
```text
$ cc -std=c89 -pedantic-errors $(pkg-config --cflags gtk4) -fsyntax-only hello.c
.../include/glib-2.0/glib/gunicode.h:308:71: error: commas at the end of enumerator lists are a C99-specific feature [-Werror,-Wc99-extensions]
.../include/glib-2.0/glib/gunicode.h:806:64: error: commas at the end of enumerator lists are a C99-specific feature [-Werror,-Wc99-extensions]
.../include/glib-2.0/glib/gstrfuncs.h:413:40: error: commas at the end of enumerator lists are a C99-specific feature [-Werror,-Wc99-extensions]
...
fatal error: too many errors emitted, stopping now [-ferror-limit=]
20 errors generated.
```
(Apple clang 21 em 2026-10-31; pastas abreviadas para `...`. Os demais
erros são macros variádicas, também "a C99 feature", em `gmessages.h` e
`genums.h`.)
O GTK e o GLib são escritos para C99 ou posterior (o próprio GTK é compilado
com `c_std=gnu11` [4]), de modo que o `build.sh` usa `-std=c99 -pedantic`.
Nem o C99 basta totalmente para os cabeçalhos do GTK 4.24: com opções `-I`
simples, o Apple clang 21 imprime 37 avisos de `-pedantic`, todos vindos dos
cabeçalhos do GTK e nenhum do `hello.c` (eles usam dois recursos do C11:
`typedef`s repetidos e `_Static_assert`). Por isso, o `build.sh` passa as
pastas do GTK com `-isystem` em vez de `-I`. O compilador trata esses
cabeçalhos como cabeçalhos de sistema e não relata avisos deles [18], ao
passo que o próprio `hello.c` continua sendo verificado: acrescente um
`_Static_assert` a ele e o `-std=c99 -pedantic` avisa que ele "is a C11
extension" (é uma extensão do C11). O próprio `hello.c` mantém hábitos do
C89: comentários `/* */` e declarações no início de cada bloco.

## Por que esta toolchain
- **GTK 4** para a versão desktop. O GTK é escrito em C, é mantido pelo
  GNOME, e aplicações como o GIMP e o Inkscape são construídas com ele [1].
- **Atual e mantido.** O GTK 4.0 foi lançado em 2020-12-16 [13]; em
  2026-10-31, o 4.24.1 é a versão mais recente em `download.gnome.org` [6] e
  a versão do Homebrew [2]. O GTK é "released under the terms of the GNU
  Lesser General Public License" [1] (tradução livre: "lançado sob os termos
  da GNU Lesser General Public License").
- **Multiplataforma.** O GTK documenta a instalação no Linux, no Windows
  (via MSYS2) e no macOS [14][16][17]. Sua compilação tem um back-end para
  cada sistema de janelas; esta compilação para macOS usa
  `-Dmacos-backend=true -Dx11-backend=false` (opções do `meson.options` do
  GTK [4]), de modo que a janela é uma janela nativa do macOS e nenhum
  servidor X está envolvido.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | GTK 4.24.1 compilado a partir do código-fonte pelo `install.sh` (sem bottle para Intel; veja Pré-requisitos), dependências do Homebrew, Apple clang 21.0.0. |
| macOS Apple Silicon | ⚠️ não verificado | O `brew install gtk4` instala um bottle [2]; o `install.sh` faz isso. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `build-essential`, `pkg-config` e `libgtk-4-dev` com o apt quando faltam [14]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o MSYS2 em `C:\msys64` e instala os pacotes UCRT64 `gcc`, `pkgconf` e `gtk4` com o `pacman` quando faltam [16]. O WSL não foi verificado; ele se comporta como o Linux, e uma janela exige o WSLg ou um servidor X. |

## Saída esperada
O `./run.sh` abre esta janela:

![A janela do GTK 4 intitulada "Hello, World!" que mostra o texto "Hello, World!"](screenshot.png)

(Capturada em 2026-10-31 no macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura somente essa janela.)

O `./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: GTK, loaded by bin/hello-desktop, opens the window and draws the label.
    Self-check: the app prints the label text and closes after ~2 seconds.
Hello, World!
```
Na máquina de teste, o back-end do GTK para macOS também pode imprimir na
saída de erro (stderr) uma linha como
`Gdk-WARNING **: gdk_frame_timings_presented() called on skipped frame.`
Ela vem do GTK, e não do `hello.c`; a janela é desenhada e o programa termina
com status 0.

## Fontes
1. The GTK Project (home page: description, license, written in C, GNOME, apps). <https://www.gtk.org/> (acessado em 2026-10-31)
2. gtk4 (formula: versions and bottles). Homebrew Formulae. <https://formulae.brew.sh/formula/gtk4> (acessado em 2026-10-31)
3. gtk4.rb (formula source: dependencies, build options). Homebrew/homebrew-core (GitHub). <https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/g/gtk4.rb> (acessado em 2026-10-31)
4. GTK 4.24.1 source release: `meson.build` (`c_std=gnu11`), `meson.options` and `gtk/meson.build` (theme compiled only for git checkouts). GNOME. <https://download.gnome.org/sources/gtk/4.24/gtk-4.24.1.tar.xz> (acessado em 2026-10-31)
5. Compiling the GTK Libraries. GTK 4 documentation. <https://docs.gtk.org/gtk4/building.html> (acessado em 2026-10-31)
6. GTK 4.24 source releases and checksum file. GNOME. <https://download.gnome.org/sources/gtk/4.24/> and <https://download.gnome.org/sources/gtk/4.24/gtk-4.24.1.sha256sum> (acessado em 2026-10-31)
7. Getting Started with GTK (Basics example, compile command). GTK 4 documentation. <https://docs.gtk.org/gtk4/getting_started.html> (acessado em 2026-10-31)
8. Application ID. GNOME Developer Documentation. <https://developer.gnome.org/documentation/tutorials/application-id.html> (acessado em 2026-10-31)
9. RFC 2606: Reserved Top Level DNS Names. IETF. <https://www.rfc-editor.org/rfc/rfc2606> (acessado em 2026-10-31)
10. `g_application_run`. GIO documentation. <https://docs.gtk.org/gio/method.Application.run.html> (acessado em 2026-10-31)
11. GtkLabel (`gtk_label_new`) and `gtk_window_set_child`. GTK 4 documentation. <https://docs.gtk.org/gtk4/class.Label.html>, <https://docs.gtk.org/gtk4/method.Window.set_child.html> (acessado em 2026-10-31)
12. `g_timeout_add_seconds`. GLib documentation. <https://docs.gtk.org/glib/func.timeout_add_seconds.html> (acessado em 2026-10-31)
13. GTK 4.0. GTK Development Blog, 2020-12-16. <https://blog.gtk.org/2020/12/16/gtk-4-0/> (acessado em 2026-10-31)
14. Installing GTK on Linux. The GTK Project. <https://www.gtk.org/docs/installations/linux> (acessado em 2026-10-31)
15. Package libgtk-4-dev (stable). Debian. <https://packages.debian.org/stable/libgtk-4-dev> (acessado em 2026-10-31)
16. Installing GTK on Windows. The GTK Project. <https://www.gtk.org/docs/installations/windows> (acessado em 2026-10-31)
17. Installing GTK on macOS. The GTK Project. <https://www.gtk.org/docs/installations/macos> (acessado em 2026-10-31)
18. System Headers. The C Preprocessor, GCC. <https://gcc.gnu.org/onlinedocs/cpp/System-Headers.html> (acessado em 2026-10-31)
