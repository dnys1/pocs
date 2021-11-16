import 'dart:async';

import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/request/canonical_request/authorization_header.dart';
import 'package:meta/meta.dart';

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

  /// Creates a presigned URL for the given [signerRequest].
  AWSSignedRequest presign(AWSSignerRequest signerRequest) {
    return _sign(signerRequest, presignedUrl: true);
  }

  /// Signs the given [signerRequest] using authorization headers.
  AWSSignedRequest sign(AWSSignerRequest signerRequest) {
    return _sign(signerRequest, presignedUrl: false);
  }

  AWSSignedRequest _sign(
    AWSSignerRequest signerRequest, {
    required bool presignedUrl,
  }) {
    final canonicalRequest = CanonicalRequest(
      request: signerRequest.request,
      credentials: credentials,
      credentialScope: signerRequest.credentialScope,
      normalizePath: signerRequest.normalizePath,
      presignedUrl: presignedUrl,
      omitSessionTokenFromSigning: signerRequest.omitSessionTokenFromSigning,
      algorithm: algorithm,
      expiresIn: signerRequest.expiresIn,
      configuration: signerRequest.serviceConfiguration,
    );
    final signingKey = algorithm.deriveSigningKey(
      credentials,
      signerRequest.credentialScope,
    );
    final sts = stringToSign(
      algorithm: algorithm,
      credentialScope: signerRequest.credentialScope,
      canonicalRequest: canonicalRequest,
    );
    final seedSignature = algorithm.sign(sts, signingKey);
    final signedBody = signerRequest.serviceConfiguration.signBody(
      algorithm: algorithm,
      signingKey: signingKey,
      seedSignature: seedSignature,
      credentialScope: signerRequest.credentialScope,
      canonicalRequest: canonicalRequest,
    );

    return _buildSignedRequest(
      credentialScope: signerRequest.credentialScope,
      signature: seedSignature,
      body: signedBody,
      canonicalRequest: canonicalRequest,
    );
  }

  /// Creates the string-to-sign (STS) for the canonical request.
  @visibleForTesting
  String stringToSign({
    required AWSAlgorithm algorithm,
    required AWSCredentialScope credentialScope,
    required CanonicalRequest canonicalRequest,
  }) {
    final sb = StringBuffer();
    sb.writeln(algorithm);
    sb.writeln(credentialScope.dateTime);
    sb.writeln(credentialScope);
    sb.write(canonicalRequest.hash);

    return sb.toString();
  }

  /// Builds a signed request from [canonicalRequest] and [signatureStream].
  AWSSignedRequest _buildSignedRequest({
    required CanonicalRequest canonicalRequest,
    required String signature,
    required Stream<List<int>> body,
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
    final sessionToken = credentials.sessionToken;
    final includeSessionToken =
        sessionToken != null && canonicalRequest.omitSessionTokenFromSigning;
    if (canonicalRequest.presignedUrl) {
      queryParameters[AWSHeaders.signature] = signature;
      if (includeSessionToken) {
        queryParameters[AWSHeaders.securityToken] = sessionToken!;
      }
    } else {
      headers[AWSHeaders.authorization] = createAuthorizationHeader(
        algorithm: algorithm,
        credentials: credentials,
        credentialScope: credentialScope,
        signedHeaders: canonicalRequest.signedHeaders,
        signature: signature,
      );
      if (includeSessionToken) {
        headers[AWSHeaders.securityToken] = sessionToken!;
      }
    }

    final originalRequest = canonicalRequest.request;
    return AWSSignedRequest(
      canonicalRequest: canonicalRequest,
      signature: signature,
      method: originalRequest.method,
      host: originalRequest.host,
      path: originalRequest.path,
      body: body,
      contentLength: originalRequest.contentLength,
      headers: headers,
      queryParameters: queryParameters,
    );
  }
}
