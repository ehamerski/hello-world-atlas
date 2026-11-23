# QCL (Quantum Computation Language)

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative (a classical control language with procedures), with
quantum operations added to it [1].

See also: [paradigms](../../docs/paradigms.md#imperative)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | QCL 0.6.7 interpreter and simulator, built from source (GNU readline) | ✅ |

## History

QCL is a quantum programming language and simulator by Bernhard Oemer. His page
describes it as a high level, architecture independent programming language for quantum
computers, with a syntax derived from classical procedural languages like C or Pascal [4].
His master thesis in theoretical physics, "A Procedural Formalism for Quantum Computing",
describes the language; its title page is dated 23 July 1998 [4][5]. A second
master thesis, in computing science, "Quantum Programming in QCL", is dated 20 January
2000 [6]. The author's page lists `qcl-0.3` as the first public release and gives it no
date [4]. Release 0.5.0 added conditional operators, quantum conditions and the quantum
if-statement (marked experimental) [4], which the QS2002 paper "Classical Concepts in
Quantum Programming" describes; its print version appeared in the International Journal of
Theoretical Physics 44/7, pp. 943-955, in 2005 [4]. The author's PhD thesis, "Structured
Quantum Programming", has a first version dated 26 May 2003 and a last revision dated
2 September 2009 on its title page [7]; the author's page gives its latest revision as
9 January 2009 [4]. The archive that this folder builds is named
0.6.7; its README still says version 0.6.4, and the interpreter prints 0.6.4 [1].

The archive includes a library of example programs (for example `deutsch.qcl`,
`grover.qcl` and `dft.qcl`) that show quantum algorithms in QCL [1]. QCL runs on a
classical computer and simulates the quantum behavior [1].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 1998 | Master thesis "A Procedural Formalism for Quantum Computing" (title page dated 23 July 1998) | [5] |
| 2000 | Master thesis "Quantum Programming in QCL" (title page dated 20 January 2000) | [6] |
| 2003 | First version of the PhD thesis "Structured Quantum Programming" (26 May 2003) | [7] |
| 2005 | Paper "Classical Concepts in Quantum Programming" in the International Journal of Theoretical Physics 44/7, pp. 943-955; it covers conditional operators, quantum conditions and quantum if-statements, which QCL 0.5.0 lists as new | [4] |
| 2009 | Last revision of the PhD thesis (2 September 2009 on the title page; 9 January 2009 on the author's page) | [4][7] |
| 2022 | QCL 0.6.7 released (2022-12-22); the version the author's page lists as current on 2026-11-20 | [4] |

## Market usage today

No current usage survey lists QCL, so this page gives no usage figure. For
today's tools, Qiskit (IBM, open source under Apache-2.0) and Q# (Microsoft) are
among the quantum programming systems in use [2][3].

## Importance then and now

QCL writes quantum algorithms with the classical procedures of a C-like language, and
its archive shows them as runnable examples [1]. Today's quantum programming tools
include Qiskit and Q# [2][3].

## Comparing the categories

Only the `cli` category is implemented. QCL is an interpreter: `hello.qcl` is read and
run by the `qcl` program, which prints the line. See [cli/README.md](cli/README.md).

## Why there is no desktop version

No desktop version is implemented. QCL is a text interpreter, and this repository does
not add a GUI for it.

## Why there is no web version

No web version is implemented. QCL is a text interpreter, and this repository does not
add a web server for it.

## Sources
1. QCL source archive, `qcl-0.6.7.tgz` (README, `qcl.cc` copyright line, `lib/*.qcl` examples). Bernhard Oemer. <https://tph.itp.tuwien.ac.at/~oemer/tgz/qcl-0.6.7.tgz> (accessed 2026-11-10)
2. Qiskit documentation (IBM) and the Qiskit repository (Apache-2.0). IBM and the Qiskit project. <https://quantum.cloud.ibm.com/docs/en/guides/tools-intro> and <https://github.com/Qiskit/qiskit> (accessed 2026-11-10)
3. Q# overview (Introduction to the quantum programming language Q#). Microsoft Learn. <https://learn.microsoft.com/azure/quantum/qsharp-overview> (accessed 2026-11-10)
4. QCL - A Programming Language for Quantum Computers (current version 0.6.7, Dec 22 2022). Bernhard Oemer. <https://tph.itp.tuwien.ac.at/~oemer/qcl.html> (accessed 2026-11-20)
5. A Procedural Formalism for Quantum Computing (master thesis, PDF). Bernhard Oemer. <https://tph.itp.tuwien.ac.at/~oemer/doc/qcldoc.pdf> (accessed 2026-11-20)
6. Quantum Programming in QCL (master thesis, PDF). Bernhard Oemer. <https://tph.itp.tuwien.ac.at/~oemer/doc/quprog.pdf> (accessed 2026-11-20)
7. Structured Quantum Programming (PhD thesis, PDF). Bernhard Oemer. <https://tph.itp.tuwien.ac.at/~oemer/doc/structquprog.pdf> (accessed 2026-11-20)
