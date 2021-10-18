/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

package software.amazon.smithy.dart.codegen.rendering.serde

import software.amazon.smithy.dart.codegen.core.RenderingContext
import software.amazon.smithy.dart.codegen.core.RuntimeTypes
import software.amazon.smithy.dart.codegen.core.addImport
import software.amazon.smithy.dart.codegen.model.getTrait
import software.amazon.smithy.dart.codegen.utils.dq
import software.amazon.smithy.model.shapes.MemberShape
import software.amazon.smithy.model.shapes.Shape
import software.amazon.smithy.model.traits.JsonNameTrait

/**
 * Field descriptor generator that processes the [jsonName trait](https://awslabs.github.io/smithy/1.0/spec/core/protocol-traits.html#jsonname-trait)
 */
open class JsonSerdeDescriptorGenerator(
    ctx: RenderingContext<Shape>,
    memberShapes: List<MemberShape>? = null
) : AbstractSerdeDescriptorGenerator(ctx, memberShapes) {

    override fun getFieldDescriptorTraits(
        member: MemberShape,
        targetShape: Shape,
        nameSuffix: String
    ): List<SdkFieldDescriptorTrait> {
        if (nameSuffix.isNotBlank()) return emptyList()

        ctx.writer.addImport(
            RuntimeTypes.Serde.SerdeJson.JsonDeserializer,
            RuntimeTypes.Serde.SerdeJson.JsonSerialName,
        )

        val serialName = member.getTrait<JsonNameTrait>()?.value ?: member.memberName
        return listOf(SdkFieldDescriptorTrait(RuntimeTypes.Serde.SerdeJson.JsonSerialName, serialName.dq()))
    }
}
