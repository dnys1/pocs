import 'dart:collection';
import 'dart:convert';

import 'package:aws_signature_v4/src/credentials/aws_credential_scope.dart';
import 'package:aws_signature_v4/src/credentials/aws_credentials.dart';
import 'package:aws_signature_v4/src/request/aws_headers.dart';
import 'package:aws_signature_v4/src/services/configuration.dart';
import 'package:aws_signature_v4/src/signer/aws_algorithm.dart';
import 'package:collection/collection.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../aws_http_request.dart';

part 'canonical_headers.dart';
part 'canonical_query_parameters.dart';
part 'signed_headers.dart';
part 'canonical_request_util.dart';

/// {@template canonical_request}
/// A canonicalized request, used for signing via the SigV4 signing process.
/// {@endtemplate}
class CanonicalRequest {
  static const encodedEquals = '%3D';
  static const doubleEncodedEquals = '%253D';
  static const _emptyPayloadHash =
      'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';

  /// The original HTTP request.
  final AWSHttpRequest request;

  /// The scope for the request.
  final AWSCredentialScope credentialScope;

  /// The canonicalized request path.
  late final String canonicalPath = _canonicalPath(
    request,
    normalizePath: normalizePath,
  );

  /// The request query parameters, with AWS values added, if necessary.
  late final Map<String, String> queryParameters;

  /// The canonicalized [queryParameters].
  late final CanonicalQueryParameters canonicalQueryParameters;

  /// The request headers, with AWS values added, if necessary.
  late final Map<String, String> headers;

  /// The canonicalized [headers].
  late final CanonicalHeaders canonicalHeaders;

  /// The list of signed headers.
  late final SignedHeaders signedHeaders;

  /// Whether or not to normalize the URI path.
  ///
  /// Defaults to `true`.
  final bool normalizePath;

  /// Whether to create a presigned URL.
  ///
  /// If `true`, authentication information is encoded in the query string
  /// instead of in the request headers.
  ///
  /// Defaults to `false`.
  final bool presignedUrl;

  /// Whether to omit the session token, if present, from the initial signing
  /// process.
  ///
  /// If `true`, the session token will be added to the request after the signing
  /// process.
  ///
  /// Defaults to `false`.
  final bool omitSessionTokenFromSigning;

  // Query-specific parameters

  /// The algorithm to use for signing.
  ///
  /// Must be provided if [presignedUrl] is `true`.
  final AWSAlgorithm? algorithm;

  /// The number of seconds the request is valid for.
  ///
  /// Only valid for presigned URLs, and must be provided if [presignedUrl]
  /// is `true`.
  final int? expiresIn;

  /// The hashed body of the request.
  late final String hashedPayload =
      request.body.isEmpty ? _emptyPayloadHash : hashRequest(request.body);

  /// The computed hash of the canonical request.
  late final String hash = hashRequest(utf8.encode(toString()));

  /// {@macro canonical_request}
  CanonicalRequest({
    required this.request,
    required AWSCredentials credentials,
    required this.credentialScope,
    ServiceConfiguration serviceConfiguration =
        const BaseServiceConfiguration(),
    bool? normalizePath,
    bool? presignedUrl,
    bool? omitSessionTokenFromSigning,
    this.algorithm,
    this.expiresIn,
  })  : normalizePath = normalizePath ?? true,
        presignedUrl = presignedUrl ?? false,
        omitSessionTokenFromSigning = omitSessionTokenFromSigning ?? false {
    if (this.presignedUrl) {
      ArgumentError.checkNotNull(algorithm, 'algorithm');
      ArgumentError.checkNotNull(expiresIn, 'expiresIn');
    }
    headers = Map.of(request.headers);
    queryParameters = Map.of(request.queryParameters);

    // Apply service configuration to appropriate values for request type.
    if (this.presignedUrl) {
      serviceConfiguration.apply(
        queryParameters,
        this,
        credentials: credentials,
      );
    } else {
      serviceConfiguration.apply(
        headers,
        this,
        credentials: credentials,
      );
    }

    canonicalHeaders = CanonicalHeaders(headers);
    canonicalQueryParameters = CanonicalQueryParameters(queryParameters);
    signedHeaders = SignedHeaders(canonicalHeaders);
  }

  /// Removes excess slashes from paths.
  ///
  /// Not handled by [Uri]'s normalization.
  static String _removeDoubleSlashes(String path) {
    return path.replaceAll('//', '/');
  }

  /// Returns the normalized path with double-encoded path segments.
  ///
  /// Uses [Uri] to normalize the path.
  static String _canonicalPath(
    AWSHttpRequest request, {
    required bool normalizePath,
  }) {
    final path = normalizePath
        ? Uri(
            host: request.host,
            path: _removeDoubleSlashes(request.path),
          ).path
        : request.path;
    final pathComponents = path.split('/').map(
          (comp) => Uri.encodeComponent(_decodeIfNeeded(comp)),
        );
    final isEmptyPath = pathComponents.isEmpty ||
        pathComponents.length == 1 && pathComponents.first.isEmpty;
    final canonicalizedPath = isEmptyPath ? '/' : pathComponents.join('/');
    return canonicalizedPath;
  }

  /// Hashes [requestBytes] using SHA-256 and returns the hex-encoded string.
  static String hashRequest(List<int> requestBytes) {
    final hash = sha256.convert(requestBytes);
    final hexed = hex.encode(hash.bytes);
    return hexed.toLowerCase();
  }

  /// Creates the canonical request string.
  @override
  String toString() {
    final sb = StringBuffer();
    sb.writeln(request.method.value);
    sb.writeln(canonicalPath);
    sb.writeln(canonicalQueryParameters);
    sb.writeln(canonicalHeaders);
    sb.writeln(signedHeaders);
    sb.write(hashedPayload);
    return sb.toString();
  }
}
