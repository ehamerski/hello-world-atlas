// build.gradle.kts - Gradle build for the Kotlin desktop project.
// It declares which plugins and libraries the program needs. Gradle
// downloads them on the first build.

plugins {
    // Compiles Kotlin code for the JVM.
    kotlin("jvm") version "2.4.21"
    // The Compose compiler plugin: it rewrites @Composable functions. Its
    // version must equal the Kotlin version.
    id("org.jetbrains.kotlin.plugin.compose") version "2.4.21"
    // Compose Multiplatform: libraries, the `run` task and packaging.
    id("org.jetbrains.compose") version "1.12.2"
}

dependencies {
    // The Compose desktop libraries for the operating system that runs the
    // build (they contain native code for the window and for drawing).
    implementation(compose.desktop.currentOs)
}

compose.desktop {
    application {
        // The class that holds main(). For Main.kt, Kotlin names it MainKt.
        mainClass = "MainKt"
    }
}
