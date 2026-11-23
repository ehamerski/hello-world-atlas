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
- [Web: one page, twenty-six servers](#web-one-page-twenty-six-servers)
- [Web with a separate front end](#web-with-a-separate-front-end)
- [Desktop: one label, twenty windows](#desktop-one-label-twenty-windows)
- [Mobile: one screen, three platforms](#mobile-one-screen-three-platforms)
- [Comparisons inside each language](#comparisons-inside-each-language)

For the paradigm of each language (imperative, object-oriented, functional,
logic, and the concurrent, Design by Contract and quantum sections), see
[paradigms.md](paradigms.md).

## A guided path through the walkthroughs
Every implementation README has a **Step-by-step walkthrough** that explains
its source line by line. They can be read in any order, but this order
builds each step on the one before. It is this repository's suggestion,
not a standard curriculum.

| Step | Read | What it adds |
|---|---|---|
| 1 | [`pseudocode/portugol`](../languages/pseudocode/portugol/README.md#step-by-step-walkthrough), [`pseudocode/pseint`](../languages/pseudocode/pseint/README.md#step-by-step-walkthrough), [`pseudocode/clrs`](../languages/pseudocode/clrs/README.md#step-by-step-walkthrough) | an algorithm before any real language |
| 2 | [`python/cli`](../languages/python/cli/README.md#step-by-step-walkthrough), then [`ruby/cli`](../languages/ruby/cli/README.md#step-by-step-walkthrough), [`perl/cli`](../languages/perl/cli/README.md#step-by-step-walkthrough), [`lua/cli`](../languages/lua/cli/README.md#step-by-step-walkthrough) | one statement, an interpreter, no build step; Perl adds two `use` lines and writes its own newline |
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
| 14 | [`simula/cli`](../languages/simula/cli/README.md#step-by-step-walkthrough), [`smalltalk/cli`](../languages/smalltalk/cli/README.md#step-by-step-walkthrough), [`objectivec/cli`](../languages/objectivec/README.md), [`swift/cli`](../languages/swift/cli/README.md#step-by-step-walkthrough) | where object orientation came from, in the order it happened ([paradigms](paradigms.md#where-object-orientation-came-from)) |
| 15 | [`eiffel/cli`](../languages/eiffel/cli/README.md#step-by-step-walkthrough) | a contract in the source: `require` and `ensure` ([Design by Contract](paradigms.md#design-by-contract)) |
| 16 | [`erlang/cli`](../languages/erlang/cli/README.md#step-by-step-walkthrough), then [`elixir/cli`](../languages/elixir/cli/README.md#step-by-step-walkthrough) | two languages on one virtual machine, the BEAM ([concurrent](paradigms.md#concurrent-processes-messages-and-the-actor-model)) |
| 17 | [`kotlin/cli`](../languages/kotlin/cli/README.md#step-by-step-walkthrough), [`scala/cli`](../languages/scala/cli/README.md#step-by-step-walkthrough), [`clojure/cli`](../languages/clojure/cli/README.md#step-by-step-walkthrough), [`fsharp/cli`](../languages/fsharp/cli/README.md#step-by-step-walkthrough) | other languages on a virtual machine that Java and C# introduced above |
| 18 | [`ocaml/cli`](../languages/ocaml/cli/README.md#step-by-step-walkthrough), [`racket/cli`](../languages/racket/cli/README.md#step-by-step-walkthrough), [`r/cli`](../languages/r/cli/README.md#step-by-step-walkthrough), [`julia/cli`](../languages/julia/cli/README.md#step-by-step-walkthrough) | more functional and numeric languages |
| 19 | [`qcl/cli`](../languages/qcl/cli/README.md#step-by-step-walkthrough) | a quantum language, used here only for its classical part ([quantum](paradigms.md#quantum)) |
| 20 | [`kotlin/mobile-android`](../languages/kotlin/mobile-android/README.md#step-by-step-walkthrough), [`swift/mobile-ios`](../languages/swift/mobile-ios/README.md#step-by-step-walkthrough), [`dart/mobile-flutter`](../languages/dart/mobile-flutter/README.md#step-by-step-walkthrough) | an app on a phone screen ([mobile](#mobile-one-screen-three-platforms)) |

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
```ruby
puts "Hello, World!"                         # ruby/cli/hello.rb
```
```lua
print("Hello, World!")                       -- lua/cli/hello.lua
```
```perl
use strict;                                  # perl/cli/hello.pl
use warnings;

print "Hello, World!\n";
```
([`perl/cli/hello.pl`](../languages/perl/cli/hello.pl): `use strict` and
`use warnings` make Perl refuse risky code and warn about likely mistakes;
the single statement is the `print`.)
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

**More languages, one idea each**

Statements at the top of the file, as in the first group:
```julia
println("Hello, World!")                     # julia/cli/hello.jl
```
```elixir
IO.puts("Hello, World!")                     # elixir/cli/hello.exs
```
```fsharp
printfn "Hello, World!"                      // fsharp/cli/hello.fs
```
```swift
import Foundation                            // swift/cli/hello.swift

print("Hello, World!")
```
```ocaml
let () = print_endline "Hello, World!"       (* ocaml/cli/hello.ml *)
```
```racket
#lang racket/base                            ; racket/cli/hello.rkt
(displayln "Hello, World!")
```
```r
writeLines("Hello, World!")                  # r/cli/hello.R
```
```bash
printf 'Hello, World!\n'                     # bash/cli/hello.sh
```
```smalltalk
'Hello, World!' displayNl                    "smalltalk/cli/hello.st"
```
```text
print (("Hello, World!", new line))          # algol68/cli/hello.a68
```
([`algol68/cli/hello.a68`](../languages/algol68/cli/hello.a68): the inner
parentheses build the row of values that `print` takes, here a string and
the value `new line`.)
```typescript
const message: string = "Hello, World!";     // typescript/cli/src/hello.ts
console.log(message);
```
```text
?? "Hello, World!"                           * dbase/cli/hello.prg
?
RETURN
```
([`dbase/cli/hello.prg`](../languages/dbase/cli/hello.prg): `??` writes
with no line end and the bare `?` ends the line, as in Clipper.)

An entry point, now with less around it:
```kotlin
fun main() {                                 // kotlin/cli/hello.kt
    println("Hello, World!")
}
```
```scala
@main def hello(): Unit =                    // scala/cli/hello.scala
  println("Hello, World!")
```
```dart
void main() {                                // dart/cli/hello.dart
  print('Hello, World!');
}
```
```zig
const std = @import("std");                  // zig/cli/hello.zig

pub fn main(init: std.process.Init) !void {
    try std.Io.File.stdout().writeStreamingAll(init.io, "Hello, World!\n");
}
```
```erlang
-export([main/1]).                           %% erlang/cli/hello.erl (excerpt)

main(_Args) ->
    io:format("Hello, World!~n").
```
```objc
#import <Foundation/Foundation.h>            // objectivec/cli/hello.m (excerpt)

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        printf("%s\n", [[NSString stringWithFormat:@"Hello, World!"] UTF8String]);
    }
    return 0;
}
```
```vb
Module Program                               ' visual-basic/cli/Program.vb
    Sub Main()
        Console.WriteLine("Hello, World!")
    End Sub
End Module
```
```pascal
program hello;                               (* delphi/cli/hello.pas *)
{$mode delphi}
begin
  WriteLn('Hello, World!');
end.
```

**A class, a block or a contract**
```eiffel
class                                        -- eiffel/cli/hello.e (excerpt)
    HELLO
create
    make
feature
    make
        do
            say (greeting)
        end
    greeting: STRING
        do
            Result := "Hello, World!"
        ensure
            not_empty: not Result.is_empty
        end
    say (a_text: STRING)
        require
            text_attached: a_text /= Void
        do
            io.put_string (a_text)
            io.put_new_line
        end
end
```
```text
begin                                        comment simula/cli/hello.sim;
   outtext("Hello, World!");
   outimage
end;
```
([`eiffel/cli/hello.e`](../languages/eiffel/cli/hello.e) carries a contract:
`require` and `ensure` are
[Design by Contract](paradigms.md#design-by-contract).
[`simula/cli/hello.sim`](../languages/simula/cli/hello.sim) is one block
of the language that began [object orientation](paradigms.md#where-object-orientation-came-from);
`outimage` ends the line.)

**A language with a classical part and a quantum part**
```text
procedure hello() {                          // qcl/cli/hello.qcl
    print "Hello, World!";
}

hello();
```
(No qubit is used: see [Quantum](paradigms.md#quantum).)

**A namespace and a `-main` function**
```clojure
(ns hello.core)                              ;; clojure/cli/src/hello/core.clj

(defn -main [& args]
  (println "Hello, World!"))
```
(Clojure's [walkthrough](../languages/clojure/cli/README.md#step-by-step-walkthrough)
explains the namespace and `-main`.)

## What the cli programs have in common, and where they differ

| Language | Folder | Print call | Who writes the newline | Entry point |
|---|---|---|---|---|
| Python | [`python/cli`](../languages/python/cli/) | `print(...)` | `print` | none: the file runs top to bottom |
| JavaScript (Node.js) | [`node/cli`](../languages/node/cli/) | `console.log(...)` | `console.log` | none |
| C# | [`csharp/cli`](../languages/csharp/cli/) | `Console.WriteLine(...)` | `WriteLine` | top-level statements (the compiler generates `Main`) |
| PHP | [`php/cli`](../languages/php/cli/) | `echo` | the program: `"\n"` | none |
| Ruby | [`ruby/cli`](../languages/ruby/cli/) | `puts` | `puts` | none |
| Perl | [`perl/cli`](../languages/perl/cli/) | `print` | the program: `"\n"` | none |
| Lua | [`lua/cli`](../languages/lua/cli/) | `print(...)` | `print` | none |
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
| Julia | [`julia/cli`](../languages/julia/cli/) | `println(...)` | `println` | none |
| Bash | [`bash/cli`](../languages/bash/cli/) | `printf` (a builtin) | the program: `\n` | none |
| R | [`r/cli`](../languages/r/cli/) | `writeLines(...)` | `writeLines` | none |
| Racket | [`racket/cli`](../languages/racket/cli/) | `displayln` | `displayln` | none: the module runs top to bottom |
| Elixir | [`elixir/cli`](../languages/elixir/cli/) | `IO.puts(...)` | `IO.puts` | none |
| Erlang | [`erlang/cli`](../languages/erlang/cli/) | `io:format(...)` | the program: `~n` | `main/1`, called by `escript` |
| OCaml | [`ocaml/cli`](../languages/ocaml/cli/) | `print_endline` | `print_endline` | none: phrases run top to bottom |
| F# | [`fsharp/cli`](../languages/fsharp/cli/) | `printfn` | `printfn` | top-level statements |
| Swift | [`swift/cli`](../languages/swift/cli/) | `print(...)` | `print` | none: top-level code |
| TypeScript | [`typescript/cli`](../languages/typescript/cli/) | `console.log(...)` | `console.log` | none |
| Smalltalk | [`smalltalk/cli`](../languages/smalltalk/cli/) | the message `displayNl` | `displayNl` | none: the file is a sequence of expressions |
| ALGOL 68 | [`algol68/cli`](../languages/algol68/cli/) | `print (( ... ))` | the program: the value `new line` | none: one clause is the program |
| Kotlin | [`kotlin/cli`](../languages/kotlin/cli/) | `println(...)` | `println` | top-level `fun main()` |
| Scala | [`scala/cli`](../languages/scala/cli/) | `println(...)` | `println` | an `@main` method |
| Dart | [`dart/cli`](../languages/dart/cli/) | `print(...)` | `print` | `void main()` |
| Zig | [`zig/cli`](../languages/zig/cli/) | `writeStreamingAll(...)` | the program: `"\n"` | `pub fn main(init: std.process.Init) !void` |
| Objective-C | [`objectivec/cli`](../languages/objectivec/cli/) | `printf(...)` | the program: `"\n"` | `int main(int argc, const char * argv[])` |
| Visual Basic | [`visual-basic/cli`](../languages/visual-basic/cli/) | `Console.WriteLine(...)` | `WriteLine` | `Sub Main` in a `Module` |
| Delphi | [`delphi/cli`](../languages/delphi/cli/) | `WriteLn(...)` | `WriteLn` | the program body (`begin` … `end.`) |
| dBASE | [`dbase/cli`](../languages/dbase/cli/) | `??` | the program: a separate `?` | none: commands run top to bottom |
| Eiffel | [`eiffel/cli`](../languages/eiffel/cli/) | `io.put_string(...)` | the program: `io.put_new_line` | the creation routine `make` |
| Simula | [`simula/cli`](../languages/simula/cli/) | `outtext(...)` | the program: `outimage` | none: one `begin` … `end` block |
| Clojure | [`clojure/cli`](../languages/clojure/cli/) | `println` | `println` | `-main` in the namespace `hello.core` |
| QCL | [`qcl/cli`](../languages/qcl/cli/) | `print "..."` | `print`, which also adds a `: ` prefix and a trailing space (see the README) | a procedure `hello()` that the file calls |

Things to notice:
- **"Who writes the newline"** is the most visible difference. The
  functions named `...ln` / `...Line` add it themselves; C's `printf`,
  C++'s `<<`, PHP's `echo`, Perl's `print`, Lisp's and Prolog's `format` and the assembly
  `write` call print exactly what they are given, so the program adds
  `\n`, `~%`, `~n` or the byte 10 (the ASCII line feed).
- **An entry point** is required by the compiled languages that start at a
  named function (C, C++, Go, Rust, Java, Haskell, Assembly). Scripting
  languages (Python, JavaScript, PHP, Ruby, Perl, Lua) run the file from the top.
  C# has both: the compiler writes the `Main` method for you.
- **Strings** use double quotes in every cli program here except Pascal,
  which uses single quotes: "Pascal has no double-quoted strings" (comment
  in [`pascal/cli/hello.pas`](../languages/pascal/cli/hello.pas)).
- **Semicolons**: in C, C++, Java, C#, JavaScript, PHP, Perl and Ada a `;` ends
  each statement. In Pascal it *separates* statements, which is why there
  is none after the single `writeln` (see the comment in the source).
  COBOL ends its sentences with a full stop.

## From source to running program
`build.sh` exists only where there is something to build. What it
produces and what `run.sh` then starts:

| Model | Languages (folder) | `build.sh` makes | `run.sh` starts |
|---|---|---|---|
| Native compiler | [C](../languages/c/cli/), [C++](../languages/cpp/cli/), [Go](../languages/go/cli/), [Rust](../languages/rust/cli/), [Haskell](../languages/haskell/cli/), [Pascal](../languages/pascal/cli/), [Fortran](../languages/fortran/cli/), [Ada](../languages/ada/cli/), [Zig](../languages/zig/cli/), [OCaml](../languages/ocaml/cli/), [Eiffel](../languages/eiffel/cli/) (Gobo `gec`), [Swift](../languages/swift/cli/) (`swiftc`), [Objective-C](../languages/objectivec/cli/) (`clang`), [Delphi](../languages/delphi/cli/) (Free Pascal in Delphi mode) | a machine-code executable | the executable, directly |
| Translate to C/C++, then compile | [COBOL](../languages/cobol/cli/) (GnuCOBOL), [Clipper](../languages/clipper/cli/) and [dBASE](../languages/dbase/cli/) (Harbour), [BASIC](../languages/basic/cli/) (QB64-PE), [Simula](../languages/simula/cli/) (GNU Cim) | C or C++ source, then a native executable | the executable |
| Assembler + linker | [Assembly](../languages/assembly/cli/) (NASM, then `cc` links it) | an object file, then an executable | the executable |
| Saved image | [Common Lisp](../languages/lisp/cli/) (SBCL) | an executable that holds the compiled Lisp image | the executable |
| Bytecode for a virtual machine | [Java](../languages/java/cli/) (JVM), [Kotlin](../languages/kotlin/cli/) (JVM), [Scala](../languages/scala/cli/) (JVM), [C#](../languages/csharp/cli/), [F#](../languages/fsharp/cli/) and [Visual Basic](../languages/visual-basic/cli/) (.NET IL) | a `.jar` / class files / a `.dll` | `java -jar ...` / `dotnet ....dll`: the JVM or the .NET runtime loads and runs it |
| No build step | [Python](../languages/python/cli/), [Node.js](../languages/node/cli/), [PHP](../languages/php/cli/), [Ruby](../languages/ruby/cli/), [Perl](../languages/perl/cli/), [Lua](../languages/lua/cli/), [Prolog](../languages/prolog/cli/), [Bash](../languages/bash/cli/), [Julia](../languages/julia/cli/), [R](../languages/r/cli/), [Racket](../languages/racket/cli/), [Elixir](../languages/elixir/cli/), [Erlang](../languages/erlang/cli/) (`escript`), [Dart](../languages/dart/cli/), [Clojure](../languages/clojure/cli/), [Smalltalk](../languages/smalltalk/cli/), [ALGOL 68](../languages/algol68/cli/) (Genie), [QCL](../languages/qcl/cli/) (its `build.sh` only checks the syntax), [Portugol](../languages/pseudocode/portugol/), [PSeInt](../languages/pseudocode/pseint/) | – | the interpreter or runtime, with the source file |
| Compile to another language | [TypeScript](../languages/typescript/cli/) | JavaScript, with `tsc` | `node` runs the JavaScript |

"No build step" does not mean "never compiled": Node.js's V8 compiles
JavaScript to bytecode as it loads it ([`node/cli`](../languages/node/cli/README.md#step-by-step-walkthrough)),
and "SWI-Prolog always compiles your program before executing it"
([`prolog/cli`](../languages/prolog/cli/README.md)). The difference is that the
reader never runs a separate compile command. Elixir is the clearest case:
`elixir` "compiles the script in memory each time it starts"
([`elixir/cli`](../languages/elixir/cli/README.md)).

## Web: one page, twenty-six servers
Each `web` folder serves a page with `Hello, World!` on
`http://localhost:8080/` (change it with `PORT=...`). Most send
`<p>Hello, World!</p>`; a few send a full HTML page or plain text, as their
READMEs say. The text is sent by the server itself; there is no separate
front end. The line that answers `GET /`:

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
| Ruby | [`ruby/web`](../languages/ruby/web/) | Sinatra (on Puma) | `get "/" do` ... `end`, with `"<p>Hello, World!</p>"` as the block's value |
| Ruby | [`ruby/web-rails`](../languages/ruby/web-rails/) | Ruby on Rails (on Puma) | `root to: "hello#index"` plus a controller method, `HelloController#index` |
| Perl | [`perl/web`](../languages/perl/web/) | Mojolicious (`Mojolicious::Lite`) | `get '/' => sub { ... };` |
| Lua | [`lua/web`](../languages/lua/web/) | Pegasus (installed with LuaRocks) | `server:start(function(request, response) ... end)` |
| Haskell | [`haskell/web`](../languages/haskell/web/) | Scotty | `get "/" $ html "<p>Hello, World!</p>"` |
| Common Lisp | [`lisp/web`](../languages/lisp/web/) | Hunchentoot | `(hunchentoot:define-easy-handler (say-hello :uri "/") () ...)` |
| Prolog | [`prolog/web`](../languages/prolog/web/) | SWI-Prolog HTTP libraries | `:- http_handler(root(.), say_hello, []).` |
| Kotlin | [`kotlin/web`](../languages/kotlin/web/) | Ktor (on Netty) | `get("/") { call.respondText("<p>Hello, World!</p>", ContentType.Text.Html) }` |
| Clojure | [`clojure/web`](../languages/clojure/web/) | Ring + Jetty | a handler function returning a map: `{:status 200 :headers {...} :body "<p>Hello, World!</p>"}` |
| Erlang | [`erlang/web`](../languages/erlang/web/) | `httpd` from `inets`, part of Erlang/OTP | a callback `do(ModData)` returning `{proceed, [{response, {response, Head, Body}}]}` |
| Elixir | [`elixir/web`](../languages/elixir/web/) | Plug + Bandit (from Hex) | `get "/" do ... send_resp(200, "<p>Hello, World!</p>") end` |
| Swift | [`swift/web`](../languages/swift/web/) | Vapor 4 | `app.get { req in "Hello, World!" }` |
| Objective-C | [`objectivec/web`](../languages/objectivec/web/) | none: Foundation and BSD sockets | the program opens the socket and builds the HTTP/1.1 reply itself (`HTTP/1.1 200 OK`) |
| Dart | [`dart/web`](../languages/dart/web/) | `dart:io` `HttpServer` | `await for (final request in server) { request.response ..write(...) ..close(); }` |
| TypeScript | [`typescript/web`](../languages/typescript/web/) | Node.js `node:http` | `createServer((_request, response) => { ... response.end("Hello, World!"); })` |
| Visual Basic | [`visual-basic/web`](../languages/visual-basic/web/) | ASP.NET Core minimal API | `app.MapGet("/", Function() "Hello, World!")` |
| Smalltalk | [`smalltalk/web`](../languages/smalltalk/web/) | Zinc (`ZnServer`, in the Pharo image) | `server onRequestRespond: [ :request | ... ]`: one block answers every request |

Things to notice:
- **Routing styles.** Most libraries map a path to a function
  (C++, C#, Go, Node.js, Rust, Haskell, Prolog, Kotlin, Elixir, Swift, Visual Basic, and Perl's
  Mojolicious::Lite; Ruby's Sinatra maps a path to a block). Java and
  Python put the path on the function as an annotation or decorator. Lisp
  defines the handler and its path together. Rails keeps the route
  (`root to: "hello#index"`) apart from the handler, a method of a
  controller class, and connects them by a naming convention. C's
  libmicrohttpd and Lua's Pegasus have no router: one function receives
  every request (Pegasus answers every URL with the same page). PHP needs no route at all: `php -S`
  serves the files of a document root, and `/` gets `public/index.php`.
- **No library at all.** [`objectivec/web`](../languages/objectivec/web/README.md)
  opens a socket with the C functions `socket` and `listen` and writes the
  reply by hand, so it shows what the other servers hide. Erlang's `httpd`,
  Dart's `dart:io` and TypeScript's `node:http` come with the language
  or runtime and need no extra package for the server itself (TypeScript
  needs `tsc` to compile).
- **Framework or standard library.** Go needs no third-party package,
  Prolog's HTTP server ships with SWI-Prolog, and ASP.NET Core comes with
  the .NET SDK as a "shared framework" (see
  [`csharp/web/hello-web.csproj`](../languages/csharp/web/hello-web.csproj)); `php -S` is PHP's
  *development* web server (see [`php/web`](../languages/php/web/README.md)). The
  others get a library from a package manager: Maven (Java),
  pip (Python), npm (Node.js), Cargo (Rust), Cabal (Haskell), Quicklisp
  (Common Lisp), Bundler and RubyGems (Ruby), CPAN (Perl), LuaRocks (Lua), Gradle (Kotlin), Hex via Mix (Elixir), Swift Package Manager (Swift), or Homebrew/apt (C's libmicrohttpd, C++'s cpp-httplib).
- **Small or large framework.** Ruby has two web folders for the same
  page: Sinatra needs one file and one block per route, while Rails is a
  larger framework with a controller class and a naming convention. The
  [Ruby README](../languages/ruby/README.md#comparing-the-categories)
  compares them.
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

## Desktop: one label, twenty windows
Each `desktop` folder opens a window titled and labeled `Hello, World!`
(Lua, Perl and Delphi are marked as compromises in their READMEs; see
the notes below).

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
| Ruby | [`ruby/desktop`](../languages/ruby/desktop/) | Ruby/Tk (the `tk` gem, over Tcl/Tk) | a block: `TkLabel.new(root) do text "Hello, World!" ... end` |
| Perl | [`perl/desktop`](../languages/perl/desktop/) | Tkx (over Tcl/Tk); a compromise | `$mw->new_ttk__label(-text => "Hello, World!", -padding => "60 40");` |
| Lua | [`lua/desktop`](../languages/lua/desktop/) | LÖVE (LuaJIT); a compromise | `love.graphics.printf("Hello, World!", ...)`, called on every frame in `love.draw` |
| Kotlin | [`kotlin/desktop`](../languages/kotlin/desktop/) | Compose Multiplatform | `Text("Hello, World!")`, inside a `Window(...) { }` |
| Clojure | [`clojure/desktop`](../languages/clojure/desktop/) | Swing, called from Clojure (Java interop) | `(JLabel. "Hello, World!" SwingConstants/CENTER)` |
| Erlang | [`erlang/desktop`](../languages/erlang/desktop/) | `wx` (`wxWidgets`), part of Erlang/OTP | `Text = wxStaticText:new(Frame, ?wxID_ANY, "Hello, World!"),` |
| Swift | [`swift/desktop`](../languages/swift/desktop/) | SwiftUI (macOS) | `Text("Hello, World!").font(.largeTitle)` in a `View`'s `body` |
| Objective-C | [`objectivec/desktop`](../languages/objectivec/desktop/) | AppKit (macOS) | `[label setStringValue:@"Hello, World!"];` |
| Smalltalk | [`smalltalk/desktop`](../languages/smalltalk/desktop/) | Pharo 14, Morphic | `text := TextMorph new. text contents: greeting.`, added to a `SystemWindow` (the window title is `Hello World`, see below) |
| Delphi | [`delphi/desktop`](../languages/delphi/desktop/) | Lazarus LCL (a compromise: Delphi itself is not run) | `FGreeting.Caption := 'Hello, World!';` |

Things to notice:
- **Object, function or description.** C++, Java, Python, Ruby, Perl and Go create a
  label object in code. C does the same with functions, because C has no
  classes (`gtk_label_new` returns a pointer to a GTK object). Pascal and
  Electron *describe* the window in a separate file (a Lazarus form, an
  HTML page) instead of building it in code.
- **Immediate mode.** egui ([`rust/desktop`](../languages/rust/desktop/README.md#step-by-step-walkthrough))
  draws the whole window again on every frame, so `ui.label(...)` is called
  again and again instead of creating a label once. LÖVE
  ([`lua/desktop`](../languages/lua/desktop/README.md#step-by-step-walkthrough))
  works the same way: it is a game framework that calls `love.draw` on every
  frame, so your code does not build a tree of widgets.
- **One toolkit, three languages.** Python (tkinter), Ruby (Ruby/Tk) and
  Perl (Tkx) all drive Tcl/Tk, each through its own binding.
- **Two compromises.** [`perl/desktop`](../languages/perl/desktop/README.md#why-this-toolchain)
  uses Tkx, not Perl/Tk, the better-known binding, because Perl/Tk needs an
  X11 server on macOS. [`lua/desktop`](../languages/lua/desktop/README.md#what-this-is)
  runs the Lua 5.1 dialect, because LÖVE embeds LuaJIT, while the cli and
  web versions use Lua 5.5.
- **Declarative UI.** SwiftUI and Compose Multiplatform describe the window
  as a function of its state: `Text("Hello, World!")` is an expression
  inside a `body` or a `Window` block, not a `new` call. Compare this with
  the object style of the Java and C++ folders above.
- **One toolkit, many languages.** Clojure and Java both use Swing (the
  Swing library of the JDK); Pascal and Delphi both use the Lazarus LCL.
  [`clojure/desktop`](../languages/clojure/desktop/README.md) shows a
  non-Java language calling a Java library without a wrapper.
- **Platform toolkits.** SwiftUI and AppKit are Apple's toolkits for macOS;
  see the Platform notes of [`swift/desktop`](../languages/swift/desktop/README.md)
  and [`objectivec/desktop`](../languages/objectivec/desktop/README.md)
  for the other systems.
- **An exclamation mark that is not text.** In a Pharo `.st` file the
  character `!` ends a chunk of code, so
  [`smalltalk/desktop`](../languages/smalltalk/desktop/hello.st) builds the
  string `'Hello, World'` plus `(Character value: 33)` and titles the window
  `Hello World` (the source comments explain this).
- **Two toolkits, one language.** [Swing or JavaFX?](../languages/java/desktop-swing/README.md#swing-or-javafx)
  compares the two Java versions.
- PHP, Haskell, Common Lisp, Prolog, TypeScript, Dart (outside mobile), and the cli-only languages have no
  desktop version; each language README explains why (for example
  [PHP](../languages/php/README.md#why-there-is-no-desktop-version)).

## Mobile: one screen, three platforms
The `mobile` category shows `Hello, World!` on the screen of a phone. Each
folder builds an app and runs it on a virtual device; `run.sh --verify`
checks the screen or the log without a person looking at it.

| Language | Folder | Toolkit | Device it runs on | The line that shows the text |
|---|---|---|---|---|
| Kotlin | [`kotlin/mobile-android`](../languages/kotlin/mobile-android/) | Jetpack Compose, Android Gradle plugin | Android emulator (x86_64 image) | `Text("Hello, World!")` in `MainActivity.kt` |
| Swift | [`swift/mobile-ios`](../languages/swift/mobile-ios/) | SwiftUI, full Xcode | iOS Simulator | `Text("Hello, World!")` in `hello.swift` |
| Dart | [`dart/mobile-flutter`](../languages/dart/mobile-flutter/) | Flutter | Android emulator (the iOS build is not verified) | `child: Text('Hello, World!')` in `lib/main.dart` |

Things to notice:
- **Three declarative toolkits.** SwiftUI, Jetpack Compose and Flutter all
  describe the screen as nested expressions (`Text(...)`), the same style
  as the [desktop](#desktop-one-label-twenty-windows) SwiftUI and Compose
  versions. Kotlin and Swift also have a desktop folder with the same
  toolkit family, so you can read the two side by side.
- **A device you have to start.** A phone app cannot run as a process on
  your computer. The Android scripts start an emulator and install the app
  with `adb`; the iOS script boots a Simulator that comes with Xcode.
- **A bigger toolchain than the other categories.** In the Android folder
  the SDK and the emulator are the largest part, and iOS needs the full
  Xcode, not only the command-line tools
  ([`swift/mobile-ios`](../languages/swift/mobile-ios/README.md#what-this-is)). The setup per system is on
  [Start here](start-here.md#5-mobile-apps-android-sdk-and-xcode).
- **Verification differs.** The Android folders are verified on the
  development machine. The iOS folder is verified there and on a macOS
  runner in continuous integration; see each README's **Platform notes**
  and [Platform support](platform-support.md).

## Comparisons inside each language
Each language README compares its own categories (cli vs desktop vs web vs mobile):

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
[Ruby](../languages/ruby/README.md#comparing-the-categories) ·
[Perl](../languages/perl/README.md#comparing-the-categories) ·
[Lua](../languages/lua/README.md#comparing-the-categories) ·
[Haskell](../languages/haskell/README.md#comparing-the-categories) ·
[Common Lisp](../languages/lisp/README.md#comparing-the-categories) ·
[Prolog](../languages/prolog/README.md#comparing-the-categories) ·
[Pascal](../languages/pascal/README.md#comparing-the-categories) ·
[COBOL](../languages/cobol/README.md#comparing-the-categories) ·
[Clipper](../languages/clipper/README.md#comparing-the-categories) ·
[BASIC](../languages/basic/README.md#comparing-the-categories) ·
[Fortran](../languages/fortran/README.md#comparing-the-categories) ·
[Ada](../languages/ada/README.md#comparing-the-categories) ·
[Assembly](../languages/assembly/README.md#comparing-the-categories) ·
[Julia](../languages/julia/README.md#comparing-the-categories) ·
[R](../languages/r/README.md#comparing-the-categories) ·
[Racket](../languages/racket/README.md#comparing-the-categories) ·
[OCaml](../languages/ocaml/README.md#comparing-the-categories) ·
[F#](../languages/fsharp/README.md#comparing-the-categories) ·
[Scala](../languages/scala/README.md#comparing-the-categories) ·
[Kotlin](../languages/kotlin/README.md#comparing-the-categories) ·
[Clojure](../languages/clojure/README.md#comparing-the-categories) ·
[Erlang](../languages/erlang/README.md#comparing-the-categories) ·
[Elixir](../languages/elixir/README.md#comparing-the-categories) ·
[TypeScript](../languages/typescript/README.md#comparing-the-categories) ·
[Dart](../languages/dart/README.md#comparing-the-categories) ·
[Swift](../languages/swift/README.md#implementations) ·
[Objective-C](../languages/objectivec/README.md) ·
[Smalltalk](../languages/smalltalk/README.md#comparing-the-categories) ·
[Simula](../languages/simula/README.md#comparing-the-categories) ·
[Eiffel](../languages/eiffel/README.md#comparing-the-categories) ·
[ALGOL 68](../languages/algol68/README.md#comparing-the-categories) ·
[Bash](../languages/bash/README.md#comparing-the-categories) ·
[Zig](../languages/zig/README.md#comparing-the-categories) ·
[dBASE](../languages/dbase/README.md#comparing-the-categories) ·
[Delphi](../languages/delphi/README.md#comparing-the-categories) ·
[Visual Basic](../languages/visual-basic/README.md#comparing-the-categories) ·
[QCL](../languages/qcl/README.md#comparing-the-categories)
