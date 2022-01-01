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
 * Create the pubspec.yaml file for the generated code
 */
fun writePubspec(
    settings: DartSettings,
    manifest: FileManifest,
    dependencies: List<DartDependency>
) {
    val writer = CodeWriter().apply {
        trimBlankLines()
        trimTrailingSpaces()
        setIndentText("  ")
        expressionStart = '#'
    }

    writer.write("name: #S", settings.pubspec.name)
    writer.write("version: #S", settings.pubspec.version)
    if (settings.pubspec.description != null) {
        writer.write("description: #S", settings.pubspec.description)
    }
    if (settings.pubspec.homepage != null) {
        writer.write("homepage: #S", settings.pubspec.homepage)
    }
    if (settings.pubspec.issueTracker != null) {
        writer.write("issue_tracker: #S", settings.pubspec.issueTracker)
    }
    if (settings.pubspec.publishTo != null) {
        writer.write("publish_to: #S", settings.pubspec.publishTo)
    }

    writer.withBlock("environment:", "") {
        writer.write("sdk: #S", settings.pubspec.environment.sdkConstraint)
    }

    writer.withBlock("dependencies:", "") {
        for (dependency in dependencies) {
            writer.write("#L: #S", dependency.packageName, dependency.version)
        }
    }
    
    val contents = writer.toString()
    manifest.writeFile("pubspec.yaml", contents)
}
