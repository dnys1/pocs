import 'dart:collection';
import 'dart:convert';

import 'package:aws_signature_v4/src/credentials/aws_credential_scope.dart';
import 'package:aws_signature_v4/src/credentials/aws_credentials.dart';
import 'package:aws_signature_v4/src/request/aws_headers.dart';
import 'package:aws_signature_v4/src/signer/aws_algorithm.dart';
import 'package:collection/collection.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../aws_http_request.dart';

part 'canonical_headers.dart';
part 'canonical_query_parameters.dart';
part 'signed_headers.dart';
part 'canonical_request_builder.dart';
part 'canonical_request_util.dart';

class CanonicalRequest {
  static const encodedEquals = '%3D';
  static const doubleEncodedEquals = '%253D';
  static const _emptyPayloadHash =
      'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';

  final AWSHttpRequest request;
  final AWSCredentialScope credentialScope;
  final String requestPath;

  late final Map<String, String> queryParameters;
  late final CanonicalQueryParameters canonicalQueryParameters =
      CanonicalQueryParameters(queryParameters);

  late final Map<String, String> headers;
  late final CanonicalHeaders canonicalHeaders = CanonicalHeaders(headers);
  late final SignedHeaders signedHeaders = SignedHeaders(canonicalHeaders);

  final bool normalizePath;
  final bool presignedUrl;
  final bool omitSessionTokenFromSigning;

  // Query-specific parameters
  final AWSAlgorithm? algorithm;
  final int? expiresIn;

  /// The hashed body of the request.
  late final String _hashedPayload =
      request.body.isEmpty ? _emptyPayloadHash : hashRequest(request.body);

  /// The computed hash of the canonical request.
  late final String hash = hashRequest(utf8.encode(toString()));

  CanonicalRequest({
    required this.request,
    required AWSCredentials credentials,
    required this.credentialScope,
    required this.normalizePath,
    required this.presignedUrl,
    required this.omitSessionTokenFromSigning,
    this.algorithm,
    this.expiresIn,
  }) : requestPath = canonicalPath(request, normalizePath: normalizePath) {
    headers = presignedUrl
        ? request.headers
        : _withAmazonValues(
            request.headers,
            credentials: credentials,
            includeBodyHash: true,
          );
    queryParameters = presignedUrl
        ? _withAmazonValues(
            request.queryParameters,
            credentials: credentials,
          )
        : request.queryParameters;
  }

  /// Returns the uppercased HTTP method.
  static String canonicalHttpMethod(String httpMethod) {
    return httpMethod.toUpperCase();
  }

  /// Not handled by [Uri].
  static String _removeDoubleSlashes(String path) {
    return path.replaceAll('//', '/');
  }

  /// Returns the normalized path with double-encoded path segments.
  static String canonicalPath(
    AWSHttpRequest request, {
    required bool normalizePath,
  }) {
    final path = normalizePath
        ? Uri(host: request.host, path: _removeDoubleSlashes(request.path)).path
        : request.path;
    final pathComponents = path
        .split('/')
        .map((comp) => Uri.encodeComponent(_decodeIfNeeded(comp)));
    final emptyPath = pathComponents.isEmpty ||
        pathComponents.length == 1 && pathComponents.first.isEmpty;
    final canPath = emptyPath ? '/' : pathComponents.join('/');
    return canPath;
  }

  /// Returns a copy of [params] with the provided Amazon added.
  Map<String, String> _withAmazonValues(
    Map<String, String> params, {
    required AWSCredentials credentials,
    bool includeBodyHash = false,
  }) {
    return {
      ...params,
      if (!request.headers.containsKey('host')) AWSHeaders.host: request.host,
      // TODO: This is service specific
      // if (request.httpMethod.hasBody &&
      //     !params.containsKey(AWSHeaders.contentType))
      //   AWSHeaders.contentType: AWSHeaderValues.defaultContentType,
      // if (request.httpMethod.hasBody &&
      //     !params.containsKey(AWSHeaders.contentLength))
      // AWSHeaders.contentLength: request.body.length.toString(),
      AWSHeaders.date: credentialScope.dateTime.formatFull(),
      if (presignedUrl && algorithm != null)
        AWSHeaders.algorithm: algorithm!.name,
      if (presignedUrl)
        AWSHeaders.credential:
            Uri.encodeComponent('${credentials.accessKeyId}/$credentialScope'),
      if (presignedUrl && expiresIn != null)
        AWSHeaders.expires: expiresIn.toString(),
      if (includeBodyHash && request.body.isNotEmpty)
        AWSHeaders.contentSHA256: hashRequest(request.body),
      if (credentials.sessionToken != null && !omitSessionTokenFromSigning)
        AWSHeaders.securityToken: credentials.sessionToken!,
      if (presignedUrl) AWSHeaders.signedHeaders: signedHeaders.toString(),
    };
  }

  static String hashRequest(List<int> requestBytes) {
    final hash = sha256.convert(requestBytes);
    final hexed = hex.encode(hash.bytes);
    return hexed.toLowerCase();
  }

  @override
  String toString() {
    final sb = StringBuffer();
    sb.writeln(request.method.value);
    sb.writeln(requestPath);
    sb.writeln(canonicalQueryParameters);
    sb.writeln(canonicalHeaders);
    sb.writeln(signedHeaders);
    sb.write(_hashedPayload);
    return sb.toString();
  }
}
