// main.rs - Rust cli: print "Hello, World!" to the terminal.
//
// Build and run it with ../build.sh and ../run.sh, which explain each step.
// By hand (from the cli/ folder):
//   cargo run --release      compile (if needed) and run
//   cargo build --release    compile to target/release/hello-cli

// The entry point. Cargo compiles src/main.rs into an executable, and the
// program starts by calling main(). "fn" declares a function. Like Go's
// func main(), it takes no parameters: arguments come from std::env::args().
// Unlike Java, no class is needed around it.
fn main() {
    // println! prints its text and a line break to standard output.
    // The "!" means println! is a macro, not a function: the compiler
    // expands it into code before compiling, and checks the format string
    // ("{}" placeholders) at compile time. Rust's standard library is
    // available without an import, so there is no "import fmt" as in Go.
    // The semicolon ends the statement; unlike Go, Rust needs it.
    println!("Hello, World!");
}
