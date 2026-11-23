# Perl

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** multi-paradigm. The perl.org page about Perl says it
"Supports object-oriented, procedural and functional programming" [1]. The
Hello World programs here use only the procedural (imperative) style:
statements run top to bottom.

See also: [paradigms](../../docs/paradigms.md#every-language-and-its-paradigm)
(how this paradigm compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | perl 5 | ✅ |
| desktop | [desktop/](desktop/) | Tkx (Tcl/Tk) | 🔶 |
| web | [web/](web/) | Mojolicious::Lite | ✅ |

The desktop folder is a **compromise**: it uses Tkx, which drives the
system Tcl/Tk, and not Perl/Tk, the better-known binding. The reason is
that Perl/Tk needs an X11 server on macOS, and the development machine has
none. See [desktop/README.md](desktop/README.md#why-this-toolchain) for the
full explanation.

## History
The Perl FAQ describes Perl as "a high-level programming language with an
eclectic heritage written by Larry Wall and a cast of thousands" [2]. It
adds that Perl "derives from the ubiquitous C programming language" and, to a
lesser extent, from other tools and languages [2]. The perlhist records,
which list every release with the person who made it, show Larry Wall as the
author of Perl 1 to Perl 5.000 [3].

The FAQ states how to write the name: "Perl" is the language, `perl` is the
interpreter. The name is not written in capitals, because "perl is not an
acronym" [2].
A guiding motto of Perl development is "there's more than one way
to do it" [2].

Perl 5 is the line used in this repository. The language Raku "(formerly
known as Perl 6) was originally described as the community's rewrite of
Perl" and is a separate language today [2]. A Raku version is not part of
this page.

## Milestones
Dates come from the perlhist release table [3]. The first column of that
table gives the release; the date is the release date.

| Date | Milestone | Source |
|---|---|---|
| 1987-12-18 | Perl 1.000, by Larry Wall | [3] |
| 1988-06-05 | Perl 2.000 | [3] |
| 1989-10-18 | Perl 3.000 | [3] |
| 1991-03-21 | Perl 4.000 | [3] |
| 1994-10-17 | Perl 5.000 | [3] |
| 2002-07-18 | Perl 5.8.0 | [3] |
| 2007-12-18 | Perl 5.10.0 | [3] |
| 2022-05-27 | Perl 5.36.0 | [3] |
| 2026-07-15 | Perl 5.44.0, the latest stable release listed on 2026-11-04 | [3] |

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** Perl is #17 with a rating of 0.88% [4].
- **Stack Overflow Developer Survey 2026:** 3.8% of the respondents to the
  programming, scripting, and markup languages question used Perl (538 of
  14,099) [5].
- **perl.org, 2026:** the page about Perl speaks of "over 38 years of
  development" and says it is "Used for mission critical projects in the
  public and private sectors" [1]. This is the project's own description,
  not an independent measure.

## Importance then and now
- **Then:** the first release is from 1987 [3]. Since the 5.000 release in
  1994 [3], the FAQ says the project has "averaged about one production
  release per year" [2]. The FAQ lists prototyping, system utilities, text
  processing, and web work as typical uses [2].
- **Now:** Perl is still maintained: Perl 5.44.0 is dated 2026-07-15 [3].
  The 2026 index and survey figures above put it in the top 20 of the
  TIOBE Index [4] and at 3.8% of the respondents of the 2026 Stack Overflow
  survey [5].

## Comparing the categories
| | [cli](cli/) | [desktop](desktop/) | [web](web/) |
|---|---|---|---|
| Lines of code (without comments) | 3 | 15 | 6 |
| What it uses | built-in `print` | Tkx, a Perl interface to Tk | Mojolicious::Lite from CPAN |
| Extra install | none | Tcl/Tk (Homebrew `tcl-tk`), a C compiler, and Tcl.pm plus Tkx from CPAN in `local/` | Mojolicious from CPAN in `local/` |
| How it runs | top to bottom, then exits | `Tkx::MainLoop()` event loop until the window closes | `perl app.pl daemon` server loop until Ctrl+C |
| Output | text on stdout | a native window | an HTML page over HTTP on `localhost:8080` |
| `--verify` self-check | same as a normal run | prints the label text once the window is shown, closes after 2 s | starts the server, fetches `/` with curl, stops it |

The cli program is a straight list of statements. The desktop and web
versions hand control to a loop that waits for events (a window event or an
HTTP request) and calls your code when one arrives. None of them needs a
build step, because Perl is interpreted (see
[cli/README.md](cli/README.md#why-there-is-no-build-step)). The one
difference in effort is the desktop folder, which compiles Tcl.pm during
`install.sh`; that is part of its compromise.

All three categories planned for Perl are implemented, so this page has no
"why no <category>" section.

## Sources
1. About Perl. perl.org. <https://www.perl.org/about.html> (accessed 2026-11-04)
2. perlfaq1: General Questions About Perl. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/perlfaq1> (accessed 2026-11-04)
3. perlhist: the Perl history records. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/perlhist> (accessed 2026-11-04)
4. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-04)
5. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-11-04)
