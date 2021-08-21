import 'package:amplify_common/src/config/api/endpoint_type.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ApiAuthorization {
  const ApiAuthorization._(this.type);

  final ApiAuthorizationType type;
  Map<String, String> connectionHeaders(AWSHttpRequest request);
}

class ApiKeyAuthorization extends ApiAuthorization {
  const ApiKeyAuthorization(this.apiKey) : super._(ApiAuthorizationType.apiKey);

  final String apiKey;

  @override
  Map<String, String> connectionHeaders(AWSHttpRequest request) => {
        AWSHeaders.host.toLowerCase(): request.host,
        'x-api-key': apiKey,
      };

  @override
  bool operator ==(Object other) =>
      other is ApiKeyAuthorization && apiKey == other.apiKey;

  @override
  int get hashCode => apiKey.hashCode;
}

class AWSAuthorization extends ApiAuthorization {
  AWSAuthorization(this.credentials, {AWSSigV4Signer? signer})
      : _signer = signer ?? AWSSigV4Signer(credentials),
        super._(ApiAuthorizationType.awsIAM);

  final AWSCredentials credentials;
  final AWSSigV4Signer _signer;

  @override
  Map<String, String> connectionHeaders(AWSHttpRequest request) {
    final host = request.host;
    final region = host.split('.')[2];
    final credentialScope = AWSCredentialScope(
      region: region,
      service: 'appsync-api',
    );
    final signedRequest = _signer.sign(
      request,
      credentialScope: credentialScope,
    );
    return signedRequest.headers;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AWSAuthorization &&
          credentials == other.credentials &&
          _signer == other._signer;

  @override
  int get hashCode => credentials.hashCode ^ _signer.hashCode;
}
