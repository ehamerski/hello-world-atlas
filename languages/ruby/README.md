# Ruby

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** object-oriented, with imperative and functional features. The
official site describes Ruby as a language that "balanced functional
programming with imperative programming" [1], and states that "In Ruby,
everything is an object" [1]. The Hello World programs here use only
the imperative style: statements run top to bottom, and the web versions
pass a block (a piece of code) to a method.

See also: [paradigms](../../docs/paradigms.md#every-language-and-its-paradigm)
(how this paradigm compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Ruby (`ruby`) | ✅ |
| desktop | [desktop/](desktop/) | Ruby/Tk (`tk` gem), Tcl/Tk | ✅ |
| web | [web/](web/) | Sinatra, Puma | ✅ |
| web-rails | [web-rails/](web-rails/) | Ruby on Rails, Puma | ✅ |

## History
Yukihiro "Matz" Matsumoto created Ruby. The official FAQ summarizes his
1999 account [2]:

- "Ruby was born on February 24, 1993." He was "talking with my colleague
  about the possibility of an object-oriented scripting language."
- He knew Perl, but "didn’t like it really, because it had the smell of a toy
  language". He knew Python too, but "didn’t think it was a true
  object-oriented language—OO features appeared to be an add-on to the
  language."
- "I really wanted a genuine object-oriented, easy-to-use scripting
  language. I looked for, but couldn’t find one. So, I decided to make it."
- "It took several months to make the interpreter run." He added "iterators,
  exception handling, garbage collection", and "reorganized the features of
  Perl into a class library".
- "I posted Ruby 0.95 to the Japanese domestic newsgroups in Dec. 1995."

The language was named after a gemstone: "Influenced by Perl, Matz wanted to use
a jewel name for his new language, so he named Ruby after a colleague’s
birthstone" [3].
The official site lists the languages that Matz blended: "Perl, Smalltalk,
Eiffel, Ada, and Lisp" [1]. It credits Smalltalk for giving "methods and
instance variables to all of its types", and quotes Matz on blocks: "in Ruby
closures, I wanted to respect the Lisp culture" [1].

Ruby grew with the web. The same page says that "Much of the growth is
attributed to the popularity of software written in Ruby, particularly the
Ruby on Rails web framework" [1]. Rails is a separate project, a framework
written in Ruby; see [web-rails](web-rails/README.md#language-and-framework)
for the difference between a language and a framework.

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1993-02-24 | Ruby is conceived (Matz's own date, corrected in a later post) | [2] |
| 1995-12 | Ruby 0.95 posted to the Japanese newsgroups, the first public release | [2] |
| 2003-08-04 | Ruby 1.8.0 | [4] |
| 2005-12-13 | Ruby on Rails 1.0, announced "15 months after the first public release" | [5] |
| 2006 | "Ruby achieved mass acceptance"; TIOBE names Ruby its programming language of the year | [1][6] |
| 2007-12-25 | Ruby 1.9.0 | [4] |
| 2013-02-24 | Ruby 2.0.0, "the first stable release of the Ruby 2.0 series" | [7] |
| 2020-12-25 | Ruby 3.0.0, with the goals "performance, concurrency, and Typing" | [8] |
| 2025-10 | Rails 8.1, the series used in this repository | [9] |
| 2025-12-25 | Ruby 4.0.0, which "introduces “Ruby Box” and “ZJIT”" | [10] |
| 2026-09-15 | Ruby 4.0.7, the version used in this repository | [4] |

The maintenance page lists a release date of 25 December for every minor
version from 2.1 (2013-12-25) to 4.0 (2025-12-25) [11].

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** Ruby is #28, with a rating of 0.53% [12].
  The official Ruby site says, without a year, that Ruby "is ranked among
  the top 10 on most of the indices" [1]; the 2026 figure above is lower.
- **Stack Overflow Developer Survey 2026:** 5.8% of the respondents to the
  programming languages question used Ruby (823 of 14,099) [13]. In the web
  frameworks question, 5.7% used Ruby on Rails (583 of 10,281) [13].
- **TIOBE "Programming Language of the Year":** Ruby won it in 2006 [6].
  The award goes to "the programming language that has the highest rise in
  ratings in a year" [6].
- **Rails site, 2026-11-04:** "There have been many hundreds of thousands of
  apps created with Rails since its inception", and "Over six thousand
  people have contributed code to Rails" [14]. This is the Rails project's
  own statement, not an independent count.

## Importance then and now
- **Then (1993–2006):** Matz wanted an object-oriented scripting language
  and found none he liked [2]. Matz posted the first release to
  Japanese newsgroups, and "highly active mailing lists have been
  established and web pages formed" since [2]. The official site dates the
  language's "mass acceptance" to 2006 [1].
- **Rails:** Rails 1.0 came out in 2005 [5]. The Rails site describes Rails
  as a "full-stack framework" [14], and the official Ruby site attributes
  much of Ruby's growth to it [1].
- **Now:** Ruby sits in the middle of the 2026 rankings: #28 at TIOBE,
  5.8% of the Stack Overflow respondents [12][13]. It still has a yearly
  release rhythm [11] and a major version, 4.0, from December 2025 [10].
  Rails is current too: version 8.1.4.1 was released on 2026-11-04 [14].

## Comparing the categories
| | [cli](cli/) | [desktop](desktop/) | [web](web/) | [web-rails](web-rails/) |
|---|---|---|---|---|
| Lines of Ruby (without comments) | 1 | 16 (7 are the self-check) | 6 | 18 |
| What it uses | built-in `puts` | `tk` gem (Ruby/Tk) and Tcl/Tk | Sinatra and Puma | Rails (railties, actionpack), Rackup, and Puma |
| Extra install | none | Tcl/Tk (Homebrew `tcl-tk`), a C compiler, and the gem in `vendor/bundle` | gems in `vendor/bundle` (`Gemfile`) | gems in `vendor/bundle` (`Gemfile`) |
| Build step | none | none for the program; the gem is compiled by `bundle install` | none | none |
| How it runs | top to bottom, then exits | `Tk.mainloop` event loop until the window closes | `ruby app.rb`: Sinatra starts Puma, which serves until Ctrl+C | `rackup config.ru`: Puma calls the Rails app until Ctrl+C |
| Output | text on stdout | a native window | an HTML page over HTTP on `localhost:8080` | the same, from a Rails controller |

The cli version is a straight list of statements, with no library and no
build step. The desktop and web versions hand control to a loop that waits
for events (a click or an HTTP request) and calls your code when one arrives.
The three that use a library list it in a `Gemfile`, and Bundler installs
exactly the versions in `Gemfile.lock` into the project folder.

The two web versions show the difference between a small framework and a
large one on the same language. Sinatra needs one file and one block per
route. Rails separates the route (`root to: "hello#index"`) from the
handler (a method of a controller class) and connects them by a naming
convention, which pays off when an application has many routes, models, and
views. The [web-rails README](web-rails/README.md#language-and-framework)
has the full comparison.

All four categories planned for Ruby are implemented, so this page has no
"why no <category>" section.

## Sources
1. About Ruby. Ruby community. <https://www.ruby-lang.org/en/about/> (accessed 2026-11-04)
2. Ruby FAQ: What is the history of Ruby? (a summary of a posting by Matz, ruby-talk:00382, 1999-06-04). Ruby community. <https://www.ruby-lang.org/en/documentation/faq/1/> (accessed 2026-11-04)
3. Ruby FAQ: Why the name “Ruby”? Ruby community. <https://www.ruby-lang.org/en/documentation/faq/1/> (accessed 2026-11-04)
4. Ruby Releases. Ruby community. <https://www.ruby-lang.org/en/downloads/releases/> (accessed 2026-11-04)
<!-- vale off -->
5. Rails 1.0: Party like it's one oh oh! David Heinemeier Hansson, rubyonrails.org, 2005-12-13. <https://rubyonrails.org/2005/12/13/rails-1-0-party-like-its-one-oh-oh> (accessed 2026-11-04)
<!-- vale on -->
6. TIOBE Index for October 2026, "Programming Language Hall of Fame". TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-04)
7. Ruby 2.0.0-p0 is released. Ruby community, 2013-02-24. <https://www.ruby-lang.org/en/news/2013/02/24/ruby-2-0-0-p0-is-released/> (accessed 2026-11-04)
8. Ruby 3.0.0 Released. Ruby community, 2020-12-25. <https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/> (accessed 2026-11-04)
9. Rails 8.1: Job continuations, structured events, local CI. Rails team, rubyonrails.org, 2025-10-22. <https://rubyonrails.org/2025/10/22/rails-8-1> (accessed 2026-11-04)
10. Ruby 4.0.0 Released. Ruby community, 2025-12-25. <https://www.ruby-lang.org/en/news/2025/12/25/ruby-4-0-0-released/> (accessed 2026-11-04)
11. Ruby Maintenance Branches. Ruby community. <https://www.ruby-lang.org/en/downloads/branches/> (accessed 2026-11-04)
12. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-04)
13. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-11-04)
14. Ruby on Rails. Rails team. <https://rubyonrails.org/> (accessed 2026-11-04)
