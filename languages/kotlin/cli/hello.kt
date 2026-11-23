// hello.kt - Kotlin cli: print "Hello, World!" to the terminal.
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// By hand (from the cli/ folder):
//   kotlinc hello.kt -include-runtime -d build/hello.jar
//   java -jar build/hello.jar

// A Kotlin file may hold functions that belong to no class. Java requires a
// class around every method, and Java 21 still needs "public static void
// main(String[] args)" for a program to start. Kotlin's entry point is a
// top-level function named main: no class, no "public" (declarations are
// public by default), no "static", and no return type (a function that
// returns nothing needs none). Parameters are optional too: the
// "String[] args" that Java demands is left out because this program does
// not read the command line. The compiler wraps the function in a class
// named after the file (HelloKt) and writes it into the jar.
fun main() {
    // println is a function of Kotlin's standard library. It prints the text
    // and then a line break, like Java's System.out.println, but it needs
    // no System.out and no import. Compare Python's print(...).
    // There is no semicolon: a line break ends a statement. Kotlin allows
    // semicolons, but nobody writes them. Strings use double quotes, as in
    // Java, C and C++.
    println("Hello, World!")
}
