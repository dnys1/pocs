import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/credentials/aws_credential_scope.dart';
import 'package:aws_signature_v4/src/credentials/aws_credentials.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

/// {@template aws_algorithm}
/// Defines the interface for an algorithm used in signing.
/// {@endtemplate}
abstract class AWSAlgorithm {
  /// `AWS4-HMAC-SHA256` signing algorithm.
  static const _AWSHmacSha256 hmacSha256 = _AWSHmacSha256();

  /// The algorithm's identifier.
  final String id;

  /// {@macro aws_algorithm}
  const AWSAlgorithm(this.id);

  /// Derives a key for signing the string-to-sign (STS).
  List<int> deriveSigningKey(
    AWSCredentials credentials,
    AWSCredentialScope credentialScope,
  );

  /// Signs the string-to-sign (STS) and returns the hex-encoded signature.
  String sign(String stringToSign, List<int> signingKey);

  @override
  String toString() => id;
}

/// The default V4 algorithm, using HMAC/SHA-256.
class _AWSHmacSha256 extends AWSAlgorithm {
  static const _id = 'AWS4-HMAC-SHA256';
  static const _hash = sha256;

  const _AWSHmacSha256() : super(_id);

  @override
  List<int> deriveSigningKey(
    AWSCredentials credentials,
    AWSCredentialScope credentialScope,
  ) {
    final date = credentialScope.dateTime;
    final region = credentialScope.region;
    final service = credentialScope.service;

    // kSecret = your secret access key
    final kSecret = credentials.secretAccessKey;

    // kDate = HMAC("AWS4" + kSecret, Date)
    final kDate = Hmac(_hash, 'AWS4$kSecret'.codeUnits)
        .convert(date.formatDate().codeUnits);

    // kRegion = HMAC(kDate, Region)
    final kRegion = Hmac(_hash, kDate.bytes).convert(region.codeUnits);

    // kService = HMAC(kRegion, Service)
    final kService = Hmac(_hash, kRegion.bytes).convert(service.codeUnits);

    // kSigning = HMAC(kService, "aws4_request")
    final kSigning = Hmac(_hash, kService.bytes)
        .convert(AWSSigV4Signer.terminationString.codeUnits);

    return kSigning.bytes;
  }

  @override
  String sign(String stringToSign, List<int> signingKey) {
    final signature = Hmac(_hash, signingKey).convert(stringToSign.codeUnits);
    return hex.encode(signature.bytes);
  }
}
