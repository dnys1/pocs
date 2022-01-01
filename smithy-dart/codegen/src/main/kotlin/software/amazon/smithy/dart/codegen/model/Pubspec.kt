package software.amazon.smithy.dart.codegen.model

/**
 * A pubspec.yaml representation.
 */
data class Pubspec(
    val name: String,
    val version: SemVer = SemVer(0, 1, 0),
    val description: String?,
    val homepage: String?,
    val publishTo: String?,
    val repository: String?,
    val issueTracker: String?,
    val environment: Environment = Environment.default,
    val dependencies: List<Dependency> = listOf(),
)

/**
 * The Dart environment constraints.
 */
data class Environment(
    private val minSdkVersion: SemVer = SemVer(2, 12, 0)
) {
    val sdkConstraint = SemVerConstraint(minSdkVersion)

    companion object {
        val default = Environment()
    }
}

/**
 * A Dart package dependency.
 */
data class Dependency(
    val packageName: String,
    val version: SemVerConstraint,
)