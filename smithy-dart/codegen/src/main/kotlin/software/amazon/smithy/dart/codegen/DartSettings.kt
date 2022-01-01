package software.amazon.smithy.dart.codegen

import software.amazon.smithy.codegen.core.CodegenException
import software.amazon.smithy.dart.codegen.lang.isValidPackageName
import software.amazon.smithy.dart.codegen.model.Environment
import software.amazon.smithy.dart.codegen.model.Pubspec
import software.amazon.smithy.dart.codegen.model.SemVer
import software.amazon.smithy.dart.codegen.utils.getOrNull
import software.amazon.smithy.model.Model
import software.amazon.smithy.model.knowledge.ServiceIndex
import software.amazon.smithy.model.node.ObjectNode
import software.amazon.smithy.model.node.StringNode
import software.amazon.smithy.model.shapes.ServiceShape
import software.amazon.smithy.model.shapes.Shape
import software.amazon.smithy.model.shapes.ShapeId
import java.util.*
import java.util.logging.Logger
import kotlin.streams.toList

// shapeId of service from which to generate an SDK
const val SERVICE = "service"
const val PACKAGE_NAME = "name"
const val PACKAGE_VERSION = "version"
const val PACKAGE_DESCRIPTION = "description"
const val PACKAGE_HOMEPAGE = "homepage"
const val PACKAGE_PUBLISH_TO = "publish_to"
const val PACKAGE_REPOSITORY = "repository"
const val PACKAGE_ISSUE_TRACKER = "issue_tracker"
const val PACKAGE_SDK_VERSION = "sdk_version"

class DartSettings(
    val service: ShapeId,
    val pubspec: Pubspec,
) {
    /**
     * Get the corresponding [ServiceShape] from a model.
     * @return Returns the found `Service`
     * @throws CodegenException if the service is invalid or not found
     */
    fun getService(model: Model): ServiceShape = model
        .getShape(service)
        .orElseThrow { CodegenException("Service shape not found: $service") }
        .asServiceShape()
        .orElseThrow { CodegenException("Shape is not a service: $service") }

    companion object {
        private val logger: Logger = Logger.getLogger(DartSettings::class.java.name)

        /**
         * Create settings from a configuration object node.
         *
         * @param model Model to infer the service from (if not explicitly set in config)
         * @param config Config object to load
         * @throws software.amazon.smithy.model.node.ExpectationNotMetException
         * @return Returns the extracted settings
         */
        fun from(model: Model, config: ObjectNode): DartSettings {
            config.warnIfAdditionalProperties(listOf(
                SERVICE,
                PACKAGE_NAME,
                PACKAGE_VERSION,
                PACKAGE_DESCRIPTION,
                PACKAGE_HOMEPAGE,
                PACKAGE_PUBLISH_TO,
                PACKAGE_REPOSITORY,
                PACKAGE_SDK_VERSION,
            ))

            val serviceId = config.getStringMember(SERVICE)
                .map(StringNode::expectShapeId)
                .orElseGet { inferService(model) }

            val packageName = config.expectStringMember(PACKAGE_NAME).value
            if (!packageName.isValidPackageName()) {
                throw CodegenException("Invalid package name, is empty or has invalid characters: '$packageName'")
            }

            val version = SemVer.parse(config.expectStringMember(PACKAGE_VERSION).value)
            val desc = config.getStringMemberOrDefault(PACKAGE_DESCRIPTION, "$packageName client")
            val homepage = config.getStringMember(PACKAGE_HOMEPAGE).getOrNull()?.value
            val publishTo = config.getStringMember(PACKAGE_PUBLISH_TO).getOrNull()?.value
            val repository = config.getStringMember(PACKAGE_REPOSITORY).getOrNull()?.value
            val issueTracker = config.getStringMember(PACKAGE_ISSUE_TRACKER).getOrNull()?.value
            val sdkVersion = config.getStringMember(PACKAGE_SDK_VERSION).getOrNull()?.value

            return DartSettings(
                serviceId,
                Pubspec(
                    packageName,
                    version,
                    desc,
                    homepage,
                    publishTo,
                    repository,
                    issueTracker,
                    environment = Environment(
                        if (sdkVersion != null) SemVer.parse(sdkVersion) else SemVer(2, 12, 0)
                    ),
                ),
            )
        }

        // infer the service to generate from a model
        private fun inferService(model: Model): ShapeId {
            val services = model.shapes(ServiceShape::class.java)
                .map(Shape::getId)
                .sorted()
                .toList()

            when {
                services.isEmpty() -> {
                    throw CodegenException(
                        "Cannot infer a service to generate because the model does not " +
                                "contain any service shapes"
                    )
                }
                services.size > 1 -> {
                    throw CodegenException(
                        "Cannot infer service to generate because the model contains " +
                                "multiple service shapes: " + services
                    )
                }
                else -> {
                    val service = services[0]
                    logger.info("Inferring service to generate as: $service")
                    return service
                }
            }
        }
    }
}