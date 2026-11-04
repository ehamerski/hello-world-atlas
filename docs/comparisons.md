# Comparisons between the implementations

Every implementation in this repository does the same job, so the
differences you see are differences between the **languages and tools**,
not between programs. This page puts them side by side.
Facts about each tool are sourced in the linked README; the code
excerpts are copied from this repository with the comments removed.

- [A guided path through the walkthroughs](#a-guided-path-through-the-walkthroughs)
- [The cli Hello World in every language](#the-cli-hello-world-in-every-language)
- [What the cli programs have in common, and where they differ](#what-the-cli-programs-have-in-common-and-where-they-differ)
- [From source to running program](#from-source-to-running-program)
- [Web: one page, twelve servers](#web-one-page-twelve-servers)
- [Web with a separate front end](#web-with-a-separate-front-end)
- [Desktop: one label, ten toolkits](#desktop-one-label-ten-toolkits)
- [Comparisons inside each language](#comparisons-inside-each-language)

For the paradigm of each language (imperative, object-oriented, functional,
logic), see [paradigms.md](paradigms.md).

## A guided path through the walkthroughs
Every implementation README has a **Step-by-step walkthrough** that explains
its source line by line. They can be read in any order, but this order
builds each step on the one before. It is this repository's suggestion,
not a standard curriculum.

| Step | Read | What it adds |
|---|---|---|
| 1 | [`pseudocode/portugol`](../languages/pseudocode/portugol/README.md#step-by-step-walkthrough), [`pseudocode/pseint`](../languages/pseudocode/pseint/README.md#step-by-step-walkthrough), [`pseudocode/clrs`](../languages/pseudocode/clrs/README.md#step-by-step-walkthrough) | an algorithm before any real language |
| 2 | [`python/cli`](../languages/python/cli/README.md#step-by-step-walkthrough) | one statement, an interpreter, no build step |
| 3 | [`c/cli`](../languages/c/cli/README.md#step-by-step-walkthrough) | a compiler, a `main` function, a header file, an explicit `\n` |
| 4 | [`cpp/cli`](../languages/cpp/cli/README.md#step-by-step-walkthrough) and [C++ vs C](../languages/cpp/README.md#comparison-with-c) | namespaces and streams on top of C |
| 5 | [`java/cli`](../languages/java/cli/README.md#step-by-step-walkthrough), then [`csharp/cli`](../languages/csharp/cli/README.md#step-by-step-walkthrough) | classes, bytecode / IL and a virtual machine; C# hides the class with top-level statements |
| 6 | [`go/cli`](../languages/go/cli/README.md#step-by-step-walkthrough), [`rust/cli`](../languages/rust/cli/README.md#step-by-step-walkthrough) | modern compiled languages: packages, modules, a macro |
| 7 | [`haskell/cli`](../languages/haskell/cli/README.md#step-by-step-walkthrough), [`lisp/cli`](../languages/lisp/cli/README.md#step-by-step-walkthrough) | the functional paradigm |
| 8 | [`prolog/cli`](../languages/prolog/cli/README.md#step-by-step-walkthrough) | the logic paradigm |
| 9 | [`fortran/cli`](../languages/fortran/cli/README.md#step-by-step-walkthrough), [`cobol/cli`](../languages/cobol/cli/README.md#step-by-step-walkthrough), [`basic/cli`](../languages/basic/cli/README.md#step-by-step-walkthrough), [`pascal/cli`](../languages/pascal/cli/README.md#step-by-step-walkthrough), [`ada/cli`](../languages/ada/cli/README.md#step-by-step-walkthrough), [`clipper/cli`](../languages/clipper/cli/README.md#step-by-step-walkthrough) | the older languages, in the order they began (1950s to 1985; dates in each language README's **Milestones**) |
| 10 | [`assembly/cli`](../languages/assembly/cli/README.md#step-by-step-walkthrough) | what all of the above turn into: CPU instructions |
| 11 | [`python/web`](../languages/python/web/README.md#step-by-step-walkthrough), then any other `web` folder | an HTTP server and a route |
| 12 | [`java/web-react`](../languages/java/web-react/README.md#step-by-step-walkthrough), [`go/web-vue`](../languages/go/web-vue/README.md#step-by-step-walkthrough), [`csharp/web-angular`](../languages/csharp/web-angular/README.md#step-by-step-walkthrough) | an API plus a separate front end |
| 13 | [`python/desktop`](../languages/python/desktop/README.md#step-by-step-walkthrough), then any other `desktop` folder | windows, widgets and the event loop |

The [root README](../README.md#languages) lists all implementations.

## The cli Hello World in every language
Each program prints exactly `Hello, World!` and one newline
(checked by `scripts/verify-all.sh`). The first line of each excerpt names its file, and the walkthrough of each
implementation explains the code.

**One statement, nothing around it**
```python
print("Hello, World!")                       # python/cli/hello.py
```
```javascript
console.log("Hello, World!");                // node/cli/hello.js
```
```csharp
Console.WriteLine("Hello, World!");          // csharp/cli/Program.cs
```
```php
<?php
echo "Hello, World!\n";                      // php/cli/hello.php
```
```basic
$CONSOLE:ONLY
PRINT "Hello, World!"
SYSTEM
```
([`basic/cli/hello.bas`](../languages/basic/cli/hello.bas): `$CONSOLE:ONLY` is a QB64
*metacommand* for a terminal-only program and `SYSTEM` ends the program;
the [walkthrough](../languages/basic/cli/README.md#step-by-step-walkthrough)
explains both.)

**An entry point: a function or procedure named `main` (or the program's name)**
```c
#include <stdio.h>                           /* c/cli/hello.c */

int main(void)
{
    printf("Hello, World!\n");
    return 0;
}
```
```cpp
#include <iostream>                          // cpp/cli/hello.cpp

int main()
{
    std::cout << "Hello, World!\n";
}
```
```go
package main                                 // go/cli/main.go

import "fmt"

func main() {
	fmt.Println("Hello, World!")
}
```
```rust
fn main() {                                  // rust/cli/src/main.rs
    println!("Hello, World!");
}
```
```ada
with Ada.Text_IO;                            -- ada/cli/src/hello.adb

procedure Hello is
begin
   Ada.Text_IO.Put_Line ("Hello, World!");
end Hello;
```
```text
PROCEDURE Main()                             // clipper/cli/hello.prg
   ?? "Hello, World!"
   ?
   RETURN
```

**A class around the entry point**
```java
package com.example.hello;                   // java/cli/.../Hello.java

public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

**A program unit with its own structure**
```pascal
program hello(output);                       { pascal/cli/hello.pas }
begin
  writeln('Hello, World!')
end.
```
```fortran
program hello                                ! fortran/cli/hello.f90
    implicit none
    print '(a)', "Hello, World!"
end program hello
```
```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       PROCEDURE DIVISION.
           DISPLAY "Hello, World!".
           STOP RUN.
```
([`cobol/cli/hello.cob`](../languages/cobol/cli/hello.cob): in COBOL's fixed format
columns 1–6 and 7 are reserved, which is why every line starts with
spaces; see its [walkthrough](../languages/cobol/cli/README.md#step-by-step-walkthrough).)

**Functional and logic**
```haskell
module Main (main) where                     -- haskell/cli/hello.hs

main :: IO ()
main = putStrLn "Hello, World!"
```
```lisp
(defun main ()                               ; lisp/cli/hello.lisp
  (format t "Hello, World!~%"))
```
```prolog
:- initialization(main, main).               % prolog/cli/hello.pl

main :-
    format("Hello, World!~n").
```

**Machine level**
```nasm
        default rel                          ; assembly/cli/hello.asm (excerpt)
        global  _main
        extern  _write
        section .data
message:
        db      "Hello, World!", 10
message_len equ $ - message
        section .text
_main:
        push    rbp
        mov     edi, 1
        lea     rsi, [message]
        mov     edx, message_len
        call    _write
        xor     eax, eax
        pop     rbp
        ret
```

**Pseudocode**
```text
algoritmo "OlaMundo"                         // pseudocode/portugol/ola-mundo.alg
var
inicio
   escreval("Hello, World!")
fimalgoritmo
```
```text
Algoritmo HolaMundo                          // pseudocode/pseint/hola.psc
    Escribir "Hello, World!";
FinAlgoritmo
```
```text
HELLO-WORLD()                                // pseudocode/clrs/hello-world.txt
1  print "Hello, World!"
```

## What the cli programs have in common, and where they differ

| Language | Folder | Print call | Who writes the newline | Entry point |
|---|---|---|---|---|
| Python | [`python/cli`](../languages/python/cli/) | `print(...)` | `print` | none: the file runs top to bottom |
| JavaScript (Node.js) | [`node/cli`](../languages/node/cli/) | `console.log(...)` | `console.log` | none |
| C# | [`csharp/cli`](../languages/csharp/cli/) | `Console.WriteLine(...)` | `WriteLine` | top-level statements (the compiler generates `Main`) |
| PHP | [`php/cli`](../languages/php/cli/) | `echo` | the program: `"\n"` | none |
| BASIC (QB64-PE) | [`basic/cli`](../languages/basic/cli/) | `PRINT` | `PRINT` | none |
| C | [`c/cli`](../languages/c/cli/) | `printf(...)` | the program: `"\n"` | `int main(void)` |
| C++ | [`cpp/cli`](../languages/cpp/cli/) | `std::cout << ...` | the program: `"\n"` | `int main()` |
| Go | [`go/cli`](../languages/go/cli/) | `fmt.Println(...)` | `Println` | `func main()` in `package main` |
| Rust | [`rust/cli`](../languages/rust/cli/) | `println!(...)` (a macro) | `println!` | `fn main()` |
| Ada | [`ada/cli`](../languages/ada/cli/) | `Ada.Text_IO.Put_Line (...)` | `Put_Line` | the main procedure, `Hello` |
| Clipper (Harbour) | [`clipper/cli`](../languages/clipper/cli/) | `??` | the program: a separate `?` | `PROCEDURE Main()` |
| Java | [`java/cli`](../languages/java/cli/) | `System.out.println(...)` | `println` | `public static void main(String[] args)` in a class |
| Pascal | [`pascal/cli`](../languages/pascal/cli/) | `writeln(...)` | `writeln` | the program body (`begin` … `end.`) |
| Fortran | [`fortran/cli`](../languages/fortran/cli/) | `print '(a)', ...` | `print` | the `program` unit |
| COBOL | [`cobol/cli`](../languages/cobol/cli/) | `DISPLAY` | `DISPLAY` | the `PROCEDURE DIVISION` |
| Haskell | [`haskell/cli`](../languages/haskell/cli/) | `putStrLn` | `putStrLn` | `main :: IO ()` |
| Common Lisp | [`lisp/cli`](../languages/lisp/cli/) | `(format t ...)` | the program: `~%` | `main`, named as `:toplevel` when the image is saved |
| Prolog | [`prolog/cli`](../languages/prolog/cli/) | `format(...)` | the program: `~n` | the goal `main`, run by `initialization/2` |
| Assembly | [`assembly/cli`](../languages/assembly/cli/) | `call _write` (libc) | the program: byte `10` | the label `_main` |
| Portugol | [`pseudocode/portugol`](../languages/pseudocode/portugol/) | `escreval(...)` | `escreval` (`escreva` would not) | `inicio` … `fimalgoritmo` |
| PSeInt | [`pseudocode/pseint`](../languages/pseudocode/pseint/) | `Escribir` | `Escribir` | `Algoritmo` … `FinAlgoritmo` |

Things to notice:
- **"Who writes the newline"** is the most visible difference. The
  functions named `...ln` / `...Line` add it themselves; C's `printf`,
  C++'s `<<`, PHP's `echo`, Lisp's and Prolog's `format` and the assembly
  `write` call print exactly what they are given, so the program adds
  `\n`, `~%`, `~n` or the byte 10 (the ASCII line feed).
- **An entry point** is required by the compiled languages that start at a
  named function (C, C++, Go, Rust, Java, Haskell, Assembly). Scripting
  languages (Python, JavaScript, PHP) run the file from the top.
  C# has both: the compiler writes the `Main` method for you.
- **Strings** use double quotes in every program here except Pascal,
  which uses single quotes: "Pascal has no double-quoted strings" (comment
  in [`pascal/cli/hello.pas`](../languages/pascal/cli/hello.pas)).
- **Semicolons**: in C, C++, Java, C#, JavaScript, PHP and Ada a `;` ends
  each statement. In Pascal it *separates* statements, which is why there
  is none after the single `writeln` (see the comment in the source).
  COBOL ends its sentences with a full stop.

## From source to running program
`build.sh` exists only where there is something to build. What it
produces and what `run.sh` then starts:

| Model | Languages (folder) | `build.sh` makes | `run.sh` starts |
|---|---|---|---|
| Native compiler | [C](../languages/c/cli/), [C++](../languages/cpp/cli/), [Go](../languages/go/cli/), [Rust](../languages/rust/cli/), [Haskell](../languages/haskell/cli/), [Pascal](../languages/pascal/cli/), [Fortran](../languages/fortran/cli/), [Ada](../languages/ada/cli/) | a machine-code executable | the executable, directly |
| Translate to C/C++, then compile | [COBOL](../languages/cobol/cli/) (GnuCOBOL), [Clipper](../languages/clipper/cli/) (Harbour), [BASIC](../languages/basic/cli/) (QB64-PE) | C or C++ source, then a native executable | the executable |
| Assembler + linker | [Assembly](../languages/assembly/cli/) (NASM, then `cc` links it) | an object file, then an executable | the executable |
| Saved image | [Common Lisp](../languages/lisp/cli/) (SBCL) | an executable that holds the compiled Lisp image | the executable |
| Bytecode for a virtual machine | [Java](../languages/java/cli/) (JVM), [C#](../languages/csharp/cli/) (.NET IL) | a `.jar` / a `.dll` | `java -jar ...` / `dotnet ....dll`: the JVM or the .NET runtime loads and runs it |
| No build step | [Python](../languages/python/cli/), [Node.js](../languages/node/cli/), [PHP](../languages/php/cli/), [Prolog](../languages/prolog/cli/), [Portugol](../languages/pseudocode/portugol/), [PSeInt](../languages/pseudocode/pseint/) | – | the interpreter or runtime, with the source file |

"No build step" does not mean "never compiled": Node.js's V8 compiles
JavaScript to bytecode as it loads it ([`node/cli`](../languages/node/cli/README.md#step-by-step-walkthrough)),
and "SWI-Prolog always compiles your program before executing it"
([`prolog/cli`](../languages/prolog/cli/README.md)). The difference is that the
student never runs a separate compile command.

## Web: one page, twelve servers
Each `web` folder serves `<p>Hello, World!</p>` on
`http://localhost:8080/` (change it with `PORT=...`). The HTML is sent by
the server itself; there is no separate front end. The line that
answers `GET /`:

| Language | Folder | Server library | The line that answers `/` |
|---|---|---|---|
| C | [`c/web`](../languages/c/web/) | GNU libmicrohttpd | `static const char page[] = "<p>Hello, World!</p>";` plus a handler function `answer(...)` |
| C++ | [`cpp/web`](../languages/cpp/web/) | cpp-httplib | `server.Get("/", [](const httplib::Request &, httplib::Response &res) { ... });` |
| Java | [`java/web`](../languages/java/web/) | Spring Boot | `@GetMapping(value = "/", produces = MediaType.TEXT_HTML_VALUE)` on a method |
| C# | [`csharp/web`](../languages/csharp/web/) | ASP.NET Core | `app.MapGet("/", () => Results.Content("<p>Hello, World!</p>", "text/html"));` |
| Go | [`go/web`](../languages/go/web/) | standard library `net/http` + `html/template` | `http.HandleFunc("GET /{$}", hello)` |
| Python | [`python/web`](../languages/python/web/) | Flask | `@app.route("/")` on a function |
| Node.js | [`node/web`](../languages/node/web/) | Express | `app.get("/", (req, res) => { ... });` |
| Rust | [`rust/web`](../languages/rust/web/) | Axum | `Router::new().route("/", get(hello))` |
| PHP | [`php/web`](../languages/php/web/) | PHP's built-in server (`php -S`) | the file itself: `<p><?php echo "Hello, World!"; ?></p>` |
| Haskell | [`haskell/web`](../languages/haskell/web/) | Scotty | `get "/" $ html "<p>Hello, World!</p>"` |
| Common Lisp | [`lisp/web`](../languages/lisp/web/) | Hunchentoot | `(hunchentoot:define-easy-handler (say-hello :uri "/") () ...)` |
| Prolog | [`prolog/web`](../languages/prolog/web/) | SWI-Prolog HTTP libraries | `:- http_handler(root(.), say_hello, []).` |

Things to notice:
- **Routing styles.** Most libraries map a path to a function
  (C++, C#, Go, Node.js, Rust, Haskell, Prolog). Java and Python put the
  path on the function as an annotation or decorator. Lisp defines the
  handler and its path together. C's libmicrohttpd has no router: one
  function receives every request. PHP needs no route at all: `php -S`
  serves the files of a document root, and `/` gets `public/index.php`.
- **Framework or standard library.** Go needs no third-party package,
  Prolog's HTTP server ships with SWI-Prolog, and ASP.NET Core comes with
  the .NET SDK as a "shared framework" (see
  [`csharp/web/hello-web.csproj`](../languages/csharp/web/hello-web.csproj)); `php -S` is PHP's
  *development* web server (see [`php/web`](../languages/php/web/README.md)). The
  others get a library from a package manager: Maven (Java),
  pip (Python), npm (Node.js), Cargo (Rust), Cabal (Haskell), Quicklisp
  (Common Lisp) or Homebrew/apt (C's libmicrohttpd, C++'s cpp-httplib).
- **Testing a server.** Every `run.sh --verify` starts the server, fetches
  the page with `curl` and stops it again (see
  [CONTRIBUTING.md](../CONTRIBUTING.md#script-contract)).

## Web with a separate front end
Three implementations split the app into an **API** and a **front end**.
All three APIs answer `GET /api/hello` with
`{"message":"Hello, World!"}`; the front end fetches it and shows it.

| Folder | API (`backend/`) | Front end (`frontend/`) | Front end URL |
|---|---|---|---|
| [`java/web-react`](../languages/java/web-react/) | Spring Boot (Java) | React, built and served by Vite | <http://localhost:4173/> |
| [`go/web-vue`](../languages/go/web-vue/) | standard library (Go) | Vue, built and served by Vite | <http://localhost:4173/> |
| [`csharp/web-angular`](../languages/csharp/web-angular/) | ASP.NET Core (C#) | Angular (TypeScript), Angular CLI | <http://localhost:4200/> |

The API always listens on port 8080. Compare each folder with the `web`
folder of the same language ([`java/web`](../languages/java/web/), [`go/web`](../languages/go/web/),
[`csharp/web`](../languages/csharp/web/)): the server stops sending HTML and sends JSON
instead, and the HTML moves to a separate program that runs in the browser.

## Desktop: one label, ten toolkits
Each `desktop` folder opens a window titled and labeled `Hello, World!`.

| Language | Folder | Toolkit | How the label is made |
|---|---|---|---|
| C | [`c/desktop`](../languages/c/desktop/) | GTK 4 | `label = gtk_label_new("Hello, World!");` |
| C++ | [`cpp/desktop`](../languages/cpp/desktop/) | Qt 6 Widgets | `QLabel label("Hello, World!");` |
| Java | [`java/desktop`](../languages/java/desktop/) | JavaFX | `Label label = new Label("Hello, World!");` |
| Java | [`java/desktop-swing`](../languages/java/desktop-swing/) | Swing (in the JDK) | `JLabel label = new JLabel("Hello, World!", SwingConstants.CENTER);` |
| C# | [`csharp/desktop`](../languages/csharp/desktop/) | Avalonia | an object initializer: `Text = "Hello, World!",` |
| Go | [`go/desktop`](../languages/go/desktop/) | Fyne | `label := widget.NewLabel("Hello, World!")` |
| Python | [`python/desktop`](../languages/python/desktop/) | tkinter (Tk) | `label = ttk.Label(root, text="Hello, World!", padding=40)` |
| Node.js | [`node/desktop`](../languages/node/desktop/) | Electron | an HTML page: `<h1 id="greeting">Hello, World!</h1>` |
| Rust | [`rust/desktop`](../languages/rust/desktop/) | eframe / egui | `ui.label("Hello, World!");`, called on every frame |
| Pascal | [`pascal/desktop`](../languages/pascal/desktop/) | Lazarus LCL | a form file, `mainunit.lfm`: `Caption = 'Hello, World!'` |

Things to notice:
- **Object, function or description.** C++, Java, Python and Go create a
  label object in code. C does the same with functions, because C has no
  classes (`gtk_label_new` returns a pointer to a GTK object). Pascal and
  Electron *describe* the window in a separate file (a Lazarus form, an
  HTML page) instead of building it in code.
- **Immediate mode.** egui ([`rust/desktop`](../languages/rust/desktop/README.md#step-by-step-walkthrough))
  draws the whole window again on every frame, so `ui.label(...)` is called
  again and again instead of creating a label once.
- **Two toolkits, one language.** [Swing or JavaFX?](../languages/java/desktop-swing/README.md#swing-or-javafx)
  compares the two Java versions.
- PHP, Haskell, Common Lisp, Prolog and the cli-only languages have no
  desktop version; each language README explains why (for example
  [PHP](../languages/php/README.md#why-there-is-no-desktop-version)).

## Comparisons inside each language
Each language README compares its own categories (cli vs desktop vs web):

[Pseudocode](../languages/pseudocode/README.md#comparing-the-variants) ·
[C](../languages/c/README.md#comparing-the-categories) ·
[C++](../languages/cpp/README.md#comparing-the-categories) ([and C++ vs C](../languages/cpp/README.md#comparison-with-c)) ·
[Java](../languages/java/README.md#comparing-the-categories) ·
[C#](../languages/csharp/README.md#comparing-the-categories) ·
[Go](../languages/go/README.md#comparing-the-categories) ·
[Python](../languages/python/README.md#comparing-the-categories) ·
[Node.js](../languages/node/README.md#comparing-the-categories) ·
[Rust](../languages/rust/README.md#comparing-the-categories) ·
[PHP](../languages/php/README.md#comparing-the-categories) ·
[Haskell](../languages/haskell/README.md#comparing-the-categories) ·
[Common Lisp](../languages/lisp/README.md#comparing-the-categories) ·
[Prolog](../languages/prolog/README.md#comparing-the-categories) ·
[Pascal](../languages/pascal/README.md#comparing-the-categories) ·
[COBOL](../languages/cobol/README.md#comparing-the-categories) ·
[Clipper](../languages/clipper/README.md#comparing-the-categories) ·
[BASIC](../languages/basic/README.md#comparing-the-categories) ·
[Fortran](../languages/fortran/README.md#comparing-the-categories) ·
[Ada](../languages/ada/README.md#comparing-the-categories) ·
[Assembly](../languages/assembly/README.md#comparing-the-categories)
