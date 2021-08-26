import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/credentials/aws_credentials.dart';
import 'package:aws_signature_v4/src/signer/aws_algorithm.dart';
import 'package:meta/meta.dart';

import '../credentials/aws_credential_scope.dart';
import '../request/aws_sig_v4_signed_request.dart';

/// {@template aws_sig_v4_signer}
/// The main class for signing requests made to AWS services.
///
/// This signer supports the V4 signing process and, by default, uses
/// the `AWS4-HMAC-SHA256` signing algorithm.
/// {@endtemplate}
class AWSSigV4Signer {
  static const terminationString = 'aws4_request';

  final AWSCredentials credentials;
  final AWSAlgorithm algorithm;

  /// {@macro aws_sig_v4_signer}
  const AWSSigV4Signer(
    this.credentials, {
    this.algorithm = AWSAlgorithm.hmacSha256,
  });

  /// Creates the string-to-sign (STS).
  @visibleForTesting
  String stringToSign({
    required AWSAlgorithm algorithm,
    required AWSCredentialScope credentialScope,
    required String canonicalRequestHash,
  }) {
    final sb = StringBuffer();
    sb.writeln(algorithm);
    sb.writeln(credentialScope.dateTime.formatFull());
    sb.writeln(credentialScope);
    sb.write(canonicalRequestHash);

    return sb.toString();
  }

  /// Signs [request] for the given [credentialScope].
  AWSSigV4SignedRequest sign(
    AWSHttpRequest request, {
    required AWSCredentialScope credentialScope,
    bool? presignedUrl,
    bool? normalizePath,
    bool? omitSessionTokenFromSigning,
    int? expiresIn,
  }) {
    final canonicalRequest = CanonicalRequest(
      request: request,
      credentials: credentials,
      credentialScope: credentialScope,

      // TODO: Service-specific stuff
      // i.e. if service == s3, normalize = false
      normalizePath: normalizePath,
      presignedUrl: presignedUrl,
      omitSessionTokenFromSigning: omitSessionTokenFromSigning,

      algorithm: algorithm,
      expiresIn: expiresIn,
    );
    final sts = stringToSign(
      algorithm: algorithm,
      credentialScope: credentialScope,
      canonicalRequestHash: canonicalRequest.hash,
    );
    final signingKey = algorithm.deriveSigningKey(
      credentials,
      credentialScope,
    );
    final signature = algorithm.sign(sts, signingKey);

    return _buildSignedRequest(
      credentialScope: credentialScope,
      signature: signature,
      canonicalRequest: canonicalRequest,
    );
  }

  /// Builds a signed request from [canonicalRequest] and [signature].
  AWSSigV4SignedRequest _buildSignedRequest({
    required CanonicalRequest canonicalRequest,
    required String signature,
    required AWSCredentialScope credentialScope,
  }) {
    // The signing process requires component keys be encoded. However, the
    // actual HTTP request should have the pre-encoded keys.
    final queryParameters = canonicalRequest.queryParameters;

    // Similar to query parameters, some header values are canonicalized for
    // signing. However their original values should be included in the
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
        algorithm.id,
        'Credential=${credentials.accessKeyId}/$credentialScope,',
        'SignedHeaders=${canonicalRequest.signedHeaders.join(';')},',
        'Signature=$signature',
      ].join(' ');
      if (includeSessionToken) {
        headers[AWSHeaders.securityToken] = sessionToken!;
      }
    }

    final originalRequest = canonicalRequest.request;
    return AWSSigV4SignedRequest(
      canonicalRequest: canonicalRequest,
      signature: signature,
      method: originalRequest.method,
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
