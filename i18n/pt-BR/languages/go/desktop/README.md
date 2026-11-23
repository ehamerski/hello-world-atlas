---
source: languages/go/desktop/README.md
source_sha: 74507d6cf49c0c47a0fedbd28f5d4206cae22bb3
---
# Go · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Go](../README.md)

## O que é
Um programa desktop que abre uma pequena janela intitulada "Hello, World!"
com o texto **Hello, World!** no centro. A janela é desenhada pelo **Fyne**,
um toolkit de GUI escrito em Go. A biblioteca padrão do Go não tem pacote de
GUI (ao contrário do Python, que inclui o tkinter), de modo que o Fyne é uma
dependência: o `go.mod` o nomeia e o `go build` o baixa.

Compare com [../cli](../cli/): o programa deixa de imprimir e terminar.
Ele entrega o controle ao laço de eventos do Fyne, que aguarda eventos da
janela até que o leitor a feche.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Go 1.25 ou superior | Go 1.27.3 (Homebrew) | compila o programa; baixa o Fyne |
| Um compilador C | Apple clang 21.0.0 (Command Line Tools 26.6) | o Fyne contém código C que o `go build` compila por meio do **cgo** |
| Fyne | v2.8.2 (fixada no `go.mod`) | o toolkit de GUI; baixado pelo `go build`, não pelo `install.sh` |
| Somente no Linux: cabeçalhos gráficos | não verificado | pacotes de desenvolvimento de OpenGL, X11 e Wayland (ver Notas por plataforma) |

O README do Fyne afirma: "you will need Go version 1.22 or later, a C
compiler and your system's development tools" [1] (tradução livre: "será
necessário o Go na versão 1.22 ou posterior, um compilador C e as
ferramentas de desenvolvimento do sistema"). O Quick Start explica por que o
compilador C é necessário: "to connect with system graphics drivers" [2]
(tradução livre: "para se conectar aos drivers gráficos do sistema"). O Fyne
v2.8.2 era a versão mais recente em 2026-10-31 [3]. O próprio Fyne exige o Go 1.22,
mas o `go.mod` daqui diz `go 1.25.0` porque fixa o `golang.org/x/image` v0.43.0,
uma versão corrigida de uma dependência indireta que exige o Go 1.25 (o `go.mod`
dela diz `go 1.25.0`). A v0.43.0 é a versão que corrige os relatórios de
vulnerabilidade do Go
[GO-2026-4815](https://pkg.go.dev/vuln/GO-2026-4815),
[GO-2026-5032](https://pkg.go.dev/vuln/GO-2026-5032),
[GO-2026-5062](https://pkg.go.dev/vuln/GO-2026-5062) e
[GO-2026-5066](https://pkg.go.dev/vuln/GO-2026-5066), todos no decodificador
TIFF desse módulo (o Fyne inclui o pacote na ligação; este programa não
decodifica arquivos de imagem).

No macOS, o Quick Start do Fyne indica instalar o Xcode e, em seguida, as
Command Line Tools com `xcode-select --install` [2]. A máquina de teste tem
apenas as Command Line Tools (sem o aplicativo Xcode), e elas foram
suficientes.

## Início rápido
```sh
./install.sh   # check Go and the C compiler (asks before installing)
./build.sh     # download Fyne and compile into bin/hello-desktop (first time: about 1 minute)
./run.sh       # open the window; close it to end the program
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica o Go 1.25+ (`go env GOVERSION`). 2. Verifica um compilador C: `xcrun --find clang` no macOS, `gcc` mais os cabeçalhos de OpenGL/X11 no Linux, `gcc` do MSYS2 no Windows. 3. Verifica se o cgo está habilitado (`go env CGO_ENABLED` é `1`). Para o que estiver faltando, o script mostra o comando de instalação e só o executa se você responder `y`. | O Fyne precisa do cgo, e o cgo precisa de um compilador C. O próprio Fyne não é instalado aqui, pelo mesmo motivo que o Maven baixa o JavaFX em [../../java/desktop](../../java/desktop/): é uma biblioteca deste projeto, não uma ferramenta do computador do leitor. |
| `build.sh` | Executa `go build -o bin/hello-desktop .` | O primeiro build baixa o Fyne e suas dependências para o cache de módulos do Go, confere-os com o `go.sum`, compila o código C do Fyne e liga um único executável. "The first run has to compile some C-code and can thus take longer than usual. Subsequent builds reuse the cache and will be much faster" [2] (tradução livre: "A primeira execução precisa compilar algum código C e, por isso, pode demorar mais que o normal. Os builds seguintes reutilizam o cache e serão muito mais rápidos"). Na máquina de teste, o primeiro build levou cerca de 55 segundos. |
| `run.sh` | Executa `./bin/hello-desktop`. `--verify` define `TF_VERIFY=1`: a aplicação imprime o texto do rótulo assim que está em execução e encerra após cerca de 2 segundos. | O executável já contém o Fyne. Somente as bibliotecas do próprio sistema operacional são carregadas em tempo de execução: no macOS, `otool -L bin/hello-desktop` lista Cocoa, AppKit e OpenGL. |

O `build.sh` pode imprimir `ld: warning: ignoring duplicate libraries: '-lobjc'`.
A mensagem vem do linker do macOS, é apenas um aviso, e o programa funciona.

## Estrutura de pastas
```text
desktop/
├── README.md        this file
├── install.sh       checks Go and the C compiler
├── build.sh         downloads Fyne and compiles
├── run.sh           opens the window
├── screenshot.png   the window, for "Expected output" below
├── go.mod           module name, minimum Go version, and the required modules (Fyne)
├── go.sum           checksums of every downloaded module
├── main.go          the program
└── bin/             created by build.sh; not committed
    └── hello-desktop
```
- A mesma estrutura de "comando básico" da [../cli](../cli/README.md#folder-structure):
  um único `main.go` na raiz do módulo [4].
- O **`go.mod`** agora tem linhas `require`. A primeira, `fyne.io/fyne/v2
  v2.8.2`, é a que este programa importa. O segundo bloco é marcado com
  `// indirect`: são módulos de que o próprio Fyne precisa. Eles foram
  escritos por `go get fyne.io/fyne/v2@v2.8.2` e `go mod tidy`, os comandos
  que o README do Fyne mostra para adicioná-lo a um projeto [1].
- O **`go.sum`** guarda um checksum para cada versão de módulo. "After
  downloading a .mod or .zip file, the go command computes a cryptographic
  hash and checks that it matches a hash in the main module's go.sum
  file" [5] (tradução livre: "Depois de baixar um arquivo .mod ou .zip, o
  comando go calcula um hash criptográfico e verifica se ele corresponde a
  um hash do arquivo go.sum do módulo principal"), de modo que todo
  estudante compila exatamente com o mesmo código. Assim como o
  `package-lock.json` em projetos npm, ambos os arquivos são incluídos no
  repositório.
- Os módulos baixados não ficam nesta pasta (ao contrário do
  `node_modules/`): o Go os mantém em um único cache compartilhado,
  `go env GOMODCACHE` (na máquina de teste, `~/go/pkg/mod`).

## Passo a passo
Abra o [`main.go`](main.go) ao lado desta lista.

1. **`import ( ... )`** lista vários pacotes em um único bloco. Os da
   biblioteca padrão (`fmt`, `os`, `time`) têm caminhos curtos. Os do Fyne
   começam com o caminho de seu módulo, `fyne.io/fyne/v2`, que também é de
   onde o Go os baixa. O `/v2` faz parte do caminho: no Go, uma nova versão
   principal de um módulo recebe um novo caminho de importação [5].
2. **`a := app.New()`** cria a aplicação. O `:=` declara uma variável e lhe
   dá o tipo do valor à direita: ele "is shorthand for a regular variable
   declaration with initializer expressions but no types" [6] (tradução
   livre: "é uma abreviação de uma declaração de variável comum com
   expressões de inicialização, mas sem tipos"). O `app.New` "returns a new
   application instance with the default driver" [7] (tradução livre:
   "retorna uma nova instância de aplicação com o driver padrão").
3. **`w := a.NewWindow("Hello, World!")`** cria a janela com seu título.
   **`widget.NewLabel("Hello, World!")`** "creates a new label widget with
   the set text content" [7] (tradução livre: "cria um novo widget de
   rótulo com o conteúdo de texto definido"). **`container.NewCenter(label)`**
   o mantém no centro, como o `StackPane` em
   [../../java/desktop](../../java/desktop/).
4. **`w.Resize(fyne.NewSize(320, 160))`** dá à janela um tamanho inicial.
   Sem ele, a janela teria apenas o tamanho do rótulo.
5. **A autoverificação** (somente com `TF_VERIFY=1`, usado por
   `./run.sh --verify`):
   - `a.Lifecycle().SetOnStarted(func() { ... })` registra uma função
     anônima que o Fyne chama quando "the app is now running" [7]
     (tradução livre: "a aplicação está em execução"); ela imprime o texto
     do rótulo.
   - `go func() { ... }()` inicia uma **goroutine**. A especificação define
     a instrução `go` como o início da "execution of a function call as an
     independent concurrent thread of control, or goroutine, within the same
     address space" [6] (tradução livre: "execução de uma chamada de função
     como uma linha de controle concorrente independente, ou goroutine,
     dentro do mesmo espaço de endereçamento"). Ela espera 2 segundos sem
     bloquear a janela.
   - `fyne.Do(a.Quit)`: desde o Fyne v2.6, "all Fyne events and callbacks
     happen on the same goroutine", e "any time your app invokes Fyne APIs
     from a goroutine your code created, you should use the fyne.Do
     function" [8] (tradução livre: "todos os eventos e callbacks do Fyne
     ocorrem na mesma goroutine"; "sempre que a aplicação invoca APIs do
     Fyne a partir de uma goroutine criada pelo código, deve-se usar a
     função fyne.Do"). O `a.Quit` fecha todas as janelas e encerra a
     aplicação [7]. O `a.Quit` é escrito sem `()`: a própria função é
     passada, para ser chamada depois.
6. **`w.ShowAndRun()`** "is a shortcut to show the window and then run the
   application. This should be called near the end of a main() function as
   it will block" [7] (tradução livre: "é um atalho para mostrar a janela e,
   em seguida, executar a aplicação. Deve ser chamada perto do fim de uma
   função main(), pois bloqueia"). É o mesmo padrão do `mainloop()` do
   tkinter e do `launch()` do JavaFX.

## Por que esta toolchain
- **O Go não tem biblioteca de GUI padrão**, de modo que toda aplicação
  desktop em Go usa um toolkit de terceiros. Este repositório usa o Fyne.
- **A API do Fyne é somente em Go**: a aplicação é escrita sem nenhum C,
  HTML ou JavaScript. O site do projeto afirma "No web runtime. No
  JavaScript. Just Go." (tradução livre: "Sem runtime web. Sem JavaScript.
  Apenas Go.") e lista Windows, macOS, Linux, iOS e Android como alvos [9].
  O README o descreve como "an easy-to-use UI toolkit and app API written
  in Go ... designed to build applications that run on desktop and mobile
  devices with a single codebase" [1] (tradução livre: "um toolkit de
  interface e API de aplicações fáceis de usar, escritos em Go ...
  projetados para construir aplicações que executam em dispositivos desktop
  e móveis com uma única base de código").
- **Código aberto e mantido:** o Fyne usa a licença BSD-3-Clause [1], e o
  projeto publicou várias versões em 2026, até a v2.8.2 [3].
- **O `go build` simples** é suficiente para compilar e executar. O Fyne
  também tem uma ferramenta opcional, `fyne`, cujo comando `package` cria
  um pacote de aplicação (`.app` ou `.exe`) com um ícone; a documentação do
  Fyne acrescenta: "Of course you can still run your applications using the
  standard Go tools if you prefer" [10] (tradução livre: "Claro que ainda é
  possível executar as aplicações com as ferramentas padrão do Go, se
  preferir"). Um Hello World não precisa de pacote, de modo que a ferramenta
  não é usada aqui.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Go 1.27.3, Fyne v2.8.2, Apple clang 21.0.0 (somente Command Line Tools, sem o aplicativo Xcode). |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos: `brew install go` e `xcode-select --install` [2]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` não instala o Go: se o Go 1.25 ou posterior não existe, ele imprime os passos do arquivo de go.dev [6] e para. Ele instala `gcc libgl1-mesa-dev xorg-dev libwayland-dev libxkbcommon-dev` com o apt quando o `gcc` ou os cabeçalhos gráficos não existem [2]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Go nem um compilador C: quando o Go 1.25 ou posterior ou o `gcc` não existe, ele imprime o comando `winget` do Go ou os passos do MSYS2 [2] e para. O README do Fyne avisa: "The first compilation of Fyne on Windows can take up to 10 minutes" [1] (tradução livre: "A primeira compilação do Fyne no Windows pode levar até 10 minutos"). O WSL não foi verificado; ele se comporta como o Linux, e uma janela exige o WSLg ou um servidor X. |

## Saída esperada
O `./run.sh` abre esta janela (na máquina de teste, o macOS estava no modo
escuro, e a janela também usou o tema escuro):

![A janela do Fyne intitulada "Hello, World!" exibindo o texto "Hello, World!"](screenshot.png)

(Capturada em 2026-10-31 em macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura somente aquela janela.)

O `./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: Fyne, linked into bin/hello-desktop, opens the window and draws it with OpenGL.
    Self-check: the app prints the label text and closes after ~2 seconds.
Hello, World!
```

## Fontes
1. `fyne-io/fyne` (README, license). GitHub. <https://github.com/fyne-io/fyne> (acessado em 2026-10-31)
2. Getting Started (Quick Start: prerequisites per OS, first build). Fyne. <https://docs.fyne.io/started/quick/> (acessado em 2026-10-31)
3. Releases. `fyne-io/fyne` (GitHub).
 <https://github.com/fyne-io/fyne/releases> (acessado em 2026-10-31)
4. Organizing a Go module. The Go Authors. <https://go.dev/doc/modules/layout> (acessado em 2026-10-31)
5. Go Modules Reference (major version suffixes, go.sum). The Go Authors. <https://go.dev/ref/mod> (acessado em 2026-10-31)
6. The Go Programming Language Specification (Short variable declarations, Go statements). The Go Authors. <https://go.dev/ref/spec> (acessado em 2026-10-31)
7. Fyne v2.8.2 API: app.New, App, Window, Lifecycle, widget.NewLabel. pkg.go.dev. <https://pkg.go.dev/fyne.io/fyne/v2@v2.8.2> (acessado em 2026-10-31; também lido com `go doc` a partir do módulo baixado)
8. Goroutines and threading. Fyne. <https://docs.fyne.io/started/goroutines/> (acessado em 2026-10-31)
9. Fyne home page. Fyne. <https://fyne.io/> (acessado em 2026-10-31)
10. Packaging for desktop. Fyne. <https://docs.fyne.io/started/packaging/> (acessado em 2026-10-31)
