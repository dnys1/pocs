import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/credentials/aws_credential_scope.dart';
import 'package:aws_signature_v4/src/request/aws_headers.dart';
import 'package:aws_signature_v4/src/request/canonical_request/canonical_request.dart';
import 'package:aws_signature_v4/src/request/http_method.dart';
import 'package:aws_signature_v4/src/signer/aws_algorithm.dart';
import 'package:equatable/equatable.dart';

export 'package:aws_signature_v4/src/request/http_method.dart';

class AWSSigV4SignedRequest {
  final String accessKeyId;
  final String? sessionToken;
  final AWSAlgorithm algorithm;
  final AWSCredentialScope credentialScope;
  final String signature;
  final CanonicalRequest canonicalRequest;

  const AWSSigV4SignedRequest({
    required this.accessKeyId,
    required this.sessionToken,
    required this.credentialScope,
    required this.algorithm,
    required this.signature,
    required this.canonicalRequest,
  });

  AWSHttpRequest get request {
    // The signing process requires component keys be encoded. However, the actual
    // HTTP request should have the pre-encoded keys.
    final queryParameters = canonicalRequest.queryParameters;

    // Similar to query parameters, some header values are altered ("canonicalized")
    // before signing. However their original values should be included in the
    // headers map of the HTTP request.
    final headers = canonicalRequest.headers;

    // If the session token was omitted from signing, include it now.
    final includeSessionToken =
        sessionToken != null && canonicalRequest.omitSessionTokenFromSigning;
    if (canonicalRequest.presignedUrl) {
      queryParameters.addAll({
        AWSHeaders.signature: signature,
        if (includeSessionToken) AWSHeaders.securityToken: sessionToken!,
      });
    } else {
      headers['Authorization'] = [
        algorithm.name,
        'Credential=$accessKeyId/$credentialScope,',
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
      headers: headers,
      body: originalRequest.body,

      // Encode query components, if necessary (avoid double encoding here)
      queryParameters: queryParameters.map(
        (k, v) => MapEntry(k, v.contains('%') ? v : Uri.encodeComponent(v)),
      ),
    );
  }
}
