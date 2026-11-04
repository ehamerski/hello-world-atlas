# Will AI give birth to a new programming paradigm?

Will AI give birth to a new programming paradigm? If so, what would the
paradigm be, and how would it work? This essay argues that it will, and
justifies the answer. It builds on [`docs/paradigms.md`](paradigms.md), which explains
the four paradigms this repository already covers.

- [The answer in short](#the-answer-in-short)
- [What would count as a new paradigm](#what-would-count-as-a-new-paradigm)
- [The proposed paradigm: intent-oriented programming](#the-proposed-paradigm-intent-oriented-programming)
- [How it would work](#how-it-would-work)
- [Where it comes from](#where-it-comes-from)
- [Evidence so far](#evidence-so-far)
- [Counter-arguments](#counter-arguments)
- [What this repository shows](#what-this-repository-shows)
- [What it means for a student](#what-it-means-for-a-student)
- [Sources](#sources)

> **This is an opinion piece.** The quotes, numbers and dates are facts,
> and each one is cited. The position and the proposed paradigm are the
> author's argument. Nobody can prove a prediction, so the essay also gives the
> strongest arguments against it.

## The answer in short
**Yes.** AI is already giving birth to a new paradigm, which this essay
calls **intent-oriented programming**. In this paradigm the program a person
writes is a statement of **what** is wanted plus the **checks** that decide
whether a result is acceptable. A model generates the **how** (the code),
and the checks accept or reject it. The code becomes an intermediate
artifact, like the assembly a compiler produces.

Two limits on that "yes":

1. It is **not a fifth, unrelated branch** next to imperative,
   object-oriented, functional and logic. It continues the *declarative*
   line that logic programming started ([Where it comes from](#where-it-comes-from)).
2. It is **not mature yet**. The measured results in 2025 are mixed
   ([Evidence so far](#evidence-so-far)), and most AI use today is still
   assistance inside the existing paradigms.

## What would count as a new paradigm
The word comes from Thomas Kuhn's 1962 book *The Structure of Scientific
Revolutions*. The Stanford Encyclopedia of Philosophy summarizes Kuhn's
paradigm as a "constellation of shared commitments" of a community: its
"shared theoretical beliefs, values, instruments and techniques" [1]. For
programming, Peter Van Roy gives a narrower definition: "A programming
paradigm is an approach to programming a computer based on a mathematical
theory or a coherent set of principles" [2].

A faster tool is therefore not a paradigm. Writing Java with an AI
autocomplete is still object-oriented programming: the person still writes
classes and methods, and the AI only types faster. For AI to create a
paradigm it has to change **what a program is made of** and **how it
becomes a running thing**, the same two questions that separate the four
paradigms in [`docs/paradigms.md`](paradigms.md#what-a-paradigm-is).

## The proposed paradigm: intent-oriented programming
This section adds one row to the table in [`docs/paradigms.md`](paradigms.md#what-a-paradigm-is):

| Paradigm | A program is… | How things change | Representative |
|---|---|---|---|
| Intent-oriented *(proposed)* | a statement of intent (prose and examples) plus executable checks (tests, types, contracts) | a model generates code; the code is kept only if every check passes | none yet: only early systems (see below) |

Its principles, which is what Van Roy's definition asks for:

1. **The intent is the source of truth.** What a person maintains is the
   description of the goal and its acceptance checks. Code can be thrown
   away and generated again.
2. **Checks are part of the program, not an extra.** A statement in prose
   alone is ambiguous (see [Dijkstra's objection](#1-natural-language-is-too-imprecise)),
   so a program is not complete until it says how a result is judged.
3. **Generation is a search.** Language models *sample* their output, so
   the same intent can produce different code each time. The paradigm
   accepts this and moves correctness from the generator to the checks.
4. **The human works on the essence.** The person decides what is wanted,
   what counts as correct, and which trade-offs to accept. The machine
   handles the representation in a programming language.

What a Hello World could look like. **This is an invented notation** for
illustration only. No such language exists, and this repository does not
run it:

```text
intent:  Greet the world on the terminal.
example: running the program prints exactly "Hello, World!" and a newline
check:   output == "Hello, World!\n"
check:   exit status == 0
```

From this, a generator could produce [`c/cli/hello.c`](../languages/c/cli/hello.c),
[`python/cli/hello.py`](../languages/python/cli/hello.py) or any other of the 46
runnable implementations here. All of them pass the same two checks. In
intent-oriented programming those four lines are the program, and the C
or Python file is output, the way a `.o` file is output today.

## How it would work
The development cycle is a loop:

1. **State the intent.** Prose for the goal, examples for the unclear
   cases, executable checks for what must be true.
2. **Generate.** A model writes one or more candidate programs in an
   existing language.
3. **Check.** Run the tests, the type checker and, where it matters, a
   verifier. Reject every candidate that fails.
4. **Refine the intent, not the code.** If the accepted program is still
   wrong, the intent or the checks were incomplete. Fix them and generate
   again.

Each part of this loop already exists separately:

- **Generation judged by tests.** The Codex paper (2021) introduced the
  HumanEval benchmark "to measure functional correctness for synthesizing
  programs from docstrings": each problem is a prose description, and an
  answer counts only if it passes unit tests [3].
- **Checks that are proofs.** Dafny describes itself as "a
  verification-aware programming language that has native support for
  recording specifications and is equipped with a static program
  verifier" [4]. A verifier like this could be the strictest kind of check
  in step 3.
- **Programs built from declared model calls.** DSPy (2023) presents
  itself as "a programming model that abstracts LM pipelines as text
  transformation graphs", where language models "are invoked through
  declarative modules", with "a compiler that will optimize any DSPy
  pipeline to maximize a given metric" [5]. The words *declarative*,
  *compiler* and *metric* show the paradigm taking shape: the person
  declares, a compiler searches, a metric decides.

What does not exist yet is a widely used language or toolchain that treats
the intent and the checks as *the* program and the generated code as a
build artifact. That is why the representative cell in the table above is
empty.

## Where it comes from
Intent-oriented programming continues an old idea. In 1979 Robert
Kowalski wrote that "An algorithm can be regarded as consisting of a logic
component, which specifies the knowledge to be used in solving problems,
and a control component, which determines the problem-solving strategies
by means of which that knowledge is used" [6]. In logic programming the
person writes the logic and the machine supplies the control; you can see
this in [`prolog/cli/hello.pl`](../languages/prolog/cli/hello.pl) and in
[`docs/paradigms.md`](paradigms.md#logic).

Intent-oriented programming moves the same line further. The person
supplies the intent and the checks. The machine supplies the control **and
the algorithm**, written in whatever language fits. Prolog searches for a
proof with a fixed strategy. A generator searches through possible
programs and is guided by what it learned from existing code.

The "automatic programming" dream is older still. Frederick P. Brooks, Jr. wrote in
1986: "For almost 40 years, people have been anticipating and writing
about 'automatic programming', the generation of a program for solving a
problem from a statement of the problem specifications" [7]. What is new
since 2021 is that the generation works often enough to measure (next
section). Brooks himself was skeptical, and his argument is one of the
counter-arguments below.

## Evidence so far
The numbers show progress, and they also show that the paradigm is not
ready.

- **Generation from a description works, sometimes.** On HumanEval (2021),
  Codex "solves 28.8% of the problems" with one sample per problem, and
  "Using this method [repeated sampling], we solve 70.2% of our problems
  with 100 samples per problem" [3]. This supports principles 2 and 3:
  generating many candidates and keeping the one that passes the tests
  works much better than trusting a single answer.
- **Adoption is wide.** In the Stack Overflow Developer Survey 2025, "84%
  of respondents are using or planning to use AI tools in their
  development process", and "51% of professional developers use AI tools
  daily" [8].
- **Trust is low.** The same survey (2025): "More developers actively
  distrust the accuracy of AI tools (46%) than trust it (33%)". The
  biggest frustration, "cited by 66% of developers", is "AI solutions that
  are almost right, but not quite" [8]. Without checks, "almost right" is
  the normal result. This is the strongest argument for making checks part
  of the program.
- **Speed results disagree.** In a 2023 controlled experiment, developers
  with GitHub Copilot implemented an HTTP server in JavaScript "55.8%
  faster than the control group" [9]. In a 2025 randomized controlled
  trial with 16 experienced open-source developers working on their own
  mature projects, METR found that "allowing AI actually increases
  completion time by 19%", even though the developers had forecast a 24%
  reduction [10]. A small, well-specified task from scratch went faster.
  Work on large existing code, where the intent lives mostly in people's
  heads, went slower. This is consistent with the claim of this essay: the gain depends
  on how explicit the intent and the checks are.

## Counter-arguments
These are the strongest objections found, each with a reply.

### 1. Natural language is too imprecise
Edsger Dijkstra wrote a note titled "On the foolishness of 'natural
language programming'" (EWD 667, undated, written after 1977 since it
quotes a 1977 report). He argued that "The virtue of formal texts is that
their manipulations, in order to be legitimate, need to satisfy only a few
simple rules", and that the naturalness of a native tongue "boils down to
the ease with which we can use them for making statements the nonsense of
which is not obvious" [11].

**Reply:** the objection is right, and that is why the paradigm does not make
prose the program. Prose is the *readable* part of the intent; the
*binding* part is the checks, which are formal. If the paradigm became
"type a wish and trust the answer", Dijkstra's objection would win, and
the 66% "almost right" figure [8] shows what that looks like.

### 2. It is only a higher-level language, not a paradigm
Brooks quotes David Parnas: "In short, automatic programming always has
been a euphemism for programming with a higher-level language than was
presently available to the programmer" [7]. By that view, prompts are the
next step after Fortran and C, not a new paradigm.

**Reply:** partly true. Intent-oriented programming *is* a higher
level. But it also changes two things that a new language level never
did. First, the translation is no longer deterministic: a compiler gives
the same output for the same input, and a generator does not [3].
Second, the person no longer reads or owns the generated code, so the
checks must carry the trust that reading the code used to carry. Those
two changes alter what a program is and how it is trusted, which is what
Van Roy's definition is about [2].

### 3. The hard part of software is not the code
Brooks again: "I believe the hard part of building software to be the
specification, design, and testing of this conceptual construct, not the
labor of representing it and testing the fidelity of the representation"
[7]. He also wrote, in 1986, that he did not expect artificial
intelligence to provide "the revolutionary breakthrough that will give
order-of-magnitude gains in software productivity and quality" [7].

**Reply:** this is the strongest objection, and the paradigm accepts
it. AI does not remove the hard part. It removes much of the
*representation* work, which leaves the specification and the testing,
the parts Brooks calls hard, as the main human job. That is the change
of paradigm: the human's program becomes the specification. Whether this
brings order-of-magnitude gains is a separate question, and the METR
result [10] says that in 2025, for experienced developers on mature
projects, it did not.

### 4. Today's AI use is assistance, not a new way of thinking
Most developers use AI inside their normal languages and workflows [8].
The resulting programs are still Java, Python or C, written in the
existing paradigms.

**Reply:** true today, which is why the essay says the paradigm is being
born, not that it has arrived. Kuhn's view, as the Stanford Encyclopedia
summarizes it, is that revolutionary science "is not cumulative" and
involves "a revision to existing scientific belief or practice" [1]. A
programming paradigm is smaller than a scientific revolution, but the
test is similar: it has arrived when people change *what they maintain*,
not only how fast they type.

### 5. It may never be reliable enough
If the checks are incomplete, a generated program can pass them and still
be wrong, and nobody may read it closely enough to notice.

**Reply:** this is a real risk, and the paradigm has no magic
solution for it. It only makes the risk visible: the quality of the
program is bounded by the quality of its checks. That is why verifiers
such as Dafny [4] matter, and why, in the view of this essay, learning to write good
checks becomes a core programming skill.

## What this repository shows
AI agents built this repository from a written specification, a plan with
a definition of done, and scripts that check the result.
[`scripts/verify-all.sh`](../scripts/verify-all.sh) runs the `install.sh`
check, `build.sh`, and `run.sh` of every runnable implementation and checks
that the output contains `Hello, World!`;
[`scripts/check-links.sh`](../scripts/check-links.sh) checks every relative
link. A human reviewer approved each step.

This is a small version of the loop described above: the intent is the
specification, the checks are the scripts and the reviews, and the 47
implementations listed in
[`languages/README.md`](../languages/README.md#all-implementations) are the
generated artifacts. This is one project with a simple program, so it
proves nothing on its own. It does show where the human effort went: into
the specification, the plan, the checks, and the review, not into typing
`printf`.

## What it means for a student
- **Learn the four paradigms anyway.** Generated code is written in
  existing languages, and someone has to judge whether it is right. You
  cannot review a Prolog program, or a Haskell one, if you do not know how
  it thinks ([`docs/paradigms.md`](paradigms.md)).
- **Learn to write checks.** A test, a type or a contract is the part of
  the program that a generator cannot argue with.
- **Learn to state intent precisely.** Dijkstra's warning [11] still
  holds: the skill is to say exactly what you mean, in prose and in formal
  checks.

## Sources
1. Thomas Kuhn. Alexander Bird, *The Stanford Encyclopedia of Philosophy*, first published 2004-08-13, substantive revision 2025-09-02. Metaphysics Research Lab, Stanford University. <https://plato.stanford.edu/entries/thomas-kuhn/> (accessed 2026-11-02)
2. Programming Paradigms for Dummies: What Every Programmer Should Know. Peter Van Roy, in *New Computational Paradigms for Computer Music*, G. Assayag and A. Gerzso (eds.), IRCAM/Delatour France, 2009. Author's copy, UCLouvain. <https://webperso.info.ucl.ac.be/~pvr/VanRoyChapter.pdf> (accessed 2026-11-02)
3. Evaluating Large Language Models Trained on Code. Mark Chen et al., OpenAI, arXiv:2107.03374, 2021. <https://arxiv.org/abs/2107.03374> (accessed 2026-11-02)
4. Dafny: The Dafny Programming and Verification Language. Dafny project. <https://dafny.org/> (accessed 2026-11-02)
5. DSPy: Compiling Declarative Language Model Calls into Self-Improving Pipelines. Omar Khattab et al., arXiv:2310.03714, 2023. <https://arxiv.org/abs/2310.03714> (accessed 2026-11-02)
6. Algorithm = Logic + Control. Robert Kowalski, Communications of the ACM, July 1979. <https://www.doc.ic.ac.uk/~rak/papers/algorithm%20=%20logic%20+%20control.pdf> (accessed 2026-11-02)
7. No Silver Bullet: Essence and Accident in Software Engineering. Frederick P. Brooks, Jr., Proceedings of the IFIP Tenth World Computing Conference, Elsevier, 1986, pp. 1069–1076; reprinted in *The Mythical Man-Month*, anniversary edition, Addison-Wesley, 1995. Copy used: <https://worrydream.com/refs/Brooks_1986_-_No_Silver_Bullet.pdf> (accessed 2026-11-02)
8. Stack Overflow Developer Survey 2025: AI. Stack Overflow, 2025. <https://survey.stackoverflow.co/2025/ai> (accessed 2026-11-02)
9. The Impact of AI on Developer Productivity: Evidence from GitHub Copilot. Sida Peng, Eirini Kalliamvakou, Peter Cihon, Mert Demirer, arXiv:2302.06590, 2023. <https://arxiv.org/abs/2302.06590> (accessed 2026-11-02)
10. Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity. Joel Becker, Nate Rush, Beth Barnes, David Rein, METR, arXiv:2507.09089, 2025. <https://arxiv.org/abs/2507.09089> (accessed 2026-11-02)
11. EWD 667: On the foolishness of "natural language programming". Edsger W. Dijkstra; E. W. Dijkstra Archive, University of Texas at Austin. <https://www.cs.utexas.edu/~EWD/transcriptions/EWD06xx/EWD667.html> (accessed 2026-11-02)
