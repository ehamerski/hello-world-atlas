% hello.pl - Prolog cli: print "Hello, World!" to the terminal.
%
% Run it with ./run.sh, which explains each step. By hand (from cli/):
%   swipl hello.pl
%
% Prolog is a LOGIC programming language. A Prolog program is not a list of
% commands to execute in order, like C, Java, or Python. It is a small
% database of facts and rules (logical statements). You run it by asking a
% question (a "goal"), and Prolog tries to PROVE that goal from the rules.
% While it proves the goal, it may print, open files, and so on: those are
% side effects of the proof.
%
% A comment starts with "%" and runs to the end of the line, like "//" in
% C99, Java, or Go. "/* ... */" block comments also work.

% A line starting with ":-" is a DIRECTIVE: a goal that runs while the file
% is being loaded, not a rule. initialization(main, main) says: "when the
% whole file is loaded, prove the goal main; then stop the program". The
% second "main" selects that mode, which also turns an error or a failed
% goal into a non-zero exit status (see the SWI-Prolog manual,
% initialization/2). Without it, swipl would load the file and then open
% its interactive prompt ("?-") to wait for your questions.
:- initialization(main, main).

% This is a RULE, read as "main is true IF format(...) is true":
%   Head :- Body.
% "main" is the head; it has no arguments (in Prolog terms, it is the
% predicate main/0: name main, arity 0). The body is one goal. Proving it
% calls format/1, a built-in predicate that writes text to the standard
% output, much like C's printf. "~n" is format's directive for a new line,
% where C would use "\n".
%
% Every clause ends with a full stop ".", the way a sentence does.
%
% main/0 has only this one clause. If a predicate had several clauses,
% Prolog would try them one by one until one succeeds, and come back for
% the next one if a later goal failed: that search is called BACKTRACKING.
main :-
    format("Hello, World!~n").
