import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/credentials/aws_credential_scope.dart';
import 'package:aws_signature_v4/src/request/aws_headers.dart';
import 'package:aws_signature_v4/src/request/canonical_request/canonical_request.dart';
import 'package:aws_signature_v4/src/signer/aws_algorithm.dart';

export 'package:aws_signature_v4/src/request/http_method.dart';

class AWSSigV4SignedRequest extends AWSHttpRequest {
  final CanonicalRequest canonicalRequest;
  final String signature;

  AWSSigV4SignedRequest({
    required AWSCredentials credentials,
    required AWSCredentialScope credentialScope,
    required AWSAlgorithm algorithm,
    required this.signature,
    required this.canonicalRequest,
  }) : super.delegate(buildRequest(
          credentials: credentials,
          credentialScope: credentialScope,
          algorithm: algorithm,
          signature: signature,
          canonicalRequest: canonicalRequest,
        ));

  static AWSHttpRequest buildRequest({
    required AWSCredentials credentials,
    required AWSCredentialScope credentialScope,
    required AWSAlgorithm algorithm,
    required String signature,
    required CanonicalRequest canonicalRequest,
  }) {
    // The signing process requires component keys be encoded. However, the actual
    // HTTP request should have the pre-encoded keys.
    final queryParameters = canonicalRequest.queryParameters;

    // Similar to query parameters, some header values are altered ("canonicalized")
    // before signing. However their original values should be included in the
    // headers map of the HTTP request.
    final headers = canonicalRequest.headers;

    // If the session token was omitted from signing, include it now.
    var sessionToken = credentials.sessionToken;
    final includeSessionToken =
        sessionToken != null && canonicalRequest.omitSessionTokenFromSigning;
    if (canonicalRequest.presignedUrl) {
      queryParameters.addAll({
        AWSHeaders.signature: signature,
        if (includeSessionToken) AWSHeaders.securityToken: sessionToken!,
      });
    } else {
      headers[AWSHeaders.authorization] = [
        algorithm.name,
        'Credential=${credentials.accessKeyId}/$credentialScope,',
        'SignedHeaders=${canonicalRequest.signedHeaders.join(';')},',
        'Signature=$signature',
      ].join(' ');
      if (includeSessionToken) {
        headers[AWSHeaders.securityToken] = sessionToken!;
      }
    }

    final originalRequest = canonicalRequest.request;
    return AWSHttpRequest(
      httpMethod: originalRequest.httpMethod,
      host: originalRequest.host,
      path: originalRequest.path,
      body: originalRequest.body,
      headers: headers,

      // Encode query components, if necessary (avoid double encoding here)
      queryParameters: queryParameters.map(
        (k, v) => MapEntry(k, v.contains('%') ? v : Uri.encodeComponent(v)),
      ),
    );
  }
}
