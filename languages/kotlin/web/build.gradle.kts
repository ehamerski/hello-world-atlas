// build.gradle.kts - Gradle build for the Kotlin web project.
// It declares which plugins and libraries the server needs. Gradle
// downloads them on the first build.

plugins {
    // Compiles Kotlin code for the JVM.
    kotlin("jvm") version "2.4.21"
    // The Ktor Gradle plugin adds the buildFatJar task, which packs the
    // program and every library into one runnable jar.
    id("io.ktor.plugin") version "3.6.1"
}

// The class that holds main(). For Main.kt, Kotlin names it MainKt.
application {
    mainClass = "MainKt"
}

// The jar that ./build.sh creates is build/libs/hello-web-all.jar.
ktor {
    fatJar {
        archiveFileName.set("hello-web-all.jar")
    }
}

dependencies {
    // Ktor's server core: routing, call handling, responses.
    implementation("io.ktor:ktor-server-core:3.6.1")
    // The engine: Netty is the network library that accepts the HTTP
    // connections and hands each request to Ktor.
    implementation("io.ktor:ktor-server-netty:3.6.1")
    // Ktor logs through SLF4J. Without a logging library behind it, SLF4J
    // prints a warning and drops every message.
    implementation("ch.qos.logback:logback-classic:1.6.8")
}
