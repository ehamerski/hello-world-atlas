// Hello.java - Java cli: print "Hello, World!" to the terminal.
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// By hand, without Maven (from the cli/ folder):
//   javac -d out src/main/java/com/example/hello/Hello.java
//   java -cp out com.example.hello.Hello

// Every Java class lives in a package (a namespace). By convention the
// package name is a reversed domain name, and the folders must match it:
// com.example.hello -> src/main/java/com/example/hello/. Python and
// JavaScript files need no such declaration.
package com.example.hello;

// In Java all code lives inside a class. "public" means any other code may
// use it, and the file must be named after its public class: Hello.java.
// Compare: in Python the whole program is the single line print(...).
public class Hello {

    // The entry point. The java launcher looks for exactly this method:
    //   public  - callable from outside the class
    //   static  - runs without creating a Hello object first
    //   void    - returns nothing (the exit code is 0 unless something fails)
    //   String[] args - the command-line arguments (unused here)
    // C and C++ also start at a main function; Python just runs the file
    // from top to bottom.
    public static void main(String[] args) {
        // System.out is the standard output stream (the terminal).
        // println prints the text and then a line break. Every statement
        // ends with a semicolon, as in C, C++ and C#.
        System.out.println("Hello, World!");
    }
}
