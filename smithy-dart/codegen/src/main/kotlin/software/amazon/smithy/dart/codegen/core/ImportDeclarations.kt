/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */
package software.amazon.smithy.dart.codegen.core

import software.amazon.smithy.codegen.core.Symbol

// Represents a namespace + name
typealias FullyQualifiedSymbolName = Pair<String, String>

internal fun Symbol.toFullyQualifiedSymbolName() = namespace to name

/**
 * Container and formatter for Dart imports
 */
class ImportDeclarations {

    fun addImport(packageName: String, symbolName: String, alias: String? = null) {
        imports.add(ImportStatement(packageName, symbolName, alias))
    }

    fun symbolCollides(packageName: String, symbolName: String): Boolean =
        imports.any { it.alias == null && it.symbolName == symbolName && it.packageName != packageName && symbolName != "*" }

    override fun toString(): String {
        if (imports.isEmpty()) {
            return ""
        }

        return imports
            .map(ImportStatement::statement)
            .sorted()
            .joinToString(separator = "\n")
    }

    private val imports: MutableSet<ImportStatement> = mutableSetOf()
}

private data class ImportStatement(val packageName: String, val symbolName: String, val alias: String? = null) {
    val statement: String
        get() {
            return if (alias != null && alias.isNotEmpty()) {
                "import 'package:$packageName/$packageName.dart' as $alias;"
            } else {
                "import 'package:$packageName/$packageName.dart';"
            }
        }

    override fun toString(): String = statement
}
