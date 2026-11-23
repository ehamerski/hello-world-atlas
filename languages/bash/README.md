# Bash

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative [2]. A Bash program is a text file of shell commands
that Bash reads and runs one after another [2]. The manual calls Bash "the
shell, or command language interpreter, for the GNU operating system" [2].

See also: [paradigms](../../docs/paradigms.md#imperative)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | GNU Bash 5.3.20 (Homebrew formula `bash`), interpreted: no build step | ✅ |

## History

The Bourne shell came first. Stephen Bourne described it in "The UNIX Shell",
published in the Bell System Technical Journal in July-August 1978 [1]. The
Bash manual names Bourne as the author of the direct ancestor of the current
Unix shell `sh`, which appeared in the Seventh Edition Bell Labs Research
version of Unix [2]. Chet Ramey, the current Bash maintainer, writes that Bash
has been influenced by many sources, dating back to that original shell [3].

Bash was written for the GNU Project. Its original author was Brian Fox, an
employee of the Free Software Foundation [3][4]. Fox announced a beta release
on the `gnu.announce` newsgroup in June 1989 [5]. The name is an acronym for
"Bourne-Again SHell", a pun on Stephen Bourne [2]. Bash "is largely compatible
with sh and incorporates useful features from the Korn shell ksh and the C
shell csh" [2].

The standard that Bash follows is POSIX. The Bash manual says Bash is intended
to be a conformant implementation of the IEEE POSIX Shell and Tools portion of
the standard [2]. The Open Group explains that the shell and utilities part,
POSIX 1003.2, was later merged into the core POSIX standard [6], where the
shell command language is described today (IEEE Std 1003.1-2024) [7]. Ramey
calls the POSIX standard the most significant influence on Bash, one that
dictates a significant portion of its behavior [3].

Bash is maintained by Chet Ramey [8]. Ramey is a volunteer who works at Case
Western Reserve University [3]. Bash 5.3 was announced on the `bug-bash`
mailing list on 2025-07-05 [9]. The Homebrew formula `bash` packages
version 5.3.20 under the license GPL-3.0-or-later [10]. The GNU Project page
says Bash is free software under the GNU General Public License, version 3 or
later [8]. This repository uses Bash 5.3.20 from Homebrew. The program
itself also runs under the older Bash 3.2.57 that is in `/bin/bash` on the
development Mac (checked by running it, 2026-11-12).

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 1978 | Stephen Bourne describes the Unix shell in the Bell System Technical Journal | [1] |
| 1989 | Brian Fox announces the Bash beta release on `gnu.announce` (the archived post is stamped 7 June 1989) | [5] |
| 1992 | POSIX shell and utilities standard, IEEE 1003.2-1992 (later merged into IEEE 1003.1) | [6] |
| 2025-07-05 | Bash 5.3 announced by Chet Ramey | [9] |

## Market usage today

- Stack Overflow Developer Survey 2026: 51.3% of all respondents (7,231 of
  14,099) named Bash/Shell among the programming, scripting, and markup languages they had
  done extensive development work in over the past year [11]. The survey groups
  all shells under one label, so the figure is not for Bash alone.
- TIOBE Index, November 2026: Bash is listed among "The Next 50 Programming
  Languages" (positions 51 to 100). The page gives no rank or rating for
  entries in that group [12].

## Importance then and now

When it appeared, Bash was the shell of the GNU operating system and was largely compatible with `sh` [2], so existing `sh` scripts could be run by it. Today it is one of the shells in the Stack Overflow survey figure above [11]. On
macOS, Apple documents zsh as the default login and interactive shell since
macOS 10.15 and lists bash as the default in macOS 10.14 and earlier [13]; both
remain valid shell paths there, including `/bin/bash` [13].

## Comparing the categories

Only the `cli` category is implemented. Bash is interpreted: the `bash`
program reads a script file and runs its commands [2], so the folder has no
`build.sh`. A script can run as `bash hello.sh`, or directly if its execute
bit is set, in which case Bash starts a new instance of itself to run it [2].

## Why there is no desktop version

Bash is a command interpreter and has no graphical toolkit in its manual: the
Bash Reference Manual covers shell syntax, builtins, variables, and startup
files [2]. A desktop program needs an add-on tool, which this repository does
not add for Bash.

## Why there is no web version

The Bash manual describes no web server or HTTP library [2]. A web program
needs an add-on tool, which this repository does not add for Bash.

## Sources

<!-- vale off -->


1. The UNIX Shell. S. R. Bourne, Bell System Technical Journal 57(6), July-August 1978. Internet Archive. <https://archive.org/details/bstj57-6-1971> (accessed 2026-11-12)
2. Bash Reference Manual: 1.1 What is Bash?, 3.1 Shell Syntax, 3.8 Shell Scripts. GNU Project. <https://www.gnu.org/software/bash/manual/bash.html> (accessed 2026-11-12; archived copy: <https://web.archive.org/web/20261117122406/https://www.gnu.org/software/bash/manual/bash.html>, accessed 2026-11-22)
3. The Bourne-Again Shell. Chet Ramey, in The Architecture of Open Source Applications, Volume 1. <https://aosabook.org/en/v1/bash.html> (accessed 2026-11-12)
4. Bash FAQ, A1. Chet Ramey, Case Western Reserve University. <https://tiswww.case.edu/php/chet/bash/FAQ> (accessed 2026-11-12)
5. Bash is in beta release! Brian Fox, forwarded by Leonard H. Tower Jr., `gnu.announce`, June 1989. Google Groups archive. <https://groups.google.com/group/gnu.announce/msg/a509f48ffb298c35?hl=en> (accessed 2026-11-12)
6. POSIX FAQ, questions 8-10. The Open Group. <https://www.opengroup.org/austin/papers/posix_faq.html> (accessed 2026-11-12)
7. The Open Group Base Specifications Issue 8, IEEE Std 1003.1-2024, Shell Command Language. The IEEE and The Open Group. <https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html> (accessed 2026-11-12)
8. Bash home page. GNU Project. <https://www.gnu.org/software/bash/> (accessed 2026-11-12; archived copy: <https://web.archive.org/web/20261104064618/http://www.gnu.org/software/bash/>, accessed 2026-11-22)
9. Bash-5.3-release available. Chet Ramey, `bug-bash` mailing list, 2025-07-05. <https://lists.gnu.org/archive/html/bug-bash/2025-07/msg00005.html> (accessed 2026-11-12)
10. Homebrew formula `bash` (version 5.3.20, license GPL-3.0-or-later). Homebrew. <https://formulae.brew.sh/formula/bash> (accessed 2026-11-12)
11. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
12. TIOBE Index for November 2026. TIOBE Software BV. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-12)
13. Change the default shell in Terminal on Mac / Use zsh as the default shell on your Mac. Apple Support. <https://support.apple.com/en-us/102360> (accessed 2026-11-12)

<!-- vale on -->
