---
source: docs/comparisons.md
source_sha: 92cd3e0f9ce7b3900c7f7cd9215658590d640b54
---
# Comparações entre as implementações

Cada implementação deste repositório executa a mesma tarefa; por isso, as
diferenças observadas são diferenças entre as **linguagens e as
ferramentas**, não entre os programas. Esta página as coloca lado a lado.
Os fatos sobre cada ferramenta têm fontes no README vinculado; os trechos
de código são copiados deste repositório, sem os comentários.

- [Um caminho guiado pelos passo a passo](#um-caminho-guiado-pelos-passo-a-passo)
- [O Hello World da categoria cli em cada linguagem](#o-hello-world-da-categoria-cli-em-cada-linguagem)
- [O que os programas cli têm em comum e onde diferem](#o-que-os-programas-cli-têm-em-comum-e-onde-diferem)
- [Do código-fonte ao programa em execução](#do-código-fonte-ao-programa-em-execução)
- [Web: uma página, vinte e seis servidores](#web-uma-página-vinte-e-seis-servidores)
- [Web com front-end separado](#web-com-front-end-separado)
- [Desktop: um rótulo, vinte janelas](#desktop-um-rótulo-vinte-janelas)
- [Mobile: uma tela, três plataformas](#mobile-uma-tela-três-plataformas)
- [Comparações dentro de cada linguagem](#comparações-dentro-de-cada-linguagem)

Para o paradigma de cada linguagem (imperativo, orientado a objetos,
funcional, lógico, e as seções sobre concorrência, Design by Contract e
programação quântica), consulte [paradigms.md](paradigms.md).

## Um caminho guiado pelos passo a passo
Todo README de implementação tem uma seção **Passo a passo** que explica
o código-fonte linha por linha. As seções podem ser lidas em qualquer
ordem, mas a ordem a seguir faz cada etapa se apoiar na anterior. Trata-se
de uma sugestão deste repositório, não de um currículo padronizado.

| Etapa | Leitura | O que acrescenta |
|---|---|---|
| 1 | [`pseudocode/portugol`](../languages/pseudocode/portugol/README.md#step-by-step-walkthrough), [`pseudocode/pseint`](../languages/pseudocode/pseint/README.md#step-by-step-walkthrough), [`pseudocode/clrs`](../languages/pseudocode/clrs/README.md#step-by-step-walkthrough) | um algoritmo antes de qualquer linguagem real |
| 2 | [`python/cli`](../languages/python/cli/README.md#step-by-step-walkthrough), depois [`ruby/cli`](../languages/ruby/cli/README.md#step-by-step-walkthrough), [`perl/cli`](../languages/perl/cli/README.md#step-by-step-walkthrough), [`lua/cli`](../languages/lua/cli/README.md#step-by-step-walkthrough) | uma instrução, um interpretador, nenhuma etapa de compilação; o Perl acrescenta duas linhas `use` e escreve a própria quebra de linha |
| 3 | [`c/cli`](../languages/c/cli/README.md#step-by-step-walkthrough) | um compilador, uma função `main`, um arquivo de cabeçalho, um `\n` explícito |
| 4 | [`cpp/cli`](../languages/cpp/cli/README.md#step-by-step-walkthrough) e [C++ vs C](../languages/cpp/README.md#comparison-with-c) | espaços de nomes e fluxos sobre o C |
| 5 | [`java/cli`](../languages/java/cli/README.md#step-by-step-walkthrough), depois [`csharp/cli`](../languages/csharp/cli/README.md#step-by-step-walkthrough) | classes, bytecode / IL e uma máquina virtual; o C# oculta a classe com instruções de nível superior |
| 6 | [`go/cli`](../languages/go/cli/README.md#step-by-step-walkthrough), [`rust/cli`](../languages/rust/cli/README.md#step-by-step-walkthrough) | linguagens compiladas modernas: pacotes, módulos, uma macro |
| 7 | [`haskell/cli`](../languages/haskell/cli/README.md#step-by-step-walkthrough), [`lisp/cli`](../languages/lisp/cli/README.md#step-by-step-walkthrough) | o paradigma funcional |
| 8 | [`prolog/cli`](../languages/prolog/cli/README.md#step-by-step-walkthrough) | o paradigma lógico |
| 9 | [`fortran/cli`](../languages/fortran/cli/README.md#step-by-step-walkthrough), [`cobol/cli`](../languages/cobol/cli/README.md#step-by-step-walkthrough), [`basic/cli`](../languages/basic/cli/README.md#step-by-step-walkthrough), [`pascal/cli`](../languages/pascal/cli/README.md#step-by-step-walkthrough), [`ada/cli`](../languages/ada/cli/README.md#step-by-step-walkthrough), [`clipper/cli`](../languages/clipper/cli/README.md#step-by-step-walkthrough) | as linguagens mais antigas, na ordem em que surgiram (da década de 1950 a 1985; as datas estão nos **Marcos** do README de cada linguagem) |
| 10 | [`assembly/cli`](../languages/assembly/cli/README.md#step-by-step-walkthrough) | aquilo em que todas as anteriores se transformam: instruções de CPU |
| 11 | [`python/web`](../languages/python/web/README.md#step-by-step-walkthrough), depois qualquer outra pasta `web` | um servidor HTTP e uma rota |
| 12 | [`java/web-react`](../languages/java/web-react/README.md#step-by-step-walkthrough), [`go/web-vue`](../languages/go/web-vue/README.md#step-by-step-walkthrough), [`csharp/web-angular`](../languages/csharp/web-angular/README.md#step-by-step-walkthrough) | uma API mais um front-end separado |
| 13 | [`python/desktop`](../languages/python/desktop/README.md#step-by-step-walkthrough), depois qualquer outra pasta `desktop` | janelas, widgets e o laço de eventos |
| 14 | [`simula/cli`](../languages/simula/cli/README.md#step-by-step-walkthrough), [`smalltalk/cli`](../languages/smalltalk/cli/README.md#step-by-step-walkthrough), [`objectivec/cli`](../languages/objectivec/README.md), [`swift/cli`](../languages/swift/cli/README.md#step-by-step-walkthrough) | de onde veio a orientação a objetos, na ordem em que aconteceu ([paradigmas](paradigms.md#where-object-orientation-came-from)) |
| 15 | [`eiffel/cli`](../languages/eiffel/cli/README.md#step-by-step-walkthrough) | um contrato no código-fonte: `require` e `ensure` ([Design by Contract](paradigms.md#design-by-contract)) |
| 16 | [`erlang/cli`](../languages/erlang/cli/README.md#step-by-step-walkthrough), depois [`elixir/cli`](../languages/elixir/cli/README.md#step-by-step-walkthrough) | duas linguagens em uma mesma máquina virtual, a BEAM ([concorrente](paradigms.md#concurrent-processes-messages-and-the-actor-model)) |
| 17 | [`kotlin/cli`](../languages/kotlin/cli/README.md#step-by-step-walkthrough), [`scala/cli`](../languages/scala/cli/README.md#step-by-step-walkthrough), [`clojure/cli`](../languages/clojure/cli/README.md#step-by-step-walkthrough), [`fsharp/cli`](../languages/fsharp/cli/README.md#step-by-step-walkthrough) | outras linguagens em uma máquina virtual que Java e C# apresentaram acima |
| 18 | [`ocaml/cli`](../languages/ocaml/cli/README.md#step-by-step-walkthrough), [`racket/cli`](../languages/racket/cli/README.md#step-by-step-walkthrough), [`r/cli`](../languages/r/cli/README.md#step-by-step-walkthrough), [`julia/cli`](../languages/julia/cli/README.md#step-by-step-walkthrough) | mais linguagens funcionais e numéricas |
| 19 | [`qcl/cli`](../languages/qcl/cli/README.md#step-by-step-walkthrough) | uma linguagem quântica, usada aqui apenas pela sua parte clássica ([quântico](paradigms.md#quantum)) |
| 20 | [`kotlin/mobile-android`](../languages/kotlin/mobile-android/README.md#step-by-step-walkthrough), [`swift/mobile-ios`](../languages/swift/mobile-ios/README.md#step-by-step-walkthrough), [`dart/mobile-flutter`](../languages/dart/mobile-flutter/README.md#step-by-step-walkthrough) | uma aplicação na tela de um telefone ([mobile](#mobile-uma-tela-três-plataformas)) |

O [README da raiz](../README.md#languages) lista todas as implementações.

## O Hello World da categoria cli em cada linguagem
Cada programa imprime exatamente `Hello, World!` e uma quebra de linha
(verificado por `scripts/verify-all.sh`). A primeira linha de cada trecho
indica o nome do arquivo, e o passo a passo de cada implementação explica
o código.

**Uma instrução, sem nada ao redor**
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
([`perl/cli/hello.pl`](../languages/perl/cli/hello.pl): `use strict` e
`use warnings` fazem o Perl recusar código arriscado e avisar sobre prováveis
erros; a única instrução do programa é o `print`.)
```basic
$CONSOLE:ONLY
PRINT "Hello, World!"
SYSTEM
```
([`basic/cli/hello.bas`](../languages/basic/cli/hello.bas): `$CONSOLE:ONLY` é
um *metacomando* do QB64 para um programa exclusivo de terminal, e `SYSTEM`
encerra o programa; o
[passo a passo](../languages/basic/cli/README.md#step-by-step-walkthrough)
explica ambos.)

**Um ponto de entrada: uma função ou um procedimento chamado `main` (ou o nome do programa)**
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

**Uma classe em torno do ponto de entrada**
```java
package com.example.hello;                   // java/cli/.../Hello.java

public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

**Uma unidade de programa com estrutura própria**
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
([`cobol/cli/hello.cob`](../languages/cobol/cli/hello.cob): no formato fixo
do COBOL, as colunas 1 a 6 e a coluna 7 são reservadas, razão pela qual
toda linha começa com espaços; consulte o seu
[passo a passo](../languages/cobol/cli/README.md#step-by-step-walkthrough).)

**Funcional e lógico**
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

**Nível de máquina**
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

**Pseudocódigo**
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

**Mais linguagens, uma ideia em cada uma**

Instruções no início do arquivo, como no primeiro grupo:
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
([`algol68/cli/hello.a68`](../languages/algol68/cli/hello.a68): os
parênteses internos montam a linha de valores que o `print` recebe, aqui uma
cadeia de caracteres e o valor `new line`.)
```typescript
const message: string = "Hello, World!";     // typescript/cli/src/hello.ts
console.log(message);
```
```text
?? "Hello, World!"                           * dbase/cli/hello.prg
?
RETURN
```
([`dbase/cli/hello.prg`](../languages/dbase/cli/hello.prg): `??` escreve
sem quebra de linha e o `?` isolado encerra a linha, como no Clipper.)

Um ponto de entrada, agora com menos ao redor:
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

**Uma classe, um bloco ou um contrato**
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
([`eiffel/cli/hello.e`](../languages/eiffel/cli/hello.e) traz um contrato:
`require` e `ensure` são o
[Design by Contract](paradigms.md#design-by-contract).
[`simula/cli/hello.sim`](../languages/simula/cli/hello.sim) é um bloco
da linguagem que deu início à [orientação a objetos](paradigms.md#where-object-orientation-came-from);
`outimage` encerra a linha.)

**Uma linguagem com uma parte clássica e uma parte quântica**
```text
procedure hello() {                          // qcl/cli/hello.qcl
    print "Hello, World!";
}

hello();
```
(Nenhum qubit é usado: consulte [Quântico](paradigms.md#quantum).)

**Um espaço de nomes (namespace) e uma função `-main`**
```clojure
(ns hello.core)                              ;; clojure/cli/src/hello/core.clj

(defn -main [& args]
  (println "Hello, World!"))
```
(O [passo a passo](../languages/clojure/cli/README.md#step-by-step-walkthrough)
do Clojure explica o namespace e o `-main`.)

## O que os programas cli têm em comum e onde diferem

| Linguagem | Pasta | Chamada de impressão | Quem escreve a quebra de linha | Ponto de entrada |
|---|---|---|---|---|
| Python | [`python/cli`](../languages/python/cli/) | `print(...)` | `print` | nenhum: o arquivo é executado de cima para baixo |
| JavaScript (Node.js) | [`node/cli`](../languages/node/cli/) | `console.log(...)` | `console.log` | nenhum |
| C# | [`csharp/cli`](../languages/csharp/cli/) | `Console.WriteLine(...)` | `WriteLine` | instruções de nível superior (o compilador gera o `Main`) |
| PHP | [`php/cli`](../languages/php/cli/) | `echo` | o programa: `"\n"` | nenhum |
| Ruby | [`ruby/cli`](../languages/ruby/cli/) | `puts` | `puts` | nenhum |
| Perl | [`perl/cli`](../languages/perl/cli/) | `print` | o programa: `"\n"` | nenhum |
| Lua | [`lua/cli`](../languages/lua/cli/) | `print(...)` | `print` | nenhum |
| BASIC (QB64-PE) | [`basic/cli`](../languages/basic/cli/) | `PRINT` | `PRINT` | nenhum |
| C | [`c/cli`](../languages/c/cli/) | `printf(...)` | o programa: `"\n"` | `int main(void)` |
| C++ | [`cpp/cli`](../languages/cpp/cli/) | `std::cout << ...` | o programa: `"\n"` | `int main()` |
| Go | [`go/cli`](../languages/go/cli/) | `fmt.Println(...)` | `Println` | `func main()` em `package main` |
| Rust | [`rust/cli`](../languages/rust/cli/) | `println!(...)` (uma macro) | `println!` | `fn main()` |
| Ada | [`ada/cli`](../languages/ada/cli/) | `Ada.Text_IO.Put_Line (...)` | `Put_Line` | o procedimento principal, `Hello` |
| Clipper (Harbour) | [`clipper/cli`](../languages/clipper/cli/) | `??` | o programa: um `?` separado | `PROCEDURE Main()` |
| Java | [`java/cli`](../languages/java/cli/) | `System.out.println(...)` | `println` | `public static void main(String[] args)` em uma classe |
| Pascal | [`pascal/cli`](../languages/pascal/cli/) | `writeln(...)` | `writeln` | o corpo do programa (`begin` … `end.`) |
| Fortran | [`fortran/cli`](../languages/fortran/cli/) | `print '(a)', ...` | `print` | a unidade `program` |
| COBOL | [`cobol/cli`](../languages/cobol/cli/) | `DISPLAY` | `DISPLAY` | a `PROCEDURE DIVISION` |
| Haskell | [`haskell/cli`](../languages/haskell/cli/) | `putStrLn` | `putStrLn` | `main :: IO ()` |
| Common Lisp | [`lisp/cli`](../languages/lisp/cli/) | `(format t ...)` | o programa: `~%` | `main`, indicada como `:toplevel` quando a imagem é salva |
| Prolog | [`prolog/cli`](../languages/prolog/cli/) | `format(...)` | o programa: `~n` | o objetivo `main`, executado por `initialization/2` |
| Assembly | [`assembly/cli`](../languages/assembly/cli/) | `call _write` (libc) | o programa: o byte `10` | o rótulo `_main` |
| Portugol | [`pseudocode/portugol`](../languages/pseudocode/portugol/) | `escreval(...)` | `escreval` (`escreva` não a escreveria) | `inicio` … `fimalgoritmo` |
| PSeInt | [`pseudocode/pseint`](../languages/pseudocode/pseint/) | `Escribir` | `Escribir` | `Algoritmo` … `FinAlgoritmo` |
| Julia | [`julia/cli`](../languages/julia/cli/) | `println(...)` | `println` | nenhum |
| Bash | [`bash/cli`](../languages/bash/cli/) | `printf` (um builtin) | o programa: `\n` | nenhum |
| R | [`r/cli`](../languages/r/cli/) | `writeLines(...)` | `writeLines` | nenhum |
| Racket | [`racket/cli`](../languages/racket/cli/) | `displayln` | `displayln` | nenhum: o módulo é executado de cima para baixo |
| Elixir | [`elixir/cli`](../languages/elixir/cli/) | `IO.puts(...)` | `IO.puts` | nenhum |
| Erlang | [`erlang/cli`](../languages/erlang/cli/) | `io:format(...)` | o programa: `~n` | `main/1`, chamada pelo `escript` |
| OCaml | [`ocaml/cli`](../languages/ocaml/cli/) | `print_endline` | `print_endline` | nenhum: as frases são executadas de cima para baixo |
| F# | [`fsharp/cli`](../languages/fsharp/cli/) | `printfn` | `printfn` | instruções de nível superior |
| Swift | [`swift/cli`](../languages/swift/cli/) | `print(...)` | `print` | nenhum: código de nível superior |
| TypeScript | [`typescript/cli`](../languages/typescript/cli/) | `console.log(...)` | `console.log` | nenhum |
| Smalltalk | [`smalltalk/cli`](../languages/smalltalk/cli/) | a mensagem `displayNl` | `displayNl` | nenhum: o arquivo é uma sequência de expressões |
| ALGOL 68 | [`algol68/cli`](../languages/algol68/cli/) | `print (( ... ))` | o programa: o valor `new line` | nenhum: uma cláusula é o programa |
| Kotlin | [`kotlin/cli`](../languages/kotlin/cli/) | `println(...)` | `println` | `fun main()` de nível superior |
| Scala | [`scala/cli`](../languages/scala/cli/) | `println(...)` | `println` | um método `@main` |
| Dart | [`dart/cli`](../languages/dart/cli/) | `print(...)` | `print` | `void main()` |
| Zig | [`zig/cli`](../languages/zig/cli/) | `writeStreamingAll(...)` | o programa: `"\n"` | `pub fn main(init: std.process.Init) !void` |
| Objective-C | [`objectivec/cli`](../languages/objectivec/cli/) | `printf(...)` | o programa: `"\n"` | `int main(int argc, const char * argv[])` |
| Visual Basic | [`visual-basic/cli`](../languages/visual-basic/cli/) | `Console.WriteLine(...)` | `WriteLine` | `Sub Main` em um `Module` |
| Delphi | [`delphi/cli`](../languages/delphi/cli/) | `WriteLn(...)` | `WriteLn` | o corpo do programa (`begin` … `end.`) |
| dBASE | [`dbase/cli`](../languages/dbase/cli/) | `??` | o programa: um `?` separado | nenhum: os comandos são executados de cima para baixo |
| Eiffel | [`eiffel/cli`](../languages/eiffel/cli/) | `io.put_string(...)` | o programa: `io.put_new_line` | a rotina de criação `make` |
| Simula | [`simula/cli`](../languages/simula/cli/) | `outtext(...)` | o programa: `outimage` | nenhum: um único bloco `begin` … `end` |
| Clojure | [`clojure/cli`](../languages/clojure/cli/) | `println` | `println` | `-main` no espaço de nomes `hello.core` |
| QCL | [`qcl/cli`](../languages/qcl/cli/) | `print "..."` | `print`, que também acrescenta um prefixo `: ` e um espaço final (consulte o README) | um procedimento `hello()` que o arquivo chama |

Pontos a observar:
- **"Quem escreve a quebra de linha"** é a diferença mais visível. As
  funções chamadas `...ln` / `...Line` a acrescentam por conta própria; o
  `printf` do C, o `<<` do C++, o `echo` do PHP, o `print` do Perl, o `format` do Lisp e do
  Prolog e a chamada `write` do assembly imprimem exatamente o que
  recebem, de modo que o programa acrescenta `\n`, `~%`, `~n` ou o byte 10
  (o avanço de linha do ASCII).
- **Um ponto de entrada** é exigido pelas linguagens compiladas que
  iniciam em uma função nomeada (C, C++, Go, Rust, Java, Haskell,
  Assembly). As linguagens de script (Python, JavaScript, PHP, Ruby, Perl, Lua) executam o
  arquivo desde o início. O C# tem os dois: o compilador escreve o método
  `Main` automaticamente.
- **Cadeias de caracteres (strings)** usam aspas duplas em todos os
  programas cli deste repositório, exceto no Pascal, que usa aspas simples:
  "Pascal has no double-quoted strings" (comentário em
  [`pascal/cli/hello.pas`](../languages/pascal/cli/hello.pas); tradução
  livre: "o Pascal não tem cadeias de caracteres com aspas duplas").
- **Ponto e vírgula**: em C, C++, Java, C#, JavaScript, PHP, Perl e Ada, um `;`
  encerra cada instrução. No Pascal, ele *separa* instruções, o que explica
  a ausência de `;` após o único `writeln` (consulte o comentário no
  código-fonte). O COBOL encerra as suas sentenças com um ponto final.

## Do código-fonte ao programa em execução
O arquivo `build.sh` existe apenas onde há algo a compilar. A tabela mostra
o que ele produz e o que `run.sh` inicia em seguida:

| Modelo | Linguagens (pasta) | `build.sh` produz | `run.sh` inicia |
|---|---|---|---|
| Compilador nativo | [C](../languages/c/cli/), [C++](../languages/cpp/cli/), [Go](../languages/go/cli/), [Rust](../languages/rust/cli/), [Haskell](../languages/haskell/cli/), [Pascal](../languages/pascal/cli/), [Fortran](../languages/fortran/cli/), [Ada](../languages/ada/cli/), [Zig](../languages/zig/cli/), [OCaml](../languages/ocaml/cli/), [Eiffel](../languages/eiffel/cli/) (Gobo `gec`), [Swift](../languages/swift/cli/) (`swiftc`), [Objective-C](../languages/objectivec/cli/) (`clang`), [Delphi](../languages/delphi/cli/) (Free Pascal em modo Delphi) | um executável em código de máquina | o executável, diretamente |
| Tradução para C/C++ e depois compilação | [COBOL](../languages/cobol/cli/) (GnuCOBOL), [Clipper](../languages/clipper/cli/) e [dBASE](../languages/dbase/cli/) (Harbour), [BASIC](../languages/basic/cli/) (QB64-PE), [Simula](../languages/simula/cli/) (GNU Cim) | código-fonte em C ou C++ e depois um executável nativo | o executável |
| Montador e ligador | [Assembly](../languages/assembly/cli/) (NASM; depois o `cc` faz a ligação) | um arquivo-objeto e depois um executável | o executável |
| Imagem salva | [Common Lisp](../languages/lisp/cli/) (SBCL) | um executável que contém a imagem Lisp compilada | o executável |
| Bytecode para uma máquina virtual | [Java](../languages/java/cli/) (JVM), [Kotlin](../languages/kotlin/cli/) (JVM), [Scala](../languages/scala/cli/) (JVM), [C#](../languages/csharp/cli/), [F#](../languages/fsharp/cli/) e [Visual Basic](../languages/visual-basic/cli/) (.NET IL) | um `.jar` / arquivos de classe / um `.dll` | `java -jar ...` / `dotnet ....dll`: a JVM ou o runtime do .NET o carrega e o executa |
| Sem etapa de compilação | [Python](../languages/python/cli/), [Node.js](../languages/node/cli/), [PHP](../languages/php/cli/), [Ruby](../languages/ruby/cli/), [Perl](../languages/perl/cli/), [Lua](../languages/lua/cli/), [Prolog](../languages/prolog/cli/), [Bash](../languages/bash/cli/), [Julia](../languages/julia/cli/), [R](../languages/r/cli/), [Racket](../languages/racket/cli/), [Elixir](../languages/elixir/cli/), [Erlang](../languages/erlang/cli/) (`escript`), [Dart](../languages/dart/cli/), [Clojure](../languages/clojure/cli/), [Smalltalk](../languages/smalltalk/cli/), [ALGOL 68](../languages/algol68/cli/) (Genie), [QCL](../languages/qcl/cli/) (o `build.sh` dele apenas verifica a sintaxe), [Portugol](../languages/pseudocode/portugol/), [PSeInt](../languages/pseudocode/pseint/) | – | o interpretador ou o runtime, com o arquivo de código-fonte |
| Compilação para outra linguagem | [TypeScript](../languages/typescript/cli/) | JavaScript, com o `tsc` | o `node` executa o JavaScript |

"Sem etapa de compilação" não significa "nunca compilado": o V8 do
Node.js compila o JavaScript para bytecode ao carregá-lo
([`node/cli`](../languages/node/cli/README.md#step-by-step-walkthrough)), e
"SWI-Prolog always compiles your program before executing it" (tradução
livre: "o SWI-Prolog sempre compila o programa antes de executá-lo";
[`prolog/cli`](../languages/prolog/cli/README.md)). A diferença é que o
leitor nunca executa um comando de compilação separado. O Elixir é o caso
mais claro: o `elixir` "compiles the script in memory each time it starts"
(tradução livre: "compila o script em memória a cada vez que é iniciado";
[`elixir/cli`](../languages/elixir/cli/README.md)).

## Web: uma página, vinte e seis servidores
Cada pasta `web` serve uma página com `Hello, World!` em
`http://localhost:8080/` (para alterar a porta, use `PORT=...`). A maioria
envia `<p>Hello, World!</p>`; algumas enviam uma página HTML completa ou texto
simples, como informam seus READMEs. O texto é enviado pelo próprio servidor;
não há front-end separado. A linha que responde a `GET /`:

| Linguagem | Pasta | Biblioteca de servidor | A linha que responde a `/` |
|---|---|---|---|
| C | [`c/web`](../languages/c/web/) | GNU libmicrohttpd | `static const char page[] = "<p>Hello, World!</p>";` mais uma função tratadora `answer(...)` |
| C++ | [`cpp/web`](../languages/cpp/web/) | cpp-httplib | `server.Get("/", [](const httplib::Request &, httplib::Response &res) { ... });` |
| Java | [`java/web`](../languages/java/web/) | Spring Boot | `@GetMapping(value = "/", produces = MediaType.TEXT_HTML_VALUE)` em um método |
| C# | [`csharp/web`](../languages/csharp/web/) | ASP.NET Core | `app.MapGet("/", () => Results.Content("<p>Hello, World!</p>", "text/html"));` |
| Go | [`go/web`](../languages/go/web/) | biblioteca padrão `net/http` + `html/template` | `http.HandleFunc("GET /{$}", hello)` |
| Python | [`python/web`](../languages/python/web/) | Flask | `@app.route("/")` em uma função |
| Node.js | [`node/web`](../languages/node/web/) | Express | `app.get("/", (req, res) => { ... });` |
| Rust | [`rust/web`](../languages/rust/web/) | Axum | `Router::new().route("/", get(hello))` |
| PHP | [`php/web`](../languages/php/web/) | servidor embutido do PHP (`php -S`) | o próprio arquivo: `<p><?php echo "Hello, World!"; ?></p>` |
| Ruby | [`ruby/web`](../languages/ruby/web/) | Sinatra (sobre o Puma) | `get "/" do` ... `end`, com `"<p>Hello, World!</p>"` como valor do bloco |
| Ruby | [`ruby/web-rails`](../languages/ruby/web-rails/) | Ruby on Rails (sobre o Puma) | `root to: "hello#index"` mais um método de controlador, `HelloController#index` |
| Perl | [`perl/web`](../languages/perl/web/) | Mojolicious (`Mojolicious::Lite`) | `get '/' => sub { ... };` |
| Lua | [`lua/web`](../languages/lua/web/) | Pegasus (instalado com o LuaRocks) | `server:start(function(request, response) ... end)` |
| Haskell | [`haskell/web`](../languages/haskell/web/) | Scotty | `get "/" $ html "<p>Hello, World!</p>"` |
| Common Lisp | [`lisp/web`](../languages/lisp/web/) | Hunchentoot | `(hunchentoot:define-easy-handler (say-hello :uri "/") () ...)` |
| Prolog | [`prolog/web`](../languages/prolog/web/) | bibliotecas HTTP do SWI-Prolog | `:- http_handler(root(.), say_hello, []).` |
| Kotlin | [`kotlin/web`](../languages/kotlin/web/) | Ktor (sobre o Netty) | `get("/") { call.respondText("<p>Hello, World!</p>", ContentType.Text.Html) }` |
| Clojure | [`clojure/web`](../languages/clojure/web/) | Ring + Jetty | uma função tratadora que devolve um mapa: `{:status 200 :headers {...} :body "<p>Hello, World!</p>"}` |
| Erlang | [`erlang/web`](../languages/erlang/web/) | `httpd` do `inets`, parte do Erlang/OTP | um callback `do(ModData)` que devolve `{proceed, [{response, {response, Head, Body}}]}` |
| Elixir | [`elixir/web`](../languages/elixir/web/) | Plug + Bandit (do Hex) | `get "/" do ... send_resp(200, "<p>Hello, World!</p>") end` |
| Swift | [`swift/web`](../languages/swift/web/) | Vapor 4 | `app.get { req in "Hello, World!" }` |
| Objective-C | [`objectivec/web`](../languages/objectivec/web/) | nenhuma: Foundation e sockets BSD | o próprio programa abre o socket e monta a resposta HTTP/1.1 (`HTTP/1.1 200 OK`) |
| Dart | [`dart/web`](../languages/dart/web/) | `HttpServer` do `dart:io` | `await for (final request in server) { request.response ..write(...) ..close(); }` |
| TypeScript | [`typescript/web`](../languages/typescript/web/) | `node:http` do Node.js | `createServer((_request, response) => { ... response.end("Hello, World!"); })` |
| Visual Basic | [`visual-basic/web`](../languages/visual-basic/web/) | API mínima do ASP.NET Core | `app.MapGet("/", Function() "Hello, World!")` |
| Smalltalk | [`smalltalk/web`](../languages/smalltalk/web/) | Zinc (`ZnServer`, na imagem do Pharo) | `server onRequestRespond: [ :request | ... ]`: um bloco responde a todas as requisições |

Pontos a observar:
- **Estilos de roteamento.** A maioria das bibliotecas associa um caminho a
  uma função (C++, C#, Go, Node.js, Rust, Haskell, Prolog, Kotlin, Elixir, Swift, Visual Basic e o
  Mojolicious::Lite, do Perl; o Sinatra, do Ruby, associa um caminho a um
  bloco). Java e Python colocam o caminho na função, como anotação ou
  decorador. O Lisp define o tratador e o seu caminho em conjunto. O
  Rails mantém a rota (`root to: "hello#index"`) separada do tratador,
  um método de uma classe de controlador, e liga os dois por uma convenção
  de nomes. A libmicrohttpd, do C, e o Pegasus, do Lua, não têm roteador:
  uma única função recebe todas as requisições (o Pegasus responde a toda
  URL com a mesma página). O PHP não precisa
  de rota alguma: o `php -S` serve os arquivos de uma raiz de documentos, e
  `/` recebe `public/index.php`.
- **Nenhuma biblioteca.** O [`objectivec/web`](../languages/objectivec/web/README.md)
  abre um socket com as funções `socket` e `listen` do C e escreve a resposta
  à mão; assim, mostra o que os outros servidores escondem. O `httpd` do
  Erlang, o `dart:io` do Dart e o `node:http` do TypeScript acompanham a
  linguagem ou o runtime e não exigem nenhum pacote adicional para o servidor
  em si (o TypeScript precisa do `tsc` para compilar).
- **Framework ou biblioteca padrão.** O Go não precisa de nenhum pacote de
  terceiros, o servidor HTTP do Prolog acompanha o SWI-Prolog, e o ASP.NET
  Core vem com o SDK do .NET como um "shared framework" (consulte
  [`csharp/web/hello-web.csproj`](../languages/csharp/web/hello-web.csproj));
  o `php -S` é o servidor web *de desenvolvimento* do PHP (consulte
  [`php/web`](../languages/php/web/README.md)). As demais obtêm uma
  biblioteca de um gerenciador de pacotes: Maven (Java), pip (Python), npm
  (Node.js), Cargo (Rust), Cabal (Haskell), Quicklisp (Common Lisp), Bundler e RubyGems (Ruby), CPAN (Perl), LuaRocks (Lua), Gradle (Kotlin), Hex via Mix (Elixir), Swift Package Manager (Swift) ou
  Homebrew/apt (libmicrohttpd, do C, e cpp-httplib, do C++).
- **Framework pequeno ou grande.** O Ruby tem duas pastas web para a mesma
  página: o Sinatra precisa de um arquivo e de um bloco por rota, enquanto o
  Rails é um framework maior, com uma classe de controlador e uma convenção
  de nomes. O [README do Ruby](../languages/ruby/README.md#comparing-the-categories)
  compara os dois.
- **Teste de um servidor.** Todo `run.sh --verify` inicia o servidor, obtém
  a página com `curl` e o encerra em seguida (consulte
  [CONTRIBUTING.md](../CONTRIBUTING.md#script-contract)).

## Web com front-end separado
Três implementações dividem a aplicação em uma **API** e um **front-end**.
As três APIs respondem a `GET /api/hello` com
`{"message":"Hello, World!"}`; o front-end busca essa resposta e a exibe.

| Pasta | API (`backend/`) | Front-end (`frontend/`) | URL do front-end |
|---|---|---|---|
| [`java/web-react`](../languages/java/web-react/) | Spring Boot (Java) | React, compilado e servido pelo Vite | <http://localhost:4173/> |
| [`go/web-vue`](../languages/go/web-vue/) | biblioteca padrão (Go) | Vue, compilado e servido pelo Vite | <http://localhost:4173/> |
| [`csharp/web-angular`](../languages/csharp/web-angular/) | ASP.NET Core (C#) | Angular (TypeScript), Angular CLI | <http://localhost:4200/> |

A API sempre escuta na porta 8080. Compare cada pasta com a pasta `web` da
mesma linguagem ([`java/web`](../languages/java/web/), [`go/web`](../languages/go/web/),
[`csharp/web`](../languages/csharp/web/)): o servidor deixa de enviar HTML e passa a enviar
JSON, e o HTML migra para um programa separado, executado no navegador.

## Desktop: um rótulo, vinte janelas
Cada pasta `desktop` abre uma janela cujo título e cujo rótulo são
`Hello, World!` (Lua, Perl e Delphi são marcados como compromissos em seus
READMEs; consulte as observações a seguir).

| Linguagem | Pasta | Toolkit | Como o rótulo é criado |
|---|---|---|---|
| C | [`c/desktop`](../languages/c/desktop/) | GTK 4 | `label = gtk_label_new("Hello, World!");` |
| C++ | [`cpp/desktop`](../languages/cpp/desktop/) | Qt 6 Widgets | `QLabel label("Hello, World!");` |
| Java | [`java/desktop`](../languages/java/desktop/) | JavaFX | `Label label = new Label("Hello, World!");` |
| Java | [`java/desktop-swing`](../languages/java/desktop-swing/) | Swing (no JDK) | `JLabel label = new JLabel("Hello, World!", SwingConstants.CENTER);` |
| C# | [`csharp/desktop`](../languages/csharp/desktop/) | Avalonia | um inicializador de objeto: `Text = "Hello, World!",` |
| Go | [`go/desktop`](../languages/go/desktop/) | Fyne | `label := widget.NewLabel("Hello, World!")` |
| Python | [`python/desktop`](../languages/python/desktop/) | tkinter (Tk) | `label = ttk.Label(root, text="Hello, World!", padding=40)` |
| Node.js | [`node/desktop`](../languages/node/desktop/) | Electron | uma página HTML: `<h1 id="greeting">Hello, World!</h1>` |
| Rust | [`rust/desktop`](../languages/rust/desktop/) | eframe / egui | `ui.label("Hello, World!");`, chamado a cada quadro |
| Pascal | [`pascal/desktop`](../languages/pascal/desktop/) | Lazarus LCL | um arquivo de formulário, `mainunit.lfm`: `Caption = 'Hello, World!'` |
| Ruby | [`ruby/desktop`](../languages/ruby/desktop/) | Ruby/Tk (a gem `tk`, sobre o Tcl/Tk) | um bloco: `TkLabel.new(root) do text "Hello, World!" ... end` |
| Perl | [`perl/desktop`](../languages/perl/desktop/) | Tkx (sobre o Tcl/Tk); um compromisso | `$mw->new_ttk__label(-text => "Hello, World!", -padding => "60 40");` |
| Lua | [`lua/desktop`](../languages/lua/desktop/) | LÖVE (LuaJIT); um compromisso | `love.graphics.printf("Hello, World!", ...)`, chamado a cada quadro em `love.draw` |
| Kotlin | [`kotlin/desktop`](../languages/kotlin/desktop/) | Compose Multiplatform | `Text("Hello, World!")`, dentro de um `Window(...) { }` |
| Clojure | [`clojure/desktop`](../languages/clojure/desktop/) | Swing, chamado a partir do Clojure (interop com Java) | `(JLabel. "Hello, World!" SwingConstants/CENTER)` |
| Erlang | [`erlang/desktop`](../languages/erlang/desktop/) | `wx` (`wxWidgets`), parte do Erlang/OTP | `Text = wxStaticText:new(Frame, ?wxID_ANY, "Hello, World!"),` |
| Swift | [`swift/desktop`](../languages/swift/desktop/) | SwiftUI (macOS) | `Text("Hello, World!").font(.largeTitle)` no `body` de uma `View` |
| Objective-C | [`objectivec/desktop`](../languages/objectivec/desktop/) | AppKit (macOS) | `[label setStringValue:@"Hello, World!"];` |
| Smalltalk | [`smalltalk/desktop`](../languages/smalltalk/desktop/) | Pharo 14, Morphic | `text := TextMorph new. text contents: greeting.`, adicionado a uma `SystemWindow` (o título da janela é `Hello World`, veja a seguir) |
| Delphi | [`delphi/desktop`](../languages/delphi/desktop/) | Lazarus LCL (um compromisso: o Delphi em si não é executado) | `FGreeting.Caption := 'Hello, World!';` |

Pontos a observar:
- **Objeto, função ou descrição.** C++, Java, Python, Ruby, Perl e Go criam um objeto
  de rótulo no código. O C faz o mesmo com funções, porque não tem classes
  (`gtk_label_new` devolve um ponteiro para um objeto GTK). Pascal e
  Electron *descrevem* a janela em um arquivo separado (um formulário do
  Lazarus, uma página HTML) em vez de construí-la no código.
- **Modo imediato.** O egui ([`rust/desktop`](../languages/rust/desktop/README.md#step-by-step-walkthrough))
  desenha a janela inteira novamente a cada quadro; assim, `ui.label(...)`
  é chamado repetidamente, em vez de criar um rótulo uma única vez. O LÖVE
  ([`lua/desktop`](../languages/lua/desktop/README.md#step-by-step-walkthrough))
  funciona da mesma forma: é um framework de jogos que chama `love.draw` a
  cada quadro, de modo que o código não constrói uma árvore de widgets.
- **Um toolkit, três linguagens.** Python (tkinter), Ruby (Ruby/Tk) e Perl
  (Tkx) controlam o Tcl/Tk, cada uma por meio de seu próprio binding.
- **Dois compromissos.** [`perl/desktop`](../languages/perl/desktop/README.md#why-this-toolchain)
  usa o Tkx, e não o Perl/Tk, o binding mais conhecido, porque o Perl/Tk
  exige um servidor X11 no macOS. [`lua/desktop`](../languages/lua/desktop/README.md#what-this-is)
  usa o dialeto Lua 5.1, porque o LÖVE incorpora o LuaJIT, enquanto as
  versões cli e web usam o Lua 5.5.
- **Interface declarativa.** SwiftUI e Compose Multiplatform descrevem a
  janela como uma função do seu estado: `Text("Hello, World!")` é uma
  expressão dentro de um `body` ou de um bloco `Window`, não uma chamada a
  `new`. Compare isso com o estilo de objetos das pastas Java e C++ acima.
- **Um toolkit, muitas linguagens.** Clojure e Java usam ambos o Swing (a
  biblioteca Swing do JDK); Pascal e Delphi usam ambos o Lazarus LCL. O
  [`clojure/desktop`](../languages/clojure/desktop/README.md) mostra uma
  linguagem que não é Java chamando uma biblioteca Java sem um wrapper.
- **Toolkits de plataforma.** SwiftUI e AppKit são os toolkits da Apple para o
  macOS; veja as Notas por plataforma de [`swift/desktop`](../languages/swift/desktop/README.md)
  e de [`objectivec/desktop`](../languages/objectivec/desktop/README.md) para
  os outros sistemas.
- **Um ponto de exclamação que não é texto.** Em um arquivo `.st` do Pharo, o
  caractere `!` encerra um trecho de código; por isso,
  [`smalltalk/desktop`](../languages/smalltalk/desktop/hello.st) monta a
  cadeia `'Hello, World'` mais `(Character value: 33)` e dá à janela o título
  `Hello World` (os comentários do código-fonte explicam isso).
- **Dois toolkits, uma linguagem.** [Swing ou JavaFX?](../languages/java/desktop-swing/README.md#swing-or-javafx)
  compara as duas versões em Java.
- PHP, Haskell, Common Lisp, Prolog, TypeScript, Dart (fora do mobile) e as linguagens que têm apenas a
  categoria cli não possuem versão desktop; o README de cada linguagem
  explica o motivo (por exemplo,
  [PHP](../languages/php/README.md#why-there-is-no-desktop-version)).

## Mobile: uma tela, três plataformas
A categoria `mobile` mostra `Hello, World!` na tela de um telefone. Cada pasta
compila uma aplicação e a executa em um dispositivo virtual; o
`run.sh --verify` verifica a tela ou o log sem que uma pessoa precise olhar
para ela.

| Linguagem | Pasta | Toolkit | Dispositivo em que executa | A linha que mostra o texto |
|---|---|---|---|---|
| Kotlin | [`kotlin/mobile-android`](../languages/kotlin/mobile-android/) | Jetpack Compose, Android Gradle plugin | Emulador Android (imagem x86_64) | `Text("Hello, World!")` em `MainActivity.kt` |
| Swift | [`swift/mobile-ios`](../languages/swift/mobile-ios/) | SwiftUI, Xcode completo | iOS Simulator | `Text("Hello, World!")` em `hello.swift` |
| Dart | [`dart/mobile-flutter`](../languages/dart/mobile-flutter/) | Flutter | Emulador Android (a compilação para iOS não é verificada) | `child: Text('Hello, World!')` em `lib/main.dart` |

Pontos a observar:
- **Três toolkits declarativos.** SwiftUI, Jetpack Compose e Flutter descrevem
  a tela como expressões aninhadas (`Text(...)`), o mesmo estilo das versões
  SwiftUI e Compose de [desktop](#desktop-um-rótulo-vinte-janelas). Kotlin e
  Swift também têm uma pasta desktop com a mesma família de toolkit; assim,
  é possível ler as duas lado a lado.
- **Um dispositivo que precisa ser iniciado.** Uma aplicação de telefone não
  pode ser executada como um processo no seu computador. Os scripts do
  Android iniciam um emulador e instalam a aplicação com o `adb`; o script do
  iOS inicia um Simulator que acompanha o Xcode.
- **Uma toolchain maior do que a das outras categorias.** Na pasta do Android,
  o SDK e o emulador são a maior parte, e o iOS exige o Xcode completo, não
  apenas as ferramentas de linha de comando
  ([`swift/mobile-ios`](../languages/swift/mobile-ios/README.md#what-this-is)).
  A configuração por sistema está em
  [Comece aqui](start-here.md#5-mobile-apps-android-sdk-and-xcode).
- **A verificação difere.** As pastas do Android são verificadas na máquina de
  desenvolvimento. A pasta do iOS é verificada nela e em um runner macOS de
  integração contínua; consulte as **Notas por plataforma** de cada README e
  [Suporte a plataformas](platform-support.md).

## Comparações dentro de cada linguagem
O README de cada linguagem compara as suas próprias categorias (cli, desktop, web e mobile):

[Pseudocódigo](../languages/pseudocode/README.md#comparing-the-variants) ·
[C](../languages/c/README.md#comparing-the-categories) ·
[C++](../languages/cpp/README.md#comparing-the-categories) ([e C++ vs C](../languages/cpp/README.md#comparison-with-c)) ·
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
