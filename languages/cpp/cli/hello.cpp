// hello.cpp - C++ cli: print "Hello, World!" to the terminal.
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// By hand (from the cli/ folder):
//   cmake -S . -B build && cmake --build build
//   ./build/hello-cli
//
// This file is compiled as ISO C++20 (see CMakeLists.txt). C++ started as
// "C with Classes", and almost all of ../../c/cli/hello.c would compile
// here too. The comments below point out what C++ does differently.
// Even the "//" comment: C only adopted it in C99, and ../../c/cli
// (C89) rejects it on purpose.

// <iostream> declares std::cout, the standard output stream. Note the
// header name: C++ standard headers have no ".h". C's <stdio.h> is still
// available, as <cstdio>, so printf would work too.
#include <iostream>

// The entry point is main, exactly as in C. In C++ an empty () already
// means "no parameters", so the "(void)" of the C version is not needed.
int main()
{
    // std:: is a namespace: the standard library keeps its names inside
    // it, so they cannot clash with yours. C has no namespaces and uses
    // prefixes instead (GTK's gtk_, libmicrohttpd's MHD_).
    //
    // << is the "insertion" operator. The library overloads it for each
    // type, so the compiler picks the right version from the type of the
    // value: there is no "%s" or "%d" to get wrong, unlike C's printf.
    // As with printf, "\n" is the line break; nothing is added for you.
    std::cout << "Hello, World!\n";

    // No "return 0;": in C++ (and in C since C99) reaching the end of
    // main means "return 0", success.
}
