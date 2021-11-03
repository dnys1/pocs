/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */
package software.amazon.smithy.dart.codegen.rendering.protocol

import software.amazon.smithy.codegen.core.SymbolProvider
import software.amazon.smithy.dart.codegen.core.DartDependency
import software.amazon.smithy.dart.codegen.core.DartWriter
import software.amazon.smithy.model.Model
import software.amazon.smithy.model.shapes.OperationShape
import software.amazon.smithy.model.shapes.ServiceShape
import software.amazon.smithy.model.traits.IdempotencyTokenTrait
import software.amazon.smithy.protocoltests.traits.HttpMessageTestCase

/**
 * Abstract base implementation for protocol test generators to extend in order to generate HttpMessageTestCase
 * specific protocol tests.
 *
 * @param T Specific HttpMessageTestCase the protocol test generator is for.
 */
abstract class HttpProtocolUnitTestGenerator<T : HttpMessageTestCase>
protected constructor(builder: Builder<T>) {

    protected val symbolProvider: SymbolProvider = builder.symbolProvider!!
    protected val model: Model = builder.model!!
    protected val testCases: List<T> = builder.testCases!!
    protected val operation: OperationShape = builder.operation!!
    protected val writer: DartWriter = builder.writer!!
    protected val serviceShape: ServiceShape = builder.service!!

    protected val idempotentFieldsInModel: Boolean by lazy {
        operation.input.isPresent &&
            model.expectShape(operation.input.get()).members().any { it.hasTrait(IdempotencyTokenTrait.ID.name) }
    }

    /**
     * Render a test class and unit tests for the specified [testCases]
     */
    fun renderTestClass(testClassName: String) {
        writer.addImport(DartDependency.test.namespace, "Test")

        writer.write("")
            .openBlock("class $testClassName {")
            .call {
                for (test in testCases) {
                    renderTestFunction(test)
                }
            }
            .closeBlock("}")
    }

    protected open fun openTestFunctionBlock(): String = "{"

    /**
     * Write a single unit test function using the given [writer]
     */
    private fun renderTestFunction(test: T) {
        test.documentation.ifPresent {
            writer.dokka(it)
        }

        writer.write("@Test")
            .openBlock("fun `${test.id}`() ${openTestFunctionBlock()}")
            .call { renderTestBody(test) }
            .closeBlock("}")
    }

    /**
     * Render the body of a unit test
     */
    protected abstract fun renderTestBody(test: T)

    abstract class Builder<T : HttpMessageTestCase> {
        var symbolProvider: SymbolProvider? = null
        var model: Model? = null
        var testCases: List<T>? = null
        var operation: OperationShape? = null
        var writer: DartWriter? = null
        var service: ServiceShape? = null

        fun symbolProvider(provider: SymbolProvider): Builder<T> = apply { this.symbolProvider = provider }
        fun model(model: Model): Builder<T> = apply { this.model = model }
        fun testCases(testCases: List<T>): Builder<T> = apply { this.testCases = testCases }
        fun operation(operation: OperationShape): Builder<T> = apply { this.operation = operation }
        fun writer(writer: DartWriter): Builder<T> = apply { this.writer = writer }
        fun service(service: ServiceShape): Builder<T> = apply { this.service = service }
        abstract fun build(): HttpProtocolUnitTestGenerator<T>
    }
}
