package software.amazon.smithy.dart.codegen

import software.amazon.smithy.model.Model
import software.amazon.smithy.model.node.Node
import software.amazon.smithy.model.node.ObjectNode
import software.amazon.smithy.model.shapes.Shape

fun createModelFromShapes(vararg shapes: Shape): Model {
    return Model.assembler()
        .addShapes(*shapes)
        .assemble()
        .unwrap()
}

fun Model.defaultSettings(
    serviceShapeId: String = "com.test#Example",
    moduleName: String = "example",
    moduleVersion: String = "1.0.0",
    sdkId: String = "Example"
): DartSettings =
    DartSettings.from(
        this,
        getSettingsNode(serviceShapeId, moduleName, moduleVersion, sdkId)
    )

fun getSettingsNode(
    serviceShapeId: String = "com.test#Example",
    moduleName: String = "example",
    moduleVersion: String = "0.1.0",
    sdkId: String = "Example"
): ObjectNode {
    return Node.objectNodeBuilder()
        .withMember(SERVICE, Node.from(serviceShapeId))
        .withMember(PACKAGE_NAME, Node.from(moduleName))
        .withMember(PACKAGE_VERSION, Node.from(moduleVersion))
        .withMember(PACKAGE_DESCRIPTION, Node.from("A Smithy model"))
        .withMember(PACKAGE_HOMEPAGE, Node.from("https://github.com/awslabs/smithy-dart"))
        .withMember(PACKAGE_REPOSITORY, Node.from("https://github.com/awslabs/smithy-dart"))
        .withMember(PACKAGE_SDK_VERSION, Node.from("2.12.0"))
        .build()
}