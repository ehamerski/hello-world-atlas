// hello.scala - Scala cli: print "Hello, World!" to the terminal.
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// By hand (from the cli/ folder):
//   mkdir -p build
//   scalac -d build hello.scala
//   scala run --main-class hello --classpath build

// @main is a Scala 3 annotation. It turns the method below into the entry
// point of the program, at the top level of the file: no class or object
// around it, and no "String[] args" parameter, because this program does
// not read the command line.
// In Scala 2 (and Scala 3 still accepts it) you wrote an object with a
//   def main(args: Array[String]): Unit
// method, or an object that extended App. Java 21 needs a class and
// "public static void main" in every program.
// Source: https://docs.scala-lang.org/scala3/book/methods-main-methods.html
@main def hello(): Unit =
  // println prints the text and then a line break. Every Scala file can
  // call it without an import, so it needs no System.out.
  // Compare Java's System.out.println.
  // The ": Unit" above is the return type. Unit means "no useful value",
  // like void in Java and C. The "=" and the indented line that follows
  // are the method body. Scala 3 reads the indentation, so it needs no
  // braces, and a line break ends a statement: no semicolon.
  // Strings use double quotes, as in Java.
  println("Hello, World!")
