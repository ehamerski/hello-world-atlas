# Programming paradigms in this repository

This repository represents all four main paradigms:
**object-oriented**, **logic**, **functional** and **imperative**.

This page explains what each paradigm is, shows the Hello World that
represents it in this repository, and lists which languages belong to
which paradigm. Four further sections follow the ideas that cut across the
four: the **concurrent** style of Erlang and Elixir and its link to the
actor model, the **origins of object orientation** from Simula to Swift,
**Design by Contract** in Eiffel, and **quantum** programming with QCL.

- [What a paradigm is](#what-a-paradigm-is)
- [Imperative](#imperative)
- [Object-oriented](#object-oriented)
- [Functional](#functional)
- [Logic](#logic)
- [Concurrent: processes, messages and the actor model](#concurrent-processes-messages-and-the-actor-model)
- [Where object orientation came from](#where-object-orientation-came-from)
- [Design by Contract](#design-by-contract)
- [Quantum](#quantum)
- [Every language and its paradigm](#every-language-and-its-paradigm)
- [What a Hello World can and cannot show](#what-a-hello-world-can-and-cannot-show)
- [Sources](#sources)

## What a paradigm is
Peter Van Roy, who wrote a textbook comparing paradigms, defines one this
way: "A programming paradigm is an approach to programming a computer based
on a mathematical theory or a coherent set of principles" [1]. He adds that
"Each paradigm supports a set of concepts that makes it the best for a
certain kind of problem" [1].

So a paradigm is not a language: it is a way
of thinking about a program, and a language makes some ways easier than
others.

Alan Kay, who named object-oriented programming, wrote in 1993 that
"Programming languages can be categorized in a number of ways: imperative,
applicative, logic-based, problem-oriented, etc." [2]. Many languages support more than one
paradigm. Van Roy calls this "multiparadigm programming" and argues that
"it should be the normal way of programming" [1]. This is why several
languages in the table below have two labels.

The four paradigms differ mainly in **what a program is made of** and
**how it changes things**:

| Paradigm | A program is… | How things change | Representative here |
|---|---|---|---|
| Imperative | a sequence of statements | statements change variables, step by step | [C](../languages/c/README.md) |
| Object-oriented | objects that hold data and behavior | objects change their own state when they receive messages (method calls) | [Java](../languages/java/README.md) |
| Functional | functions applied to arguments | nothing is changed: functions return new values | [Haskell](../languages/haskell/README.md) |
| Logic | facts and rules | nothing is "run" step by step: a query is proved from the rules | [Prolog](../languages/prolog/README.md) |

## Imperative
The program tells the computer **what to do, in order**. The C standard
describes it in one sentence: "A statement specifies an action to be
performed. Except as indicated, statements are executed in sequence" [6].
Van Roy calls the concept behind it *named state*: a variable that
has a name and whose content changes over time. "State introduces an abstract
notion of time in programs" [1].

*Structured* (or *procedural*)
programming is imperative programming organized into procedures and
blocks (`if`, loops) instead of jumps; Dijkstra's 1968 letter "Go To
Statement Considered Harmful" made the case against jumps (`goto`) [9].

The C version, [`c/cli/hello.c`](../languages/c/cli/hello.c) (comments removed):
```c
#include <stdio.h>

int main(void)
{
    printf("Hello, World!\n");
    return 0;
}
```
One function, `main`, whose statements run from top to bottom: call
`printf`, then return 0. The
[walkthrough](../languages/c/cli/README.md#step-by-step-walkthrough) explains each
line.

Imperative languages here: [C](../languages/c/README.md), [Pascal](../languages/pascal/README.md),
[COBOL](../languages/cobol/README.md), [Fortran](../languages/fortran/README.md),
[BASIC](../languages/basic/README.md), [Clipper](../languages/clipper/README.md),
[dBASE](../languages/dbase/README.md), [ALGOL 68](../languages/algol68/README.md),
[Ada](../languages/ada/README.md), [Go](../languages/go/README.md), [PHP](../languages/php/README.md),
[Bash](../languages/bash/README.md), [Zig](../languages/zig/README.md),
[QCL](../languages/qcl/README.md) (imperative, with quantum operations: see
[Quantum](#quantum)),
[Assembly](../languages/assembly/README.md) (imperative with nothing in between: each
line is one CPU instruction) and the three
[pseudocode](../languages/pseudocode/README.md) dialects.

## Object-oriented
The program is made of **objects**: each one keeps its own data and the
operations on that data together. Kay described the idea behind Smalltalk
as "a single kind of behavioral building block that hides its combination
of state and process inside itself and can be dealt with only through the
exchange of messages" and called it "a new design paradigm—which I called
object-oriented" [2].

He also traces it back to Simula, a language of the
1960s: "Simula-67 added [inheritance] as a generalization to the
ALGOL-60 <block> structure" [2].

Java is the clearest example here. Its specification calls it "a
general-purpose, concurrent, class-based, object-oriented language" [7],
and even Hello World must live inside a class
([`java/cli/.../Hello.java`](../languages/java/cli/src/main/java/com/example/hello/Hello.java),
comments removed):
```java
package com.example.hello;

public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

`System.out` is an object (the standard output stream) and `println` is a
message sent to it. A Hello World creates no objects of its own, so the
object-oriented style shows better in the desktop versions, where a window
class extends a toolkit class: see [`java/desktop`](../languages/java/desktop/README.md#step-by-step-walkthrough),
[`csharp/desktop`](../languages/csharp/desktop/README.md#step-by-step-walkthrough)
(`override`) and [`cpp/desktop`](../languages/cpp/desktop/README.md#step-by-step-walkthrough)
(Qt classes).

Object-oriented languages here: [Java](../languages/java/README.md),
[C#](../languages/csharp/README.md), [C++](../languages/cpp/README.md) (multi-paradigm),
[Ruby](../languages/ruby/README.md) (with imperative and functional features;
its README quotes the official site: "In Ruby, everything is an object"),
[Simula](../languages/simula/README.md), [Smalltalk](../languages/smalltalk/README.md),
[Objective-C](../languages/objectivec/README.md), [Swift](../languages/swift/README.md),
[Eiffel](../languages/eiffel/README.md), [Kotlin](../languages/kotlin/README.md),
[Scala](../languages/scala/README.md), [Dart](../languages/dart/README.md),
[Visual Basic](../languages/visual-basic/README.md) and
[Delphi](../languages/delphi/README.md). The next sections follow the
[history](#where-object-orientation-came-from) of the idea and one
[design method](#design-by-contract) that grew from it.

Languages that added objects later: [Ada](../languages/ada/README.md) (Ada 95),
[Fortran](../languages/fortran/README.md) (Fortran 2003), [COBOL](../languages/cobol/README.md)
(COBOL 2002), [PHP](../languages/php/README.md) (PHP 3 and 5) and Object
[Pascal](../languages/pascal/README.md) (used by [`pascal/desktop`](../languages/pascal/desktop/)).
Each language README gives the source for its own milestone.

## Functional
The program is made of **functions** in the mathematical sense: given the
same arguments, they always return the same result, and they change
nothing.

John Hughes, in "Why Functional Programming Matters": "Functional
programming is so called because its fundamental operation is the
application of functions to arguments" [3], and "Functional programs
contain no assignment statements, so variables, once given a value, never
change. More generally, functional programs contain no side-effects at
all" [3].

Printing is a side effect, so how can a purely functional language print?
The Haskell 2010 Report calls Haskell "a general purpose, purely
functional programming language" with "a monadic I/O system" [8]. The
program does not print; it *returns a value that describes* printing, an
`IO` action, and the runtime performs it
([`haskell/cli/hello.hs`](../languages/haskell/cli/hello.hs), comments removed):
```haskell
module Main (main) where

main :: IO ()
main = putStrLn "Hello, World!"
```

`main = ...` is an equation, not a statement: `main` *is* the action
`putStrLn "Hello, World!"`. The type `IO ()` says so. The
[walkthrough](../languages/haskell/cli/README.md#step-by-step-walkthrough) goes
through it line by line.

Functional languages here: [Haskell](../languages/haskell/README.md) (purely
functional), [Common Lisp](../languages/lisp/README.md) (multi-paradigm, grouped
with the functional languages; see its README),
[Clojure](../languages/clojure/README.md), [OCaml](../languages/ocaml/README.md),
[F#](../languages/fsharp/README.md), [Racket](../languages/racket/README.md),
[R](../languages/r/README.md), [Erlang](../languages/erlang/README.md) and
[Elixir](../languages/elixir/README.md). Erlang and Elixir are also the
[concurrent](#concurrent-processes-messages-and-the-actor-model) languages here.
Scala and Kotlin join functional and object-oriented features. Many mainstream languages
borrowed functional features, for example lambdas in
[Java](../languages/java/README.md) and [C#](../languages/csharp/README.md), and
[Rust](../languages/rust/README.md), whose book names functional programming as "one
significant influence" (see the Rust README).

## Logic
The program is a set of **facts and rules** written in logic, and running
it means **asking a question** that the system tries to prove. Robert
Kowalski put it this way in 1974: "An
axiomatisation of a problem domain is a program for solving problems in
that domain. Individual problems are posed as theorems to be proved" [4].

In 1979 he summed it up as "Algorithm = Logic + Control": "An algorithm can
be regarded as consisting of a logic component, which specifies the
knowledge to be used in solving problems, and a control component, which
determines the problem-solving strategies by means of which that knowledge
is used" [5]. The programmer writes the logic; the Prolog system supplies
the control (search).

The Prolog version, [`prolog/cli/hello.pl`](../languages/prolog/cli/hello.pl)
(comments removed):
```prolog
:- initialization(main, main).

main :-
    format("Hello, World!~n").
```

`main :- format(...)` is a **rule**: "`main` is true if `format(...)`
succeeds". The directive on the first line asks SWI-Prolog to prove the
goal `main` when the program starts; proving it prints the text as a side
effect. The [walkthrough](../languages/prolog/cli/README.md#step-by-step-walkthrough)
explains the directive, and the [Prolog README](../languages/prolog/README.md)
explains facts, rules and queries.

Logic language here: [Prolog](../languages/prolog/README.md). Van Roy notes that
Prolog is itself two paradigms in one: "a logic programming engine based on
unification and depth-first search" plus an imperative part, "the assert
and retract operations" [1].

## Concurrent: processes, messages and the actor model
Concurrency means that several activities are in progress at the same time.
The usual way to program it is *shared state*: threads read and write the
same memory, guarded by locks. Erlang and Elixir take the other road. A
program is made of many small **processes**, and they change nothing in
each other: they only send **messages**.

The Erlang guide puts it this way: "Threads of execution in Erlang share no
data, that is why they are called processes" [12]. "Each process has its
own input queue for messages it receives" [12], and a process sends a
message with the operator `!` (`Pid ! Message`) [12].

The reference manual
adds that "Erlang processes are lightweight (grow and shrink dynamically)
with a small memory footprint, fast to create and terminate, and the
scheduling overhead is low" [13].

Sending is asynchronous: "Signals are
received asynchronously and automatically" [13].

Elixir's guide says the
same for Elixir: "Processes are isolated from each other, run concurrent to
one another and communicate via message passing", and the sender "does not
block on `send/2`, it puts the message in the recipient's mailbox and
continues" [14].

**Why isolation.** Joe Armstrong, one of the creators of Erlang, derives
the rules from one requirement in his doctoral thesis. Processes are
imagined to run on separate machines, and "Isolation has several
consequences": processes have "share nothing" semantics, "Message passing
is the only way to pass data between processes", and "Isolation implies
that message passing is asynchronous" [11].

If communication were
synchronous, "a software error in the receiver of a message could
indefinitely block the sender" [11].

He named the style *Concurrency Oriented Programming*: "the concurrent
structure of the program should follow the concurrent structure of the application" [11]. He also notes
that it gives "the two major advantages commonly associated with
object-oriented programming": polymorphism and a message-passing interface
shared by different process types [11].

**The actor model.** In 1973 Carl Hewitt, Peter Bishop and Richard Steiger
proposed a formalism built on one kind of thing, the *actor*, and wrote
that "all of the modes of behavior can be defined in terms of one kind of
behavior: sending messages to actors" [10]. Erlang and Elixir processes
have the same shape: separate units that hold their own state and reach
each other only through messages [11][12][14].

This page draws that
comparison itself. The sources above do not say that Erlang was derived
from the actor paper, and Armstrong's account of Erlang's origins (see the
[Erlang README](../languages/erlang/README.md#history)) starts from Prolog.

**The BEAM.** Both languages run on the same virtual machine. Armstrong's
thesis calls the Erlang run-time system "a virtual machine designed to run
the intermediate code produced by the Erlang BEAM compiler", and records
that the BEAM compiler "replaced the original JAM compiler in 1998" [11].
The [Elixir README](../languages/elixir/README.md#history) quotes Elixir's
own announcement: "Elixir leverages the Erlang VM".

The two Hello World
programs show it: [`erlang/cli`](../languages/erlang/cli/README.md#step-by-step-walkthrough)
calls `io:format`, [`elixir/cli`](../languages/elixir/cli/README.md#step-by-step-walkthrough)
calls `IO.puts`, and both end up in the same runtime. A Hello World sends no messages
between processes, so these programs show the runtime, not the model.

Other languages here with built-in concurrency are [Go](../languages/go/README.md)
and [Clojure](../languages/clojure/README.md); their READMEs cite how each
one does it. They are not the actor model unless a source says so.

## Where object orientation came from
Object orientation did not arrive in one step. Four languages in this
repository mark the path.

1. **Simula (1960s).** Ole-Johan Dahl and Kristen Nygaard designed Simula
   at the Norwegian Computing Center for simulation programs. Krogdahl's
   history says they "introduced the basic concepts of what later became
   object-orientation" [15]. Simula 67 let a programmer declare a subclass
   of a class where the class is visible, by writing the class name as a
   "prefix": "C class D (...); begin ... end" [15]. The
   [Simula README](../languages/simula/README.md#history) gives the dates
   and the report that defines the language.
2. **Smalltalk (1970s).** Alan Kay wrote that "most of my ideas from then on
   took their roots from Simula—but not as an attempt to improve it" [2],
   and that Simula "became the precursor of Smalltalk in 1972" [2].

   Smalltalk made the message the center: its design rests on "a single
   kind of    behavioral building block that hides its combination of state and process
   inside itself and can be dealt with only through the exchange of
   messages" [2]. In [`smalltalk/cli`](../languages/smalltalk/cli/hello.st)
   even printing is a message: `'Hello, World!' displayNl` sends
   `displayNl` to a string.
3. **Objective-C (1980s).** Apple's guide describes it as "a small but
   powerful set of extensions to the standard ANSI C language. Its additions
   to C are mostly based on Smalltalk, one of the first object-oriented
   programming languages" [16]. The messaging syntax of its source,
   `[object message]`, shows the debt (see
   [`objectivec/desktop`](../languages/objectivec/desktop/hello.m), where
   `[label setStringValue:...]` is a message). The
   [Objective-C README](../languages/objectivec/README.md#history-and-milestones)
   has the dates.
4. **Swift (2014).** Its principal designer, Chris Lattner, writes that
   Swift benefited from "the experiences hard-won by many other languages
   in the field, drawing ideas from Objective-C, Rust, Haskell, Ruby,
   Python, C#, CLU, and far too many others to list" [17]. The Swift README
   has the release history.

The result is two meanings of "object-oriented" that still coexist. Simula
and Java organize a program around **classes**; Smalltalk and Objective-C
organize it around **messages** to objects.

Kay himself stressed the second:
"Objects communicate by sending and receiving messages (in terms of
objects)" [2]. This is why the [Object-oriented](#object-oriented) section
above quotes both Kay and the Java specification. This repository does
not rank the two views; each language README says which words its own
source uses.

## Design by Contract
**Design by Contract** is a method from Bertrand Meyer, built into the
language he designed, [Eiffel](../languages/eiffel/README.md). The Eiffel
documentation explains the idea with a business metaphor: "Design by
Contract states that their cooperation should be based on precise
specifications -- contracts -- describing each party's expectations and
guarantees" [18]. A contract has three parts [18]:

- a **precondition**: "The client's obligation, which protects the supplier"
  ("what the client must satisfy before requesting a certain service");
- a **postcondition**: "The client's benefit, which describes what the
  supplier must do (assuming the precondition was satisfied)";
- a **class invariant**, which "must be ensured by every creation procedure
  ... and maintained by every exported routine of the class".

The goal is reliability. Meyer's 1992 article says its guidelines aim "to
help improve the reliability of software systems", where reliability is "the
combination of correctness and robustness" [19]. The Eiffel
documentation says who is to blame when a contract breaks: "A precondition
violation signals a bug in the client" and "A postcondition (or invariant)
violation signals a bug in the supplier" [18].

Even Hello World shows it in Eiffel
([`eiffel/cli/hello.e`](../languages/eiffel/cli/hello.e), comments removed):
```eiffel
class
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
`require` states what the caller of `say` must provide, and `ensure` states
what `greeting` promises. As the comments in the source say, both are
checked while the program runs when assertion checking is switched on in
the compiler. Most languages in this repository
have no such keywords; they check the same ideas with tests, types or
exceptions. The [Eiffel README](../languages/eiffel/README.md) and its
[walkthrough](../languages/eiffel/cli/README.md#step-by-step-walkthrough)
explain every line.

## Quantum
Quantum programming is less a paradigm than a new kind of machine. This
repository has one language for it, [QCL](../languages/qcl/README.md)
(Quantum Computation Language) by Bernhard Ömer. Its page calls QCL "a high
level, architecture independent programming language for quantum computers,
with a syntax derived from classical procedural languages like C or
Pascal" [21].

Ömer's thesis defines the terms: "A QPL [quantum programming
language] is called imperative if it provides quantum registers (quantum
variables), elementary gates and single qubit measurements" [20].

The physics behind it, in the words of IBM's course: "The term *qubit*
refers to a quantum system whose classical state set is {0,1}"; a state that
is a linear combination of the two is a *superposition*; and when a state is
measured, "each classical state of the system appears with probability equal
to the absolute value squared of the entry in the quantum state vector" [24].

**The Hello World shows none of this.** [`qcl/cli/hello.qcl`](../languages/qcl/cli/hello.qcl)
uses only QCL's classical part: a `procedure` and a `print` statement, with
no qubit. Printing text is a classical job, so the program is imperative
like the C and Pascal it resembles. The QCL README explains the output
format and what the interpreter simulates.

For today's tools, the sources describe two others, neither built in this
repository:
- **Qiskit**: "an open-source SDK for working with quantum computers at the
  level of extended (static, dynamic, and scheduled) quantum circuits,
  operators, and primitives" [22].
- **Q#**: "a high-level, open-source programming language developed by
  Microsoft for writing quantum programs" [23].

They are named for context only. This page gives no ranking and no usage
figure for any of the three.

## Every language and its paradigm
The label for each language comes from its own README, which quotes the
language's specification or official documentation for it (first
paragraph, **Paradigm**). "Primary" is the paradigm this repository uses to
group the language; "also supports" lists other styles that the cited
source names.

| Language | Primary paradigm | Also supports | Hello World style used here |
|---|---|---|---|
| [Pseudocode](../languages/pseudocode/README.md) | imperative (teaching) | – | statements in order |
| [C](../languages/c/README.md) | imperative (procedural) | – | `main` function, statements in order |
| [C++](../languages/cpp/README.md) | multi-paradigm / object-oriented | procedural, generic | procedural `main`, like C |
| [Java](../languages/java/README.md) | object-oriented | functional features (lambdas, Java 8) | a class with a `main` method |
| [C#](../languages/csharp/README.md) | object-oriented | functional features | top-level statement (no class written) |
| [Go](../languages/go/README.md) | imperative, concurrent | methods without classes | `main` function in package `main` |
| [Python](../languages/python/README.md) | multi-paradigm | object-oriented, procedural, functional | one statement |
| [Node.js (JavaScript)](../languages/node/README.md) | multi-paradigm, event-driven | prototype-based objects | one statement |
| [Rust](../languages/rust/README.md) | multi-paradigm, systems | functional influence, traits | `main` function and a macro |
| [PHP](../languages/php/README.md) | imperative | object-oriented (PHP 3, PHP 5) | one statement |
| [Ruby](../languages/ruby/README.md) | object-oriented | imperative, functional | one statement |
| [Perl](../languages/perl/README.md) | multi-paradigm | object-oriented, procedural, functional | one statement, after `use strict;` and `use warnings;` |
| [Lua](../languages/lua/README.md) | multi-paradigm | procedural, object-oriented, functional, data-driven, data description | one statement |
| [Haskell](../languages/haskell/README.md) | **functional** (purely, lazy) | – | `main` is an `IO` action |
| [Common Lisp](../languages/lisp/README.md) | **functional** (multi-paradigm) | imperative, object-oriented | a function called by the saved image |
| [Prolog](../languages/prolog/README.md) | **logic** | imperative (`assert`/`retract`) [1] | a rule proved at startup |
| [Pascal](../languages/pascal/README.md) | imperative (structured) | object-oriented (Object Pascal) | program body between `begin` and `end.` |
| [COBOL](../languages/cobol/README.md) | imperative (procedural) | object-oriented (COBOL 2002) | a `PROCEDURE DIVISION` |
| [Clipper (Harbour)](../languages/clipper/README.md) | imperative (procedural) | – | `PROCEDURE Main()` |
| [BASIC](../languages/basic/README.md) | imperative (procedural) | – | one statement |
| [Fortran](../languages/fortran/README.md) | imperative (procedural) | object-oriented (Fortran 2003) | a `program` unit |
| [Ada](../languages/ada/README.md) | imperative | object-oriented (Ada 95) | a main procedure |
| [Assembly (x86-64)](../languages/assembly/README.md) | imperative, low-level | – | CPU instructions and a system call |
| [Bash](../languages/bash/README.md) | imperative (shell) | – | one command, `printf` |
| [ALGOL 68](../languages/algol68/README.md) | imperative | parallel execution (collateral elaboration) | one `print` call, no `main` |
| [dBASE](../languages/dbase/README.md) | imperative, with database commands | – | commands in a `.prg` file |
| [Zig](../languages/zig/README.md) | imperative | – | `main` function and an explicit write |
| [Delphi](../languages/delphi/README.md) | imperative | object-oriented (Object Pascal) | program body, Delphi mode |
| [Visual Basic (VB.NET)](../languages/visual-basic/README.md) | object-oriented | imperative | `Module` with `Sub Main` |
| [Simula](../languages/simula/README.md) | object-oriented | – | one block with `outtext` and `outimage` |
| [Smalltalk](../languages/smalltalk/README.md) | **object-oriented** (messages) | – | a message sent to a string |
| [Eiffel](../languages/eiffel/README.md) | **object-oriented** | Design by Contract | a class with `require` and `ensure` |
| [Objective-C](../languages/objectivec/README.md) | object-oriented | imperative (superset of C) | `main`, plus a message send |
| [Swift](../languages/swift/README.md) | multi-paradigm | object-oriented, functional | one statement |
| [Kotlin](../languages/kotlin/README.md) | multi-paradigm | object-oriented, functional | top-level `fun main()` |
| [Scala](../languages/scala/README.md) | multi-paradigm | functional, object-oriented | an `@main` method |
| [Dart](../languages/dart/README.md) | object-oriented | – | `main` function |
| [TypeScript](../languages/typescript/README.md) | multi-paradigm | object-oriented, optional static types | one typed constant and one call |
| [Julia](../languages/julia/README.md) | multi-paradigm | imperative, functional, object-oriented | one statement |
| [Clojure](../languages/clojure/README.md) | **functional** | concurrency support | a function in a namespace |
| [OCaml](../languages/ocaml/README.md) | **functional** | object-oriented, imperative | `let () = ...` |
| [F#](../languages/fsharp/README.md) | **functional** | object-oriented, imperative (multi-paradigm) | one top-level statement |
| [Racket](../languages/racket/README.md) | **functional** | object-oriented (a class library), language-oriented | one expression in a module |
| [R](../languages/r/README.md) | **functional** | object-oriented | one expression |
| [Erlang](../languages/erlang/README.md) | **functional**, concurrent | – | an `escript` with `main/1` |
| [Elixir](../languages/elixir/README.md) | **functional**, concurrent | – | one function call |
| [QCL](../languages/qcl/README.md) | imperative | quantum operations (not used by Hello World) | a procedure and a call |

**Coverage check:** each paradigm has at least one language with a
runnable implementation in this repository:

| Paradigm | Languages | Runnable implementations |
|---|---|---|
| Imperative | C, Pascal, COBOL, Fortran, BASIC, Clipper, dBASE, ALGOL 68, Ada, Go, PHP, Bash, Zig, QCL, Assembly, pseudocode | e.g. [`c/cli`](../languages/c/cli/), [`pascal/cli`](../languages/pascal/cli/), [`cobol/cli`](../languages/cobol/cli/), [`assembly/cli`](../languages/assembly/cli/) |
| Object-oriented | Java, C#, C++, Ruby, Simula, Smalltalk, Eiffel, Objective-C, Swift, Kotlin, Scala, Dart, Visual Basic, Delphi | e.g. [`java/cli`](../languages/java/cli/), [`smalltalk/cli`](../languages/smalltalk/cli/), [`simula/cli`](../languages/simula/cli/), [`eiffel/cli`](../languages/eiffel/cli/), [`java/desktop`](../languages/java/desktop/), [`swift/desktop`](../languages/swift/desktop/) |
| Functional | Haskell, Common Lisp, Clojure, OCaml, F#, Racket, R, Erlang, Elixir | [`haskell/cli`](../languages/haskell/cli/), [`haskell/web`](../languages/haskell/web/), [`lisp/cli`](../languages/lisp/cli/), [`ocaml/cli`](../languages/ocaml/cli/), [`erlang/cli`](../languages/erlang/cli/), [`elixir/web`](../languages/elixir/web/) |
| Logic | Prolog | [`prolog/cli`](../languages/prolog/cli/), [`prolog/web`](../languages/prolog/web/) |
| Concurrent (processes and messages) | Erlang, Elixir | [`erlang/cli`](../languages/erlang/cli/), [`erlang/web`](../languages/erlang/web/), [`elixir/cli`](../languages/elixir/cli/), [`elixir/web`](../languages/elixir/web/) |
| Quantum | QCL | [`qcl/cli`](../languages/qcl/cli/) |

## What a Hello World can and cannot show
A Hello World does one thing: it writes text, which is a side effect. That
is the natural job of an imperative program, so in most languages the
program looks imperative even when the language is not. Compare:

- **Python, JavaScript, PHP, BASIC, Ruby, Perl, Lua, Julia, Elixir, Swift, F#, R**: one statement
  (Perl puts `use strict;` and `use warnings;` before it). The multi-paradigm
  languages do not force any paradigm on a program this small. Ruby is
  object-oriented, yet its Hello World is a single `puts` call with no class.
- **Java**: a class is required, so the object-oriented structure is
  visible even with no objects created.
- **Haskell**: the program is a value of type `IO ()`, so the functional
  rule "no side effects" is visible in the type.
- **Prolog**: the program is a rule, and running it is proving a goal.
- **Smalltalk**: the program sends a message, `displayNl`, to a string.
- **Eiffel**: the program is a class, and two of its routines carry a
  contract (`require` and `ensure`).
- **Erlang and Elixir**: a single process prints; no messages are sent, so
  the actor-like style does not show.
- **QCL**: only the classical part of the language is used; no qubit is
  created.

To see more of each paradigm than printing allows, read the "Comparing the
categories" section of each language README (for example
[Haskell](../languages/haskell/README.md#comparing-the-categories) and
[Prolog](../languages/prolog/README.md#comparing-the-categories)), and
[comparisons.md](comparisons.md) for comparisons across languages.

Whether AI will produce a new paradigm is discussed separately in
[ai-new-paradigm.md](ai-new-paradigm.md).

## Sources
1. Programming Paradigms for Dummies: What Every Programmer Should Know. Peter Van Roy, in *New Computational Paradigms for Computer Music*, G. Assayag and A. Gerzso (eds.), IRCAM/Delatour France, 2009. Author's copy, UCLouvain. <https://webperso.info.ucl.ac.be/~pvr/VanRoyChapter.pdf> (accessed 2026-11-02). Companion page: <https://webperso.info.ucl.ac.be/~pvr/paradigms.html> (accessed 2026-11-02)
2. The Early History of Smalltalk. Alan C. Kay, Second History of Programming Languages conference (HOPL-II), ACM, 1993. <https://doi.org/10.1145/155360.155364>. The ACM page blocks automated reading; the quotes were checked in this full-text copy: <https://worrydream.com/EarlyHistoryOfSmalltalk/> (accessed 2026-11-02)
3. Why Functional Programming Matters. John Hughes, in *Research Topics in Functional Programming*, D. Turner (ed.), Addison-Wesley, 1990, pp. 17–42 (earlier version in The Computer Journal 32(2), 1989). <https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf> (accessed 2026-11-02)
4. Predicate Logic as Programming Language. Robert Kowalski, Information Processing 74 (IFIP Congress), North-Holland, 1974. <https://www.doc.ic.ac.uk/~rak/papers/IFIP%2074.pdf> (accessed 2026-11-01)
5. Algorithm = Logic + Control. Robert Kowalski, Communications of the ACM, July 1979. <https://www.doc.ic.ac.uk/~rak/papers/algorithm%20=%20logic%20+%20control.pdf> (accessed 2026-11-02)
6. ISO/IEC 9899:TC3, committee draft WG14/N1256 (6.8 Statements and blocks). ISO/IEC JTC1/SC22/WG14, 2007-09-07. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (accessed 2026-10-31)
7. The Java Language Specification, Java SE 21 Edition, Chapter 1. Introduction. Oracle. <https://docs.oracle.com/javase/specs/jls/se21/html/jls-1.html> (accessed 2026-10-31)
8. Haskell 2010 Language Report, Chapter 1: Introduction. Simon Marlow (editor), haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch1.html> (accessed 2026-11-01)
9. EWD 215: A Case against the GO TO Statement, published as the letter "Go-to statement considered harmful", Communications of the ACM 11(3), 1968, pp. 147–148. Edsger W. Dijkstra; E. W. Dijkstra Archive, University of Texas at Austin. <https://www.cs.utexas.edu/~EWD/ewd02xx/EWD215.PDF> (accessed 2026-11-02)
10. A Universal Modular ACTOR Formalism for Artificial Intelligence. Carl Hewitt, Peter Bishop and Richard Steiger, Proceedings of the Third International Joint Conference on Artificial Intelligence (IJCAI), 1973. <https://www.ijcai.org/Proceedings/73/Papers/027B.pdf> (accessed 2026-11-16)
11. Making reliable distributed systems in the presence of software errors. Joe Armstrong, doctoral dissertation, Royal Institute of Technology (KTH), Stockholm, final version, 2003-11-20 (sections 2.4 and the run-time system chapter). <https://erlang.org/download/armstrong_thesis_2003.pdf> (accessed 2026-11-16)
12. Conc prog (Processes, Message Passing). Erlang/OTP documentation, Getting Started. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/conc_prog.html> (accessed 2026-11-16)
13. Processes (reference manual). Erlang/OTP documentation. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/ref_man_processes.html> (accessed 2026-11-16)
14. Processes. Elixir Getting started guide, Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/processes.html> (accessed 2026-11-16)
15. The Birth of Simula. Stein Krogdahl, Department of Informatics, University of Oslo. <https://www.mn.uio.no/english/services/it/simula/bibliography/history/sk-the-birth-of-simula.pdf> (accessed 2026-11-16)
16. The Objective-C Programming Language (Introduction; retired document, updated 2013-04-23). Apple Inc. <https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Introduction/introObjectiveC.html> (accessed 2026-11-16)
17. Chris Lattner's homepage (section on Swift). Chris Lattner. <https://nondot.org/sabre/> (accessed 2026-11-16)
18. Design by Contract, Assertions and Exceptions (Eiffel Tutorial). Eiffel Software, eiffel.org. <https://www.eiffel.org/doc/eiffel/ET-_Design_by_Contract_%28tm%29%2C_Assertions_and_Exceptions> (accessed 2026-11-16)
19. Applying "Design by Contract". Bertrand Meyer, *Computer* (IEEE), October 1992. Author's copy, ETH Zurich. <https://se.inf.ethz.ch/~meyer/publications/computer/contract.pdf> (accessed 2026-11-16)
20. Structured Quantum Programming. Bernhard Ömer, doctoral thesis, Vienna University of Technology, first version 2003-05-26 (abstract and chapter 2). <https://tph.itp.tuwien.ac.at/~oemer/doc/structquprog.pdf> (accessed 2026-11-16)
21. QCL - A Programming Language for Quantum Computers. Bernhard Oemer, TU Wien. <https://tph.itp.tuwien.ac.at/~oemer/qcl.html> (accessed 2026-11-16)
22. Introduction to Qiskit (The Qiskit SDK). IBM Quantum documentation. <https://quantum.cloud.ibm.com/docs/en/guides/tools-intro> (accessed 2026-11-16)
23. Q# overview. Microsoft Learn (page updated 2026-08-29). <https://learn.microsoft.com/azure/quantum/qsharp-overview> (accessed 2026-11-16)
24. Quantum information (Basics of quantum information, Single systems). IBM Quantum Learning. <https://quantum.cloud.ibm.com/learning/en/courses/basics-of-quantum-information/single-systems/quantum-information> (accessed 2026-11-16)
