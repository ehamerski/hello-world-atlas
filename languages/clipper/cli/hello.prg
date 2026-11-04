/*
 * hello.prg - Clipper cli: print "Hello, World!" to the terminal.
 *
 * Build and run it with ./build.sh and ./run.sh, which explain each step.
 * By hand (from the cli/ folder):
 *   hbmk2 -q0 -w3 -es2 -gtcgi hello.prg -obin/hello-cli
 *   ./bin/hello-cli
 *
 * This file is plain Clipper 5 code: CA-Clipper could compile it on
 * MS-DOS, and Harbour, Clipper's open-source successor, compiles it today.
 * Clipper source files end in .prg ("program"), a name inherited from
 * dBASE, the database language Clipper was first made to compile.
 *
 * Comments are written between slash-star and star-slash, as here, or after
 * "//" to the end of the line, like C and Java. The older dBASE forms "*"
 * at the start of a line and "&&" after a statement also work.
 */

// Code lives in PROCEDUREs and FUNCTIONs. Harbour starts the program at
// the one named Main() if there is one, otherwise at the first in the file.
// A PROCEDURE returns no value; a FUNCTION does. Unlike C there is no
// "int" or "void": Clipper is dynamically typed, like Python.
PROCEDURE Main()

   // "??" writes its value at the current position on the screen. "?"
   // with no value then starts a new line. The more common form is
   // ? "Hello, World!", but "?" writes the line break BEFORE its value,
   // so the output would begin with an empty line. Strings may use double
   // quotes, single quotes or [square brackets].
   // "?" and "??" are commands: the preprocessor (std.ch) turns them into
   // calls of the functions QOut() and QQOut(), so QQOut( "Hello, World!" )
   // would do the same. Like BASIC and Pascal, Clipper ignores case in
   // keywords and names: procedure, Procedure and PROCEDURE are one word.
   ?? "Hello, World!"
   ?

   // RETURN ends the procedure. Returning from Main() ends the program
   // with exit status 0 ("success").
   RETURN
