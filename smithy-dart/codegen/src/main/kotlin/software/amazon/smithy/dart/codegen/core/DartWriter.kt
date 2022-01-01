/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

package software.amazon.smithy.dart.codegen.core

import software.amazon.smithy.codegen.core.CodegenException
import software.amazon.smithy.codegen.core.Symbol
import software.amazon.smithy.codegen.core.SymbolDependency
import software.amazon.smithy.codegen.core.SymbolReference
import software.amazon.smithy.dart.codegen.lang.isBuiltIn
import software.amazon.smithy.dart.codegen.model.defaultValue
import software.amazon.smithy.dart.codegen.model.getTrait
import software.amazon.smithy.dart.codegen.model.isBoxed
import software.amazon.smithy.dart.codegen.model.isDeprecated
import software.amazon.smithy.dart.codegen.utils.getOrNull
import software.amazon.smithy.model.Model
import software.amazon.smithy.model.shapes.MemberShape
import software.amazon.smithy.model.shapes.Shape
import software.amazon.smithy.model.traits.DocumentationTrait
import software.amazon.smithy.model.traits.EnumDefinition
import software.amazon.smithy.utils.CodeWriter
import java.util.function.BiFunction

/**
 * Extension function that is more idiomatic Kotlin that is roughly the same purpose as
 * the provided function `openBlock(String textBeforeNewline, String textAfterNewline, Runnable r)`
 *
 * Example:
 * ```
 * writer.withBlock("{", "}") {
 *     write("foo")
 * }
 * ```
 *
 * Equivalent to:
 * ```
 * writer.openBlock("{")
 * writer.write("foo")
 * writer.closeBlock("}")
 * ```
 */
fun <T : CodeWriter> T.withBlock(
    textBeforeNewLine: String,
    textAfterNewLine: String,
    vararg args: Any,
    block: T.() -> Unit
): T = wrapBlockIf(true, textBeforeNewLine, textAfterNewLine, *args) { block(this) }

/**
 * Extension function that is more idiomatic Kotlin that is roughly the same purpose as an if block wrapped around
 * the provided function `openBlock(String textBeforeNewline, String textAfterNewline, Runnable r)`
 *
 * Example:
 * ```
 * writer.wrapBlockIf(foo == bar, "{", "}") {
 *     write("foo")
 * }
 * ```
 *
 * Equivalent to:
 * ```
 * if (foo == bar) writer.openBlock("{")
 * writer.write("foo")
 * if (foo == bar) writer.closeBlock("}")
 * ```
 */
fun <T : CodeWriter> T.wrapBlockIf(
    condition: Boolean,
    textBeforeNewLine: String,
    textAfterNewLine: String,
    vararg args: Any,
    block: T.() -> Unit,
): T {
    if (condition) openBlock(textBeforeNewLine, *args)
    block(this)
    if (condition) closeBlock(textAfterNewLine)
    return this
}

/**
 * Extension function that closes the previous block, dedents, opens a new block with [textBeforeNewLine], and indents.
 *
 * This is useful for chaining if-if-else-else branches.
 *
 * Example:
 * ```
 * writer.openBlock("if (foo) {")
 *     .write("foo()")
 *     .closeAndOpenBlock("} else {")
 *     .write("bar()")
 *     .closeBlock("}")
 * ```
 */
fun <T : CodeWriter> T.closeAndOpenBlock(
    textBeforeNewLine: String,
    vararg args: Any,
): T = apply {
    dedent()
    openBlock(textBeforeNewLine, *args)
    indent()
}

private fun <T : CodeWriter> T.removeContext(context: Map<String, Any?>): Unit =
    context.keys.forEach { key -> removeContext(key) }


// Convenience function to create symbol and add it as an import.
fun DartWriter.addImport(
    name: String,
    dependency: DartDependency,
    namespace: String = dependency.namespace,
): DartWriter {
    val importSymbol = Symbol.builder()
        .name(name)
        .namespace(namespace, ".")
        .addDependency(dependency)
        .build()

    addImport(importSymbol)
    return this
}

fun DartWriter.addImport(vararg imports: Symbol): DartWriter {
    imports.forEach { import -> addImport(import) }
    return this
}

fun DartWriter.addImport(imports: Iterable<Symbol>): DartWriter {
    imports.forEach { import -> addImport(import) }
    return this
}

fun DartWriter.addImport(vararg imports: Iterable<Symbol>): DartWriter {
    imports.forEach { importSet -> importSet.forEach { import -> addImport(import) } }
    return this
}

class DartWriter() : CodeWriter() {
    private val fullyQualifiedSymbols: MutableSet<FullyQualifiedSymbolName> = mutableSetOf()
    val dependencies: MutableSet<SymbolDependency> = mutableSetOf()
    private val imports = ImportDeclarations()

    init {
        trimBlankLines()
        trimTrailingSpaces()
        setIndentText("  ")
        expressionStart = '#'

        putFormatter('S', QuotedFormatter())

        // type name: `Foo`
        putFormatter('T', DartSymbolFormatter { symbol -> fullyQualifiedSymbols.contains(symbol.toFullyQualifiedSymbolName()) })
        // fully qualified type: `aws.sdk.kotlin.model.Foo`
        putFormatter('Q', DartSymbolFormatter { true })

        // like `T` but with nullability information: `aws.sdk.kotlin.model.Foo?`. This is mostly useful
        // when formatting properties
        putFormatter('P', DartPropertyFormatter())

        // like `P` but with default set (if applicable): `aws.sdk.kotlin.model.Foo = 1`
        putFormatter('D', DartPropertyFormatter(setDefault = true))

    }

    fun addImport(symbol: Symbol, alias: String = symbol.name): DartWriter {
        // don't import built-in symbols
        if (symbol.isBuiltIn) return this

        // always add dependencies
        dependencies.addAll(symbol.dependencies)

        // only add imports for symbols in a different namespace
        if (symbol.namespace.isNotEmpty()) {
            // Check to see if another symbol with the same name but different namespace
            // is already contained in imports.  If so, in codegen it will be fully qualified
            if (imports.symbolCollides(symbol.namespace, symbol.name)) {
                fullyQualifiedSymbols.add(symbol.toFullyQualifiedSymbolName())
            } else {
                imports.addImport(symbol.namespace, symbol.name, alias)
            }
        }
        return this
    }

    fun addImportReferences(symbol: Symbol, vararg options: SymbolReference.ContextOption) {
        symbol.references.forEach { reference ->
            for (option in options) {
                if (reference.hasOption(option)) {
                    addImport(reference.symbol, reference.alias)
                    break
                }
            }
        }
    }

    /**
     * Directly add an import
     */
    fun addImport(packageName: String, symbolName: String, alias: String = symbolName) {
        if (imports.symbolCollides(packageName, symbolName)) {
            fullyQualifiedSymbols.add(packageName to symbolName)
        } else {
            imports.addImport(packageName, symbolName, alias)
        }
    }

    override fun toString(): String {
        val contents = super.toString()
        val header = "// Code generated by smithy-kotlin-codegen. DO NOT EDIT!\n\n"
        val importStatements = "${imports}\n\n"
//        val pkgDecl = "library $fullPackageName\n\n"
        return header + importStatements + contents
    }

    /**
     * Configures the writer with the appropriate opening/closing doc comment lines and calls the [block]
     * with this writer. Any calls to `write()` inside of block will be escaped appropriately.
     * On return the writer's original state is restored.
     *
     * e.g.
     * ```
     * writer.dokka(){
     *     write("This is a doc comment")
     * }
     * ```
     *
     * would output
     *
     * ```
     * /**
     *  * This is a doc comment
     *  */
     * ```
     */
    fun docs(block: DartWriter.() -> Unit) {
        pushState()
        setNewlinePrefix("/// ")
        block(this)
        popState()
    }

    fun docs(docs: String) {
        docs {
            write(
                formatDocumentation(
                    sanitizeDocumentation(docs)
                )
            )
        }
    }

    /**
     * Adds appropriate annotations to generated declarations.
     */
    fun renderAnnotations(shape: Shape) {
        renderDeprecatedAnnotation(shape)
    }

    /**
     * Adds the `@Deprecated` annotation if appropriate.
     */
    private fun renderDeprecatedAnnotation(shape: Shape) {
        if (shape.isDeprecated) {
            write("""@Deprecated("No longer recommended for use. See API documentation for more details.")""")
        }
    }

    // handles the documentation for shapes
    fun renderDocumentation(shape: Shape) = shape.getTrait<DocumentationTrait>()?.let { docs(it.value) }

    // handles the documentation for member shapes
    fun renderMemberDocumentation(model: Model, shape: MemberShape) =
        shape.getMemberTrait(model, DocumentationTrait::class.java).getOrNull()?.let { docs(it.value) }

    // handles the documentation for enum definitions
    fun renderEnumDefinitionDocumentation(enumDefinition: EnumDefinition) {
        enumDefinition.documentation.ifPresent {
            write("")
            docs(it)
        }
    }
}

/**
 * Implements Dart symbol formatting for the `#T` and `#Q` formatter(s)
 */
private class DartSymbolFormatter(
    private val fullyQualifiedPredicate: (Symbol) -> Boolean = { false },
) : BiFunction<Any, String, String> {
    override fun apply(type: Any, indent: String): String {
        return when (type) {
            is Symbol -> printSymbol(type)
            else -> throw CodegenException("Invalid type provided for #T. Expected a Symbol, but found `$type`")
        }
    }
}

private class QuotedFormatter: BiFunction<Any, String, String> {
    override fun apply(t: Any, u: String): String = "'$t'"
}

fun printSymbol(symbol: Symbol): String {
    var name = symbol.name
    if (symbol.references.isNotEmpty()) {
        name = "${name}<${symbol.references.joinToString(",") { printSymbol(it.symbol) }}>"
    }
    return if (symbol.isBoxed) "$name?" else name
}

/**
 * Implements Dart symbol formatting for the `#D` and `#P` formatter(s)
 */
class DartPropertyFormatter(
    // set defaults
    private val setDefault: Boolean = false,
    // format with nullability `?`
    private val includeNullability: Boolean = true,
    // use fully qualified names
    private val fullyQualifiedNames: Boolean = false,
) : BiFunction<Any, String, String> {
    override fun apply(type: Any, indent: String): String {
        when (type) {
            is Symbol -> {
                var formatted = if (fullyQualifiedNames) type.fullName else type.name
                if (includeNullability && type.isBoxed) {
                    formatted += "?"
                }

                if (setDefault) {
                    type.defaultValue()?.let {
                        formatted += " = $it"
                    }
                }
                return formatted
            }
            else -> throw CodegenException("Invalid type provided for ${javaClass.name}. Expected a Symbol, but found `$type`")
        }
    }
}

// Most commonly occurring (but not exhaustive) set of HTML tags found in AWS models
private val commonHtmlTags = setOf(
    "a",
    "b",
    "code",
    "dd",
    "dl",
    "dt",
    "i",
    "important",
    "li",
    "note",
    "p",
    "strong",
    "ul"
).map { listOf("<$it>", "</$it>") }.flatten()

// Replace characters in the input documentation to prevent issues in codegen or rendering.
// NOTE: Currently we look for specific strings of Html tags commonly found in docs
//       and remove them.  A better solution would be to generally convert from HTML to "pure"
//       markdown such that formatting is preserved.
// TODO: https://github.com/awslabs/smithy-kotlin/issues/136
private fun sanitizeDocumentation(doc: String): String = doc
    .stripAll(commonHtmlTags)
    // Docs can have valid $ characters that shouldn't run through formatters.
    .replace("#", "##")
    // Services may have comment string literals embedded in documentation.
    .replace("/*", "&##47;*")
    .replace("*/", "*&##47;")

// Remove all strings from source string and return the result
private fun String.stripAll(stripList: List<String>): String {
    var newStr = this
    for (item in stripList) newStr = newStr.replace(item, "")

    return newStr
}

// Remove whitespace from the beginning and end of each line of documentation
// Remove blank lines
private fun formatDocumentation(doc: String, lineSeparator: String = "\n") =
    doc
        .split('\n') // Break the doc into lines
        .filter { it.isNotBlank() } // Remove empty lines
        .joinToString(separator = lineSeparator) { it.trim() } // Trim line

/**
 * Optionally call the [Runnable] if [test] is true, otherwise do nothing and return the instance without
 * running the block
 */
fun CodeWriter.callIf(test: Boolean, runnable: Runnable): CodeWriter {
    if (test) {
        runnable.run()
    }
    return this
}
