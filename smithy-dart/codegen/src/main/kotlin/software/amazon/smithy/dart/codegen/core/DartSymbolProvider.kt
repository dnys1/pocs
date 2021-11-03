package software.amazon.smithy.dart.codegen.core

import software.amazon.smithy.codegen.core.*
import software.amazon.smithy.dart.codegen.DartSettings
import software.amazon.smithy.dart.codegen.lang.dartReservedWords
import software.amazon.smithy.dart.codegen.model.*
import software.amazon.smithy.model.Model
import software.amazon.smithy.model.shapes.*
import software.amazon.smithy.model.traits.BoxTrait
import software.amazon.smithy.model.traits.SparseTrait
import software.amazon.smithy.model.traits.StreamingTrait
import java.util.logging.Logger

/**
 * Convert shapes to Dart types
 * @param model The smithy model to generate for
 * @param settings [DartSettings] associated with this codegen
 */
class DartSymbolProvider(private val model: Model, private val settings: DartSettings) :
    SymbolProvider,
    ShapeVisitor<Symbol> {
    private val rootNamespace = settings.pkg.name
    private val service = model.expectShape<ServiceShape>(settings.service)
    private val logger = Logger.getLogger(javaClass.name)
    private val escaper: ReservedWordSymbolProvider.Escaper

    // model depth; some shapes use `toSymbol()` internally as they convert (e.g.) member shapes to symbols, this tracks
    // how deep in the model we have recursed
    private var depth = 0

    init {
        val reservedWords = dartReservedWords()
        escaper = ReservedWordSymbolProvider.builder()
            .nameReservedWords(reservedWords)
            .memberReservedWords(reservedWords)
            // only escape words when the symbol has a definition file to prevent escaping intentional references to built-in shapes
            .escapePredicate { _, symbol -> symbol.definitionFile.isNotEmpty() }
            .buildEscaper()
    }

    companion object {
        /**
         * Determines if a new Kotlin type is generated for a given shape. Generally only structures, unions, and enums
         * result in a type being generated. Strings, ints, etc are mapped to builtins
         */
        fun isTypeGeneratedForShape(shape: Shape): Boolean = when {
            // pretty much anything we visit in CodegenVisitor (we don't care about service shape here though)
            shape.isEnum || shape.isStructureShape || shape.isUnionShape -> true
            else -> false
        }
    }

    override fun toSymbol(shape: Shape): Symbol {
        depth++
        val symbol: Symbol = shape.accept(this)
        depth--
        logger.fine("creating symbol from $shape: $symbol")
        return escaper.escapeSymbol(shape, symbol)
    }

    override fun toMemberName(shape: MemberShape): String = escaper.escapeMemberName(shape.defaultName())

    override fun byteShape(shape: ByteShape): Symbol = numberShape(shape, "int")

    override fun integerShape(shape: IntegerShape): Symbol = fixNumShape(shape, "Int32")

    override fun shortShape(shape: ShortShape): Symbol = numberShape(shape, "int")

    override fun longShape(shape: LongShape): Symbol = fixNumShape(shape, "Int64")

    override fun floatShape(shape: FloatShape): Symbol = numberShape(shape, "double")

    override fun doubleShape(shape: DoubleShape): Symbol = numberShape(shape, "double")

    private fun numberShape(shape: Shape, typeName: String, defaultValue: String = "0"): Symbol =
        createSymbolBuilder(shape, typeName, namespace = "dart.core")
            .defaultValue(defaultValue)
            .build()

    private fun fixNumShape(shape: Shape, typeName: String): Symbol =
        createSymbolBuilder(shape, typeName, namespace = "package.fixnum")
            .defaultValue("${typeName}()")
            .build()

    override fun bigIntegerShape(shape: BigIntegerShape?): Symbol =
        createSymbolBuilder(shape, "BigInteger", namespace = "dart.core", boxed = true).build()

    override fun bigDecimalShape(shape: BigDecimalShape?): Symbol = TODO()

    override fun stringShape(shape: StringShape): Symbol = if (shape.isEnum) {
        createEnumSymbol(shape)
    } else {
        createSymbolBuilder(shape, "String", boxed = true, namespace = "dart.core").build()
    }

    fun createEnumSymbol(shape: StringShape): Symbol {
        val namespace = "$rootNamespace.model"
        return createSymbolBuilder(shape, shape.defaultName(service), namespace, boxed = true)
            .definitionFile("${shape.defaultName(service)}.kt")
            .build()
    }

    override fun booleanShape(shape: BooleanShape?): Symbol =
        createSymbolBuilder(shape, "bool", namespace = "dart.core").defaultValue("false").build()

    override fun structureShape(shape: StructureShape): Symbol {
        val name = shape.defaultName(service)
        val namespace = "$rootNamespace.model"
        val builder = createSymbolBuilder(shape, name, namespace, boxed = true)
            .definitionFile("$name.kt")

        // add a reference to each member symbol
        addDeclareMemberReferences(builder, shape.allMembers.values)

        return builder.build()
    }

    /**
     * Add all the [members] as references needed to declare the given symbol being built.
     */
    private fun addDeclareMemberReferences(builder: Symbol.Builder, members: Collection<MemberShape>) {
        // when converting a shape to a symbol we only need references to top level members
        // in order to declare the symbol. This prevents recursive shapes from causing a stack overflow (and doing
        // unnecessary work since we don't need the inner references)
        if (depth > 1) return
        members.forEach {
            val memberSymbol = toSymbol(it)
            builder.addReference(memberSymbol, SymbolReference.ContextOption.DECLARE)

            when (model.expectShape(it.target)) {
                // collections and maps may have a value type that needs a reference
                is CollectionShape, is MapShape -> addSymbolReferences(memberSymbol, builder)
            }
        }
    }

    private fun addSymbolReferences(from: Symbol, to: Symbol.Builder) {
        if (from.references.isEmpty()) return
        from.references.forEach {
            addSymbolReferences(it.symbol, to)
            to.addReference(it)
        }
    }

    override fun listShape(shape: ListShape): Symbol {
        val reference = toSymbol(shape.member)
        val valueType = if (shape.hasTrait<SparseTrait>()) "${reference.name}?" else reference.name

        return createSymbolBuilder(shape, "List<$valueType>", boxed = true)
            .addReference(reference)
            .build()
    }

    override fun mapShape(shape: MapShape): Symbol {
        val reference = toSymbol(shape.value)
        val valueType = if (shape.hasTrait<SparseTrait>()) "${reference.name}?" else reference.name

        return createSymbolBuilder(shape, "Map<String, $valueType>", boxed = true)
            .addReference(reference)
            .build()
    }

    override fun setShape(shape: SetShape): Symbol {
        val reference = toSymbol(shape.member)
        return createSymbolBuilder(shape, "Set<${reference.name}>", boxed = true)
            .addReference(reference)
            .build()
    }

    override fun memberShape(shape: MemberShape): Symbol {
        val targetShape =
            model.getShape(shape.target).orElseThrow { CodegenException("Shape not found: ${shape.target}") }
        return toSymbol(targetShape)
    }

    override fun timestampShape(shape: TimestampShape?): Symbol {
        return createSymbolBuilder(shape, "DateTime", namespace = "dart.core", boxed = true)
            .build()
    }

    override fun blobShape(shape: BlobShape): Symbol = if (shape.hasTrait<StreamingTrait>()) {
        createSymbolBuilder(shape, "Stream<List<int>>", namespace = "dart.core", boxed = true)
            .build()
    } else {
        createSymbolBuilder(shape, "Uint8List", boxed = true, namespace = "dart.core").build()
    }

    override fun documentShape(shape: DocumentShape?): Symbol {
        return createSymbolBuilder(shape, "Object", boxed = true)
            .build()
    }

    override fun unionShape(shape: UnionShape): Symbol {
        val name = shape.defaultName(service)
        val namespace = "$rootNamespace.model"
        val builder = createSymbolBuilder(shape, name, namespace, boxed = true)
            .definitionFile("$name.kt")

        // add a reference to each member symbol
        addDeclareMemberReferences(builder, shape.allMembers.values)

        return builder.build()
    }

    override fun resourceShape(shape: ResourceShape?): Symbol = createSymbolBuilder(shape, "Resource").build()

    override fun operationShape(shape: OperationShape?): Symbol {
        // The Kotlin SDK does not produce code explicitly based on Operations
        error { "Unexpected codegen code path" }
    }

    override fun serviceShape(shape: ServiceShape): Symbol {
        val serviceName = clientName(settings.sdkId)
        return createSymbolBuilder(shape, "${serviceName}Client")
            .namespace(rootNamespace, ".")
            .definitionFile("${serviceName}Client.kt").build()
    }

    /**
     * Creates a symbol builder for the shape with the given type name in the root namespace.
     */
    private fun createSymbolBuilder(shape: Shape?, typeName: String, boxed: Boolean = false): Symbol.Builder {
        val builder = Symbol.builder()
            .putProperty(SymbolProperty.SHAPE_KEY, shape)
            .name(typeName)

        val explicitlyBoxed = shape?.hasTrait<BoxTrait>() ?: false
        if (explicitlyBoxed || boxed) {
            builder.boxed()
        }
        return builder
    }

    /**
     * Creates a symbol builder for the shape with the given type name in a child namespace relative
     * to the root namespace e.g. `relativeNamespace = bar` with a root namespace of `foo` would set
     * the namespace (and ultimately the package name) to `foo.bar` for the symbol.
     */
    private fun createSymbolBuilder(
        shape: Shape?,
        typeName: String,
        namespace: String,
        boxed: Boolean = false
    ): Symbol.Builder = createSymbolBuilder(shape, typeName, boxed).namespace(namespace, ".")
}
