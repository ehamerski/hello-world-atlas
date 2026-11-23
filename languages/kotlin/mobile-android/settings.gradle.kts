// settings.gradle.kts - Gradle settings for the Android project.
// Gradle reads this file first. It says where plugins and libraries are
// downloaded from, which modules belong to the build, and the project name.

// Where Gradle finds the PLUGINS used in build.gradle.kts (the Android
// Gradle plugin and the Compose compiler plugin). Google's repository holds
// the Android plugins and libraries; Maven Central and the Gradle plugin
// portal hold the rest.
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// Where Gradle finds the LIBRARIES the app depends on (Compose, activity).
// FAIL_ON_PROJECT_REPOS stops a module from adding its own repositories, so
// every download is listed here in one place.
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

// The name of the project. It is used for build output and in the IDE.
rootProject.name = "hello-android"

// The one module of this project: the app in the app/ folder.
include(":app")
