package software.amazon.smithy.dart.codegen

import software.amazon.smithy.build.PluginContext
import software.amazon.smithy.build.SmithyBuildPlugin
import software.amazon.smithy.codegen.core.SymbolProvider
import software.amazon.smithy.dart.codegen.core.DartSymbolProvider
import software.amazon.smithy.model.Model

class DartCodegenPlugin: SmithyBuildPlugin {
    override fun getName(): String = "dart-codegen"

    override fun execute(context: PluginContext?) {
        CodegenVisitor(context!!).execute()
    }

    companion object {
        /**
         * Creates a Dart symbol provider.
         * @param model The model to generate symbols for
         * @param settings Codegen settings
         * @return Returns the created provider
         */
        fun createSymbolProvider(model: Model, settings: DartSettings): SymbolProvider =
            DartSymbolProvider(model, settings)
    }
}