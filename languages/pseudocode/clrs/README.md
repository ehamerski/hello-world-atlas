# Pseudocode · CLRS style: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Pseudocode](../README.md)

## What this is
A Hello World, [`hello-world.txt`](hello-world.txt), written in the
pseudocode style of *Introduction to Algorithms* by Cormen, Leiserson,
Rivest and Stein, known as **CLRS** from the authors' initials. The book
grew out of MIT's algorithms course 6.046, and in 2022 MIT News reported
that it "has now officially sold over 1 million copies worldwide" [1]. Why
it is one of the three variants is explained in the
[pseudocode overview](../README.md#ranking-evidence).

**This variant is documented only.** CLRS pseudocode is a notation for
reading, typeset in the book with the authors' own LaTeX package [2]. No
interpreter for it exists; the 4th edition is accompanied by Python
implementations of its algorithms instead [1]. So this folder has no
`install.sh` or `run.sh`, and `scripts/verify-all.sh` skips it (it runs only
folders that have a `run.sh`).

## Prerequisites
None: a text editor or a browser to read the file.

## Quick start
```sh
cat hello-world.txt
```

## Scripts explained
There are no scripts, because there is nothing to install, build or run.

## Folder structure
```text
clrs/
├── README.md         this file
└── hello-world.txt   the procedure (teaching comments on top)
```
The book has no file format; `.txt` says "plain text".

## Step-by-step walkthrough
```text
HELLO-WORLD()
1  print "Hello, World!"
```
1. **The procedure name** is in small caps, with hyphens between words.
   The package manual says its `\proc` command "typesets procedure names
   in small caps, and dashes (which occur frequently in our procedure
   names) are typeset as hyphens" [3]. Plain text has no small caps, so
   upper case is used here. The parentheses hold the parameters (none).
2. **Numbered lines** form the body. Each level of nesting is one more
   level of indentation: "Each tab stop gives one level of indentation",
   and the package's `\Do` and `\End` commands only increase and decrease
   that level [3]. There are no `begin`/`end` keywords or braces in the
   output, so the indentation alone shows the block, like Python.
3. **`print`** writes text. The book uses it, for example, in the
   KMP-MATCHER procedure: `print "Pattern occurs with shift" i - m` (as
   shown in the package manual for the 3rd edition) [3].
4. **Comments** start with `//` in the 3rd and 4th editions: "The \Comment
   command simply produces the comment symbol //" [3]. The 2nd edition's
   package drew a triangle (▷) instead [4].
5. **Assignment** (not needed here) is written with `=`. The 1st and 2nd
   editions used a left arrow; "Many readers told us that they preferred to
   use an equals sign for assignment", so the 3rd edition changed it [3].
   An equality test is written `==` [3].

Compare it with the [Portugol](../portugol/) and [PSeInt](../pseint/)
versions: those close blocks with keywords and can be run; CLRS is
shorter and closer to Python.

## Why this toolchain
There is no toolchain. The authors' LaTeX packages (`clrscode` for the 2nd
edition, `clrscode3e` for the 3rd [2], `clrscode4e` for the 4th [5]) are
the reference for how the notation looks, so they are the sources for the
walkthrough above.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| any | ✅ (nothing to run) | Plain text, readable anywhere. |

## Expected output
None is produced by a program. If a reader "executes" the procedure by
hand, it writes:
```text
Hello, World!
```

## Sources
1. Q&A: What makes a bestselling textbook? (Introduction to Algorithms). MIT News, 2022-02-23. <https://news.mit.edu/2022/qa-what-makes-bestselling-textbook-introduction-algorithms-0223> (accessed 2026-11-02)
2. Cormen, T. H. `clrscode`: LaTeX packages for CLRS pseudocode. Dartmouth College. <https://www.cs.dartmouth.edu/~thc/clrscode/> (accessed 2026-11-02)
3. Cormen, T. H. Using the clrscode3e Package in LaTeX 2e (manual). Dartmouth College. <https://www.cs.dartmouth.edu/~thc/clrscode/clrscode3e.pdf> (accessed 2026-11-02)
4. clrscode.sty (package for the 2nd edition). Dartmouth College. <https://www.cs.dartmouth.edu/~thc/clrscode/clrscode.sty> (accessed 2026-11-02)
5. clrscode4e.sty (package for the 4th edition). MIT Press. <https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/11599/clrscode4e.sty> (accessed 2026-11-02)
