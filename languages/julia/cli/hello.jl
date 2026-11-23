# hello.jl - Hello World in Julia.
#
# Run it with: julia --startup-file=no hello.jl   (or ./run.sh)
# There is no build step. Julia compiles each function with its just-in-time (JIT)
# compiler the first time the program calls it, so the file runs as a script.

# println is a function of Base, the module that Julia loads before your code.
# No import is needed. C, by contrast, needs #include <stdio.h> before printf.
# It writes the text and a newline to standard output, so the program prints one line.
# Strings use double quotes. Single quotes make one character, as in 'H'.
# There is no main function and no class: the top-level statements run in order.
println("Hello, World!")
