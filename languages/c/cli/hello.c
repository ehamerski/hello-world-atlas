/*
 * hello.c - C cli: print "Hello, World!" to the terminal.
 *
 * Build and run it with ./build.sh and ./run.sh, which explain each step.
 * By hand (from the cli/ folder):
 *   cc -std=c89 -pedantic-errors -Wall -Wextra -o bin/hello-cli hello.c
 *   ./bin/hello-cli
 *
 * This file is written in ANSI C (C89, the first C standard). That is why
 * every comment uses slash-star ... star-slash: the one-line "//" comment
 * of C++, Java and Go only became legal C in C99. build.sh compiles with
 * -std=c89 -pedantic-errors, so any later feature is a compile error.
 */

/*
 * #include is a preprocessor directive: before compiling, the preprocessor
 * pastes the header file <stdio.h> ("standard input/output") here. The
 * header declares printf. Unlike Go's import or Java's import, it copies
 * text; the code of printf itself lives in the C library, which the linker
 * adds when it builds the executable.
 */
#include <stdio.h>

/*
 * The entry point. Every C program starts in a function called main.
 * "int" is its return type: main returns an exit status to the operating
 * system (0 means success). "(void)" says it takes no arguments; before
 * C23 an empty () meant "unknown arguments", not "none". Compare Go's
 * func main(), which returns nothing, and Java's main(String[] args),
 * which must sit inside a class. C has no classes.
 */
int main(void)
{
    /*
     * printf ("print formatted") writes to standard output. "\n" is the
     * line break: unlike Python's print or Go's Println, printf adds
     * nothing on its own. Every statement ends with a semicolon.
     */
    printf("Hello, World!\n");

    /*
     * The exit status. C89 does not define it if main ends without a
     * return; C99 made the end of main mean "return 0". This file
     * follows C89, so it says it explicitly.
     */
    return 0;
}
