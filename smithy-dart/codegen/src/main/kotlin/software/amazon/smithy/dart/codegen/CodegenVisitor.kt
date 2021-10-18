package software.amazon.smithy.dart.codegen

import software.amazon.smithy.build.FileManifest
import software.amazon.smithy.build.PluginContext
import software.amazon.smithy.codegen.core.SymbolProvider
import software.amazon.smithy.dart.codegen.core.DartDelegator
import software.amazon.smithy.dart.codegen.core.DartDependency
import software.amazon.smithy.dart.codegen.core.GenerationContext
import software.amazon.smithy.dart.codegen.core.toRenderingContext
import software.amazon.smithy.dart.codegen.integration.DartIntegration
import software.amazon.smithy.dart.codegen.model.OperationNormalizer
import software.amazon.smithy.dart.codegen.model.hasTrait
import software.amazon.smithy.dart.codegen.rendering.*
import software.amazon.smithy.dart.codegen.rendering.protocol.ApplicationProtocol
import software.amazon.smithy.dart.codegen.rendering.protocol.ProtocolGenerator
import software.amazon.smithy.model.Model
import software.amazon.smithy.model.knowledge.ServiceIndex
import software.amazon.smithy.model.neighbor.Walker
import software.amazon.smithy.model.shapes.*
import software.amazon.smithy.model.traits.EnumTrait
import software.amazon.smithy.model.transform.ModelTransformer
import java.util.*
import java.util.logging.Logger

class CodegenVisitor(context: PluginContext): ShapeVisitor.Default<Unit>() {

    private val logger = Logger.getLogger(javaClass.name)
    private val model: Model
    private val settings = DartSettings.from(context.model, context.settings)
    private val service: ServiceShape
    private val fileManifest: FileManifest = context.fileManifest
    private val symbolProvider: SymbolProvider
    private val writers: DartDelegator
    private val integrations: List<DartIntegration>
    private val protocolGenerator: ProtocolGenerator?
    private val applicationProtocol: ApplicationProtocol
    private val baseGenerationContext: GenerationContext

    init {
        val classLoader = context.pluginClassLoader.orElse(javaClass.classLoader)
        logger.info("Discovering DartIntegration providers...")
        integrations = ServiceLoader.load(DartIntegration::class.java, classLoader)
            .also { integration -> logger.info("Loaded DartIntegration: ${integration.javaClass.name}") }
            .filter { integration -> integration.enabledForService(context.model, settings) }
            .also { integration -> logger.info("Enabled DartIntegration: ${integration.javaClass.name}") }
            .sortedBy(DartIntegration::order)
            .toList()

        logger.info("Pre-processing model...")
        var resolvedModel = context.model
        for (integration in integrations) {
            resolvedModel = integration.preprocessModel(resolvedModel, settings)
        }

        // normalize operations
        model = OperationNormalizer.transform(resolvedModel, settings.service)

        service = settings.getService(model)

        symbolProvider = integrations.fold(
            DartCodegenPlugin.createSymbolProvider(model, settings)
        ) { provider, integration ->
            integration.decorateSymbolProvider(settings, model, provider)
        }

        writers = DartDelegator(settings, model, fileManifest, symbolProvider, integrations)

        protocolGenerator = resolveProtocolGenerator(integrations, model, service, settings)
        applicationProtocol = protocolGenerator?.applicationProtocol ?: ApplicationProtocol.createDefaultHttpApplicationProtocol()

        baseGenerationContext = GenerationContext(model, symbolProvider, settings, protocolGenerator, integrations)
    }

    private fun resolveProtocolGenerator(
        integrations: List<DartIntegration>,
        model: Model,
        service: ServiceShape,
        settings: DartSettings
    ): ProtocolGenerator? {
        val generators = integrations.flatMap { it.protocolGenerators }.associateBy { it.protocol }
        val serviceIndex = ServiceIndex.of(model)

        try {
            val protocolTrait = settings.resolveServiceProtocol(serviceIndex, service, generators.keys)
            return generators[protocolTrait]
        } catch (ex: UnresolvableProtocolException) {
            logger.warning("Unable to find protocol generator for ${service.id}: ${ex.message}")
        }
        return null
    }

    fun execute() {
        logger.info("Generating Dart client for service ${settings.service}")

        logger.info("Walking shapes from ${settings.service} to find shapes to generate")
        val modelWithoutTraits = ModelTransformer.create().getModelWithoutTraitShapes(model)
        val serviceShapes = Walker(modelWithoutTraits).walkShapes(service)
        serviceShapes.forEach { it.accept(this) }

        protocolGenerator?.apply {
            val ctx = ProtocolGenerator.GenerationContext(
                settings,
                model,
                service,
                symbolProvider,
                integrations,
                protocol,
                writers
            )

            logger.info("[${service.id}] Generating serde for protocol $protocol")
            generateSerializers(ctx)
            generateDeserializers(ctx)

            logger.info("[${service.id}] Generating unit tests for protocol $protocol")
            generateProtocolUnitTests(ctx)

            logger.info("[${service.id}] Generating service client for protocol $protocol")
            generateProtocolClient(ctx)
        }

        if (settings.build.generateFullProject) {
            val dependencies = writers.dependencies
                .map { it.properties["dependency"] as DartDependency }
                .distinct()
            writeGradleBuild(settings, fileManifest, dependencies)
        }

        // write files defined by integrations
        integrations.forEach { it.writeAdditionalFiles(baseGenerationContext, writers) }

        writers.flushWriters()
    }

    override fun getDefault(shape: Shape?) { }

    override fun structureShape(shape: StructureShape) {
        writers.useShapeWriter(shape) {
            val renderingContext = baseGenerationContext.toRenderingContext(it, shape)
            StructureGenerator(renderingContext).render()
        }
    }

    override fun stringShape(shape: StringShape) {
        if (shape.hasTrait<EnumTrait>()) {
            writers.useShapeWriter(shape) { EnumGenerator(shape, symbolProvider.toSymbol(shape), it).render() }
        }
    }

    override fun unionShape(shape: UnionShape) {
        writers.useShapeWriter(shape) { UnionGenerator(model, symbolProvider, it, shape).render() }
    }

    override fun serviceShape(shape: ServiceShape) {
        if (service != shape) {
            logger.fine("Skipping `${shape.id}` because it is not `${service.id}`")
            return
        }

        writers.useShapeWriter(shape) {
            val renderingCtx = baseGenerationContext.toRenderingContext(it, shape)
            ServiceGenerator(renderingCtx).render()
        }

        // render the service (client) base exception type
        val baseExceptionSymbol = ExceptionBaseClassGenerator.baseExceptionSymbol(baseGenerationContext.settings)
        writers.useFileWriter("${baseExceptionSymbol.name}.kt", baseExceptionSymbol.namespace) { writer ->
            ExceptionBaseClassGenerator.render(baseGenerationContext, writer)
        }
    }
}