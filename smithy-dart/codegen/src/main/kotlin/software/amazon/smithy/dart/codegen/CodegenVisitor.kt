package software.amazon.smithy.dart.codegen

import software.amazon.smithy.build.FileManifest
import software.amazon.smithy.build.PluginContext
import software.amazon.smithy.codegen.core.SymbolProvider
import software.amazon.smithy.dart.codegen.core.DartDelegator
import software.amazon.smithy.dart.codegen.core.DartDependency
import software.amazon.smithy.dart.codegen.core.GenerationContext
import software.amazon.smithy.dart.codegen.core.toRenderingContext
import software.amazon.smithy.dart.codegen.model.OperationNormalizer
import software.amazon.smithy.dart.codegen.model.hasTrait
import software.amazon.smithy.dart.codegen.rendering.*
import software.amazon.smithy.model.Model
import software.amazon.smithy.model.neighbor.Walker
import software.amazon.smithy.model.shapes.*
import software.amazon.smithy.model.traits.EnumTrait
import software.amazon.smithy.model.transform.ModelTransformer
import java.util.logging.Logger

class CodegenVisitor(context: PluginContext): ShapeVisitor.Default<Unit>() {

    private val logger = Logger.getLogger(javaClass.name)
    private val model: Model
    private val settings = DartSettings.from(context.model, context.settings)
    private val service: ServiceShape
    private val fileManifest: FileManifest = context.fileManifest
    private val symbolProvider: SymbolProvider
    private val writers: DartDelegator
    private val baseGenerationContext: GenerationContext

    init {
        val resolvedModel = context.model

        // normalize operations
        model = OperationNormalizer.transform(resolvedModel, settings.service)

        service = settings.getService(model)
        symbolProvider = DartCodegenPlugin.createSymbolProvider(model, settings)
        writers = DartDelegator(settings, model, fileManifest, symbolProvider)
        baseGenerationContext = GenerationContext(model, symbolProvider, settings)
    }

    fun execute() {
        logger.info("Generating Dart client for service ${settings.service}")

        logger.info("Walking shapes from ${settings.service} to find shapes to generate")
        val modelWithoutTraits = ModelTransformer.create().getModelWithoutTraitShapes(model)
        val serviceShapes = Walker(modelWithoutTraits).walkShapes(service)
        serviceShapes.forEach { it.accept(this) }

        writers.flushWriters()
    }

    override fun getDefault(shape: Shape?) { }

    override fun structureShape(shape: StructureShape) {
//        writers.useShapeWriter(shape) {
//            val renderingContext = baseGenerationContext.toRenderingContext(it, shape)
//            StructureGenerator(renderingContext).render()
//        }
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

//        writers.useShapeWriter(shape) {
//            val renderingCtx = baseGenerationContext.toRenderingContext(it, shape)
//            ServiceGenerator(renderingCtx).render()
//        }
    }
}