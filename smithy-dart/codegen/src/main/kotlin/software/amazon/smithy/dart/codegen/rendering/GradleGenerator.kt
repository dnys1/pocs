/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */
package software.amazon.smithy.dart.codegen.rendering

import software.amazon.smithy.build.FileManifest
import software.amazon.smithy.dart.codegen.DartSettings
import software.amazon.smithy.dart.codegen.core.*
import software.amazon.smithy.utils.CodeWriter

/**
 * Create the gradle build file for the generated code
 */
fun writeGradleBuild(
    settings: DartSettings,
    manifest: FileManifest,
    dependencies: List<DartDependency>
) {
    val writer = CodeWriter().apply {
        trimBlankLines()
        trimTrailingSpaces()
        setIndentText("    ")
        expressionStart = '#'
    }

    writer.withBlock("plugins {", "}\n") {
        if (settings.build.generateFullProject) {
            write("kotlin(\"jvm\") version #S", KOTLIN_COMPILER_VERSION)
        } else {
            write("kotlin(\"jvm\")")
        }
    }

    if (settings.build.generateFullProject) {
        writer.withBlock("repositories {", "}\n") {
            write("mavenLocal()")
            write("mavenCentral()")
        }
    }

    writer.withBlock("dependencies {", "}\n") {
        write("implementation(kotlin(\"stdlib\"))")
        // TODO - can we make kotlin dependencies not specify a version e.g. kotlin("kotlin-test")
        // TODO - Kotlin MPP setup (pass through KotlinSettings) - maybe separate gradle writers
        val orderedDependencies = dependencies.sortedWith(compareBy({ it.config }, { it.artifact }))
        for (dependency in orderedDependencies) {
            write("${dependency.config}(\"#L:#L:#L\")", dependency.group, dependency.artifact, dependency.version)
        }
    }

    writer.write("")
        .openBlock("tasks.test {")
        .write("useJUnitPlatform()")
        .openBlock("testLogging {")
        .write("""events("passed", "skipped", "failed")""")
        .write("showStandardStreams = true")
        .closeBlock("}")
        .closeBlock("}")

    val contents = writer.toString()
    manifest.writeFile("build.gradle.kts", contents)
    if (settings.build.generateFullProject) {
        manifest.writeFile("settings.gradle.kts", "")
    }
}
