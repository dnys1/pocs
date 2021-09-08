import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/configuration/service_configuration.dart';

/// Represents a request made to an [AWSSigV4Signer].
class AWSSignerRequest<T extends AWSBaseHttpRequest> {
  const AWSSignerRequest(
    this.request, {
    required this.credentialScope,
    this.presignedUrl,
    this.normalizePath,
    this.omitSessionTokenFromSigning,
    ServiceConfiguration? serviceConfiguration,
    this.expiresIn,
  }) : serviceConfiguration =
            serviceConfiguration ?? const BaseServiceConfiguration();

  final T request;
  final AWSCredentialScope credentialScope;
  final bool? presignedUrl;
  final bool? normalizePath;
  final bool? omitSessionTokenFromSigning;
  final ServiceConfiguration serviceConfiguration;
  final int? expiresIn;
}
