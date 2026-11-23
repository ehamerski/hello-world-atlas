# Go · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Go](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, `main.go`, with a `main` function in package `main`. Like the
[Java `cli` version](../../java/cli/), it is **compiled** first, so this folder has a
`build.sh`. Unlike Java, the result is a native executable for your
computer, `bin/hello-cli`, not bytecode for a virtual machine.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Go 1.22 or newer | Go 1.27.3 (Homebrew) | the `go` command compiles and links the program |

No other tool is needed: `fmt` is part of Go's standard library, so nothing is
downloaded. Go 1.27.3 was released on 2026-10-19 [7]. The program itself
would build with any Go 1.x release; 1.22 is the minimum shared by all four
Go folders (see [../web](../web/README.md#why-this-toolchain)).

## Quick start
```sh
./install.sh   # check / install Go (asks before installing)
./build.sh     # compile into bin/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Runs `go env GOVERSION` and checks that the version is 1.22 or newer. If Go is missing, it shows the install command (Homebrew, the official archive on Linux, or winget) and runs it only if you answer `y`. | Go is compiled, and the `go` command is the whole toolchain: compiler, linker, formatter, test runner, and module downloader in one program [5]. |
| `build.sh` | Runs `go build -o bin/hello-cli .` | `go build` "compiles the packages named by the import paths, along with their dependencies"; the `-o` flag "forces build to write the resulting executable or object to the named output file" [5]. `.` means the package in this folder. |
| `run.sh` | Runs `./bin/hello-cli`. `--verify` does the same (a CLI program ends by itself). | The executable is machine code, so the operating system runs it directly: no interpreter, no JVM, and Go does not have to be installed on the computer that runs it. |

## Folder structure
```text
cli/
├── README.md        this file
├── install.sh       checks / installs Go
├── build.sh         compiles with go build
├── run.sh           runs bin/hello-cli
├── go.mod           the module file: the module's name and the minimum Go version
├── main.go          the program
└── bin/             created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- This is the "basic command" layout from Go's own guide, *Organizing a Go
  module*: "The simplest program can consist of a single Go file where
  `func main` is defined" [3]. There is no `src/` folder and no package
  folders as in Java's Maven layout.
- **`go.mod`** makes the folder a *module*. The tutorial says: "To enable
  dependency tracking for your code by creating a go.mod file, run the go
  mod init command, giving it the name of the module your code will be
  in" [2]. Its first line names the module (`example.com/hello-cli`).
  A module path "should describe both what the module does and where to
  find it" [4]; `example.com` is reserved for examples [11], so this path
  belongs to nobody.
- The `go 1.22` line "sets the minimum version of Go required to use this
  module"; since Go 1.21 "Go toolchains refuse to use modules declaring
  newer Go versions" [4].
- There is no `go.sum` here: that file records the checksums of downloaded
  modules [4], and this program downloads none. Compare [../desktop](../desktop/).
- `bin/` is ignored by the root `.gitignore`: build output is never
  committed.

## Step-by-step walkthrough
Open [`main.go`](main.go) next to this list.

1. **`package main`**: every Go file starts by naming its package. The
   spec says: "A complete program is created by linking a single, unimported
   package called the main package with all the packages it imports" [1].
   Unlike Java, there is no class around the code: Go has no classes.
2. **`import "fmt"`** makes the standard library package `fmt` (format)
   available. Go is strict here: "It is illegal for a package ... to
   directly import a package without referring to any of its exported
   identifiers" [1], so an unused import is a compile error. Java and Python
   accept unused imports.
3. **`func main()`**: "Program execution begins by initializing the program
   and then invoking the function main in package main", and main "takes no
   arguments and returns no value" [1]. Compare Java's
   `public static void main(String[] args)` and C's `int main(void)`. In Go
   the arguments are in `os.Args` and the exit code is set with `os.Exit`.
4. **`fmt.Println("Hello, World!")`** "writes to standard output. Spaces
   are always added between operands and a newline is appended" [8].
   - `Println` starts with a capital letter because it is **exported**: a
     name is visible outside its package when "the first character of the
     identifier's name is a Unicode uppercase letter" [1]. That is Go's
     replacement for Java's `public`.
   - There is no semicolon. Go has them, but "a semicolon is automatically
     inserted into the token stream immediately after a line's final token"
     when that token is, for example, a `)` [1].
5. **Compile, then run.** `go build` turns `main.go` into `bin/hello-cli`, a
   native executable (on the test machine, a "Mach-O 64-bit executable x86_64",
   as `file bin/hello-cli` reports). Or do both steps at once, without
   keeping the executable:
   ```sh
   go run .
   ```
6. **Formatting.** The code is laid out by `gofmt`, the official formatter:
   "The gofmt program ... reads a Go program and emits the source in a
   standard style" [9]. That is why the indentation uses tabs. Run
   `gofmt -l .` to list files that are not formatted (it prints nothing here).

## Why this toolchain
- **The official Go distribution** from go.dev [6]: the `go` command with
  the Go team's compiler, `gc` (`go version -m bin/hello-cli` shows
  `-compiler=gc`). Building needs nothing but `go build` [5]: there is no
  separate build tool like Maven.
- **Homebrew on macOS** packages the same release (the `go` formula was at
  1.27.3 on 2026-10-31) [10]. The official `.pkg` installer from
  <https://go.dev/dl/> works too [6].
- **Supported versions:** "Each major Go release is supported until there
  are two newer major releases" [7]. On 2026-10-31 that means Go 1.26 and
  1.27. The minimum 1.22 in `go.mod` only says which language features the
  code uses; install a supported release.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Go 1.27.3 from Homebrew. |
| macOS Apple Silicon | ⚠️ not verified | Same commands (`brew install go` [10]). The executable is then built for arm64, the value `go env GOARCH` reports there. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` does not install Go: if Go 1.22 or newer is missing it prints the go.dev archive steps [6] and stops. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does not install Go: if Go 1.22 or newer is missing it prints `winget install --id GoLang.Go -e` [12] and stops. WSL not verified; it behaves like Linux. |

**Cross-compiling:** Go can build for another system from this one, for example
`GOOS=windows GOARCH=amd64 go build -o bin/hello-cli.exe .` [5]. This was
not tested on Windows.

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. The Go Programming Language Specification (Packages, Import declarations, Program execution, Exported identifiers, Semicolons). The Go Authors. <https://go.dev/ref/spec> (accessed 2026-10-31)
2. Tutorial: Get started with Go. The Go Authors. <https://go.dev/doc/tutorial/getting-started> (accessed 2026-10-31)
3. Organizing a Go module. The Go Authors. <https://go.dev/doc/modules/layout> (accessed 2026-10-31)
4. Go Modules Reference (go.mod, go directive, go.sum). The Go Authors. <https://go.dev/ref/mod> (accessed 2026-10-31)
5. Command go (go build, environment variables). The Go Authors. <https://pkg.go.dev/cmd/go> (accessed 2026-10-31)
6. Download and install. The Go Authors. <https://go.dev/doc/install> (accessed 2026-10-31)
7. Release History. The Go Authors. <https://go.dev/doc/devel/release> (accessed 2026-10-31)
8. Package `fmt` (`Println`).
 The Go Authors. <https://pkg.go.dev/fmt#Println> (accessed 2026-10-31)
9. Effective Go (Formatting). The Go Authors. <https://go.dev/doc/effective_go#formatting> (accessed 2026-10-31)
10. go (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/go> (accessed 2026-10-31)
11. RFC 2606: Reserved Top Level DNS Names. IETF. <https://www.rfc-editor.org/rfc/rfc2606> (accessed 2026-10-31)
12. GoLang.Go manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/g/GoLang/Go> (accessed 2026-10-31)
