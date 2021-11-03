/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

package software.amazon.smithy.dart.codegen.rendering.protocol

import software.amazon.smithy.dart.codegen.model.expectTrait
import software.amazon.smithy.dart.codegen.model.hasTrait
import software.amazon.smithy.model.Model
import software.amazon.smithy.model.knowledge.HttpBinding
import software.amazon.smithy.model.knowledge.HttpBindingIndex
import software.amazon.smithy.model.knowledge.TopDownIndex
import software.amazon.smithy.model.shapes.*
import software.amazon.smithy.model.traits.HttpTrait
import software.amazon.smithy.model.traits.TimestampFormatTrait

/**
 * A generic subset of [HttpBinding] that is not specific to any protocol implementation.
 */
data class HttpBindingDescriptor(
    val member: MemberShape,
    val location: HttpBinding.Location,
    val locationName: String? = null
) {
    /**
     * @param Smithy [HttpBinding] to create from
     */
    constructor(httpBinding: HttpBinding) : this(httpBinding.member, httpBinding.location, httpBinding.locationName)

    val memberName: String = member.memberName
}

/**
 * Represents a protocol-specific implementation that resolves http binding data.
 * Smithy protocol implementations need to supply a protocol-specific implementation
 * of this type in order to use [HttpBindingProtocolGenerator].
 */
interface HttpBindingResolver {
    /**
     * Return from the model all operations with HTTP bindings (explicit/implicit/or assumed)
     */
    fun bindingOperations(): List<OperationShape>

    /**
     * Return HttpTrait data from an operation suitable for the protocol implementation.
     * @param operationShape [OperationShape] for which to retrieve the HttpTrait
     * @return [HttpTrait]

     */
    fun httpTrait(operationShape: OperationShape): HttpTrait

    /**
     * Return request bindings for an operation.
     * @param operationShape [OperationShape] for which to retrieve bindings
     * @return all found http request bindings
     */
    fun requestBindings(operationShape: OperationShape): List<HttpBindingDescriptor>

    /**
     * Return response bindings for an operation.
     * @param shape [Shape] for which to retrieve bindings
     * @return all found http response bindings
     */
    fun responseBindings(shape: Shape): List<HttpBindingDescriptor>

    /**
     * Determine the request content type for the protocol.
     *
     * @param operationShape [OperationShape] associated with content type
     * @return content type
     */
    fun determineRequestContentType(operationShape: OperationShape): String

    /**
     * Determine the timestamp format depending on input parameter values.
     *
     * @param member id of member
     * @param location location in the request for timestamp format
     * @param defaultFormat default value
     */
    fun determineTimestampFormat(
        member: ToShapeId,
        location: HttpBinding.Location,
        defaultFormat: TimestampFormatTrait.Format
    ): TimestampFormatTrait.Format
}

/**
 * @return true if the operation contains request data bound to the PAYLOAD or DOCUMENT locations
 */
fun HttpBindingResolver.hasHttpBody(operationShape: OperationShape): Boolean =
    requestBindings(operationShape).any {
        it.location == HttpBinding.Location.PAYLOAD || it.location == HttpBinding.Location.DOCUMENT
    }

/**
 * An Http Binding Resolver that relies on [HttpTrait] data from service models.
 * @param model Model
 * @param serviceShape service under which to find bindings
 * @param defaultContentType content-type
 * @param bindingIndex [HttpBindingIndex]
 * @param topDownIndex [TopDownIndex]
 */
class HttpTraitResolver(
    private val model: Model,
    private val serviceShape: ServiceShape,
    private val defaultContentType: String,
    private val bindingIndex: HttpBindingIndex = HttpBindingIndex.of(model),
    private val topDownIndex: TopDownIndex = TopDownIndex.of(model)
) : HttpBindingResolver {
    /**
     * @param ctx [ProtocolGenerator.GenerationContext]
     * @param defaultContentType content-type
     * @param bindingIndex [HttpBindingIndex]
     * @param topDownIndex [TopDownIndex]
     */
    constructor(
        ctx: ProtocolGenerator.GenerationContext,
        defaultContentType: String,
        bindingIndex: HttpBindingIndex = HttpBindingIndex.of(ctx.model),
        topDownIndex: TopDownIndex = TopDownIndex.of(ctx.model)
    ) : this(ctx.model, ctx.service, defaultContentType, bindingIndex, topDownIndex)

    override fun bindingOperations(): List<OperationShape> = topDownIndex
        .getContainedOperations(serviceShape)
        .filter { op -> op.hasTrait<HttpTrait>() }
        .toList<OperationShape>()

    override fun httpTrait(operationShape: OperationShape): HttpTrait = operationShape.expectTrait()

    override fun requestBindings(operationShape: OperationShape): List<HttpBindingDescriptor> = bindingIndex
        .getRequestBindings(operationShape)
        .values
        .map { HttpBindingDescriptor(it) }

    override fun responseBindings(shape: Shape): List<HttpBindingDescriptor> = when (shape) {
        is OperationShape,
        is StructureShape -> bindingIndex.getResponseBindings(shape.toShapeId()).values.map { HttpBindingDescriptor(it) }
        else -> error { "Unimplemented resolving bindings for ${shape.javaClass.canonicalName}" }
    }

    override fun determineRequestContentType(operationShape: OperationShape): String = bindingIndex
        .determineRequestContentType(operationShape, defaultContentType)
        .orElse(defaultContentType)

    override fun determineTimestampFormat(
        member: ToShapeId,
        location: HttpBinding.Location,
        defaultFormat: TimestampFormatTrait.Format
    ): TimestampFormatTrait.Format =
        bindingIndex.determineTimestampFormat(member, location, defaultFormat)
}
