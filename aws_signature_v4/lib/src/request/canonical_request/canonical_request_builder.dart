part of 'canonical_request.dart';

class CanonicalRequestBuilder {
  final AWSHttpRequest request;

  const CanonicalRequestBuilder(this.request);

  /// Builds a canonical request from [request].
  ///
  /// [normalizeUriPath]: Whether or not to normalize the URI path. Defaults to `true`.
  ///
  /// [presignedUrl]: When `true`, authentication information is encoded in the query string
  /// instead of in the request headers. Defaults to `false`.
  ///
  /// [omitSessionToken]: Whether to omit the session token, if present, from the initial
  /// signing process. If `true`, the session token will be added to the request after the
  /// signing process. Defaults to `false`.
  ///
  /// [region]: The AWS region of the request.
  CanonicalRequest build({
    required AWSCredentialScope credentialScope,
    required AWSCredentials credentials,
    bool normalizeUriPath = true,
    bool presignedUrl = false,
    bool omitSessionToken = false,
    AWSAlgorithm? algorithm,
    int? expiresIn,
  }) {
    if (presignedUrl) {
      assert(algorithm != null, 'Algorithm must be provided.');
      assert(expiresIn != null, 'Expires in must be provided.');
    }
    return CanonicalRequest(
      request: request,
      credentialScope: credentialScope,
      normalizePath: normalizeUriPath,
      omitSessionTokenFromSigning: omitSessionToken,
      presignedUrl: presignedUrl,
      algorithm: algorithm,
      credentials: credentials,
      expiresIn: expiresIn,
    );
  }
}
