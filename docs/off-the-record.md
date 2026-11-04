# Off the record

The rest of this site is formal. This page is not. It collects a light
remark about each language of this repository, jokes about programming
found elsewhere, an improbable dictionary, and some well-known quotations
by people who designed or studied programming languages.

The jokes may be about languages, paradigms, tools, artificial
intelligence and the everyday life of programmers, and a joke at the
programmer's own expense is welcome. None is demeaning to any group of
people or to any real person.

## One line per language
<!-- BEGIN SITE: humor-lines -->
Each language keeps its line in its own `meta.yml` (`humor.line`, see the
[schema](../languages/README.md#humor-keys)). The website lists them here,
sorted by name.
<!-- END SITE: humor-lines -->

## Jokes about programming
Every joke below is quoted word for word from the page named under it,
with its author when that page gives one and "Origin unknown"
otherwise. The xkcd comics are only linked: they are licensed CC BY-NC
2.5, and this site does not copy them. Stack Overflow text is licensed
CC BY-SA, and the entries from it name their author and link to the
page that collects them.

### Languages talking about each other

<!-- vale off -->

> C makes it easy to shoot yourself in the foot; C++ makes it harder, but
> when you do it blows your whole leg off

Bjarne Stroustrup, who writes "Yes, I said something like that (in 1986
or so)" on his [Quotes](https://www.stroustrup.com/quotes.html) page
(accessed 2026-11-03).

> Any sufficiently complicated C or Fortran program contains an ad-hoc,
> informally-specified bug-ridden slow implementation of half of Common
> Lisp.

Philip Greenspun, "Greenspun's Tenth Rule of Programming", on his
[Research](https://philip.greenspun.com/research/) page (accessed
2026-11-03).

> 1970 - Niklaus Wirth creates Pascal, a procedural language. Critics
> immediately denounce Pascal because it uses "x := x + y" syntax instead
> of the more familiar C-like "x = x + y". This criticism happens in spite
> of the fact that C has not yet been invented.

James Iry, [A Brief, Incomplete, and Mostly Wrong History of Programming
Languages](https://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)
(2009) (accessed 2026-11-03).

> 1996 - James Gosling invents Java. Java is a relatively verbose, garbage
> collected, class based, statically typed, single dispatch, object
> oriented language with single implementation inheritance and multiple
> interface inheritance. Sun loudly heralds Java's novelty.

James Iry, [A Brief, Incomplete, and Mostly Wrong History of Programming
Languages](https://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)
(2009) (accessed 2026-11-03).

<!-- vale on -->

Randall Munroe, [xkcd 224, "Lisp"](https://xkcd.com/224/): a comic about
a dream of enlightenment that comes over a reader of a Lisp book
(accessed 2026-11-03).

### Paradigms

<!-- vale off -->

> 1980 - Alan Kay creates Smalltalk and invents the term "object
> oriented." When asked what that means he replies, "Smalltalk programs
> are just objects." When asked what objects are made of he replies,
> "objects." When asked again he says "look, it's all objects all the way
> down. Until you reach turtles."

James Iry, [A Brief, Incomplete, and Mostly Wrong History of Programming
Languages](https://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)
(2009), on object-oriented programming (accessed 2026-11-03).

> Any sufficiently complicated concurrent program in another language
> contains an ad hoc informally-specified bug-ridden slow implementation
> of half of Erlang.

Robert Virding, [Virding's First Rule of
Programming](https://rvirding.blogspot.com/2008/01/virdings-first-rule-of-programming.html)
(2008), written after blog posts about Erlang's message-passing
concurrency, the actor model at work. He adds "With all respect to
Greenspun." (accessed 2026-11-03).

> Haskell gets some resistance due to the complexity of using monads to
> control side effects. Wadler tries to appease critics by explaining that
> "a monad is a monoid in the category of endofunctors, what's the
> problem?"

James Iry, [A Brief, Incomplete, and Mostly Wrong History of Programming
Languages](https://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)
(2009), part of the entry for 1990, on functional programming (accessed
2026-11-03).

> 1972 - Alain Colmerauer designs the logic language Prolog. His goal is
> to create a language with the intelligence of a two year old. He proves
> he has reached his goal by showing a Prolog session that says "No." to
> every query.

James Iry, [A Brief, Incomplete, and Mostly Wrong History of Programming
Languages](https://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)
(2009), on logic programming (accessed 2026-11-03).

> One day a student came to Moon and said: “I understand how to make a
> better garbage collector. We must keep a reference count of the
> pointers to each cons.”
>
> Moon patiently told the student the following story:
>
> “One day a student came to Moon and said: ‘I understand how to make a
> better garbage collector...

"Moon instructs a student", one of the AI koans, a genre of jokes told
at the MIT AI Lab, found at [The Jargon File, "Some AI
Koans"](http://www.catb.org/jargon/html/koans.html) (accessed
2026-11-03). The story never ends, as a structure that points to itself
never reaches a reference count of zero.

<!-- vale on -->

Randall Munroe, [xkcd 1312, "Haskell"](https://xkcd.com/1312/): a comic
about the guarantee that code written in Haskell has no side effects
(accessed 2026-11-03).

### AI and programming

<!-- vale off -->

> In the days when Sussman was a novice, Minsky once came to him as he sat
> hacking at the PDP-6.
>
> “What are you doing?”, asked Minsky.
>
> “I am training a randomly wired neural net to play Tic-Tac-Toe” Sussman
> replied.
>
> “Why is the net wired randomly?”, asked Minsky.
>
> “I do not want it to have any preconceptions of how to play”, Sussman
> said.
>
> Minsky then shut his eyes.
>
> “Why do you close your eyes?”, Sussman asked his teacher.
>
> “So that the room will be empty.”
>
> At that moment, Sussman was enlightened.

"Sussman attains enlightenment", one of the AI koans, found at [The Jargon File, "Some AI
Koans"](http://www.catb.org/jargon/html/koans.html) (accessed
2026-11-03).

> A novice was trying to fix a broken Lisp machine by turning the power
> off and on.
>
> Knight, seeing what the student was doing, spoke sternly: “You cannot
> fix a machine by just power-cycling it with no understanding of what is
> going wrong.”
>
> Knight turned the machine off and on.
>
> The machine worked.

"Tom Knight and the Lisp Machine", from the same [AI
koans](http://www.catb.org/jargon/html/koans.html) (accessed 2026-11-03).

> Intelligence is whatever machines haven't done yet

Larry Tesler, who gives this as "What I actually said" for the line
usually quoted as "Artificial Intelligence is whatever hasn't been done
yet", in [Adages and
Coinages](https://www.nomodes.com/larry-tesler-consulting/adages-and-coinages)
(accessed 2026-11-03).

<!-- vale on -->

Randall Munroe, [xkcd 1838, "Machine Learning"](https://xkcd.com/1838/):
a comic about a learning system that is a pile of linear algebra, stirred
until the answers look right (accessed 2026-11-03).

Randall Munroe, [xkcd 1425, "Tasks"](https://xkcd.com/1425/): a comic
about telling a task that takes a few hours of programming from one that
takes a research team five years (accessed 2026-11-03).

### Everyday programming

<!-- vale off -->

> There are only two hard things in Computer Science: cache invalidation
> and naming things.

Phil Karlton, as quoted by Martin Fowler in
[TwoHardThings](https://martinfowler.com/bliki/TwoHardThings.html)
(accessed 2026-11-03).

> There are 2 hard problems in computer science: cache invalidation,
> naming things, and off-by-1 errors.

Leon Bambrick, as quoted on the same
[page](https://martinfowler.com/bliki/TwoHardThings.html) (accessed
2026-11-03).

> There are only two hard problems in distributed systems: 2. Exactly-once
> delivery 1. Guaranteed order of messages 2. Exactly-once delivery

Mathias Verraes, as quoted on the same
[page](https://martinfowler.com/bliki/TwoHardThings.html) (accessed
2026-11-03).

> Some people, when confronted with a problem, think “I know, I'll use
> regular expressions.” Now they have two problems.

Jamie Zawinski, in a Usenet post of August 12, 1997, as traced by Jeffrey
Friedl in [Source of the famous "Now you have two problems"
quote](https://regex.info/blog/2006-09-15/247) (accessed 2026-11-03).

> The first 90 percent of the code accounts for the first 90 percent of
> the development time. The remaining 10 percent of the code accounts for
> the other 90 percent of the development time.

Tom Cargill, of Bell Labs, made popular by Jon Bentley's "Programming
Pearls" column (1985), as quoted at [Wikipedia, "Ninety–ninety
rule"](https://en.wikipedia.org/wiki/Ninety%E2%80%93ninety_rule)
(accessed 2026-11-03).

> Everyone knows that debugging is twice as hard as writing a program in
> the first place. So if you're as clever as you can be when you write
> it, how will you ever debug it?

Brian W. Kernighan and P. J. Plauger, *The Elements of Programming
Style*, 2nd edition, chapter 2, as quoted at [Wikiquote, "Brian
Kernighan"](https://en.wikiquote.org/wiki/Brian_Kernighan) (accessed
2026-11-03).

> heisenbug: /hi:´zen·buhg/, n.
>
> [from Heisenberg's Uncertainty Principle in quantum physics] A bug that
> disappears or alters its behavior when one attempts to probe or isolate
> it.

Origin unknown, found at [The Jargon File,
"heisenbug"](http://www.catb.org/jargon/html/H/heisenbug.html) (accessed
2026-11-03).

> Using if(constant == variable) instead of if(variable == constant), like
> if(4 == foo). Because it’s like saying “if blue is the sky” or “if tall
> is the man.”

"Yoda Conditions", by the Stack Overflow user zneak, collected by Jeff
Atwood in [New Programming
Jargon](https://blog.codinghorror.com/new-programming-jargon/) (2012);
Stack Overflow text, CC BY-SA (accessed 2026-11-03).

> For when you just Gotta Catch ’Em All.

"Pokémon Exception Handling", by the Stack Overflow user woot4moo, from
the same [collection](https://blog.codinghorror.com/new-programming-jargon/);
CC BY-SA (accessed 2026-11-03).

> The process of taking a well-designed piece of code and, through a
> series of small, reversible changes, making it completely unmaintainable
> by anyone except yourself.

"Refuctoring", by Jason Gorman, from the same
[collection](https://blog.codinghorror.com/new-programming-jargon/);
CC BY-SA (accessed 2026-11-03).

> A riff on strongly typed. Used to describe an implementation that
> needlessly relies on strings when programmer & refactor friendly options
> are available.

"Stringly Typed", by Mark Simpson, from the same
[collection](https://blog.codinghorror.com/new-programming-jargon/);
CC BY-SA (accessed 2026-11-03).

<!-- vale on -->

Randall Munroe, [xkcd 1597, "Git"](https://xkcd.com/1597/): a comic about
the usual way to fix a broken Git repository, which is to save the work
elsewhere, delete the project, and download a fresh copy (accessed
2026-11-03).

Randall Munroe, [xkcd 2347, "Dependency"](https://xkcd.com/2347/): a
comic about modern digital infrastructure, resting on one small project
that one person has maintained for years (accessed 2026-11-03).

<!-- BEGIN SITE: humor-jokes -->
<!-- END SITE: humor-jokes -->

## The Improbable Dictionary of Programming
A mock dictionary is an old joke. Ambrose Bierce gathered his satirical
definitions into *The Cynic's Word Book* in 1906 and, in a more complete
version, *The Devil's Dictionary* in 1911 [10]. Stan Kelly-Bootle
brought the form to computing with *The Devil's DP Dictionary* (McGraw-Hill,
1981) [11], [12]. The Jargon File, begun by Raphael Finkel at Stanford in
1975, records the real slang of programmers, often with a joke inside
[13]. These works are the inspiration for the entries below, which are
written for this site and copy nothing from them. An entry for a
language name comes from that language's own folder.

<!-- BEGIN SITE: humor-dictionary -->
<!-- The entries for language names are in each languages/<language>/meta.yml
(humor.dictionary); the website merges them with these, from A to Z. -->
- **Actor** (n.): in the actor model, a small process that reads its
  messages and sends more, which is also a fair description of a working
  day.
- **AI pair programmer** (n.): a colleague who never tires, never sleeps,
  and never remembers the conversation from yesterday.
- **API** (n.): a promise between two programs, kept until the next major
  version.
- **Bug** (n.): a feature that nobody asked for, delivered on time.
- **Cache** (n.): a place to keep the answer to a question, so that it can
  be wrong faster next time.
- **Comment** (n.): a note from a past programmer to a future one,
  describing code that has changed since.
- **Commit message** (n.): a short note to the future, usually "fix".
- **Compiler** (n.): a program that reads your code more carefully than
  anyone else ever will.
- **Container** (n.): a way to ship the programmer's machine along with
  the program, so that it works on every machine that is the
  programmer's machine.
- **Deadline** (n.): the date on which an estimate becomes history.
- **Debugger** (n.): a tool for watching, one step at a time, a program do
  exactly what it was told.
- **Dependency** (n.): someone else's code that your code needs, which
  needs someone else's code, all the way down.
- **Documentation** (n.): the second most up-to-date description of a
  program, after the program.
- **Estimate** (n.): a number of days, multiplied by a constant that
  nobody knows yet.
- **Framework** (n.): code that calls your code, on its own schedule.
- **Functional programming** (n.): programming without side effects, except
  printing "Hello, World!", which needs a monad.
- **Git** (n.): a version control system in which every past mistake is
  kept, signed, and copied to every colleague.
- **Hallucination** (n.): an answer from an AI model that is fluent,
  confident, and cited, to a paper that does not exist.
- **Hello World** (n.): the first program in a new language, and the last
  one that works the first time.
- **Large language model** (n.): a program that has read most of the
  internet and, like the internet, answers every question with
  confidence.
- **Legacy code** (n.): code that works.
- **Logic programming** (n.): a paradigm in which the program states the
  facts and the computer takes responsibility for the consequences.
- **Machine learning** (n.): a program that learns from examples,
  including the ones nobody meant to give it.
- **Object-oriented programming** (n.): a way to organize code in which
  every problem is a noun, and every noun has a manager class.
- **Off-by-one error** (n.): a mistake that is never far from the right
  answer.
- **Prompt** (n.): a program written in English, for a computer that may
  run it, or may run something close to it.
- **Pull request** (n.): a polite way to ask colleagues to find your
  mistakes in public.
- **Race condition** (n.): a bug that appears only when nobody is looking.
- **Regular expression** (n.): a short string that matches what was
  meant, and also what was not.
- **Semicolon** (n.): a punctuation mark that some languages require, some
  forbid, and JavaScript inserts on its own when it thinks one is missing.
- **Stack Overflow** (n.): 1. what happens when a recursion never stops.
  2. where programmers go to find out why.
- **Technical debt** (n.): time borrowed from the future, at an interest
  rate nobody wrote down.
- **Undefined behavior** (n.): what a C program does once the standard
  has stopped watching.
- **Vibe coding** (n.): programming by describing the program to an AI
  model, and then hoping.
- **Whitespace** (n.): invisible characters that cause visible
  arguments.
- **Works on my machine** (phrase): the first half of a bug report.
- **YAML** (n.): a data format in which indentation has meaning and, in
  version 1.1, so does the word `no`.
- **Zero-based** (adj.): how most languages in this repository count.
  Fortran and COBOL start at one, and neither will discuss it.
<!-- END SITE: humor-dictionary -->

## Quotations
Each quotation is copied word for word from the source listed under it.

<!-- vale off -->

> A language that doesn't affect the way you think about programming, is
> not worth knowing.

Alan J. Perlis, *Epigrams on Programming*, epigram 19 (1982) [1].

> Syntactic sugar causes cancer of the semicolon.

Alan J. Perlis, *Epigrams on Programming*, epigram 3 (1982) [1].

> In the good old days physicists repeated each other's experiments, just to
> be sure. Today they stick to FORTRAN, so that they can share each other's
> programs, bugs included.

Edsger W. Dijkstra, *How do we tell truths that might hurt?*, EWD498
(1975) [2].

> Here is a language so far ahead of its time, that it was not only an
> improvement on its predecessors, but also on nearly all its successors.

C. A. R. Hoare on ALGOL 60, *Hints on Programming Language Design* (1973),
appendix, p. 27 [3].

> We should forget about small efficiencies, say about 97% of the time:
> premature optimization is the root of all evil.

Donald E. Knuth, *Structured Programming with go to Statements* (1974),
p. 268 [4].

> In this case it prints hello, world

Brian W. Kernighan, *Programming in C: A Tutorial* (Bell Laboratories,
c. 1974), section 2, on one of the earliest printed Hello World programs
[5].

> There are only two kinds of languages: the ones people complain about and
> the ones nobody uses

A remark that Bjarne Stroustrup confirms as his on his own quotations
page, where he adds that he doubts the sentiment is original [6].

> Readability counts.

Tim Peters, *The Zen of Python*, PEP 20 (2004) [7].

> Do I have to like “Monty Python’s Flying Circus”? No, but it helps. :)

The official General Python FAQ, question and answer [8].

> In retrospect, therefore, perhaps the biggest single benefit of laziness
> is not laziness per se, but rather that laziness kept us pure

Paul Hudak, John Hughes, Simon Peyton Jones and Philip Wadler, *A History
of Haskell: Being Lazy With Class* (2007), section 3.2 [9].

<!-- vale on -->

## Sources
1. Epigrams in Programming. Alan J. Perlis, ACM SIGPLAN Notices 17(9), September 1982; text published by the Yale University Department of Computer Science. <https://www.cs.yale.edu/homes/perlis-alan/quotes.html> (accessed 2026-11-03)
2. How do we tell truths that might hurt? (EWD498). Edsger W. Dijkstra, 1975; E. W. Dijkstra Archive, University of Texas at Austin. <https://www.cs.utexas.edu/~EWD/transcriptions/EWD04xx/EWD498.html> (accessed 2026-11-03)
3. Hints on Programming Language Design. C. A. R. Hoare, Stanford Artificial Intelligence Memo AIM-224 / STAN-CS-73-403, December 1973; scan hosted by the University of Michigan. <https://web.eecs.umich.edu/~bchandra/courses/papers/Hoare_Hints.pdf> (accessed 2026-11-03)
4. Structured Programming with go to Statements. Donald E. Knuth, Computing Surveys 6(4), December 1974; archived copy. <https://web.archive.org/web/2013/http://cs.sjsu.edu/~mak/CS185C/KnuthStructuredProgrammingGoTo.pdf> (accessed 2026-11-03)
5. Programming in C: A Tutorial. Brian W. Kernighan, Bell Laboratories; archived copy of bell-labs.com. <https://web.archive.org/web/20151226023321/https://www.bell-labs.com/usr/dmr/www/ctut.pdf> (accessed 2026-11-03)
6. Quotes. Bjarne Stroustrup. <https://www.stroustrup.com/quotes.html> (accessed 2026-11-03)
7. PEP 20: The Zen of Python. Tim Peters, Python Software Foundation, 2004. <https://peps.python.org/pep-0020/> (accessed 2026-11-03)
8. General Python FAQ. Python Software Foundation. <https://docs.python.org/3/faq/general.html> (accessed 2026-11-03)
9. A History of Haskell: Being Lazy With Class. Paul Hudak, John Hughes, Simon Peyton Jones, Philip Wadler, Third ACM SIGPLAN History of Programming Languages Conference (HOPL III), 2007; author copy hosted by Microsoft Research. <https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/history.pdf> (accessed 2026-11-03)
10. The Devil's Dictionary. Wikipedia. <https://en.wikipedia.org/wiki/The_Devil%27s_Dictionary> (accessed 2026-11-03)
11. The Devil's DP Dictionary. Stan Kelly-Bootle, McGraw-Hill, 1981; Open Library record. <https://openlibrary.org/works/OL3522422W> (accessed 2026-11-03)
12. Stan Kelly-Bootle. Wikipedia. <https://en.wikipedia.org/wiki/Stan_Kelly-Bootle> (accessed 2026-11-03)
13. Revision History. The Jargon File, version 4.4.7, Eric S. Raymond. <http://www.catb.org/jargon/html/revision-history.html> (accessed 2026-11-03)
