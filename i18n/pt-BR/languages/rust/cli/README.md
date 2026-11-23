---
source: languages/rust/cli/README.md
source_sha: bbdcd181c36cc30eeb1bbb29434fbdd7ad7f3502
---
# Rust · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Rust](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É um único arquivo, `src/main.rs`, com uma função `main`, compilado
pelo **Cargo**, a ferramenta de build e gerenciador de pacotes do Rust. Como a
[versão `cli` do Go](../../go/cli/), ele é **compilado** para um executável
nativo, `target/release/hello-cli`, que executa sem que o Rust esteja
instalado. Diferentemente do Go, o código-fonte fica em uma pasta `src/`,
porque é ali que o Cargo o procura.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| Rust 1.85 ou posterior (`rustc` + `cargo`) | Rust 1.98.1 (Homebrew) | o `cargo` compila o pacote e o `rustc` o compila |

Nenhuma outra ferramenta é necessária: `println!` faz parte da biblioteca
padrão do Rust, portanto nenhum crate (biblioteca) é baixado. O Rust 1.85 é o
mínimo porque `Cargo.toml` usa a edição 2024, que o Rust 1.85.0 estabilizou
em 2025-02-20 [9].

## Início rápido
```sh
./install.sh   # check / install Rust (asks before installing)
./build.sh     # compile into target/release/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Executa `rustc --version` e verifica se `cargo` existe e se o Rust é 1.85 ou posterior. Caso contrário, baixa para um arquivo o script por trás do comando oficial do rustup (`https://sh.rustup.rs` [10]) e mostra o caminho dele; em seguida, só o executa com `sh` se a resposta for `y`. Ele pergunta também antes do download. No Windows, imprime o comando do winget. | O Rust é compilado. O rustup "installs rustc, cargo, rustup and other standard tools to Cargo's bin directory" (tradução livre: "instala rustc, cargo, rustup e outras ferramentas padrão no diretório bin do Cargo"), `$HOME/.cargo/bin` no Unix [11]; portanto, não é necessário `sudo`. |
| `build.sh` | Executa `cargo build --release --locked` | `--release`: "Build optimized artifacts with the release profile" [4] (tradução livre: "Compilar artefatos otimizados com o perfil release"); o resultado vai para `target/release` em vez de `target/debug` [2]. `--locked`: "Asserts that the exact same dependencies and versions are used as when the existing Cargo.lock file was originally generated" [4] (tradução livre: "Garante que sejam usadas exatamente as mesmas dependências e versões de quando o arquivo Cargo.lock existente foi gerado originalmente"). |
| `run.sh` | Executa `./target/release/hello-cli`. `--verify` faz o mesmo (um programa CLI termina por conta própria). | O executável é código de máquina, de modo que o sistema operacional o executa diretamente: sem interpretador, sem JVM, e o Rust não precisa estar instalado no computador que o executa. |

## Estrutura de pastas
```text
cli/
├── README.md        this file
├── install.sh       checks / installs Rust
├── build.sh         compiles with cargo build
├── run.sh           runs target/release/hello-cli
├── Cargo.toml       the manifest: package name, edition, minimum Rust version
├── Cargo.lock       the exact versions of every dependency (here: none)
├── src/
│   └── main.rs      the program
└── target/          created by build.sh; not committed (see ../../../.gitignore)
    └── release/
        └── hello-cli
```
- Este é o layout de pacote padrão do Cargo: "Cargo.toml and Cargo.lock are
  stored in the root of your package (package root)" e "The default
  executable file is src/main.rs" [3] (tradução livre: "Cargo.toml e
  Cargo.lock ficam na raiz do pacote (package root)" e "O arquivo executável
  padrão é src/main.rs"). Por causa dessas convenções, `Cargo.toml` não
  precisa listar nenhum arquivo de código-fonte.
- **`Cargo.toml`** é o manifesto [5]. `edition` "affects which Rust Edition
  your package is compiled with" [5] (tradução livre: "afeta com qual edição
  do Rust o pacote é compilado"); `rust-version` "tells cargo what version of
  the Rust toolchain you support for your package" [5] (tradução livre: "informa
  ao cargo qual versão da toolchain do Rust o pacote suporta"); `publish =
  false` impede a publicação no crates.io "by mistake" [5] (tradução livre:
  "por engano").
- **`Cargo.lock`** é escrito pelo Cargo. Sem dependências, ele lista apenas
  este pacote, mas é versionado mesmo assim, como em toda pasta Rust deste
  repositório. O guia do Cargo diz: "When in doubt, check Cargo.lock into the
  version control system (e.g. Git)" [6] (tradução livre: "Na dúvida,
  registre o Cargo.lock no sistema de controle de versão (por exemplo, o
  Git)").
- `target/` contém toda a saída de compilação (incluindo o cache de
  dependências compiladas do Cargo). Ela é ignorada pelo `.gitignore` da raiz.

## Passo a passo
Abra [`src/main.rs`](src/main.rs) ao lado desta lista.

1. **`fn main() { ... }`**: `fn` declara uma função. "The main function is
   special: It is always the first code that runs in every executable Rust
   program" [1] (tradução livre: "A função main é especial: é sempre o
   primeiro código a executar em todo programa Rust executável"). Como o
   `func main()` do Go, ela não recebe parâmetros; compare com o
   `public static void main(String[] args)` do Java. Não há classe nem linha
   `package`: o crate é definido por `Cargo.toml`, e não pelo arquivo.
2. **`println!("Hello, World!");`** "Prints to the standard output, with a
   newline" [8] (tradução livre: "Imprime na saída padrão, com uma quebra de
   linha").
   - O `!` importa: "println! calls a Rust macro. If it had called a
     function instead, it would be entered as println (without the !)" [1]
     (tradução livre: "println! chama uma macro do Rust. Se tivesse chamado uma
     função, seria escrito como println (sem o !)"). Uma macro é expandida em
     código em tempo de compilação. É assim que `println!("{}", x)` consegue
     verificar sua string de formato em relação aos argumentos antes de o
     programa executar; um erro de digitação ali é um erro de compilação, e
     não um erro em tempo de execução como no `str.format` do Python.
   - Nenhum `import` (`use` no Rust): as macros da biblioteca padrão, como
     `println!`, estão disponíveis em todo programa. O Go precisa de
     `import "fmt"`.
   - O ponto e vírgula "indicates that this expression is over, and the next
     one is ready to begin" [1] (tradução livre: "indica que esta expressão
     terminou e que a próxima está pronta para começar"). Diferentemente do
     Go, o Rust não o insere automaticamente.
3. **Compilar e depois executar.** `cargo build --release` transforma
   `src/main.rs` em `target/release/hello-cli`, um executável nativo (na
   máquina de teste, um "Mach-O 64-bit executable x86_64", conforme o `file`
   informa, com 418 KB). Ou faça as duas etapas de uma vez:
   ```sh
   cargo run --release
   ```
4. **Formatação.** `cargo fmt` "Formats all bin and lib files of the current
   crate using rustfmt" [7] (tradução livre: "Formata todos os arquivos bin e
   lib do crate atual usando o rustfmt"). `cargo fmt --check` não imprime
   nada para esta pasta: o código já segue o estilo padrão do Rust
   (indentação de 4 espaços, diferentemente das tabulações do Go).

## Por que esta toolchain
- **O Cargo e o `rustc` do projeto Rust** são a única forma padrão de compilar
  Rust; "By default cargo new creates a manifest with the 2024 edition
  currently" [5] (tradução livre: "Por padrão, cargo new cria atualmente um
  manifesto com a edição 2024"), a edição usada aqui.
- O **rustup** é o instalador recomendado em rust-lang.org [10] e o que
  `install.sh` oferece. Ele instala na pasta pessoal do usuário e pode
  atualizar o Rust depois (`rustup update`).
- **Na máquina de teste,** o Rust 1.98.1 veio da fórmula `rust` do Homebrew (a
  fórmula estava na 1.99.1 em 2026-10-31). O Homebrew não tem bottle para
  macOS Intel de `rust` nem de `rustup`; assim, em um Mac Intel,
  `brew install rust` compila o Rust a partir do código-fonte [12]: mais um
  motivo para preferir o rustup nesse caso.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Rust 1.98.1 do Homebrew (o rustup também funciona, ver acima). |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. O executável é então compilado para arm64 (`aarch64-apple-darwin`). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` baixa o script instalador do rustup de `https://sh.rustup.rs` [10] e o executa quando o Rust 1.85 ou posterior não existe. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Rust: se o Rust 1.85 ou posterior não existe, ele imprime `winget install --id Rustlang.Rustup -e` [13] e para. O rustup exige as Build Tools C++ do Visual Studio [14]. O WSL não foi verificado; ele se comporta como o Linux. |

**O script do rustup não tem verificação de checksum.** O rustup publica arquivos
SHA-256 para os programas `rustup-init`, mas não para o script `rustup-init.sh`
por trás de `https://sh.rustup.rs` [20], e esse script muda a cada versão do
rustup. Por isso, o `install.sh` o salva em
`~/.cache/hello-world-rust/rustup-init.sh` e mostra o caminho, para que você
possa ler o script antes de responder `y` para executá-lo.

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: target/release/hello-cli is machine code; the operating system runs it directly.
Hello, World!
```
O programa em si imprime apenas a última linha; as demais vêm de `run.sh`.

## Fontes
1. The Rust Programming Language, ch. 1.2 "Hello, World!". The Rust Project. <https://doc.rust-lang.org/book/ch01-02-hello-world.html> (acessado em 2026-10-31)
2. The Rust Programming Language, ch. 1.3 "Hello, Cargo!". The Rust Project. <https://doc.rust-lang.org/book/ch01-03-hello-cargo.html> (acessado em 2026-10-31)
3. The Cargo Book: Package Layout. The Rust Project. <https://doc.rust-lang.org/cargo/guide/project-layout.html> (acessado em 2026-10-31)
4. The Cargo Book: `cargo build`. The Rust Project. <https://doc.rust-lang.org/cargo/commands/cargo-build.html> (acessado em 2026-10-31)
5. The Cargo Book: The Manifest Format (edition, rust-version, publish). The Rust Project. <https://doc.rust-lang.org/cargo/reference/manifest.html> (acessado em 2026-10-31)
6. The Cargo Book: Cargo.toml vs Cargo.lock. The Rust Project. <https://doc.rust-lang.org/cargo/guide/cargo-toml-vs-cargo-lock.html> (acessado em 2026-10-31)
7. The Cargo Book: `cargo fmt`. The Rust Project. <https://doc.rust-lang.org/cargo/commands/cargo-fmt.html> (acessado em 2026-10-31)
8. Macro std::println. The Rust Standard Library. <https://doc.rust-lang.org/std/macro.println.html> (acessado em 2026-10-31)
9. Announcing Rust 1.85.0 and Rust 2024. The Rust Release Team, 2025-02-20. <https://blog.rust-lang.org/2025/02/20/Rust-1.85.0/> (acessado em 2026-10-31)
10. Install Rust. The Rust Project. <https://www.rust-lang.org/tools/install> (acessado em 2026-10-31)
11. The rustup book: Installation. The Rust Project. <https://rust-lang.github.io/rustup/installation/index.html> (acessado em 2026-10-31)
12. rust and rustup formulae (versions, bottles). Homebrew Formulae. <https://formulae.brew.sh/formula/rust> and <https://formulae.brew.sh/formula/rustup> (acessado em 2026-10-31)
13. Rustlang.Rustup manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/r/Rustlang/Rustup> (acessado em 2026-10-31)
14. The rustup book: Windows MSVC prerequisites. The Rust Project. <https://rust-lang.github.io/rustup/installation/windows-msvc.html> (acessado em 2026-10-31)
15. The Rust Programming Language, ch. 1.1 "Installation". The Rust Project. <https://doc.rust-lang.org/book/ch01-01-installation.html> (acessado em 2026-10-31)
20. The rustup book: Other installation methods. The Rust Project. <https://rust-lang.github.io/rustup/installation/other.html> (acessado em 2026-11-19)
