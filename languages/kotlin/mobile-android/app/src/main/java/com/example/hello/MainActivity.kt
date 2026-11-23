// MainActivity.kt - Kotlin Android: one screen that shows "Hello, World!".
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// The screen is drawn with Jetpack Compose: this file describes the screen,
// and Android draws it. In Java Android projects, an Activity would call
// setContentView with an XML layout instead.

// The package matches the namespace in app/build.gradle.kts and the folder
// com/example/hello. The manifest's ".MainActivity" is short for
// "com.example.hello.MainActivity", so without this line Android could not
// find the class and the app would not start.
package com.example.hello

// Imports name the classes and functions this file uses. Kotlin imports a
// function by its name, because functions can live outside classes.
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier

// An Activity is one screen of the app. Android creates an instance of this
// class when the user opens the app. ": ComponentActivity()" means the class
// extends ComponentActivity, the base class for Compose screens. Java writes
// this as "extends"; Kotlin writes a colon.
class MainActivity : ComponentActivity() {

    // onCreate runs once when the screen is created. "override" says that the
    // function replaces the one of the base class. "Bundle?" is a nullable
    // type: the saved state is null on the first start, so the type allows it.
    override fun onCreate(savedInstanceState: Bundle?) {
        // super.onCreate runs the base class's setup first. Kotlin, like Java,
        // needs it, and it is the first line of every onCreate.
        super.onCreate(savedInstanceState)

        // setContent receives the screen as a function. Everything inside the
        // braces describes what the screen shows. Compose calls it again when
        // the data it reads changes, so the code describes the screen rather
        // than changing views step by step.
        setContent {
            // MaterialTheme gives the text its Material 3 colors and fonts.
            // It also follows the device's light or dark setting.
            MaterialTheme {
                // Surface fills the screen with the theme's background color.
                // Modifier.fillMaxSize() makes it take the whole screen.
                Surface(modifier = Modifier.fillMaxSize()) {
                    // Box stacks its children on top of each other. The
                    // alignment centers the text horizontally and vertically.
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center,
                    ) {
                        // Text is a composable function: it draws the words
                        // in the middle of the box. This is the text that
                        // ./run.sh --verify looks for on the screen.
                        Text("Hello, World!")
                    }
                }
            }
        }
    }
}
