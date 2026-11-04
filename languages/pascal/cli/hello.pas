{ hello.pas - Pascal cli: print "Hello, World!" to the terminal.

  Build and run it with ./build.sh and ./run.sh, which explain each step.
  By hand (from the cli/ folder):
    fpc -Miso -FEbin -FUbin -ohello-cli hello.pas
    ./bin/hello-cli

  This file is written in ISO 7185 Standard Pascal, the language much as
  Niklaus Wirth first defined it. -Miso switches Free Pascal to its ISO
  7185 mode, a little like -std=c89 in ../../c/cli. The desktop version
  (../desktop) uses Object Pascal, the extended dialect that Lazarus and
  Delphi use.

  Comments are written between curly braces, as here, or between (* and *).
  Unlike C's "//" or Fortran's "!", a Pascal comment has no "rest of the
  line" form in the standard: it always needs a closing brace. }

{ A Standard Pascal program starts with a header: the word "program", a
  name and the list of files the program uses. "output" is the standard
  output (the terminal). Free Pascal's own dialects also accept a program
  without a header. Unlike C, Java or Go there is no "main" function: the
  program's own body, below, is the entry point. }
program hello(output);

{ The statements of the program go between "begin" and "end". Pascal marks
  blocks with these words where C, Java and Go use curly braces (Pascal
  needs the braces for its comments). }
begin
  { writeln writes its arguments to "output" and then a line break; write
    would leave the line open. Strings use single quotes: 'a' is text,
    and Pascal has no double-quoted strings. Pascal ignores case, so
    WriteLn, WRITELN and writeln are the same word. }
  writeln('Hello, World!')
{ The program ends with "end" and a full stop. Semicolons SEPARATE
  statements in Pascal; they do not end them as in C. That is why there is
  no semicolon after the single writeln above. }
end.
