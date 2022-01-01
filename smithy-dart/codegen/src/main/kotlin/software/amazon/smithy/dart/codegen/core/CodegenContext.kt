/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

package software.amazon.smithy.dart.codegen.core

import software.amazon.smithy.codegen.core.SymbolProvider
import software.amazon.smithy.dart.codegen.DartSettings
import software.amazon.smithy.model.Model
import software.amazon.smithy.model.shapes.Shape

/**
 * Common codegen properties required across different codegen contexts
 */
interface CodegenContext {
    val model: Model
    val symbolProvider: SymbolProvider
    val settings: DartSettings
}

/**
 * Base generation context
 */
data class GenerationContext(
    override val model: Model,
    override val symbolProvider: SymbolProvider,
    override val settings: DartSettings
) : CodegenContext

/**
 * Convert this context into a context for rendering a specific shape
 */
fun <T : Shape> CodegenContext.toRenderingContext(writer: DartWriter, forShape: T? = null): RenderingContext<T> =
    RenderingContext(this, writer, forShape)

/**
 * Context passed to an individual generator for rendering (writing) a shape
 */
data class RenderingContext<T : Shape>(
    // writer to render to
    val writer: DartWriter,
    // shape to render for
    val shape: T?,
    override val model: Model,
    override val symbolProvider: SymbolProvider,
    override val settings: DartSettings
) : CodegenContext {

    constructor(otherCtx: CodegenContext, writer: DartWriter, shape: T?) :
        this(writer, shape, otherCtx.model, otherCtx.symbolProvider, otherCtx.settings)
}
