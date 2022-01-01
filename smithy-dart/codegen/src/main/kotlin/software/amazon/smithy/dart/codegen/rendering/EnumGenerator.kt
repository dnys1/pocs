/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */
package software.amazon.smithy.dart.codegen.rendering

import software.amazon.smithy.codegen.core.CodegenException
import software.amazon.smithy.codegen.core.Symbol
import software.amazon.smithy.dart.codegen.core.*
import software.amazon.smithy.dart.codegen.lang.DartTypes
import software.amazon.smithy.dart.codegen.lang.isValidDartIdentifier
import software.amazon.smithy.dart.codegen.model.boxed
import software.amazon.smithy.dart.codegen.model.expectTrait
import software.amazon.smithy.dart.codegen.model.hasTrait
import software.amazon.smithy.model.shapes.StringShape
import software.amazon.smithy.model.traits.EnumDefinition
import software.amazon.smithy.model.traits.EnumTrait

/**
 * Generates a Dart sealed class from a Smithy enum string
 *
 * For example, given the following Smithy model:
 *
 * ```
 * @enum("YES": {}, "NO": {})
 * string SimpleYesNo
 *
 * @enum("Yes": {name: "YES"}, "No": {name: "NO"})
 * string TypedYesNo
 * ```
 *
 * We will generate the following Kotlin code:
 *
 * ```dart
 * ```
 */
class EnumGenerator(val shape: StringShape, val symbol: Symbol, val writer: DartWriter) {

    // generated enum names must be unique, keep track of what we generate to ensure this.
    // Necessary due to prefixing and other name manipulation to create either valid identifiers
    // and idiomatic names
    private val generatedNames = mutableSetOf<String>()

    init {
        assert(shape.hasTrait<EnumTrait>())
    }

    private val enumTrait: EnumTrait by lazy {
        shape.expectTrait()
    }

    fun render() {
        writer.renderDocumentation(shape)
        writer.renderAnnotations(shape)
        // NOTE: The smithy spec only allows string shapes to apply to a string shape at the moment
        writer.withBlock("class ${symbol.name} extends SmithyEnum<${symbol.name}> {", "}") {
            val sortedDefinitions = enumTrait
                .values
                .sortedBy { it.name.orElse(it.value) }

            // Render private constructor
            writer.withBlock("const #T._(int index, String name, String value)", "", symbol) {
                write(": super(index, name, value);")
            }

            // Render the `unknown` constructor
            writer.write("const #T.unknown(String value) : super.unknown(value);", symbol)

            sortedDefinitions.forEachIndexed { index, enumDefinition ->
                generateEnumVariant(index, enumDefinition)
            }

            writer.docs {
                write("All values of [#T].", symbol)
            }
            openBlock("static #T values = [", DartTypes.List(symbol))
                .call {
                    sortedDefinitions.forEach {
                        val variantName = getVariantName(it)
                        write("${variantName},")
                    }
                }
                .closeBlock("];")

            // Create `toString` override
            write("")
            writer.write("@override\n#T toString() => value;", DartTypes.String)
        }

        writer.withBlock("extension \$#T on #T {", "}", symbol, DartTypes.List(symbol)) {
            // Generate `byName` utility
            write(
                "#T byName(#T name) => firstWhereOrNull((el) => el.name == name);",
                symbol.boxed(),
                DartTypes.String.boxed(),
            )

            // Generate `byValue` utility
            writer.withBlock(
                "#T byValue(#T value) {", "}",
                symbol.boxed(),
                DartTypes.String.boxed(),
            ) {
                write("if (value == null) return null;")
                withBlock("return firstWhere(", ");") {
                    write("(el) => el.value == value,")
                    write("orElse: () => #T.unknown(value),", symbol)
                }
            }
        }
    }

    private fun generateEnumVariant(index: Int, definition: EnumDefinition) {
        writer.renderEnumDefinitionDocumentation(definition)
        val variantName = getVariantName(definition)
        if (!generatedNames.add(variantName)) {
            throw CodegenException("prefixing invalid enum value to form a valid Kotlin identifier causes generated sealed class names to not be unique: $variantName; shape=$shape")
        }

        writer.write(
            "static const $variantName = " +
                    "${symbol.name}._(#L, #S, #S);", index, variantName, definition.value
        )
    }

    private fun getVariantName(definition: EnumDefinition): String {
        val identifierName = definition.variantName()
        if (identifierName == "unknown") {
            return "unknown$"
        }

        if (!isValidDartIdentifier(identifierName)) {
            // suffixing didn't fix it, this must be a value since EnumDefinition.name MUST be a valid identifier
            // already, see: https://awslabs.github.io/smithy/1.0/spec/core/constraint-traits.html#enum-trait
            throw CodegenException("$identifierName is not a valid Dart identifier and cannot be automatically fixed with a prefix. Fix by customizing the model for $shape or giving the enum definition a name.")
        }

        return identifierName
    }
}
