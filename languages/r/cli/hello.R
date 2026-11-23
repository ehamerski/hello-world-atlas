# hello.R - R Hello World.
# A comment in R starts with # and runs to the end of the line.

# R is interpreted: Rscript reads this file and evaluates each expression
# from top to bottom. There is no main function and no compile step.

# writeLines writes each element of a character vector to standard output,
# followed by a newline. Here the vector has one element: a string.
# In R, a single string is already a character vector of length one.
writeLines("Hello, World!")

# cat("Hello, World!\n") prints the same line, but cat adds no newline:
# you write "\n" yourself. print("Hello, World!") would show the quotes and
# a [1] index prefix, because print shows the value as the console does.
