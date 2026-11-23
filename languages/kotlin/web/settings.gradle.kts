// settings.gradle.kts - Gradle settings for the Kotlin web project.
// Gradle reads this file first. It says where plugins and libraries are
// downloaded from and names the project. The name decides the file name of
// the jar that the build writes (build/libs/hello-web-all.jar).

// Where Gradle finds the PLUGINS used in build.gradle.kts (the Kotlin
// compiler plugin, the Ktor plugin).
pluginManagement {
    repositories {
        gradlePluginPortal()
        mavenCentral()
    }
}

// Where Gradle finds the LIBRARIES the program depends on (Ktor, Netty).
dependencyResolutionManagement {
    repositories {
        mavenCentral()
    }
}

rootProject.name = "hello-web"
