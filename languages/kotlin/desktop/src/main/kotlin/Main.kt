// Main.kt - Kotlin desktop: open a window that shows "Hello, World!".
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// With the environment variable TF_VERIFY=1 the program also prints
// "Hello, World!" to the terminal and closes itself after about 2 seconds
// (used by ./run.sh --verify and by scripts/verify-all.sh).

// Imports name the Compose classes and functions the program uses. Kotlin
// imports a function by its name, because functions can live outside
// classes. Java imports only classes.
import androidx.compose.material.Text
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.window.Window
import androidx.compose.ui.window.application
import kotlinx.coroutines.delay

// main is again a top-level function, with no class around it (see
// ../../cli/hello.kt). "= application { ... }" is a function with one
// expression as its body: it returns what application returns, which is
// nothing here. application starts Compose and keeps the program alive
// until exitApplication() is called. Compare JavaFX and Swing in the Java
// folders: they need an Application subclass or a call to invokeLater.
fun main() = application {
    // True when the program was started by ./run.sh --verify.
    // System.getenv is a Java method: a Kotlin program calls the Java
    // library directly, with no wrapper. "val" declares a variable that
    // cannot be assigned again (Java's "final"); "var" would allow it. The
    // type, Boolean, is inferred from the right-hand side, so it is not
    // written, and "==" compares strings by content (Java needs equals).
    val verify = System.getenv("TF_VERIFY") == "1"

    // Window opens one native window. Its content is the block in braces.
    //   onCloseRequest - what to do when the user closes the window; ::name
    //                    is a reference to the function exitApplication
    //   title          - the text in the title bar
    Window(onCloseRequest = ::exitApplication, title = "Hello, World!") {
        // Text is a composable function: it describes a piece of the
        // screen. Compose calls it again when its inputs change (the UI
        // is declarative). Swing and JavaFX instead create label objects
        // and change them step by step.
        Text("Hello, World!")

        if (verify) {
            // LaunchedEffect runs its block once, after the window content
            // has been composed, in a coroutine: a function that can
            // pause without blocking a thread. So delay(2000) waits 2 s
            // while the window stays responsive.
            LaunchedEffect(Unit) {
                println("Hello, World!")
                delay(2000)
                exitApplication()
            }
        }
    }
}
