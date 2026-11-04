# Programming paradigms in this repository

This repository represents all four main paradigms:
**object-oriented**, **logic**, **functional** and **imperative**. This
page explains what each paradigm is, shows the Hello World that represents
it in this repository, and lists which languages belong to which
paradigm.

- [What a paradigm is](#what-a-paradigm-is)
- [Imperative](#imperative)
- [Object-oriented](#object-oriented)
- [Functional](#functional)
- [Logic](#logic)
- [Every language and its paradigm](#every-language-and-its-paradigm)
- [What a Hello World can and cannot show](#what-a-hello-world-can-and-cannot-show)
- [Sources](#sources)

## What a paradigm is
Peter Van Roy, who wrote a textbook comparing paradigms, defines one this
way: "A programming paradigm is an approach to programming a computer based
on a mathematical theory or a coherent set of principles" [1]. He adds that
"Each paradigm supports a set of concepts that makes it the best for a
certain kind of problem" [1]. So a paradigm is not a language: it is a way
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
notion of time in programs" [1]. *Structured* (or *procedural*)
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
[Ada](../languages/ada/README.md), [Go](../languages/go/README.md), [PHP](../languages/php/README.md),
[Assembly](../languages/assembly/README.md) (imperative with nothing in between: each
line is one CPU instruction) and the three
[pseudocode](../languages/pseudocode/README.md) dialects.

## Object-oriented
The program is made of **objects**: each one keeps its own data and the
operations on that data together. Kay described the idea behind Smalltalk
as "a single kind of behavioral building block that hides its combination
of state and process inside itself and can be dealt with only through the
exchange of messages" and called it "a new design paradigm—which I called
object-oriented" [2]. He also traces it back to Simula, a language of the
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
[C#](../languages/csharp/README.md) and [C++](../languages/cpp/README.md) (multi-paradigm).
Languages that added objects later: [Ada](../languages/ada/README.md) (Ada 95),
[Fortran](../languages/fortran/README.md) (Fortran 2003), [COBOL](../languages/cobol/README.md)
(COBOL 2002), [PHP](../languages/php/README.md) (PHP 3 and 5) and Object
[Pascal](../languages/pascal/README.md) (used by [`pascal/desktop`](../languages/pascal/desktop/)).
Each language README gives the source for its own milestone.

## Functional
The program is made of **functions** in the mathematical sense: given the
same arguments, they always return the same result, and they change
nothing. John Hughes, in "Why Functional Programming Matters": "Functional
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
functional) and [Common Lisp](../languages/lisp/README.md) (multi-paradigm, grouped
with the functional languages; see its README). Many mainstream languages
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

**Coverage check:** each paradigm has at least one language with a
runnable implementation in this repository:

| Paradigm | Languages | Runnable implementations |
|---|---|---|
| Imperative | C, Pascal, COBOL, Fortran, BASIC, Clipper, Ada, Go, PHP, Assembly, pseudocode | e.g. [`c/cli`](../languages/c/cli/), [`pascal/cli`](../languages/pascal/cli/), [`cobol/cli`](../languages/cobol/cli/), [`assembly/cli`](../languages/assembly/cli/) |
| Object-oriented | Java, C#, C++ | e.g. [`java/cli`](../languages/java/cli/), [`java/desktop`](../languages/java/desktop/), [`csharp/desktop`](../languages/csharp/desktop/), [`cpp/desktop`](../languages/cpp/desktop/) |
| Functional | Haskell, Common Lisp | [`haskell/cli`](../languages/haskell/cli/), [`haskell/web`](../languages/haskell/web/), [`lisp/cli`](../languages/lisp/cli/), [`lisp/web`](../languages/lisp/web/) |
| Logic | Prolog | [`prolog/cli`](../languages/prolog/cli/), [`prolog/web`](../languages/prolog/web/) |

## What a Hello World can and cannot show
A Hello World does one thing: it writes text, which is a side effect. That
is the natural job of an imperative program, so in most languages the
program looks imperative even when the language is not. Compare:

- **Python, JavaScript, PHP, BASIC**: one statement. The multi-paradigm
  languages do not force any paradigm on a program this small.
- **Java**: a class is required, so the object-oriented structure is
  visible even with no objects created.
- **Haskell**: the program is a value of type `IO ()`, so the functional
  rule "no side effects" is visible in the type.
- **Prolog**: the program is a rule, and running it is proving a goal.

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
