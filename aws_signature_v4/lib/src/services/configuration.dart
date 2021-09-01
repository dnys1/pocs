import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/services/validator.dart';
import 'package:meta/meta.dart';

/// A description of an [AWSSigv4Signer] configuration.
///
/// All requests made to AWS services must be processed in the precise way
/// that service expects. Since each service is different, this class provides
/// a way to override steps of the signing process which need precendence over
/// the [BaseServiceConfiguration].
///
/// Polices are applied iteratively based on the value of [precedence]. Lower
/// precendence policies are applied first, while higher precendence values are
/// applied last and can override values of the previous policies.
///
/// Policies of the same precedence with conflicting values are not allowed and
/// throw a runtime [ServiceConfigurationError]. Implementers should take care
/// to ensure this does not happen.
@sealed
abstract class ServiceConfiguration {
  final bool? normalizePath;
  final bool? omitSessionToken;

  const ServiceConfiguration._({
    this.normalizePath,
    this.omitSessionToken,
  });

  /// Applies service-specific keys to [base] with values from [canonicalRequest]
  /// and [credentials].
  @mustCallSuper
  void apply(
    Map<String, String> base,
    CanonicalRequest canonicalRequest, {
    required AWSCredentials credentials,
  });
}

class BaseServiceConfiguration extends ServiceConfiguration {
  const BaseServiceConfiguration({
    bool? normalizePath,
    bool? omitSessionToken,
  }) : super._(
          normalizePath: normalizePath,
          omitSessionToken: omitSessionToken,
        );

  @override
  void apply(
    Map<String, String> base,
    CanonicalRequest canonicalRequest, {
    required AWSCredentials credentials,
  }) {
    final request = canonicalRequest.request;
    final presignedUrl = canonicalRequest.presignedUrl;
    final credentialScope = canonicalRequest.credentialScope;
    final algorithm = canonicalRequest.algorithm;
    final expiresIn = canonicalRequest.expiresIn;
    final omitSessionTokenFromSigning =
        canonicalRequest.omitSessionTokenFromSigning;
    final includeBodyHash = !presignedUrl;

    if (presignedUrl) {
      base[AWSHeaders.signedHeaders] =
          SignedHeaders(CanonicalHeaders(request.headers)).toString();
    }

    base.addAll({
      if (!request.headers.containsKey(AWSHeaders.host))
        AWSHeaders.host: request.host,
      AWSHeaders.date: credentialScope.dateTime.formatFull(),
      if (presignedUrl && algorithm != null) AWSHeaders.algorithm: algorithm.id,
      if (presignedUrl)
        AWSHeaders.credential:
            Uri.encodeComponent('${credentials.accessKeyId}/$credentialScope'),
      if (presignedUrl && expiresIn != null)
        AWSHeaders.expires: expiresIn.toString(),
      if (includeBodyHash && request.body.isNotEmpty)
        AWSHeaders.contentSHA256: canonicalRequest.hashedPayload,
      if (credentials.sessionToken != null && !omitSessionTokenFromSigning)
        AWSHeaders.securityToken: credentials.sessionToken!,
    });
  }
}

abstract class ServiceHeader with AWSEquatable {
  /// The header map key.
  final String key;

  /// The validator for values of the header.
  final Validator<String> validator;

  const ServiceHeader(this.key, this.validator);

  @override
  List<Object?> get props => [
        key,
        validator,

        // To distinguish between keys of the same value but from
        // different service configurations.
        runtimeType,
      ];

  @override
  String toString() => key;
}

class ServiceConfigurationError extends Error {
  final String? message;

  ServiceConfigurationError.conflicting(
    ServiceConfiguration a,
    ServiceConfiguration b,
  ) : message = 'Conflicting configurations:\n1) $a\n\n2) $b';

  @override
  String toString() => message ?? 'Invalid service configuration';
}
