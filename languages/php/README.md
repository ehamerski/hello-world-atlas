# PHP

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative, with object-oriented support. php.net describes
PHP as "A popular general-purpose scripting language that is especially
suited to web development" [1]. It began as a procedural template language
for web pages. Classes arrived later: PHP 3.0 "included object-oriented
programming support", and PHP 5 brought "the Zend Engine 2.0 with a new
object model" [2]. Today the manual says "PHP includes a complete object
model" [3]. A Hello World needs none of that: no class, no `main` function.

See also: [paradigms](../../docs/paradigms.md#imperative) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | PHP 8.5 command-line interpreter (`php hello.php`) | ✅ verified on macOS Intel |
| desktop | – | not implemented, see [Why there is no desktop version](#why-there-is-no-desktop-version) | – |
| web | [web/](web/) | plain PHP on PHP's built-in web server (`php -S`) | ✅ verified on macOS Intel |

## History
"Created in 1994 by Rasmus Lerdorf, the very first incarnation of PHP was
a simple set of Common Gateway Interface (CGI) binaries written in the C
programming language" [2]. He announced it publicly on 1995-06-08 in the
Usenet group `comp.infosystems.www.authoring.cgi`: "Announcing the Personal
Home Page Tools (PHP Tools) version 1.0" [4].

For a short time Lerdorf dropped the PHP name and called the next version
"FI (short for "Forms Interpreter")"; the two names were later combined
as PHP/FI [2]. "It had Perl-like variables,
automatic interpretation of form variables, and HTML embedded syntax" [2].
That HTML-embedded syntax is still the core idea of PHP: compare the
[web](web/public/index.php) version, where the PHP code sits inside a `<p>`
tag.

PHP 3.0 was "announced by the new PHP Development Team as the official
successor to PHP/FI 2.0" in June 1998 [2]. With it, the name changed: "It
was renamed simply 'PHP', with the meaning becoming a recursive acronym -
PHP: Hypertext Preprocessor" [2]. Andi Gutmans and Zeev Suraski then rewrote
PHP's core as the "Zend Engine" ("comprised of their first names, Zeev and
Andi"), and PHP 4.0, based on it, "was officially released in May 2000" [2].

Two later versions changed the language most. PHP 7.0 (2015-12-03 [5])
"featured another major version of the core, Zend Engine 3.0, which
included significant performance improvements (up to twice as fast as PHP
5.6)" [2][6]. PHP 8.0 (2020-11-26 [5]) added "named arguments, union types,
attributes, constructor property promotion, match expressions, the
nullsafe operator (?->), a new optimizing JIT compiler" [2][7].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1994 | Rasmus Lerdorf writes the first PHP: CGI binaries in C | [2] |
| 1995-06-08 | Public announcement of "Personal Home Page Tools (PHP Tools) version 1.0" | [4] |
| 1998-06 | PHP 3.0: object-oriented support; the name becomes "PHP: Hypertext Preprocessor" | [2] |
| 2000-05 | PHP 4.0 on the new Zend Engine | [2] |
| 2004-07-13 | PHP 5.0: Zend Engine 2.0 "with a new object model" | [2][5] |
| 2012-03-01 | PHP 5.4.0 adds the built-in web server used by [web/](web/) | [5][8] |
| 2015-12-03 | PHP 7.0: Zend Engine 3.0, "up to twice as fast as PHP 5.6" | [2][5][6] |
| 2020-11-26 | PHP 8.0: JIT compiler, named arguments, union types, `match` | [2][5][7] |
| 2025-11-20 | PHP 8.5: "the URI extension, Pipe operator, and support for modifying properties while cloning"; the version used in this repository | [5][9] |

PHP branches have a fixed support schedule. PHP 8.5 has active support
until 2027-12-31 and security support until 2029-12-31; on 2026-10-31 the
supported branches were 8.2, 8.3, 8.4, and 8.5 [10].

## Market usage today
Every number below has its date and source. They change every year.

- **Websites (W3Techs, 2026-10-31):** "PHP is used by 69.2% of all the
  websites whose server-side programming language we know" [11]. It is
  first in W3Techs' ranking of server-side languages; JavaScript is second
  with 8.3% [12]. Of the sites that use PHP, 65.9% use version 8 [11].
  Part of this comes from WordPress, a PHP application, which W3Techs
  finds on 39.5% of all websites (2026-10-31) [13].
- **TIOBE Index, October 2026:** PHP is #12 with a rating of 1.26%. It was
  #14 in October 2025 [14].
- **Stack Overflow Developer Survey 2026:** 17.7% of all respondents to the
  programming languages question used PHP (2,490 of 14,099) [15]. In the
  web frameworks question, 7.6% used Laravel, a PHP framework (785 of
  10,281) [15].

The two kinds of numbers measure different things. W3Techs counts
websites, so one PHP application installed on millions of sites (such as
WordPress) counts many times. TIOBE counts search-engine results, and the
Stack Overflow survey counts developers who answered.

## Importance then and now
- **Then (1995–2004):** PHP lowered the effort needed to write dynamic web
  pages. A page was an
  HTML file with "HTML embedded syntax" for the dynamic parts [2], and the
  language "was deliberately designed to resemble C in structure, making it
  an easy adoption for developers familiar with C, Perl, and similar
  languages" [2].
- **Performance turn (2015):** PHP 7 was "up to twice as fast as PHP 5.6"
  [6], and PHP 8 added a JIT compiler [7].
- **Now:** PHP runs most of the websites whose server language W3Techs can
  detect (69.2%, 2026-10-31) [11], yet it is not among the 10 most used
  languages in the 2026 Stack Overflow survey (17.7% of respondents) [15].
  Much of today's PHP code is in applications and frameworks such as
  WordPress [13] and Laravel [15].
- **In teaching:** PHP shows the "template" model of the web, where code is
  embedded in the page, a model that the other languages in this
  repository do not have. Its CLI also shows that PHP is a general-purpose language, not only
  a web one [1].

## Comparing the categories
| | [`cli`](cli/) | [`web`](web/) |
|---|---|---|
| Lines of PHP/HTML (no comments, no blank lines) | 2 (`<?php` and `echo`) | 3 (`<?php`, `?>` and the `<p>` line) |
| Starts in | PHP mode (`<?php` on line 1) | PHP mode, then switches to HTML after `?>` |
| Started with | `php hello.php` | `php -S 127.0.0.1:8080 -t public` |
| Which code runs the main loop | none: the file runs once and the program exits | the built-in web server, which runs `index.php` once per request |
| Server code written by you | – | none: the server maps `/` to `public/index.php` |
| Output | text on stdout | HTML in the HTTP response (`text/html; charset=UTF-8`) |
| Extra dependencies | none | none (`curl` only for testing) |

What stays the same: both use the same `php` program and the same `echo`
statement. The web version does not need Composer, a framework, or a
separate web server. Compare [Python](../python/README.md), whose web
version needs Flask from PyPI, and [Go](../go/README.md), whose web version
writes the server in code with `net/http`.

## Why there is no desktop version
This repository has no desktop version of PHP: a
category is included only if a maintained, mainstream, and reasonably
simple toolchain exists for it. PHP has no such GUI toolchain:

- **PHP-GTK is unmaintained.** It is "an extension for the PHP programming
  language that implements language bindings for GTK+", and its website
  says: "The PHP-GTK project is no longer under active development, and
  the related mailing lists and other online services are no longer
  active" [16]. Its source repository "was archived by the owner on Dec 8,
  2021. It is now read-only" [17], and its README still says "PHP-GTK
  requires PHP 5.1.2 or greater" [17].
- **NativePHP is not plain PHP.** NativePHP for desktop "builds on top of
  the incredible affordances and ecosystem that Laravel provides", and
  "Before using NativePHP, you'll want to be familiar with building web
  applications using Laravel" [18]. Its requirements are "PHP 8.3+",
  "Laravel 11 or higher" and "Node 22+", and it runs the app on "the
  Electron runtime" [19]: "NativePHP ships a statically-compiled PHP binary
  inside your app, alongside an Electron shell" [20]. The window is drawn
  by Electron (Chromium), with a Laravel web app inside it. That is a
  Laravel project plus an Electron app, not a simple PHP Hello World, and
  the Electron part is already shown directly in
  [Node.js desktop](../node/desktop/).

So a "desktop" PHP Hello World would either depend on an unmaintained project or be
mostly Laravel and Electron. Neither shows PHP in "the most simple and
direct way", which is the goal of this repository
([Hello World in many languages](../../README.md)).

## Sources
1. PHP: Hypertext Preprocessor (home page). The PHP Group. <https://www.php.net/> (accessed 2026-10-31)
2. History of PHP. The PHP Group. <https://www.php.net/manual/en/history.php.php> (accessed 2026-10-31)
3. Classes and Objects: Introduction. The PHP Group. <https://www.php.net/manual/en/oop5.intro.php> (accessed 2026-10-31)
4. Announce: Personal Home Page Tools (PHP Tools). Rasmus Lerdorf, comp.infosystems.www.authoring.cgi, 1995-06-08. <https://groups.google.com/g/comp.infosystems.www.authoring.cgi/c/PyJ25gZ6z7A/m/M9FkTUVDfcwJ> (accessed 2026-10-31)
5. PHP releases (JSON release data, e.g. `?json&version=8.0.0`). The PHP Group. <https://www.php.net/releases/index.php?json&version=8.0.0> (accessed 2026-10-31)
6. PHP 7.0.0 Release Announcement. The PHP Group. <https://www.php.net/releases/7_0_0.php> (accessed 2026-10-31)
7. PHP 8.0 Release Announcement. The PHP Group. <https://www.php.net/releases/8.0/en.php> (accessed 2026-10-31)
8. PHP 5.4.0 Release Announcement. The PHP Group. <https://www.php.net/releases/5_4_0.php> (accessed 2026-10-31)
9. PHP 8.5 Release Announcement. The PHP Group. <https://www.php.net/releases/8.5/en.php> (accessed 2026-10-31)
10. Supported Versions. The PHP Group. <https://www.php.net/supported-versions.php> (accessed 2026-10-31)
11. Usage statistics of PHP for websites. W3Techs. <https://w3techs.com/technologies/details/pl-php> (accessed 2026-10-31)
12. Usage statistics of server-side programming languages for websites. W3Techs. <https://w3techs.com/technologies/overview/programming_language> (accessed 2026-10-31)
13. Usage statistics of WordPress. W3Techs. <https://w3techs.com/technologies/details/cm-wordpress> (accessed 2026-10-31)
14. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-10-31)
15. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
16. PHP-GTK. The PHP Group. <https://gtk.php.net/> (accessed 2026-10-31)
17. `php/php-gtk-src` (archived repository). GitHub. <https://github.com/php/php-gtk-src> (accessed 2026-10-31)
18. NativePHP for Desktop: Introduction. NativePHP. <https://nativephp.com/docs/desktop/getting-started/introduction> (accessed 2026-10-31)
19. NativePHP for Desktop: Installation. NativePHP. <https://nativephp.com/docs/desktop/2/getting-started/installation> (accessed 2026-10-31)
20. NativePHP (home page). NativePHP. <https://nativephp.com/> (accessed 2026-10-31)
