---
source: languages/go/cli/README.md
source_sha: 6c7369e3cb5578ce432829f46075c6984ffe0d72
---
# Go · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Go](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É composto por um único arquivo, `main.go`, com uma função `main`
no pacote `main`. Assim como a [versão `cli` em Java](../../java/cli/), é
**compilado** antes de ser executado, de modo que esta pasta tem um
`build.sh`. Diferentemente do Java, o resultado é um executável nativo para
o computador do leitor, `bin/hello-cli`, e não bytecode para uma máquina
virtual.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Go 1.22 ou superior | Go 1.27.3 (Homebrew) | o comando `go` compila e liga o programa |

Nenhuma outra ferramenta é necessária: o `fmt` faz parte da biblioteca
padrão do Go, de modo que nada é baixado. O Go 1.27.3 foi lançado em
2026-10-19 [7]. O programa em si compilaria com qualquer versão 1.x do Go;
a 1.22 é o mínimo compartilhado pelas quatro pastas Go (ver
[../web](../web/README.md#why-this-toolchain)).

## Início rápido
```sh
./install.sh   # check / install Go (asks before installing)
./build.sh     # compile into bin/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Executa `go env GOVERSION` e verifica se a versão é 1.22 ou superior. Se o Go não estiver instalado, mostra o comando de instalação (Homebrew, o arquivo oficial no Linux ou winget) e só o executa se você responder `y`. | O Go é compilado, e o comando `go` é toda a toolchain: compilador, linker, formatador, executor de testes e baixador de módulos em um único programa [5]. |
| `build.sh` | Executa `go build -o bin/hello-cli .` | O `go build` "compiles the packages named by the import paths, along with their dependencies" (tradução livre: "compila os pacotes indicados pelos caminhos de importação, junto com suas dependências"); a opção `-o` "forces build to write the resulting executable or object to the named output file" (tradução livre: "força o build a gravar o executável ou objeto resultante no arquivo de saída indicado") [5]. O `.` significa o pacote desta pasta. |
| `run.sh` | Executa `./bin/hello-cli`. `--verify` faz o mesmo (um programa CLI termina por conta própria). | O executável é código de máquina, de modo que o sistema operacional o executa diretamente: sem interpretador, sem JVM, e o Go não precisa estar instalado no computador que o executa. |

## Estrutura de pastas
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
- Esta é a estrutura de "comando básico" do guia do próprio Go, *Organizing
  a Go module*: "The simplest program can consist of a single Go file where
  `func main` is defined" [3] (tradução livre: "O programa mais simples pode
  consistir em um único arquivo Go em que `func main` é definida"). Não há
  pasta `src/` nem pastas de pacotes como na estrutura do Maven, no Java.
- O **`go.mod`** transforma a pasta em um *módulo*. O tutorial afirma: "To
  enable dependency tracking for your code by creating a go.mod file, run
  the go mod init command, giving it the name of the module your code will
  be in" [2] (tradução livre: "Para habilitar o rastreamento de
  dependências do código criando um arquivo go.mod, execute o comando go
  mod init, informando o nome do módulo em que o código ficará"). A
  primeira linha nomeia o módulo (`example.com/hello-cli`). O caminho de um
  módulo "should describe both what the module does and where to find it"
  [4] (tradução livre: "deve descrever tanto o que o módulo faz quanto onde
  encontrá-lo"); `example.com` é reservado para exemplos [11], de modo que
  este caminho não pertence a ninguém.
- A linha `go 1.22` "sets the minimum version of Go required to use this
  module" (tradução livre: "define a versão mínima do Go necessária para
  usar este módulo"); desde o Go 1.21, "Go toolchains refuse to use modules
  declaring newer Go versions" [4] (tradução livre: "as toolchains do Go
  se recusam a usar módulos que declaram versões mais novas do Go").
- Não há `go.sum` aqui: esse arquivo registra os checksums dos módulos
  baixados [4], e este programa não baixa nenhum. Compare com
  [../desktop](../desktop/).
- O `bin/` é ignorado pelo `.gitignore` da raiz: a saída da compilação
  nunca é incluída no repositório.

## Passo a passo
Abra o [`main.go`](main.go) ao lado desta lista.

1. **`package main`**: todo arquivo Go começa nomeando seu pacote. A
   especificação afirma: "A complete program is created by linking a
   single, unimported package called the main package with all the packages
   it imports" [1] (tradução livre: "Um programa completo é criado ligando
   um único pacote não importado, chamado de pacote main, com todos os
   pacotes que ele importa"). Diferentemente do Java, não há classe em
   torno do código: o Go não tem classes.
2. **`import "fmt"`** disponibiliza o pacote `fmt` (format) da biblioteca
   padrão. O Go é rigoroso neste ponto: "It is illegal for a package ... to
   directly import a package without referring to any of its exported
   identifiers" [1] (tradução livre: "É ilegal um pacote ... importar
   diretamente um pacote sem se referir a nenhum de seus identificadores
   exportados"), de modo que uma importação não usada é um erro de
   compilação. Java e Python aceitam importações não usadas.
3. **`func main()`**: "Program execution begins by initializing the program
   and then invoking the function main in package main", e a main "takes no
   arguments and returns no value" [1] (tradução livre: "A execução do
   programa começa inicializando o programa e, em seguida, invocando a
   função main do pacote main"; a main "não recebe argumentos e não
   retorna valor"). Compare com o `public static void main(String[] args)`
   do Java e o `int main(void)` do C. No Go, os argumentos estão em
   `os.Args` e o código de saída é definido com `os.Exit`.
4. **`fmt.Println("Hello, World!")`** "writes to standard output. Spaces
   are always added between operands and a newline is appended" [8]
   (tradução livre: "escreve na saída padrão. Espaços são sempre
   adicionados entre os operandos e uma quebra de linha é acrescentada").
   - `Println` começa com letra maiúscula porque é **exportado**: um nome
     é visível fora de seu pacote quando "the first character of the
     identifier's name is a Unicode uppercase letter" [1] (tradução livre:
     "o primeiro caractere do nome do identificador é uma letra maiúscula
     Unicode"). Essa é a substituta do Go para o `public` do Java.
   - Não há ponto e vírgula. O Go os tem, mas "a semicolon is automatically
     inserted into the token stream immediately after a line's final token"
     [1] (tradução livre: "um ponto e vírgula é inserido automaticamente no
     fluxo de tokens imediatamente após o último token de uma linha")
     quando esse token é, por exemplo, um `)`.
5. **Compilar e depois executar.** O `go build` transforma o `main.go` em
   `bin/hello-cli`, um executável nativo (na máquina de teste, um "Mach-O
   64-bit executable x86_64", conforme o `file bin/hello-cli` informa). Ou
   é possível fazer as duas etapas de uma vez, sem manter o executável:
   ```sh
   go run .
   ```
6. **Formatação.** O código é organizado pelo `gofmt`, o formatador oficial:
   "The gofmt program ... reads a Go program and emits the source in a
   standard style" [9] (tradução livre: "O programa gofmt ... lê um
   programa Go e emite o código-fonte em um estilo padrão"). Por isso a
   indentação usa tabulações. Execute `gofmt -l .` para listar os arquivos
   que não estão formatados (aqui, ele não imprime nada).

## Por que esta toolchain
- **A distribuição oficial do Go**, de go.dev [6]: o comando `go` com o
  compilador da equipe do Go, o `gc` (`go version -m bin/hello-cli` mostra
  `-compiler=gc`). Compilar exige apenas o `go build` [5]: não há uma
  ferramenta de build separada como o Maven.
- **O Homebrew no macOS** empacota a mesma versão (a fórmula `go` estava na
  1.27.3 em 2026-10-31) [10]. O instalador `.pkg` oficial, em
  <https://go.dev/dl/>, também funciona [6].
- **Versões suportadas:** "Each major Go release is supported until there
  are two newer major releases" [7] (tradução livre: "Cada versão principal
  do Go é suportada até que existam duas versões principais mais novas").
  Em 2026-10-31, isso significa o Go 1.26 e o 1.27. O mínimo 1.22 no
  `go.mod` apenas indica quais recursos da linguagem o código usa; convém
  instalar uma versão suportada.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Go 1.27.3 do Homebrew. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos (`brew install go` [10]). O executável é então compilado para arm64, o valor que `go env GOARCH` informa nessa plataforma. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` não instala o Go: se o Go 1.22 ou posterior não existe, ele imprime os passos do arquivo de go.dev [6] e para. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Go: se o Go 1.22 ou posterior não existe, ele imprime `winget install --id GoLang.Go -e` [12] e para. O WSL não foi verificado; ele se comporta como o Linux. |

**Compilação cruzada:** o Go pode gerar executáveis para outro sistema a
partir deste, por exemplo
`GOOS=windows GOARCH=amd64 go build -o bin/hello-cli.exe .` [5]. Isso não
foi testado no Windows.

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly.
Hello, World!
```
O programa em si imprime apenas a última linha; as demais linhas vêm do
`run.sh`.

## Fontes
1. The Go Programming Language Specification (Packages, Import declarations, Program execution, Exported identifiers, Semicolons). The Go Authors. <https://go.dev/ref/spec> (acessado em 2026-10-31)
2. Tutorial: Get started with Go. The Go Authors. <https://go.dev/doc/tutorial/getting-started> (acessado em 2026-10-31)
3. Organizing a Go module. The Go Authors. <https://go.dev/doc/modules/layout> (acessado em 2026-10-31)
4. Go Modules Reference (go.mod, go directive, go.sum). The Go Authors. <https://go.dev/ref/mod> (acessado em 2026-10-31)
5. Command go (go build, environment variables). The Go Authors. <https://pkg.go.dev/cmd/go> (acessado em 2026-10-31)
6. Download and install. The Go Authors. <https://go.dev/doc/install> (acessado em 2026-10-31)
7. Release History. The Go Authors. <https://go.dev/doc/devel/release> (acessado em 2026-10-31)
8. Package `fmt` (`Println`).
 The Go Authors. <https://pkg.go.dev/fmt#Println> (acessado em 2026-10-31)
9. Effective Go (Formatting). The Go Authors. <https://go.dev/doc/effective_go#formatting> (acessado em 2026-10-31)
10. go (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/go> (acessado em 2026-10-31)
11. RFC 2606: Reserved Top Level DNS Names. IETF. <https://www.rfc-editor.org/rfc/rfc2606> (acessado em 2026-10-31)
12. GoLang.Go manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/g/GoLang/Go> (acessado em 2026-10-31)
