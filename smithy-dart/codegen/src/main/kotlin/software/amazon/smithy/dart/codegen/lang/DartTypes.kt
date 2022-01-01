/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

package software.amazon.smithy.dart.codegen.lang

import software.amazon.smithy.codegen.core.Symbol
import software.amazon.smithy.codegen.core.SymbolReference
import software.amazon.smithy.dart.codegen.model.DartPackage
import software.amazon.smithy.dart.codegen.model.buildSymbol
import sun.jvm.hotspot.debugger.cdbg.Sym

/**
 * Dart SDK types
 */
object DartTypes {
    // Core types
    val BigInt: Symbol = DartPackage.CORE.symbol("BigInt")
    val bool: Symbol = DartPackage.CORE.symbol("bool")
    val DateTime: Symbol = DartPackage.CORE.symbol("DateTime")
    val double: Symbol = DartPackage.CORE.symbol("double")
    val Duration: Symbol = DartPackage.CORE.symbol("Duration")
    val int: Symbol = DartPackage.CORE.symbol("int")
    fun List(ref: SymbolReference): Symbol = DartPackage.CORE.symbol("List", refs = listOf(ref))
    fun List(ref: Symbol): Symbol = List(SymbolReference(ref))
    fun Map(key: SymbolReference, value: SymbolReference): Symbol = DartPackage.CORE.symbol("Map", refs = listOf(key, value))
    fun Map(key: Symbol, value: Symbol): Symbol = Map(SymbolReference(key), SymbolReference(value))
    val Never: Symbol = DartPackage.CORE.symbol("Never")
    val Null: Symbol = DartPackage.CORE.symbol("Null")
    val num: Symbol = DartPackage.CORE.symbol("num")
    val Object: Symbol = DartPackage.CORE.symbol("Object")
    val RegExp: Symbol = DartPackage.CORE.symbol("RegExp")
    fun Set(ref: SymbolReference): Symbol = DartPackage.CORE.symbol("Set", refs = listOf(ref))
    fun Set(ref: Symbol): Symbol = Set(SymbolReference(ref))
    val String: Symbol = DartPackage.CORE.symbol("String")
    val void: Symbol = DartPackage.CORE.symbol("void")

    // Async types
    fun Future(ref: SymbolReference): Symbol = DartPackage.ASYNC.symbol("Future", refs = listOf(ref))
    fun Future(ref: Symbol): Symbol = Future(SymbolReference(ref))
    fun Stream(ref: SymbolReference): Symbol = DartPackage.ASYNC.symbol("Stream", refs = listOf(ref))
    fun Stream(ref: Symbol): Symbol = Stream(SymbolReference(ref))
}

/**
 * Test if a string is a valid Dart identifier
 *
 * https://kotlinlang.org/spec/syntax-and-grammar.html#grammar-rule-Identifier
 */
fun isValidDartIdentifier(s: String): Boolean {
    s.forEachIndexed { idx, chr ->
        val isLetterOrUnderscore = chr.isLetter() || chr == '_'
        return when (idx) {
            0 -> isLetterOrUnderscore
            else -> isLetterOrUnderscore || chr.isDigit()
        }
    }
    return true
}

/**
 * Flag indicating if this symbol is a Kotlin built-in symbol
 */
val Symbol.isBuiltIn: Boolean
    get() = getProperty("builtin").orElse(false) == true

/**
 * Escape characters in strings to ensure they are treated as pure literals.
 */
fun String.toEscapedLiteral(): String = replace("\$", "\\$")

/**
 * Return true if string is valid package namespace, false otherwise.
 */
fun String.isValidPackageName() = isNotEmpty() && all { it.isLetterOrDigit() || it == '_' }
