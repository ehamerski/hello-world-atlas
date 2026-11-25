// build.gradle.kts (root) - declares the Gradle plugins for the whole project.
// "apply false" means: make the plugin version known here, but do not apply
// it to the root project. The app module applies them (see app/build.gradle.kts).

plugins {
    // The Android Gradle plugin (AGP). It builds Android apps: it compiles
    // the code, merges the manifest, and packages the APK. Version 9 has
    // built-in Kotlin support, so the Kotlin Android plugin is not needed.
    id("com.android.application") version "9.5.2" apply false

    // The Compose compiler plugin: it rewrites the @Composable functions. Its
    // version must match the Kotlin version that the build uses.
    id("org.jetbrains.kotlin.plugin.compose") version "2.4.21" apply false
}
