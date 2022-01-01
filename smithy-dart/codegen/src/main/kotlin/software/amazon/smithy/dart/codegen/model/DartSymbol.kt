package software.amazon.smithy.dart.codegen.model

import software.amazon.smithy.codegen.core.Symbol
import software.amazon.smithy.codegen.core.SymbolReference
import software.amazon.smithy.dart.codegen.model.SymbolProperty.BUILT_IN_KEY

enum class DartPackage(val import: String?) {
    CORE(null),
    ASYNC("dart:async"),
    COLLECTION("dart:collection"),
    MATH("dart:math"),
    TYPED_DATA("dart:typed_data");

    fun symbol(name: String, refs: List<SymbolReference> = listOf()): Symbol {
        val builder = Symbol.builder().name(name).putProperty(BUILT_IN_KEY, this == CORE).also {
            for (ref in refs) {
                it.addReference(ref)
            }
        }
        if (import != null) {
            builder.addDependency(import, "")
        }
        return builder.build()
    }
}
