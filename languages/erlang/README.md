# Erlang

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** functional and concurrent, dynamically typed. The Erlang
website describes Erlang as "a programming language used to build
massively scalable soft real-time systems" "with requirements on high
availability", and says that its "runtime system has built-in support for
concurrency, distribution and fault tolerance" [1]. Its program units are
processes: lightweight, and part of the language, not of the operating
system [2].

See also: [paradigms](../../docs/paradigms.md#functional) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

What these words mean here:

- **Functional:** a program is built from functions, and a variable "can
  only be bound once" [3]. Armstrong writes that Erlang's design ended with
  "removing virtually all traces of Prolog from the language and adding many
  well-known features from functional languages", such as higher-order
  functions and list comprehensions [2]. A function repeats by calling
  itself: the [desktop](desktop/) version has no `while` loop, only a
  function, `loop/1`, that calls itself.
- **Dynamically typed:** the type of a value is checked when the program
  runs. Armstrong writes that Erlang "has always had a dynamic type
  system" [2].
- **Concurrent:** "In Erlang, each thread of execution is called a
  process", and processes "share no data" [4]. Armstrong's abstract says
  that they "have no shared memory and communicate by asynchronous message
  passing" [2]. A message goes to the input queue of a process, and the
  `receive` expression takes the first one that matches a pattern [3][4].
  The [desktop](desktop/) version is one such loop. A web server is a group
  of such processes.

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Erlang/OTP (`escript hello.erl`) | ✅ |
| desktop | [desktop/](desktop/) | Erlang/OTP, `wx` (`wxWidgets`) | ✅ |
| web | [web/](web/) | Erlang/OTP, `httpd` from `inets` | ✅ |

## History
Joe Armstrong, Robert Virding, and Mike Williams created Erlang at the
Ericsson Computer Science Laboratory. Armstrong's paper "A History of
Erlang" (HOPL III, 2007) says: "The initial development of Erlang took
place in 1986 at the Ericsson Computer Science Laboratory (the Lab)." The
objective was "to provide a better way of programming telephony
applications" [2]. Telephony applications "are by their nature highly
concurrent", with software that is "expected to be highly fault-tolerant",
and that has to be changed "on the fly", "without loss of service" [2].

**From Prolog to its own language.** Armstrong started with a meta-interpreter
in Prolog, to which he added parallel processes. He writes: "What started
as an experiment in 'adding concurrency to Prolog' became more of a
language in its own right and this language acquired a name 'Erlang,' which
was probably coined by Bjarne Däcker." Some said that the name meant
"Ericsson Language", while others said that it honored Agner Krarup Erlang
(1878–1929), and the team "deliberately encouraged this ambiguity" [2].
Robert Virding then wrote a second implementation, also in Prolog, and the
two took turns rewriting each other's code [2]. By 1987, "Erlang was
regarded as a new programming language that we had prototyped in Prolog"
[2].

**A virtual machine.** The Prolog interpreters were slow. In early 1990,
Armstrong understood the abstract machines of parallel logic languages
well enough to design the JAM virtual machine. Mike Williams wrote its
emulator in C, which "ran 70 times faster than the original Prolog
emulator" [2]. In 1990, "the language acquired its own syntax" because the
team had to write its own parser, and "the Erlang implementor group had
expanded to three, Mike, Robert and myself" [2]. In 1993, "the Turbo Erlang system
started working", created by Bogumil (Bogdan) Hausman. Its name was changed
to BEAM, and "BEAM programs compiled to C ran about ten times faster than
JAM interpreted programs" [2].

**Open source.** At the start of the AXD project, plans were made to build
a product unit, called OTP, to support the Erlang system. "OTP stands for the
'Open Telecom Platform' and is both the name of the Erlang software
distribution and the name of an Ericsson product unit". Since 1997, the
OTP unit has been responsible for the distribution of Erlang [2]. In 1998,
Erlang was banned inside Ericsson Radio AB for new product development. The
paper calls this "the second most significant event in the history of
Erlang: It led indirectly to Open Source Erlang and was the main reason why
Erlang started spreading outside Ericsson." It adds: "On 2 December 1998,
Open Source Erlang was announced" [2]. Most of the original team then left
Ericsson and formed a company, Bluetail AB [2]. Today, the Erlang/OTP
documentation carries the copyright notice "Copyright © 1996-2026 Ericsson
AB" [5], and OTP 29.1.2 was published on 2026-10-14 [6].

**Where the ideas come from.** Armstrong writes that "The early syntax of
Erlang came straight from Prolog", and that "The only remaining signs of
the Prolog heritage lie in the syntax for atoms and variables, the scoping
rules for variables and the dynamic type system" [2]. Armstrong lists the
languages with processes that the team knew when Erlang was first
implemented: "Ada (with tasks), EriPascal (an
Ericsson dialect of Pascal with concurrent processes), Chill (with
processes), PLEX (with its own special form of processes implemented in
hardware) and Euclid" [2].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1986 | Initial development of Erlang at the Ericsson Computer Science Laboratory | [2] |
| 1987 | Erlang is regarded as a new language, prototyped in Prolog, and is ready for external users | [2] |
| 1990 | The language gets its own syntax; the JAM virtual machine runs 70 times faster than the Prolog emulator | [2] |
| 1990 (middle) | Ericsson delivers a copy of Erlang to Bellcore, its first external user | [2] |
| 1993 | The Turbo Erlang system starts working; its name is changed to BEAM | [2] |
| 1997 | The OTP unit is formed as a new product unit and becomes responsible for the distribution of Erlang | [2] |
| 1998-02 | Erlang is banned inside Ericsson Radio Systems | [2] |
| 1998-03 | The AXD301 is announced, "possibly the largest ever program in a functional language" | [2] |
| 1998-12-02 | Open Source Erlang is announced | [2] |
| 2026-10-14 | OTP 29.1.2, the version used in this repository | [6] |

## Market usage today
Every number below has its date and source. They change every year.

- **Stack Overflow Developer Survey 2026:** 1.5% of all respondents to the
  programming languages question used Erlang (218 of 14,099) [7]. In the
  same survey, 2.8% of respondents want to work with it ("Desired"), and
  49.1% of those who used it want to keep using it ("Admired") [7].
- **TIOBE Index, October 2026:** Erlang is not in the top 50. The index
  lists it only by name among the languages "#51 to #100", without a rank
  or a rating [8].

The numbers measure different things. The Stack Overflow survey counts the
developers who answered it, and TIOBE counts search-engine results. Erlang
has a small share in both. In the survey, 49.1% of those who used it want
to keep using it, while 2.8% of all respondents want to work with it [7].

## Importance then and now
- **Then (1986–1998):** Erlang solved a specific problem: telephone
  switches that must handle "tens or hundreds of thousands of simultaneous
  transactions" and that cannot stop for code upgrades [2]. The AXD301,
  announced in 1998, "has 2.6 millions lines of Erlang code" at the time of
  the paper (2007), and Armstrong says that it "is also highly reliable
  and runs in realtime" [2].
- **Now:** the Erlang website describes the language as one used "to build
  massively scalable soft real-time systems" [1]. Releases continue: OTP
  29.1.2 was published on 2026-10-14 [6]. Erlang is also the base of other
  languages: [Elixir](../elixir/) runs on the Erlang virtual machine, and
  its team says that "the whole Erlang ecosystem is also available to
  Elixir developers" [9].
- **In teaching:** Erlang is this repository's example of a language in
  which processes and messages are the basic building blocks. The
  [desktop](desktop/) version is a process that waits for a message, and
  the [web](web/) version starts a web server that ships with the
  distribution. The [Prolog](../prolog/) version of this program shows the
  language that Erlang started from.

## Comparing the categories
| | [cli](cli/) | [desktop](desktop/) | [web](web/) |
|---|---|---|---|
| Source | an escript: `hello.erl` | a module: `hello_wx.erl` | a module: `hello_httpd.erl` |
| Run with | `escript hello.erl` | `erl -noshell -pa ebin -s hello_wx main -s init stop` | `erl -noshell -pa ebin -s hello_httpd main` |
| Build | none: "By default, the script will be compiled by the Erlang compiler" in memory [10] | `erlc` writes `ebin/hello_wx.beam` | `erlc` writes `ebin/hello_httpd.beam` |
| Libraries | `io` from the standard library | `wx`, "an erlang binding of `wxWidgets`" [11] | `httpd` of the `inets` application [12] |
| Downloads | none | none: `wx` ships with Erlang/OTP | none: `inets` ships with Erlang/OTP |
| Entry point | `main/1`, called by `escript` | `hello_wx:main/0`, called with `-s` | `hello_httpd:main/0`, called with `-s`; `do/1` is called by `httpd` for each request |
| Output | `Hello, World!` on stdout | a label in a native window | `<p>Hello, World!</p>` in the response to `GET /`, on `PORT` (default 8080) |
| Ends | after the last expression | when the user closes the window | when you press Ctrl+C |

What stays the same: all three run on the BEAM, and all three use only
what Erlang/OTP includes. The desktop version adds a message loop, and the
web version adds a callback that a server calls.

## Sources
1. Erlang/OTP home page. Ericsson AB, erlang.org. <https://www.erlang.org/> (accessed 2026-11-04)
2. A History of Erlang. Joe Armstrong, HOPL III, ACM SIGPLAN, 2007 (DOI 10.1145/1238844.1238850). Author's copy. <https://lfe.io/papers/%5B2007%5D%20Armstrong%20-%20HOPL%20III%20A%20History%20of%20Erlang.pdf> (accessed 2026-11-04)
3. Expressions (variables, `receive`). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/expressions.html> (accessed 2026-11-04)
4. Conc prog (processes and message passing). Erlang/OTP documentation, Getting Started. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/conc_prog.html> (accessed 2026-11-04)
5. Getting started (page footer). Erlang/OTP documentation. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/getting_started.html> (accessed 2026-11-04)
6. Releases. erlang/otp, GitHub (release `OTP-29.1.2`). <https://github.com/erlang/otp/releases> (accessed 2026-11-04)
7. 2026 Stack Overflow Developer Survey: Technology (data; languages, admired and desired). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-11-04)
8. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-04)
9. Elixir v1.0 released. José Valim, elixir-lang.org, 2014-09-18. <https://elixir-lang.org/blog/2014/09/18/elixir-v1-0-0-released/> (accessed 2026-11-04)
10. escript. Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/escript_cmd.html> (accessed 2026-11-04)
11. wx (chapter). Erlang/OTP documentation. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/wx/chapter.html> (accessed 2026-11-04)
12. httpd. Erlang/OTP documentation, inets. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/inets/httpd.html> (accessed 2026-11-04)
