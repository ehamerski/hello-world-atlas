# hello.exs - Elixir cli: print "Hello, World!" to the terminal.
#
# Run it with ./run.sh, which explains each step. By hand (from cli/):
#   elixir hello.exs
#
# A comment starts with "#" and runs to the end of the line, like in Python
# or Ruby. Elixir has no block comments.
#
# The extension is .exs, not .ex. Elixir treats both the same way; the
# difference is intention: ".ex" files are meant to be compiled (into
# .beam files) and ".exs" files are meant for scripting. The "elixir"
# command compiles a script in memory and runs it, so no file is written.
#
# Elixir runs on the BEAM, the Erlang virtual machine. The same virtual
# machine runs Erlang, so this program and ../../erlang/cli do the same work
# in the same runtime, with a different syntax.

# IO is a module (a named group of functions), here from Elixir's standard
# library. IO.puts is the function puts in the module IO: the dot picks a
# function out of a module, as in Python's "os.path", but there is no object
# here, only a function call.
# IO.puts writes its argument to the standard output and adds a newline,
# like println in Java or Go's fmt.Println.
# The text is a string in double quotes. An Elixir string is a UTF-8 encoded
# binary. Single quotes are not a second kind of string: they are an old
# spelling of a "charlist" (a list of numbers), which Elixir now warns about;
# the current spelling is ~c"...".
# Parentheses around the arguments are optional in Elixir, so
# IO.puts "Hello, World!" works too; the formatter keeps them for clarity.
# There is no main function and no semicolon: the file runs from top to
# bottom, like a Python script.
IO.puts("Hello, World!")
