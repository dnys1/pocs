package software.amazon.smithy.dart.codegen.model

/**
 * A version which follows Semantic Versioning.
 */
data class SemVer(
    val major: Int,
    val minor: Int = 0,
    val patch: Int = 0,
) {
    companion object {
        fun parse(value: String): SemVer {
            val values = value.split(".").map { it.toIntOrNull() }
            return SemVer(
                values.get(0) ?: 0,
                values.get(1) ?: 0,
                values.get(2) ?: 0,
            )
        }
    }

    val nextMajor: SemVer
        get() = SemVer(major + 1, 0, 0)
}

/**
 * Represents a constraints based on minimum and maximum allowed versions.
 */
data class SemVerConstraint(
    val minVersion: SemVer,
    val maxVersion: SemVer = minVersion.nextMajor
) {
    override fun toString(): String = if (maxVersion == minVersion.nextMajor) {
        "^${minVersion}"
    } else {
        ">=${minVersion} <${maxVersion}"
    }
}