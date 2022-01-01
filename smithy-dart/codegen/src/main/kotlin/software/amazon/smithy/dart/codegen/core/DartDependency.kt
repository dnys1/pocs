package software.amazon.smithy.dart.codegen.core

import com.sun.xml.internal.ws.util.VersionUtil.isValidVersion
import software.amazon.smithy.codegen.core.CodegenException
import software.amazon.smithy.codegen.core.SymbolDependency
import software.amazon.smithy.codegen.core.SymbolDependencyContainer

// root namespace for the runtime
const val RUNTIME_ROOT_NS = "aws.smithy"

val RUNTIME_VERSION: String = System.getProperty("smithy.dart.codegen.clientRuntimeVersion", getDefaultRuntimeVersion())

private fun getDefaultRuntimeVersion(): String {
    // generated as part of the build, see smithy-dart/build.gradle.kts
    try {
        val version = object {}.javaClass.getResource("sdk-version.txt")?.readText() ?: throw CodegenException("sdk-version.txt does not exist")
        check(isValidVersion(version)) { "Version parsed from sdk-version.txt '$version' is not a valid version string" }
        return version
    } catch (ex: Exception) {
        throw CodegenException("failed to load sdk-version.txt which sets the default client-runtime version", ex)
    }
}

data class DartDependency(
    val namespace: String,
    val packageName: String? = null,
    val version: String? = null
): SymbolDependencyContainer {
    companion object {
        val CORE = DartDependency(RUNTIME_ROOT_NS, "aws_smithy", RUNTIME_VERSION)
        val HTTP = DartDependency("package.http", "http", "^0.13.0")
    }

    override fun getDependencies(): List<SymbolDependency> {
        val dependency = SymbolDependency.builder()
            .packageName(packageName)
            .version(version)
            .putProperty("dependency", this)
            .build()
        return listOf(dependency)
    }
}