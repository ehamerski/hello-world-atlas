---
source: docs/start-here.md
source_sha: 42a2611ac242be5a69100f073da8e0371875c39f
---
# Comece aqui

> Parte de [Hello World em várias linguagens](../README.md)

Todo exemplo deste repositório é executado da mesma forma, em qualquer
sistema operacional: abra um terminal na pasta do exemplo e execute seus
scripts. Esta página mostra como obter um terminal capaz de executá-los e o
que os scripts fazem.

## 1. Obtenha o código
- **Um exemplo:** no site, abra a página de uma linguagem e clique em
  **Download ZIP** ao lado do exemplo. Descompacte o arquivo. O ZIP mantém os
  caminhos do repositório; assim, o exemplo fica em
  `languages/<language>/<category>/` dentro da pasta descompactada, ao lado
  do `scripts/common.sh` compartilhado.
- **Tudo:** clone o repositório com o Git.

## 2. Abra um terminal que execute scripts `sh`
Os scripts são scripts POSIX `sh` ([CONTRIBUTING.md](../CONTRIBUTING.md#script-contract)).

| Sistema | Terminal | Situação |
|---|---|---|
| macOS (Intel) | Terminal (em Aplicativos → Utilitários) | verificado: a máquina de desenvolvimento |
| macOS (Apple Silicon) | Terminal | documentado, não verificado |
| Linux | qualquer terminal | verificado no CI no Ubuntu em 2026-11-06 para as implementações que existiam então; as mais novas não foram verificadas no CI ([Platform support](platform-support.md#linux-and-windows-in-ci)) |
| Windows | **Git Bash**, que acompanha o [Git for Windows](https://gitforwindows.org/), ou um shell Linux no [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) | Git Bash: verificado no CI em 2026-11-06 para as implementações que existiam então; as mais novas não foram verificadas no CI. WSL: documentado, não verificado. Cada README também lista os comandos nativos do Windows |

### O que cada sistema usa para instalar uma toolchain
O `install.sh` mostra o comando de instalação para o sistema em que é executado:

| Sistema | Gerenciador de pacotes que os scripts usam | Observações |
|---|---|---|
| macOS | [Homebrew](https://brew.sh/) | Algumas ferramentas vêm do fornecedor, quando não existe pacote no Homebrew ou a versão é diferente; o README de cada exemplo indica quais (por exemplo, Zig, Julia e Racket são descompactados do download oficial para `~/.local`). |
| Debian e Ubuntu | `apt` | As **Notas por plataforma** do README informam os nomes dos pacotes. |
| Windows (Git Bash) | `winget` e o instalador de cada fornecedor | Cada README também lista os comandos nativos do Windows. |

Algumas linguagens levam muito mais tempo para instalar do que outras, porque
um pacote é compilado a partir do código-fonte ou é grande: QCL, OCaml e R
(compilados a partir do código-fonte aqui) e o Android SDK são exemplos. Leia
os **Prerequisites** do README antes de responder sim; o `install.sh` sempre
pergunta primeiro.

## 3. Execute os três scripts
```sh
cd languages/<language>/<category>   # e.g. languages/python/cli
./install.sh                         # check the toolchain; asks before installing anything
./build.sh                           # compile (compiled languages only)
./run.sh                             # run it
```
- O `install.sh` verifica se a toolchain está instalada. Quando algo falta,
  ele mostra o comando de instalação para o sistema do usuário (por exemplo,
  com o [Homebrew](https://brew.sh/) no macOS ou o `apt` no Debian e no
  Ubuntu) e pergunta antes de executá-lo. Se a resposta for não, ele apenas
  exibe o comando. Ele nunca executa `sudo` sem exibi-lo antes.
- O `build.sh` existe apenas quando a linguagem é compilada.
- O `run.sh` exibe `Hello, World!` (cli), abre uma janela (desktop) ou inicia
  um servidor web em `http://localhost:8080/` (web; altere a porta com
  `PORT=...`).

Cada script informa o que faz e por que o faz enquanto é executado. O README
de cada exemplo explica o código passo a passo ("Step-by-step walkthrough") e
traz "Notas por plataforma" para cada sistema operacional.

## 4. As categorias e o que elas abrem
O nome da pasta indica o que o `run.sh` faz:

| Pasta (categoria) | `run.sh` | Para saber além disso |
|---|---|---|
| `cli` | exibe `Hello, World!` no terminal | nada mais é necessário |
| `desktop` | abre uma janela | exige uma sessão gráfica (no Linux, um display) |
| `web`, `web-*` | inicia um servidor em `http://localhost:8080/` (um front-end em outra porta, veja [Comparisons](comparisons.md#web-with-a-separate-front-end)) | encerre com Ctrl+C |
| `mobile-*` | inicia um telefone virtual e executa a aplicação nele | exige o Android SDK ou o Xcode: veja a seção 5 |

## 5. Aplicações móveis: Android SDK e Xcode
Os três exemplos `mobile` ([`kotlin/mobile-android`](../languages/kotlin/mobile-android/README.md),
[`dart/mobile-flutter`](../languages/dart/mobile-flutter/README.md) e
[`swift/mobile-ios`](../languages/swift/mobile-ios/README.md)) são executados
em um **dispositivo virtual**; por isso, exigem mais do que um compilador.

**Android** (Kotlin com Jetpack Compose e Dart com Flutter)
- Você precisa de um JDK e do **Android SDK**: as ferramentas de linha de
  comando, uma plataforma, as build-tools, o emulador e uma imagem de sistema.
  O `install.sh` verifica cada item e pergunta antes de baixar qualquer coisa.
- Se você já tem um SDK, por exemplo o do Android Studio, defina `ANDROID_HOME`
  com a pasta dele antes de executar o `./install.sh`; o script então o usa
  ([`kotlin/mobile-android`](../languages/kotlin/mobile-android/README.md)).
  Sem essa variável, o SDK vai para `~/.local/android-sdk`.
- O SDK e o emulador ocupam a maior parte dessa pasta
  ([`kotlin/mobile-android`](../languages/kotlin/mobile-android/README.md)).
- A imagem de sistema precisa corresponder à sua CPU. Os scripts indicam a
  imagem Intel (`x86_64`), que é a usada pelo Mac verificado. Em um Mac Apple
  Silicon, a imagem e as ferramentas de linha de comando precisam ser as
  arm64; por isso, o README marca essa plataforma como **não verificada** e
  informa o que alterar.
- No Linux, o emulador usa KVM e, no Windows, precisa de um hipervisor; ambos
  **não foram verificados** para essas pastas (veja as **Notas por plataforma** de
  cada README).

**iOS** (Swift com SwiftUI)
- Você precisa de um **Mac** com o **aplicativo Xcode completo**, da Mac App
  Store ou de [developer.apple.com/xcode](https://developer.apple.com/xcode/).
  As Command Line Tools sozinhas não incluem o iOS SDK nem o Simulator
  ([`swift/mobile-ios`](../languages/swift/mobile-ios/README.md#what-this-is)).
- O `install.sh` apenas **verifica** a presença do Xcode, do iOS Simulator SDK
  e do `simctl`. Ele nunca instala o Xcode: você mesmo o instala e talvez
  precise instalar um runtime do iOS Simulator no Xcode.
- A aplicação é executada no iOS Simulator, não em um telefone real.
- O iOS não pode ser compilado no Linux nem no Windows.

Para saber o que de fato foi executado e onde, leia [Platform support](platform-support.md).

## 6. Para onde ir em seguida
- Está começando a programar? Siga o
  [roteiro guiado pelos passo a passo](comparisons.md#a-guided-path-through-the-walkthroughs).
- Tem curiosidade sobre as ideias por trás das linguagens? Leia a página
  sobre [paradigmas](paradigms.md).
