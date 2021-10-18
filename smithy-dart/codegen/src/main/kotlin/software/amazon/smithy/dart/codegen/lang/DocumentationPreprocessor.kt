/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

package software.amazon.smithy.dart.codegen.lang

import software.amazon.smithy.dart.codegen.DartSettings
import software.amazon.smithy.dart.codegen.integration.DartIntegration
import software.amazon.smithy.model.Model
import software.amazon.smithy.model.traits.DocumentationTrait
import software.amazon.smithy.model.transform.ModelTransformer

/**
 * Sanitize all instances of [DocumentationTrait]
 */
class DocumentationPreprocessor : DartIntegration {

    override fun preprocessModel(model: Model, settings: DartSettings): Model {
        val transformer = ModelTransformer.create()
        return transformer.mapTraits(model) { _, trait ->
            when (trait) {
                is DocumentationTrait -> {
                    val docs = sanitize(trait.value)
                    DocumentationTrait(docs, trait.sourceLocation)
                }
                else -> trait
            }
        }
    }

    // KDoc comments use inline markdown. Replace square brackets with escaped equivalents so that they
    // are not rendered as invalid links
    private fun sanitize(str: String): String =
        str.replace("[", "&#91;")
            .replace("]", "&#93;")
}
