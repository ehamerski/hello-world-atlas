# Elixir

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** functional and concurrent, dynamically typed. The Elixir
team describes Elixir as "a dynamic, functional language designed for
building scalable and maintainable applications" [1]. It runs on the
Erlang virtual machine, and its program units are processes, not objects
or threads.

See also: [paradigms](../../docs/paradigms.md#functional) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

What these words mean here:

- **Functional:** a program is built from functions that take values and
  return new values. Elixir data is immutable: a function never changes
  its argument. The [web](web/) version shows it: the pipe operator `|>`
  passes a connection through one function after another, and each
  function returns a new connection.
- **Dynamically typed:** the type of a value is checked when the program
  runs, not before. The announcement of version 1.0 uses the word
  "dynamic" for the language [1].
- **Concurrent:** the Elixir guide says that "Processes are isolated from
  each other, run concurrent to one another and communicate via message
  passing" [2]. These processes belong to the Erlang virtual machine:
  "Elixir's processes should not be confused with operating system
  processes", and they are "extremely lightweight in terms of memory and
  CPU" [2]. A web server is a tree of such processes.

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Elixir (`elixir hello.exs`) | ✅ |
| desktop | – | not implemented, see [Why there is no desktop version](#why-there-is-no-desktop-version) | – |
| web | [web/](web/) | Mix project, Plug and Bandit from Hex | ✅ |

## History
José Valim created Elixir. The Elixir team's page says: "José Valim
created Elixir in 2012 as a Research and Development project inside
Plataformatec" [3]. Plataformatec was Valim's company: he writes "I have
pitched Elixir to my company, Plataformatec" [4]. The history of the code starts earlier. The announcement of
version 1.0 counts "8005 commits by 189 contributors, including the
initial commit on January 9th, 2011" [1].

Valim describes the beginning in the announcement of version 0.5.0
(2012-05-25). An early version of Elixir "attempted to be a considerable
departure from Erlang", which was a bad design decision: to use any
Erlang module, Elixir would first need a wrapper for it. After that
version, he took a break "to study old, new and emerging languages". The
challenge was "to not re-invent Erlang as a language, but how to provide
the productivity and flexibility I expect from Elixir while staying a
100% compatible with Erlang". The foundation of the current version came
"around October 2011, during a short stay in San Francisco", with the
help of Yehuda Katz. Valim then pitched Elixir to Plataformatec, which
"accepted to sponsor Elixir" [4].

Version 0.5.0 was "the first release since the language was rewritten"
[4]. Version 0.6.0 (2012-08-01) added "a build tool called Mix" [5]. The
announcement of version 1.0 (2014-09-18) says: "We are glad to announce
Elixir v1.0 is finally out", and that the release "is the consolidation of
all the work done through the years" [1]. It also says: "Elixir leverages
the Erlang VM, known for running low-latency, distributed and
fault-tolerant systems", and "the whole Erlang ecosystem is also
available to Elixir developers" [1]. The Elixir team's page says that
Elixir v1.0 was released in September 2014, and that a new minor version
is released "every 6 months, around June and December of every year" [3].

**Where the ideas come from.** In an interview, Valim names the sources:
"The three main ones were Ruby, Erlang, and Clojure." From Erlang, Elixir
"inherited the whole infrastructure". "With Clojure, there are a bunch of
similar ways we approach problems, like protocols." And "Ruby reflects on
the syntax, the standard libraries, and how we name things" [6].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 2011-01-09 | Initial commit of Elixir | [1] |
| 2011-10 | The foundation of the current version is conceived (around this month) | [4] |
| 2012 | Valim creates Elixir as a research and development project inside Plataformatec | [3] |
| 2012-05-25 | Version 0.5.0, the first release since the language was rewritten | [4] |
| 2012-08-01 | Version 0.6.0 includes the build tool Mix | [5] |
| 2014-09-18 | Version 1.0 | [1] |
| 2025-10-16 | Version 1.19.0 | [7] |
| 2026-06-03 | Version 1.20.0 | [7] |
| 2026-10-29 | Version 1.20.5, the one used in this repository | [7] |

## Market usage today
Every number below has its date and source. They change every year.

- **Stack Overflow Developer Survey 2026:** 2.6% of all respondents to the
  programming languages question used Elixir (367 of 14,099) [8]. In the
  same survey, 4.7% of respondents want to work with it ("Desired"), and
  62.1% of those who used it want to keep using it ("Admired") [8].
- **TIOBE Index, October 2026:** Elixir is not in the top 50. The index
  lists it only by name among the languages "#51 to #100", without a rank
  or a rating [9].

The numbers measure different things. The Stack Overflow survey counts the
developers who answered it, and TIOBE counts search-engine results. Elixir
has a small share in both. In the survey, 62.1% of those who used it
want to keep using it, while 4.7% of all respondents want to work with it [8].

## Importance then and now
- **Then (2011–2014):** Elixir offered the Erlang virtual machine with a new
  syntax and tools. The design goal was compatibility: "staying a 100%
  compatible with Erlang" [4]. The result is that Elixir calls Erlang
  libraries directly. The Elixir guide says that "Elixir provides excellent
  interoperability with Erlang libraries" [10].
- **Now:** the Elixir site says that "Thanks to the Erlang VM, Elixir also
  excels at IoT, distributed systems, and everything Erlang is renowned
  for" [11]. A new minor version still appears about every six months [3] (version
  1.20.0 on 2026-06-03 [7]), and version 1.20 needs Erlang/OTP 27 or later [12].
- **In teaching:** Elixir is this repository's example of a functional
  language with the process model of Erlang. Its [web](web/) version
  shows how a server is described as a tree of supervised processes. It
  shares the virtual machine with the [Erlang](../erlang/) version of the
  same program.

## Comparing the categories
| | [cli](cli/) | [web](web/) |
|---|---|---|
| Project file | none: one `hello.exs` script | a Mix project: `mix.exs` and `mix.lock`; "Mix is a build tool that ships with Elixir" [13] |
| Source files | `.exs`: "meant for scripting" [14] | `.ex` files: "meant to be compiled" [14] |
| Libraries | only the standard library (`IO.puts`) | Plug and Bandit from Hex, the package repository of the Erlang and Elixir community |
| Run with | `elixir hello.exs` | `mix run --no-halt` |
| Build | none: the script is "compiled and loaded into memory, but no `.beam` file was written to disk" [14] | `mix compile` writes `.beam` files into `_build/` [13] |
| Downloads | none | Plug, Bandit and their dependencies, pinned in `mix.lock` |
| Entry point | the file runs from top to bottom | `HelloWeb.Application.start/2`, named in `mix.exs`, starts a supervisor that starts the web server |
| Output | `Hello, World!` on stdout | `<p>Hello, World!</p>` in the response to `GET /`, on `PORT` (default 8080) |

What stays the same: both programs run on the BEAM, the Erlang virtual
machine, and both are plain Elixir. The web version only adds a project
file, two libraries and a supervision tree.

## Why there is no desktop version
This repository has no desktop version of Elixir, for this reason: Elixir
has no desktop GUI toolkit of its own in its standard library. The `lib/`
folder of the Elixir repository holds six applications (`eex`, `elixir`,
`ex_unit`, `iex`, `logger`, and `mix`), and a GUI toolkit is not among
them [15]. A desktop program written in Elixir would
call Erlang's `wx` application through interoperability. Elixir calls an
Erlang module by writing its name as an atom, as in `:binary.first("hello")`
[10]. The Erlang documentation describes `wx` as "an erlang binding of
wxWidgets" [16].

That is the same toolkit that the [Erlang desktop](../erlang/desktop/)
version shows, with the same calls, in Erlang syntax. An Elixir version
would show the same window through a different syntax, so it is left out
here. The Elixir guide discourages merely wrapping Erlang libraries and
recommends calling Erlang code directly [10].

## Sources
1. Elixir v1.0 released. José Valim, elixir-lang.org, 2014-09-18. <https://elixir-lang.org/blog/2014/09/18/elixir-v1-0-0-released/> (accessed 2026-11-04)
2. Processes (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/processes.html> (accessed 2026-11-04)
3. Development & team. The Elixir team, elixir-lang.org. <https://elixir-lang.org/development/> (accessed 2026-11-04)
4. Elixir v0.5.0 released. José Valim, elixir-lang.org, 2012-05-25. <https://elixir-lang.org/blog/2012/05/25/elixir-v0-5-0-released/> (accessed 2026-11-04)
5. Elixir v0.6.0 released. José Valim, elixir-lang.org, 2012-08-01. <https://elixir-lang.org/blog/2012/08/01/elixir-v0-6-0-released/> (accessed 2026-11-04)
6. Elixir is great for everything that runs on top of a socket: José Valim, creator of Elixir (interview by Evrone). HackerNoon, 2020-10-20. <https://hackernoon.com/elixir-is-great-for-everything-that-runs-on-top-of-a-socket-jose-valim-creator-of-elixir-4m2l3zhb> (accessed 2026-11-04)
7. Releases. elixir-lang/elixir, GitHub. <https://github.com/elixir-lang/elixir/releases> (accessed 2026-11-04)
8. 2026 Stack Overflow Developer Survey: Technology (data; languages, admired and desired). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-11-04)
9. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-04)
10. Erlang libraries (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/erlang-libraries.html> (accessed 2026-11-04)
11. Elixir (home page). The Elixir team, elixir-lang.org. <https://elixir-lang.org/> (accessed 2026-11-04)
12. Install Elixir. The Elixir team, elixir-lang.org. <https://elixir-lang.org/install/> (accessed 2026-11-04)
13. Introduction to Mix (Mix and OTP). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/introduction-to-mix.html> (accessed 2026-11-04)
14. Modules and functions (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/1.18.1/modules-and-functions.html> (accessed 2026-11-04)
15. `lib/` folder of elixir-lang/elixir. GitHub. <https://github.com/elixir-lang/elixir/tree/main/lib> (accessed 2026-11-04)
16. wx (Erlang/OTP documentation). Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/wx/chapter.html> (accessed 2026-11-04)
