import 'dart:async';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/configuration/validator.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

/// A description of an [AWSSigV4Signer] configuration.
///
/// All requests made to AWS services must be processed in the precise way
/// that service expects. Since each service is different, this class provides
/// a way to override steps of the signing process which need precendence over
/// the [BaseServiceConfiguration].
@sealed
abstract class ServiceConfiguration {
  final bool? normalizePath;
  final bool? omitSessionToken;

  const ServiceConfiguration._({
    this.normalizePath,
    this.omitSessionToken,
  });

  /// Applies service-specific keys to [base] with values from [canonicalRequest]
  /// and [credentials].
  void apply(
    Map<String, String> base,
    CanonicalRequest canonicalRequest, {
    required AWSCredentials credentials,
  });

  /// Hashes the request payload for the canonical request.
  Future<String> hashPayload(AWSHttpRequest request);

  /// Transforms the request body using [algorithm] and [signingKey].
  Stream<List<int>> signBody({
    required AWSAlgorithm algorithm,
    required List<int> signingKey,
    required String seedSignature,
    required AWSCredentialScope credentialScope,
    required CanonicalRequest canonicalRequest,
  });
}

class BaseServiceConfiguration extends ServiceConfiguration {
  const BaseServiceConfiguration({
    bool? normalizePath,
    bool? omitSessionToken,
  }) : super._(
          normalizePath: normalizePath,
          omitSessionToken: omitSessionToken,
        );

  @override
  @mustCallSuper
  void apply(
    Map<String, String> base,
    CanonicalRequest canonicalRequest, {
    required AWSCredentials credentials,
  }) {
    final request = canonicalRequest.request;
    final presignedUrl = canonicalRequest.presignedUrl;
    final credentialScope = canonicalRequest.credentialScope;
    final algorithm = canonicalRequest.algorithm;
    final expiresIn = canonicalRequest.expiresIn;
    final omitSessionTokenFromSigning =
        canonicalRequest.omitSessionTokenFromSigning;
    final includeBodyHash = !presignedUrl;

    if (presignedUrl) {
      base[AWSHeaders.signedHeaders] =
          SignedHeaders(CanonicalHeaders(request.headers)).toString();
    }

    base.addAll({
      if (!request.headers.containsKey(AWSHeaders.host))
        AWSHeaders.host: request.host,
      AWSHeaders.date: credentialScope.dateTime.formatFull(),
      if (presignedUrl && algorithm != null) AWSHeaders.algorithm: algorithm.id,
      if (presignedUrl)
        AWSHeaders.credential:
            Uri.encodeComponent('${credentials.accessKeyId}/$credentialScope'),
      if (presignedUrl && expiresIn != null)
        AWSHeaders.expires: expiresIn.toString(),
      if (includeBodyHash && canonicalRequest.request.contentLength > 0)
        AWSHeaders.contentSHA256: canonicalRequest.payloadHash,
      if (credentials.sessionToken != null && !omitSessionTokenFromSigning)
        AWSHeaders.securityToken: credentials.sessionToken!,
    });
  }

  @override
  Future<String> hashPayload(AWSHttpRequest request) async {
    final digestSink = _DigestSink();
    final shaSink = sha256.startChunkedConversion(digestSink);
    request.body.listen(
      shaSink.add,
      onDone: shaSink.close,
      onError: digestSink._digest.completeError,
      cancelOnError: true,
    );
    final digest = await digestSink.digest;
    return hex.encode(digest.bytes);
  }

  @override
  Stream<List<int>> signBody({
    required AWSAlgorithm algorithm,
    required List<int> signingKey,
    required String seedSignature,
    required AWSCredentialScope credentialScope,
    required CanonicalRequest canonicalRequest,
  }) {
    // By default, the body is not signed.
    return canonicalRequest.request.body;
  }
}

class _DigestSink extends Sink<Digest> {
  final Completer<Digest> _digest = Completer();

  Future<Digest> get digest => _digest.future;

  @override
  void add(Digest data) {
    if (_digest.isCompleted) {
      throw StateError('Cannot call add more than once');
    }
    _digest.complete(data);
  }

  @override
  void close() {
    if (!_digest.isCompleted) {
      throw StateError('No digest received');
    }
  }
}

abstract class ServiceHeader with AWSEquatable {
  /// The header map key.
  final String key;

  /// The validator for values of the header.
  final Validator<String> validator;

  const ServiceHeader(this.key, this.validator);

  @override
  List<Object?> get props => [
        key,
        validator,

        // To distinguish between keys of the same value but from
        // different service configurations.
        runtimeType,
      ];

  @override
  String toString() => key;
}
