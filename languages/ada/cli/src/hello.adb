--  hello.adb - Ada cli: print "Hello, World!" to the terminal.
--
--  Build and run it with ./build.sh and ./run.sh, which explain each step.
--  By hand (from the cli/ folder):
--    alr build
--    ./bin/hello
--
--  Comments in Ada start with "--" and run to the end of the line (Ada has
--  no block comment like C's /* ... */). GNAT expects the file name to be
--  the unit name in lower case: procedure Hello lives in hello.adb.

--  A "with" clause names a library unit this file depends on. Ada.Text_IO
--  is the standard package for text input/output. Compare C's
--  #include <stdio.h> and Go's import "fmt". Unlike C, "with" does not paste
--  text: the compiler reads the package specification (a-textio.ads).
with Ada.Text_IO;

--  The main program is a procedure without parameters. Ada has no fixed
--  name such as "main": the build (hello.gpr, "for Main use") says which
--  procedure is the program. Ada ignores case: Hello and HELLO are the same.
procedure Hello is
   --  Declarations (variables, constants...) would go here, between "is"
   --  and "begin". This program needs none.
begin
   --  Put_Line writes the string to standard output and ends the line,
   --  like Python's print. The full name Ada.Text_IO.Put_Line says which
   --  package it comes from; a "use Ada.Text_IO;" clause would allow the
   --  short name Put_Line. Every statement ends with a semicolon.
   Ada.Text_IO.Put_Line ("Hello, World!");
--  "end Hello" repeats the name, so the compiler can check that blocks
--  are closed where the programmer meant.
end Hello;
