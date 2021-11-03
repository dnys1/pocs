rootProject.name = "smithy-dart"

pluginManagement {
    repositories {
        mavenCentral()
        maven("https://plugins.gradle.org/m2/")
        google()
        gradlePluginPortal()
    }

    // configure default plugin versions
    plugins {
        val kotlinVersion: String by settings
        val smithyGradleVersion: String by settings
        id("org.jetbrains.kotlin.jvm") version kotlinVersion
        id("software.amazon.smithy") version smithyGradleVersion
    }
}