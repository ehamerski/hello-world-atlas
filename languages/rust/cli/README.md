# Rust · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Rust](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, `src/main.rs`, with a `main` function, built by **Cargo**, Rust's
build tool and package manager. Like the [Go `cli` version](../../go/cli/), it is
**compiled** to a native executable, `target/release/hello-cli`, that runs
without Rust installed. Unlike Go, the source sits in a `src/` folder,
because that is where Cargo looks for it.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Rust 1.85 or newer (`rustc` + `cargo`) | Rust 1.98.1 (Homebrew) | `cargo` builds the package and `rustc` compiles it |

No other tool is needed: `println!` is part of Rust's standard library, so
no crate (library) is downloaded. Rust 1.85 is the minimum because
`Cargo.toml` uses
edition 2024, which Rust 1.85.0 stabilized on 2025-02-20 [9].

## Quick start
```sh
./install.sh   # check / install Rust (asks before installing)
./build.sh     # compile into target/release/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Runs `rustc --version` and checks that `cargo` exists and Rust is 1.85 or newer. If not, it shows the official rustup command (`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` [10]) and runs it only if you answer `y`. On Windows it prints the winget command. | Rust is compiled. rustup "installs rustc, cargo, rustup and other standard tools to Cargo's bin directory", `$HOME/.cargo/bin` on Unix [11], so no `sudo` is needed. |
| `build.sh` | Runs `cargo build --release --locked` | `--release`: "Build optimized artifacts with the release profile" [4]; the result goes to `target/release` instead of `target/debug` [2]. `--locked`: "Asserts that the exact same dependencies and versions are used as when the existing Cargo.lock file was originally generated" [4]. |
| `run.sh` | Runs `./target/release/hello-cli`. `--verify` does the same (a CLI program ends by itself). | The executable is machine code, so the operating system runs it directly: no interpreter, no JVM, and Rust does not have to be installed on the computer that runs it. |

## Folder structure
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
- This is Cargo's standard package layout: "Cargo.toml and Cargo.lock are
  stored in the root of your package (package root)" and "The default
  executable file is src/main.rs" [3]. Because of these conventions,
  `Cargo.toml` does not have to list any source file.
- **`Cargo.toml`** is the manifest [5]. `edition` "affects which Rust
  Edition your package is compiled with" [5]; `rust-version` "tells cargo
  what version of the Rust toolchain you support for your package" [5];
  `publish = false` prevents publishing to crates.io "by mistake" [5].
- **`Cargo.lock`** is written by Cargo. With no dependencies it only lists
  this package, but it is committed anyway, as in every Rust folder here.
  Cargo's guide says: "When in doubt, check Cargo.lock into the version
  control system (e.g. Git)" [6].
- `target/` holds every build output (including Cargo's cache of
  compiled dependencies). It is ignored by the root `.gitignore`.

## Step-by-step walkthrough
Open [`src/main.rs`](src/main.rs) next to this list.

1. **`fn main() { ... }`**: `fn` declares a function. "The main function is
   special: It is always the first code that runs in every executable Rust
   program" [1]. Like Go's `func main()`, it takes no parameters; compare
   Java's `public static void main(String[] args)`. There is no class and
   no `package` line: the crate is defined by `Cargo.toml`, not by the file.
2. **`println!("Hello, World!");`** "Prints to the standard output, with a
   newline" [8].
   - The `!` matters: "println! calls a Rust macro. If it had called a
     function instead, it would be entered as println (without the !)" [1].
     A macro is expanded into code at compile time. That is how
     `println!("{}", x)` can check its format string against its arguments
     before the program runs; a typo there is a compile error, not a
     run-time error as with Python's `str.format`.
   - No `import` (`use` in Rust): the standard library's macros, such as
     `println!`, are available in every program. Go needs `import "fmt"`.
   - The semicolon "indicates that this expression is over, and the next
     one is ready to begin" [1]. Unlike Go, Rust does not insert it for you.
3. **Compile, then run.** `cargo build --release` turns `src/main.rs` into
   `target/release/hello-cli`, a native executable (on the test machine, a
   "Mach-O 64-bit executable x86_64", as `file` reports, 418 KB). Or do
   both steps at once:
   ```sh
   cargo run --release
   ```
4. **Formatting.** `cargo fmt` "Formats all bin and lib files of the
   current crate using rustfmt" [7]. `cargo fmt --check` prints nothing
   for this folder: the code already follows Rust's standard style
   (4-space indentation, unlike Go's tabs).

## Why this toolchain
- **Cargo and `rustc` from the Rust project** are the only standard way to
  build Rust; "By default cargo new creates a manifest with the 2024 edition
  currently" [5], the edition used here.
- **rustup** is the installer recommended on rust-lang.org [10], and the one
  `install.sh` offers. It installs into your home folder and can update
  Rust later (`rustup update`).
- **On the test machine,** Rust 1.98.1 came from Homebrew's `rust` formula
  (the formula was at 1.99.1 on 2026-10-31). Homebrew has no Intel-macOS
  bottle for `rust` or `rustup`, so on an Intel Mac `brew install rust`
  builds Rust from source [12]: another reason to prefer rustup there.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Rust 1.98.1 from Homebrew (rustup also works, see above). |
| macOS Apple Silicon | ⚠️ not verified | Same commands. The executable is then built for arm64 (`aarch64-apple-darwin`). |
| Linux (Debian/Ubuntu) | ⚠️ not verified | rustup, same command as macOS [10]. Rust also needs "a linker, which is a program that Rust uses to join its compiled outputs into one file"; on Ubuntu, "you can install the build-essential package" [15]. The distribution's `rustc` package may be older than 1.85. |
| Windows (Git Bash / WSL) | ⚠️ not verified | `winget install --id Rustlang.Rustup -e` [13], or `rustup-init.exe` from [10]. For the default MSVC toolchain "Rust requires a linker, libraries and Windows API import libraries", and "rustup-init will offer to automatically install the prerequisites" (Visual Studio Build Tools) [14]. The executable is `target\release\hello-cli.exe`; these scripts do not handle the `.exe` suffix. Native commands (PowerShell): `cargo build --release --locked`, then `.\target\release\hello-cli.exe`. WSL behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: target/release/hello-cli is machine code; the operating system runs it directly.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. The Rust Programming Language, ch. 1.2 "Hello, World!". The Rust Project. <https://doc.rust-lang.org/book/ch01-02-hello-world.html> (accessed 2026-10-31)
2. The Rust Programming Language, ch. 1.3 "Hello, Cargo!". The Rust Project. <https://doc.rust-lang.org/book/ch01-03-hello-cargo.html> (accessed 2026-10-31)
3. The Cargo Book: Package Layout. The Rust Project. <https://doc.rust-lang.org/cargo/guide/project-layout.html> (accessed 2026-10-31)
4. The Cargo Book: `cargo build`. The Rust Project. <https://doc.rust-lang.org/cargo/commands/cargo-build.html> (accessed 2026-10-31)
5. The Cargo Book: The Manifest Format (edition, rust-version, publish). The Rust Project. <https://doc.rust-lang.org/cargo/reference/manifest.html> (accessed 2026-10-31)
6. The Cargo Book: Cargo.toml vs Cargo.lock. The Rust Project. <https://doc.rust-lang.org/cargo/guide/cargo-toml-vs-cargo-lock.html> (accessed 2026-10-31)
7. The Cargo Book: `cargo fmt`. The Rust Project. <https://doc.rust-lang.org/cargo/commands/cargo-fmt.html> (accessed 2026-10-31)
8. Macro std::println. The Rust Standard Library. <https://doc.rust-lang.org/std/macro.println.html> (accessed 2026-10-31)
9. Announcing Rust 1.85.0 and Rust 2024. The Rust Release Team, 2025-02-20. <https://blog.rust-lang.org/2025/02/20/Rust-1.85.0/> (accessed 2026-10-31)
10. Install Rust. The Rust Project. <https://www.rust-lang.org/tools/install> (accessed 2026-10-31)
11. The rustup book: Installation. The Rust Project. <https://rust-lang.github.io/rustup/installation/index.html> (accessed 2026-10-31)
12. rust and rustup formulae (versions, bottles). Homebrew Formulae. <https://formulae.brew.sh/formula/rust> and <https://formulae.brew.sh/formula/rustup> (accessed 2026-10-31)
13. Rustlang.Rustup manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/r/Rustlang/Rustup> (accessed 2026-10-31)
14. The rustup book: Windows MSVC prerequisites. The Rust Project. <https://rust-lang.github.io/rustup/installation/windows-msvc.html> (accessed 2026-10-31)
15. The Rust Programming Language, ch. 1.1 "Installation". The Rust Project. <https://doc.rust-lang.org/book/ch01-01-installation.html> (accessed 2026-10-31)
