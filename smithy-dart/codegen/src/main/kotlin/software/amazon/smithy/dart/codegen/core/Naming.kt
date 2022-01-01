/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

package software.amazon.smithy.dart.codegen.core

import software.amazon.smithy.dart.codegen.utils.splitOnWordBoundaries
import software.amazon.smithy.dart.codegen.utils.toCamelCase
import software.amazon.smithy.dart.codegen.utils.toPascalCase
import software.amazon.smithy.dart.codegen.lang.isValidDartIdentifier
import software.amazon.smithy.model.shapes.MemberShape
import software.amazon.smithy.model.shapes.OperationShape
import software.amazon.smithy.model.shapes.ServiceShape
import software.amazon.smithy.model.shapes.Shape
import software.amazon.smithy.model.traits.EnumDefinition
import software.amazon.smithy.utils.StringUtils
import java.util.logging.Logger

// (somewhat) centralized naming rules

/**
 * Get the default name for a shape (for code generation).  Delegates to
 * Smithy to rename shapes when configured to do so in the model.
 */
fun Shape.defaultName(serviceShape: ServiceShape?): String {
    return serviceShape?.let {
        id.getName(it).toPascalCase()
    } ?: id.name.toPascalCase()
}

/**
 * Get the default name for a member shape (for code generation)
 */
fun MemberShape.defaultName(): String = memberName.toCamelCase()

/**
 * Get the default name for an operation shape
 */
fun OperationShape.defaultName(): String = id.name.toCamelCase()

private fun String.sanitizeClientName(): String =
    replace(Regex("(API|Client|Service)\$", setOf(RegexOption.IGNORE_CASE)), "")

/**
 * Get the generated SDK service client name to use.
 * See https://awslabs.github.io/smithy/1.0/spec/aws/aws-core.html#using-sdk-service-id-for-client-naming
 *
 * @param raw The raw string that represents the service name (usually settings.sdkId)
 */
fun clientName(raw: String): String = raw.sanitizeClientName().toPascalCase()

/**
 * Capitalizes the string by upper-casing the first character and lower-casing the remainder.
 */
fun String.capitalize() = lowercase().replaceFirstChar { c -> c.uppercaseChar() }

/**
 * Transforms the string to snake_case.
 */
fun String.snakeCase() = splitOnWordBoundaries().joinToString("_") { it.lowercase() }

/**
 * Get the (un-validated) name of an enum variant from the trait definition
 */
fun EnumDefinition.variantName(): String {
    val identifier = name.orElseGet {
        // we don't want to be doing this...name your enums people
        Logger
            .getLogger("NamingUtils")
            .warning("Using EnumDefinition.value to derive generated identifier name: $value")
        value
    }
        .splitOnWordBoundaries()
        .fold(StringBuilder()) { acc, x ->
            val curr = if(acc.isEmpty()) x.lowercase() else x.capitalize()
            if (acc.isNotEmpty() && acc.last().isDigit() && x.first().isDigit()) {
                // split on word boundaries created distinct words for adjacent digits e.g. "11.4" -> ["11" "4"]
                // separate these out with _ as they are likely versions strings of some sort where a separation
                // gives meaning
                acc.append("_")
            }
            acc.append(curr)
            acc
        }.toString()
        .replace(Regex("([0-9]+_[0-9]+)([a-zA-Z])"), "$1_$2") // increase visual separation: "NodeJs_1_2Edge" -> "NodeJs_1_2_Edge"

    return when (isValidDartIdentifier(identifier)) {
        true -> identifier
        // suffix it with $
        false -> "$identifier\$"
    }
}

/**
 * Generate the union variant name from a union member shape
 * e.g. `VariantName`
 */
fun MemberShape.unionVariantName(): String = this.memberName.toPascalCase()

/**
 * Get the name of the middleware registration function for an operation
 * e.g. `register{OperationName}Middleware
 */
fun OperationShape.registerMiddlewareName(): String = "register${this.defaultName().replaceFirstChar(Char::uppercase)}Middleware"
