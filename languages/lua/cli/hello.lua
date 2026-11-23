-- hello.lua - Lua cli: print "Hello, World!" to the terminal.
--
-- Run it with:  lua hello.lua   (or ./run.sh, which explains each step)
--
-- Lines that start with "--" are comments: Lua ignores them. Python and
-- Perl write comments as "# ...", and C, Java, and Go as "// ...".

-- print() is a function of Lua's base library: it is always available, so
-- nothing has to be imported first. In C, "#include <stdio.h>" is needed to
-- use printf, and in Java, System.out.println is called from inside a class.
--
-- Lua runs a file from top to bottom, so this single line IS the whole
-- program, as in Python. There is no main() entry point, no class, and no
-- semicolon (Lua allows one, but nobody writes it), unlike C, Java, or C#.
--
-- print() writes its arguments and then a newline ("\n"), like Python's
-- print and Java's println, and unlike C's printf, which needs an explicit
-- "\n". Strings use quotes, either "..." or '...'.
print("Hello, World!")
