package software.amazon.smithy.dart.codegen

import io.kotest.matchers.string.shouldContain
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.Test
import software.amazon.smithy.codegen.core.SymbolProvider
import software.amazon.smithy.dart.codegen.core.DartWriter
import software.amazon.smithy.dart.codegen.core.snakeCase
import software.amazon.smithy.dart.codegen.rendering.EnumGenerator
import software.amazon.smithy.model.shapes.StringShape
import software.amazon.smithy.model.traits.DocumentationTrait
import software.amazon.smithy.model.traits.EnumDefinition
import software.amazon.smithy.model.traits.EnumTrait
import java.io.File
import java.sql.Time
import java.util.concurrent.TimeUnit
import kotlin.test.assertEquals
import kotlin.test.expect

class EnumGeneratorTest {
    companion object {
        lateinit var expected: String

        @BeforeAll
        @JvmStatic
        fun beforeAll() {
            val fileName = this::class.simpleName!!.snakeCase()
            expected = this::class.java.classLoader.getResource("EnumGeneratorTest.dart")!!.readText()
        }
    }

    @Test
    fun testCreateEnum() {
        val enumTrait = createStringWithEnumTrait(
            EnumDefinition.builder().value("FOO_BAZ@-. XAP - . ").build(),
            EnumDefinition.builder().value("BAR").documentation("Documentation for BAR").build()
        )
        val model = createModelFromShapes(enumTrait)
        val settings = model.defaultSettings()
        val provider: SymbolProvider = DartCodegenPlugin.createSymbolProvider(model, settings)
        val symbol = provider.toSymbol(enumTrait)
        val writer = DartWriter()

        val generator = EnumGenerator(enumTrait, symbol, writer)
        generator.render()

        val contents = writer.toString()
        val tempFile = File.createTempFile("enum", "dart").also {
            it.writeText(contents)
        }
        val status = ProcessBuilder()
            .command("dart", "format", tempFile.absolutePath)
            .start()
            .waitFor()

        expect(0) { status }

        val formattedContents = tempFile.readText()
        assertEquals(expected, formattedContents)
    }

    private fun createStringWithEnumTrait(vararg enumDefinitions: EnumDefinition): StringShape {
        val enumTraitBuilder = EnumTrait.builder()
        for (enumDefinition in enumDefinitions) {
            enumTraitBuilder.addEnum(enumDefinition)
        }

        return StringShape.builder()
            .id("smithy.example#MyEnum")
            .addTrait(enumTraitBuilder.build())
            .addTrait(DocumentationTrait("Really long multi-line\nDocumentation for the enum"))
            .build()
    }
}