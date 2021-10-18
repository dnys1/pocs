/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

package software.amazon.smithy.dart.codegen.lang

import software.amazon.smithy.codegen.core.Symbol
import software.amazon.smithy.dart.codegen.model.buildSymbol

/**
 * Builtin dart:core types
 */
object DartTypes {
    val BigInt: Symbol = builtInSymbol("BigInt")
    val bool: Symbol = builtInSymbol("bool")
    val DateTime: Symbol = builtInSymbol("DateTime")
    val double: Symbol = builtInSymbol("double")
    val Duration: Symbol = builtInSymbol("Duration")
    val int: Symbol = builtInSymbol("int")
    val List: Symbol = builtInSymbol("List")
    val Map: Symbol = builtInSymbol("Map")
    val Null: Symbol = builtInSymbol("Null")
    val num: Symbol = builtInSymbol("num")
    val Object: Symbol = builtInSymbol("Object")
    val RegExp: Symbol = builtInSymbol("RegExp")
    val Set: Symbol = builtInSymbol("Set")
    val String: Symbol = builtInSymbol("String")
    val void: Symbol = builtInSymbol("void")


    /**
     * A (non-exhaustive) set of builtin dart:core symbols
     */
    val All: Set<Symbol> = setOf(
        Null,
        void,

        BigInt,
        bool,
        DateTime,
        Duration,
        DateTime,
        double,
        Duration,
        int,
        num,
        Object,
        RegExp,
        String,

        List,
        Map,
        Set,
    )
}

private fun builtInSymbol(symbol: String, ns: String = "dart.core"): Symbol = buildSymbol {
    name = symbol
    namespace = ns
    nullable = false
}

/**
 * Test if a string is a valid Dart identifier
 *
 * https://kotlinlang.org/spec/syntax-and-grammar.html#grammar-rule-Identifier
 */
fun isValidDartIdentifier(s: String): Boolean {
    s.forEachIndexed { idx, chr ->
        val isLetterOrUnderscore = chr.isLetter() || chr == '_'
        when (idx) {
            0 -> if (!isLetterOrUnderscore) return false
            else -> if (!isLetterOrUnderscore && !chr.isDigit()) return false
        }
    }
    return true
}

/**
 * Flag indicating if this symbol is a Kotlin built-in symbol
 */
val Symbol.isBuiltIn: Boolean
    get() = namespace.startsWith("dart.core")

/**
 * Escape characters in strings to ensure they are treated as pure literals.
 */
fun String.toEscapedLiteral(): String = replace("\$", "\\$")

/**
 * Return true if string is valid package namespace, false otherwise.
 */
fun String.isValidPackageName() = isNotEmpty() && all { it.isLetterOrDigit() || it == '.' }
