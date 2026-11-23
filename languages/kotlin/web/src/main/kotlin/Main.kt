// Main.kt - Kotlin web: a web server that answers "Hello, World!".
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// The server listens on http://localhost:8080/ (change it with PORT=9000).

// Imports name the Ktor classes and functions the program uses. The last
// three are extension functions: functions that Ktor adds to existing
// classes from outside, so that "call.respondText(...)" reads like a method
// of the call object. Java has no such feature; Spring Boot uses
// annotations instead (see ../../java/web).
import io.ktor.http.ContentType
import io.ktor.server.application.call
import io.ktor.server.engine.embeddedServer
import io.ktor.server.netty.Netty
import io.ktor.server.response.respondText
import io.ktor.server.routing.get
import io.ktor.server.routing.routing

fun main() {
    // The port comes from the environment variable PORT, or is 8080.
    // "?:" is the Elvis operator: it takes the left value, or the right
    // one when the left is null. System.getenv returns null for an unset
    // variable. "toInt()" converts the text to a number, as Java's
    // Integer.parseInt does.
    val port = System.getenv("PORT")?.toInt() ?: 8080

    // embeddedServer creates the server inside this program: there is no
    // separate web server to install, as in Spring Boot with Tomcat.
    //   Netty     - the engine that handles the network connections
    //   port      - a named argument: the name is written at the call
    //   host      - 127.0.0.1 accepts connections from this computer only
    // The code in braces after the parentheses configures the application.
    // start(wait = true), at the end, opens the port and keeps main waiting,
    // so the server runs until the process is stopped (Ctrl+C). Without
    // wait, main would return and the program would end.
    // This is a "trailing lambda": a block of code passed as the last
    // argument, outside the parentheses.
    embeddedServer(Netty, port = port, host = "127.0.0.1") {
        // routing { ... } defines which code answers which URL.
        routing {
            // GET requests for "/" run the block. "call" is the current
            // request and its response. respondText sends text; the
            // content type text/html makes the browser render the <p> tag
            // (as plain text it would show the tag). Ktor adds the
            // charset (UTF-8) for text types by itself. respondText is
            // a suspend function, which may pause the coroutine while the
            // data is sent, so the thread stays free for other requests.
            get("/") {
                call.respondText("<p>Hello, World!</p>", ContentType.Text.Html)
            }
        }
    }.start(wait = true) // opens the port; wait = true keeps main from returning
}
