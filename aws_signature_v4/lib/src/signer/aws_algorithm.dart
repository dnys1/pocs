import 'package:aws_signature_v4/src/request/aws_date_time.dart';
import 'package:aws_signature_v4/src/credentials/aws_credential_scope.dart';
import 'package:aws_signature_v4/src/credentials/aws_credentials.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

abstract class AWSAlgorithm {
  /// AWS4-HMAC-SHA256 signing algorithm.
  static const _AWSHmacSha256 hmacSha256 = _AWSHmacSha256();

  final String name;

  const AWSAlgorithm(this.name);

  List<int> deriveSigningKey(
    AWSCredentials credentials,
    AWSCredentialScope credentialScope,
  );

  String sign(String stringToSign, List<int> signingKey);

  @override
  String toString() => name;
}

class _AWSHmacSha256 extends AWSAlgorithm {
  static const _name = 'AWS4-HMAC-SHA256';
  static const _hash = sha256;

  const _AWSHmacSha256() : super(_name);

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
    final kSigning =
        Hmac(_hash, kService.bytes).convert('aws4_request'.codeUnits);

    return kSigning.bytes;
  }

  @override
  String sign(String stringToSign, List<int> signingKey) {
    return hex
        .encode(Hmac(_hash, signingKey).convert(stringToSign.codeUnits).bytes);
  }
}
