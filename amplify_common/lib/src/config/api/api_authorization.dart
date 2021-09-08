import 'dart:async';

import 'package:amplify_common/src/config/api/endpoint_type.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ApiAuthorization {
  const ApiAuthorization._(this.type);

  final ApiAuthorizationType type;
  FutureOr<Map<String, String>> connectionHeaders(AWSHttpRequest request);
  FutureOr<Map<String, String>> requestHeaders(AWSHttpRequest request);
}

class AppSyncApiKeyAuthorization extends ApiAuthorization {
  const AppSyncApiKeyAuthorization(this.apiKey)
      : super._(ApiAuthorizationType.apiKey);

  final String apiKey;

  @override
  Map<String, String> connectionHeaders(AWSHttpRequest request) => {
        AWSHeaders.host.toLowerCase(): request.host,
        'x-api-key': apiKey,
      };

  @override
  Map<String, String> requestHeaders(AWSHttpRequest request) => {
        'x-api-key': apiKey,
      };

  @override
  bool operator ==(Object other) =>
      other is AppSyncApiKeyAuthorization && apiKey == other.apiKey;

  @override
  int get hashCode => apiKey.hashCode;
}

class AppSyncIamAuthorization extends ApiAuthorization {
  AppSyncIamAuthorization(this.credentials, {AWSSigV4Signer? signer})
      : _signer = signer ?? AWSSigV4Signer(credentials),
        super._(ApiAuthorizationType.awsIAM);

  final AWSCredentials credentials;
  final AWSSigV4Signer _signer;

  @override
  Map<String, String> connectionHeaders(AWSHttpRequest request) =>
      _headers(request);

  @override
  Map<String, String> requestHeaders(AWSHttpRequest request) =>
      _headers(request);

  Map<String, String> _headers(AWSHttpRequest request) {
    final host = request.host;
    final region = host.split('.')[2];
    final credentialScope = AWSCredentialScope(
      region: region,
      service: 'appsync',
    );
    final signedRequest = _signer.sign(
      AWSSignerRequest(
        request,
        credentialScope: credentialScope,
      ),
    );
    return signedRequest.headers;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSyncIamAuthorization &&
          credentials == other.credentials &&
          _signer.algorithm == other._signer.algorithm;

  @override
  int get hashCode => credentials.hashCode ^ _signer.algorithm.hashCode;
}
