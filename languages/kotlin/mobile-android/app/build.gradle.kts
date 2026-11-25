// app/build.gradle.kts - the app module: its Android settings and libraries.
// Gradle downloads the libraries the first time ./build.sh runs.

plugins {
    // Builds the app module as an Android application (an APK).
    id("com.android.application")

    // Compiles the @Composable functions of Jetpack Compose. Applied to this
    // module only, because the root build script only declares its version.
    id("org.jetbrains.kotlin.plugin.compose")
}

android {
    // The namespace is the Kotlin package of the generated R class. It is
    // separate from applicationId, which Android uses to identify the app.
    namespace = "com.example.hello"

    // The Android API level the code is compiled against. Compose 1.12 and
    // later require compileSdk 37 with AGP 9 (see the README).
    compileSdk = 37

    defaultConfig {
        // The name that identifies the app on the device and in the Play Store.
        applicationId = "com.example.hello"

        // The oldest Android API level that can install the app. Level 24 is
        // Android 7.0 (VERSION_CODES.N in the Android API reference).
        minSdk = 24

        // The Android version the app is tested against. A higher value tells
        // the system that the app follows newer behavior rules.
        targetSdk = 37

        // versionCode must increase with every release; versionName is for people.
        versionCode = 1
        versionName = "1.0"
    }

    buildFeatures {
        // Turns on the Compose code generation for this module.
        compose = true
    }
}

dependencies {
    // The Compose BOM (bill of materials) names one version for every Compose
    // library, so the libraries always match. The versions below come from it.
    implementation(platform("androidx.compose:compose-bom:2026.11.01"))

    // ui: the Compose runtime and drawing. material3: Material Design widgets.
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")

    // activity-compose: connects an Android Activity to Compose (setContent).
    // It is not in the BOM, so it has its own version.
    implementation("androidx.activity:activity-compose:1.13.0")
}
