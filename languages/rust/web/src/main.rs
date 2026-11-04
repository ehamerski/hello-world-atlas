// main.rs - Rust web: a web server that answers "/" with <p>Hello, World!</p>.
//
// Build and run it with ../build.sh and ../run.sh, which explain each step.
// Then open http://localhost:8080/ in a browser.
// Rust's standard library has no HTTP server (unlike Go's net/http), so two
// crates do the work: Axum (routing) and Tokio (the async runtime).

// "use" brings names into scope, like Go's import or Python's from ... import.
// Paths are separated by "::"; braces import several names at once.
use axum::{Router, response::Html, routing::get};

// A handler: Axum calls it for every GET / request. "async fn" returns a
// future, a value that the runtime runs to completion later; while one
// request waits (for example, for the network), Tokio runs others on the
// same threads. The return type Html<&str> tells Axum to send the text with
// the header Content-Type: text/html. "&'static str" is a borrowed string
// that lives as long as the program: here a constant in the executable.
async fn hello() -> Html<&'static str> {
    // No "return" and no semicolon: in Rust a block's last expression is
    // its value, so this line is what the function returns.
    Html("<p>Hello, World!</p>")
}

// #[tokio::main] is an attribute macro. It wraps main in code that starts
// the Tokio runtime, because main itself cannot be async without one.
#[tokio::main]
async fn main() {
    // The port comes from the PORT environment variable (default 8080), as
    // in the Python, Java, and Go versions. env::var returns a Result (Ok
    // with the value, or Err if it is unset); unwrap_or_else picks a default
    // instead of failing. Rust has no null and no exceptions: missing values
    // and errors are ordinary return values that the compiler makes you handle.
    let port = std::env::var("PORT").unwrap_or_else(|_| "8080".to_string());

    // The router maps a path and an HTTP method to a handler. Only "/"
    // matches; any other path gets 404 Not Found.
    let app = Router::new().route("/", get(hello));

    // Listen on 127.0.0.1 (this computer only). ".await" waits for the
    // future to finish without blocking a thread. ".expect" stops the
    // program with this message if binding fails (e.g. the port is in use);
    // it is the short way to handle an error you cannot recover from.
    let addr = format!("127.0.0.1:{port}");
    let listener = tokio::net::TcpListener::bind(&addr)
        .await
        .expect("could not listen on the port (is it already in use?)");
    println!("Listening on http://localhost:{port}/");

    // Serve requests until the program is stopped (Ctrl+C).
    axum::serve(listener, app).await.expect("server error");
}
