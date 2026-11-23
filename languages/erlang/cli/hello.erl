#!/usr/bin/env escript
%% hello.erl - Erlang cli: print "Hello, World!" and end.
%%
%% Run it with:  escript hello.erl   (or ./run.sh, which explains each step)
%%
%% This file is an ESCRIPT: an Erlang program that runs like a shell script.
%% Python and Node.js programs are run the same way. Compiled Erlang code
%% normally lives in a MODULE (a .erl file that is compiled to a .beam file),
%% and the other two folders of this language, ../desktop and ../web, are
%% built that way. An escript needs no separate build step.
%%
%% The first line above is an "interpreter line": when this file is run as
%% a program (./hello.erl), the system hands it to escript. The Erlang
%% comment character is %, not # or //. A "%%" comment is the usual style
%% for a comment on its own line.

%% Every Erlang function belongs to a module. An escript file does not need
%% a -module(...) line, but it is a module all the same.
%% -export lists the functions that other code (here: escript) may call.
%% "main/1" means the function named main that takes 1 argument; the number
%% is part of the function's name, so main/1 and main/2 are different
%% functions.
-export([main/1]).

%% main/1 is the ENTRY POINT. escript calls it with the command-line
%% arguments as a list of strings. The argument is called _Args: a name that
%% starts with an underscore tells the compiler (and the reader) that the
%% variable is not used. A name that starts with an uppercase letter is a
%% VARIABLE, which can be set only once, as in Prolog. A name that starts
%% with a lowercase letter, such as main or io, is an ATOM, a constant whose
%% value is its own name.
%% "->" separates the function head from its body, and "." ends the function
%% (the same role that "." has in Prolog; a semicolon would start another
%% clause of the same function, which is how Erlang does pattern matching
%% on arguments).
main(_Args) ->
    %% io:format(Format) calls the function format/1 of the module io.
    %% "io:format" is Module:Function, like java.io.PrintStream.printf, but
    %% every function is reached this way. The format string uses ~ for its
    %% directives, as printf uses %. "~n" prints a newline, the same as \n
    %% in C. Python's print and Java's println add the newline by
    %% themselves; Erlang does not, so ~n is required.
    io:format("Hello, World!~n").
