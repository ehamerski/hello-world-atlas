// settings.gradle.kts - Gradle settings for the Kotlin desktop project.
// Gradle reads this file first. It says where plugins and libraries are
// downloaded from and names the project. Kotlin uses the Kotlin language
// for build scripts too (.kts = Kotlin script); Maven used XML (pom.xml).

// Where Gradle finds the PLUGINS used in build.gradle.kts (the Kotlin
// compiler plugin, the Compose plugin).
pluginManagement {
    repositories {
        gradlePluginPortal()
        mavenCentral()
        google()
    }
}

// Where Gradle finds the LIBRARIES the program depends on (Compose).
dependencyResolutionManagement {
    repositories {
        mavenCentral()
        google()
    }
}

// The name of the project, used for build output such as the jar file.
rootProject.name = "hello-compose"
