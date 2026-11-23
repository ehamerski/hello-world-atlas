---
source: languages/rust/desktop/README.md
source_sha: cd642105e45d8c9a9850f2de72f801b18755c565
---
# Rust · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Rust](../README.md)

## O que é
Um programa desktop que abre uma pequena janela com o título "Hello, World!" e
o texto **Hello, World!** no centro. A janela é desenhada pelo **egui**, "a
simple, fast, and highly portable immediate mode GUI library for Rust"
(tradução livre: "uma biblioteca de GUI em modo imediato para Rust, simples,
rápida e altamente portável"), por meio do **eframe**, "the official egui
framework, which supports writing apps for Web, Linux, Mac, Windows, and
Android" [1] (tradução livre: "o framework oficial do egui, que permite
escrever aplicações para Web, Linux, Mac, Windows e Android"). A biblioteca
padrão do Rust não tem GUI (o Python traz o tkinter), portanto o eframe é uma
dependência: `Cargo.toml` o nomeia e `cargo build` o baixa.

Compare com [../cli](../cli/): o programa não imprime e termina mais. Ele
entrega o controle ao laço de eventos do eframe, que aguarda eventos da janela
até que ela seja fechada.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| Rust 1.95 ou posterior (`rustc` + `cargo`) | Rust 1.98.1 (Homebrew) | compila o programa; baixa o eframe |
| eframe (com egui) | 0.37.0 (publicada em 2026-10-15) [6] | o framework de GUI; baixado por `cargo build`, e não por `install.sh` |
| Somente Linux: bibliotecas do sistema de janelas | não verificado | pacotes de desenvolvimento do X11/Wayland (ver Notas por plataforma) |

O mínimo é maior que em [../cli](../cli/) (1.85): o eframe 0.37.0 declara
`rust_version` 1.95 [6], e `Cargo.toml` o repete. O Rust 1.95.0 foi lançado em
2026-04-16 [7]. No macOS, nada mais é necessário: nem Xcode nem compilador C
além do linker que o Rust já usa (compare com
[../../go/desktop](../../go/desktop/), em que o Fyne precisa do cgo).

## Início rápido
```sh
./install.sh   # check / install Rust (asks before installing)
./build.sh     # download eframe and compile (first time: about 5 minutes)
./run.sh       # open the window; close it to end the program
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Mesma verificação de [../cli](../cli/README.md#scripts-explained), com Rust mínimo 1.95. No Linux, também imprime o comando `apt-get` das bibliotecas de janelas (não executado: exige `sudo`). | O eframe é uma dependência deste projeto, e não uma ferramenta do computador; por isso o Cargo o baixa durante a compilação, como o Maven baixa o JavaFX em [../../java/desktop](../../java/desktop/). |
| `build.sh` | Executa `cargo build --release --locked` [2] | A primeira compilação baixa e compila o eframe, o egui e os crates que eles usam: 176 no macOS (as linhas `Compiling` do log de compilação). `Cargo.lock` lista 348, porque também registra crates usados apenas em outros sistemas (Windows, Linux, Android, web). Na máquina de teste, a primeira compilação limpa levou 9 min 10 s (enquanto outras compilações rodavam); as seguintes recompilam apenas `main.rs`. |
| `run.sh` | Executa `./target/release/hello-desktop`. `--verify` define `TF_VERIFY=1`: a aplicação imprime o texto do rótulo no primeiro quadro e se fecha após cerca de 2 segundos. | O executável já contém o eframe e o egui. Apenas as bibliotecas do próprio sistema operacional são carregadas em tempo de execução: no macOS, `otool -L` lista AppKit, Metal, QuartzCore e CoreText, entre outras. |

## Estrutura de pastas
```text
desktop/
├── README.md        this file
├── install.sh       checks / installs Rust
├── build.sh         downloads eframe and compiles
├── run.sh           opens the window
├── screenshot.png   the window, for "Expected output" below
├── Cargo.toml       the manifest: name, edition, minimum Rust, the dependency eframe
├── Cargo.lock       the exact version and checksum of every crate (written by cargo)
├── src/
│   └── main.rs      the program
└── target/          created by build.sh; not committed
    └── release/
        └── hello-desktop
```
- O mesmo layout do Cargo de [../cli](../cli/README.md#folder-structure):
  "The default executable file is src/main.rs" [3] (tradução livre: "O
  arquivo executável padrão é src/main.rs").
- **`eframe = "0.37"`** aceita qualquer versão 0.37.x, mas não a 0.38: para
  versões abaixo de 1.0, "0.2.3 := >=0.2.3, <0.3.0" [4]. O egui ainda está na
  série 0.x e sua API muda entre versões menores (na 0.37, a aplicação é
  escrita como uma função `ui`); portanto, isso importa.
- **`Cargo.lock`** é versionado, como em [../web](../web/README.md#folder-structure),
  de modo que todo estudante compila a mesma árvore de dependências de 348
  entradas.
- O eframe é usado com seus recursos padrão, menos `accesskit`, `wayland`, `winit/default` e o `web_screen_reader`, exclusivo da web: os três primeiros trazem os crates `zbus`, `zvariant` e `ttf-parser`, que têm avisos RustSec abertos sem versão corrigida ([RUSTSEC-2026-0192](https://rustsec.org/advisories/RUSTSEC-2026-0192.html), [0370](https://rustsec.org/advisories/RUSTSEC-2026-0370.html), [0371](https://rustsec.org/advisories/RUSTSEC-2026-0371.html), [0372](https://rustsec.org/advisories/RUSTSEC-2026-0372.html)). O custo: no Linux, a janela usa o X11 (por meio da camada de compatibilidade do X11 nos desktops Wayland) e a ponte do leitor de tela fica desligada. Seu renderizador padrão é o
  **wgpu**: "Switching from `wgpu (the default)` to `glow` can significantly
  reduce your binary size" [5] (tradução livre: "Trocar de `wgpu (o padrão)`
  para `glow` pode reduzir significativamente o tamanho do binário"). O wgpu
  "runs natively on Vulkan, Metal, D3D12, and OpenGL" [8] (tradução livre:
  "executa nativamente em Vulkan, Metal, D3D12 e OpenGL"); no macOS, ele usa o
  Metal, e por isso o executável de 15 MB vincula `Metal.framework`.

## Passo a passo
Abra [`src/main.rs`](src/main.rs) ao lado desta lista.

1. **Modo imediato.** Esta é a grande diferença em relação a todas as outras
   versões desktop deste repositório. O README do egui explica: "In a
   retained GUI you create a button, add it to some UI and install some
   on-click handler (callback)" (tradução livre: "Em uma GUI em modo retido,
   cria-se um botão, adiciona-se a alguma interface e instala-se um tratador
   de clique (callback)"). "By contrast, in immediate mode you show the button
   and interact with it immediately, and you do so every frame (e.g. 60 times
   per second)" [1] (tradução livre: "Em contraste, no modo imediato exibe-se
   o botão e interage-se com ele imediatamente, e isso é feito a cada quadro
   (por exemplo, 60 vezes por segundo)"). Portanto, diferentemente do tkinter,
   do JavaFX ou do Fyne, aqui não há objeto de rótulo: uma closure descreve a
   janela inteira a cada vez que ela é desenhada.
2. **`fn main() -> eframe::Result`**: `main` retorna um `Result`. "When a main
   function returns a Result<(), E>, the executable will exit with a value of
   0 if main returns Ok(()) and will exit with a nonzero value if main
   returns an Err value" [9] (tradução livre: "Quando uma função main retorna
   um Result<(), E>, o executável termina com o valor 0 se main retornar
   Ok(()) e com um valor diferente de zero se main retornar um valor Err"),
   por exemplo quando nenhum adaptador gráfico é encontrado.
3. **`eframe::NativeOptions { viewport: ..., ..Default::default() }`** define
   o tamanho da janela (320 × 160 pontos lógicos). `..Default::default()`
   preenche todos os outros campos com seus valores padrão; o Rust não tem
   argumentos opcionais, portanto essa "struct update syntax" (sintaxe de
   atualização de struct) é a substituição usual.
4. **`let verify = ...; let started = ...; let mut printed = false;`**: "by
   default, variables are immutable" [10] (tradução livre: "por padrão, as
   variáveis são imutáveis"); `mut` torna `printed` alterável. Essas três só
   são usadas pela autoverificação (passo 7).
5. **`eframe::run_ui_native("Hello, World!", options, move |ui, _frame| { ... })`**
   é "The simplest way to get started when writing a native app" [5]
   (tradução livre: "A forma mais simples de começar ao escrever uma aplicação
   nativa"). O primeiro argumento é o nome da aplicação, que o eframe também
   usa como título da janela quando nenhum é definido. O terceiro é uma
   **closure**: "Rust's closures are anonymous functions you can save in a
   variable or pass as arguments to other functions" [11] (tradução livre: "As
   closures do Rust são funções anônimas que podem ser salvas em uma variável
   ou passadas como argumentos a outras funções"). `move` faz a closure "take
   ownership of the values it uses in the environment" [11] (tradução livre:
   "assumir a posse dos valores que usa do ambiente") (`verify`, `started`,
   `printed`), porque o eframe continua a chamá-la depois que o próprio código
   de `main` já seguiu adiante. `run_ui_native` só retorna quando a janela é
   fechada, como o `mainloop()` do tkinter e o `ShowAndRun()` do Fyne.
6. **`egui::CentralPanel::default().show(ui, |ui| { ... })`** preenche a
   janela com um painel (margens e uma cor de fundo), e
   **`ui.centered_and_justified(|ui| { ui.label("Hello, World!"); })`**
   coloca o rótulo no centro. Cada closure aninhada recebe um `ui` para a
   área em seu interior.
7. **A autoverificação** (somente com `TF_VERIFY=1`, usada por
   `./run.sh --verify`): no primeiro quadro, imprime `Hello, World!`; após 2
   segundos, envia `egui::ViewportCommand::Close`, que fecha a janela e
   encerra o laço de eventos. O egui só redesenha quando algo acontece; por
   isso `request_repaint_after(100 ms)` solicita o próximo quadro, que verifica
   o tempo novamente. No Go, a mesma verificação usava uma goroutine; aqui,
   nenhuma thread é necessária, porque a closure executa a cada quadro de
   qualquer forma.

## Por que esta toolchain
- **Rust puro, uma dependência:** `Cargo.toml` nomeia apenas o eframe, e
  `cargo build` faz o resto. No macOS, nenhum dos 176 crates compila código C
  (`cargo tree` não mostra nenhum crate `cc`, `cmake` ou `bindgen`); assim, não
  há Xcode nem SDK de GUI separado a instalar. O Linux precisa de algumas
  bibliotecas do sistema.
- **Multiplataforma:** o eframe tem como alvo "Web, Linux, Mac, Windows, and
  Android" [1] (tradução livre: "Web, Linux, Mac, Windows e Android").
- **Mantido:** a "first release on crates.io (0.1.0)" do egui (tradução
  livre: "primeira versão no crates.io (0.1.0)") foi em 2020-05-30 [12]; o
  eframe 0.37.0 foi publicado em 2026-10-15 [6].
- **Somente Rust:** o eframe/egui mantém o Hello World em Rust, sem toolkit
  C/C++ e sem mecanismo de navegador.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Rust 1.98.1, eframe 0.37.0, renderizado com Metal por meio do wgpu. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libxkbcommon-dev libssl-dev libxkbcommon-x11-0 mesa-vulkan-drivers libgl1-mesa-dri libvulkan1 libegl1` com o apt quando algum deles não existe e, em seguida, executa o instalador do rustup quando o Rust 1.95 ou posterior não existe. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Rust: se o Rust 1.95 ou posterior não existe, ele imprime `winget install --id Rustlang.Rustup -e` [13] e para. O rustup exige as Build Tools C++ do Visual Studio [14]. O wgpu usa D3D12 ou Vulkan [8]. O WSL não foi verificado; ele se comporta como o Linux, e uma janela exige o WSLg ou um servidor X. |

**O script do rustup não tem verificação de checksum.** O rustup publica arquivos
SHA-256 para os programas `rustup-init`, mas não para o script `rustup-init.sh`
por trás de `https://sh.rustup.rs` [20], e esse script muda a cada versão do
rustup. Por isso, o `install.sh` o salva em
`~/.cache/hello-world-rust/rustup-init.sh` e mostra o caminho, para que você
possa ler o script antes de responder `y` para executá-lo.

## Saída esperada
`./run.sh` abre esta janela (na máquina de teste, o macOS estava em modo
escuro, e o egui o acompanhou):

![A janela do egui com o título "Hello, World!" exibindo o texto "Hello, World!"](screenshot.png)

(Captura feita em 2026-10-31 no macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura apenas essa janela.)

`./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: eframe, linked into target/release/hello-desktop, opens the window; egui draws it with the GPU.
    Self-check: the app prints the label text and closes after ~2 seconds.
Hello, World!
```

## Fontes
1. emilk/egui (README: description, immediate mode, eframe, Linux packages). GitHub. <https://github.com/emilk/egui> (acessado em 2026-10-31)
2. The Cargo Book: `cargo build`. The Rust Project. <https://doc.rust-lang.org/cargo/commands/cargo-build.html> (acessado em 2026-10-31)
3. The Cargo Book: Package Layout. The Rust Project. <https://doc.rust-lang.org/cargo/guide/project-layout.html> (acessado em 2026-10-31)
4. The Cargo Book: Specifying Dependencies (caret requirements). The Rust Project. <https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html> (acessado em 2026-10-31)
5. eframe 0.37.0: README, `Cargo.toml` features and API (`run_ui_native`). docs.rs and GitHub. <https://docs.rs/eframe/0.37.0/eframe/> and <https://github.com/emilk/egui/blob/0.37.0/crates/eframe/Cargo.toml> (acessado em 2026-10-31; também lido a partir do crate baixado)
6. crates.io API: eframe 0.37.0 (publish date, `rust_version`). crates.io. <https://crates.io/api/v1/crates/eframe/0.37.0> (acessado em 2026-10-31)
7. Announcing Rust 1.95.0. The Rust Release Team, 2026-04-16. <https://blog.rust-lang.org/2026/04/16/Rust-1.95.0/> (acessado em 2026-10-31)
8. gfx-rs/wgpu (README: supported backends). GitHub. <https://github.com/gfx-rs/wgpu> (acessado em 2026-10-31; também lido a partir do crate wgpu 30.0.1 baixado)
9. The Rust Programming Language, ch. 9.2 "Recoverable Errors with Result". The Rust Project. <https://doc.rust-lang.org/book/ch09-02-recoverable-errors-with-result.html> (acessado em 2026-10-31)
10. The Rust Programming Language, ch. 3.1 "Variables and Mutability". The Rust Project. <https://doc.rust-lang.org/book/ch03-01-variables-and-mutability.html> (acessado em 2026-10-31)
11. The Rust Programming Language, ch. 13.1 "Closures". The Rust Project. <https://doc.rust-lang.org/book/ch13-01-closures.html> (acessado em 2026-10-31)
12. egui CHANGELOG. emilk/egui (GitHub). <https://github.com/emilk/egui/blob/main/CHANGELOG.md> (acessado em 2026-10-31)
20. The rustup book: Other installation methods. The Rust Project. <https://rust-lang.github.io/rustup/installation/other.html> (acessado em 2026-11-19)
