# Python

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** multi-paradigm. The official FAQ calls Python "an interpreted,
interactive, object-oriented programming language" that "supports multiple
programming paradigms beyond object-oriented programming, such as
procedural and functional programming" [1]. The Hello World programs here
use only the procedural (imperative) style: statements run top to bottom.

See also: [paradigms](../../docs/paradigms.md#every-language-and-its-paradigm)
(how this paradigm compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | CPython 3.14 | ✅ verified on macOS Intel |
| desktop | [desktop/](desktop/) | CPython 3.14 + tkinter (Tcl/Tk) | ✅ verified on macOS Intel |
| web | [web/](web/) | CPython 3.14 + Flask 3.1.3 | ✅ verified on macOS Intel |

## History
Guido van Rossum started Python at CWI in the Netherlands. The official
FAQ gives his account [1]:

- He "had extensive experience with implementing an interpreted language in
  the ABC group at CWI". ABC is "the origin of many Python features,
  including the use of indentation for statement grouping".
- He worked in the Amoeba distributed operating system group, which
  "needed a better way to do system administration than by writing either C
  programs or Bourne shell scripts".
- "During the 1989 Christmas holidays, I had a lot of time on my hand, so I
  decided to give it a try." In February 1991 he posted it to USENET.
- The exception syntax came from Modula-3 [1].

The name comes from the BBC comedy series "Monty Python's Flying Circus",
whose scripts van Rossum was reading at the time [1]. Python's official
history says it "was created in the early 1990s by Guido van Rossum at
Stichting Mathematisch Centrum (CWI ...) in the Netherlands as a successor
of a language called ABC" [2]. The Python Software Foundation (PSF), a
non-profit formed in 2001 [2], "holds the copyright on Python versions 2.1
and newer" [1].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| December 1989 | Implementation started | [3] |
| 1991-02-20 | Python 0.9.0 posted to the `alt.sources` USENET group | [3] |
| 1994-01-26 | Python 1.0.0 | [3] |
| 1995 | Development moves to CNRI in Reston, Virginia (USA) | [2] |
| May 2000 | The core team moves to BeOpen.com (BeOpen PythonLabs) | [2] |
| 2000-10-16 | Python 2.0 | [4] |
| 2001 | Python Software Foundation formed | [2] |
| 2008-12-03 | Python 3.0, "incompatible with the 2.x line of releases" | [5] |
| 2010-07-03 | Python 2.7 final | [6] |
| 2020-01-01 | Python 2 is sunset: "no longer supported" | [7] |
| 2025-10-07 | Python 3.14 (the version used in this repository) | [8] |
| 2026-10-09 | Python 3.15, the newest release on 2026-10-30 | [8] |

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** Python is #1 with a rating of 19.23% [9].
  TIOBE notes that the long-term historical data is temporarily
  unavailable after a change to include Chinese search terms [9].
- **Stack Overflow Developer Survey 2026:** 58.0% of all respondents to the
  programming languages question used Python (8,184 of 14,099) [10].
- **IEEE Spectrum Top Programming Languages 2025** (published 2025-09-23):
  Python has "the top spot" in the default "Spectrum" ranking [11].
- **GitHub Octoverse:** in 2024 "Python overtook JavaScript as the most
  popular language on GitHub" [12]. The 2026 report ranks languages by
  contributors: "TypeScript first, Python second, and JavaScript third"
  [13]. The two reports measure different things, so the rankings are not
  directly comparable.

## Importance then and now
- **Then (1990s):** the FAQ describes Python as a way to get "a scripting
  language with a syntax like ABC but with access to the Amoeba system
  calls", sitting between C programs and shell scripts [1]. The language
  was designed to be extensible, because ABC's "lack of extensibility was
  one of its biggest problems" [1].
- **Python 3 (2008):** a new version "incompatible with the 2.x line of
  releases" [5]. Python 2 was supported until 2020-01-01 [7], so both
  lines were maintained side by side for 11 years.
- **Now:** the survey and index figures above put Python at or near the top
  of every 2025–2026 ranking cited on this page [9][10][11][13]. GitHub links the
  2024 rise to "the surge in data science and machine learning" [12].
- **In teaching:** the official FAQ argues that "students may be better
  served by learning Python as their first language", because of its
  "very simple and consistent syntax and a large standard library" [1].
  This is the Python project's own view, not an independent study.

## Comparing the categories
| | [cli](cli/) | [desktop](desktop/) | [web](web/) |
|---|---|---|---|
| Lines of code (without comments) | 1 | 12 | 5 |
| What it uses | built-in `print()` | `tkinter` + `ttk` from the standard library | Flask from PyPI |
| Extra install | none | Tcl/Tk (`python-tk@3.14` / `python3-tk`), included in the python.org installers | Flask in a local `.venv/` (`requirements.txt`) |
| How it runs | top to bottom, then exits | `mainloop()` event loop until the window closes | `flask run` server loop until Ctrl+C |
| Output | text on stdout | a native window | an HTML page over HTTP on `localhost:8080` |
| `--verify` self-check | same as a normal run | prints the label text once the window is visible, closes after 2 s | starts the server, fetches `/` with curl, stops it |

The same idea runs through all three: the cli is a straight list of
statements, while the desktop and web versions hand control to a loop that
waits for events (a click or an HTTP request) and calls your code when one
arrives. None of them needs a build step, because Python is interpreted
(see [cli/README.md](cli/README.md#why-there-is-no-build-step)).

All three categories planned for Python are implemented, so this page has
no "why no <category>" section.

## Sources
1. General Python FAQ. Python Software Foundation. <https://docs.python.org/3/faq/general.html> (accessed 2026-10-30)
2. History and License. Python Software Foundation. <https://docs.python.org/3/license.html> (accessed 2026-10-30)
3. A Brief Timeline of Python. Guido van Rossum, The History of Python (blog), 2009. <https://python-history.blogspot.com/2009/01/brief-timeline-of-python.html> (accessed 2026-10-30)
4. Python 2.0. Python Software Foundation. <https://www.python.org/download/releases/2.0/> (accessed 2026-10-30)
5. Python 3.0 Release. Python Software Foundation. <https://www.python.org/download/releases/3.0/> (accessed 2026-10-30)
6. PEP 373: Python 2.7 Release Schedule. Python Software Foundation. <https://peps.python.org/pep-0373/> (accessed 2026-10-30)
7. Sunsetting Python 2. Python Software Foundation. <https://www.python.org/doc/sunset-python-2/> (accessed 2026-10-30)
8. Status of Python versions. Python Developer's Guide. <https://devguide.python.org/versions/> (accessed 2026-10-30)
9. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-10-30)
10. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-30)
11. Top Programming Languages 2025. IEEE Spectrum, 2025-09-23. <https://spectrum.ieee.org/top-programming-languages-2025> (accessed 2026-10-30)
12. Octoverse 2024. GitHub. <https://github.blog/news-insights/octoverse/octoverse-2024/> (accessed 2026-10-30)
13. Octoverse 2026. GitHub, 2026-10-28. <https://github.blog/news-insights/octoverse/octoverse-commits-pushes-reach-new-highs-in-2026-as-developers-build-with-agents/> (accessed 2026-10-30)
