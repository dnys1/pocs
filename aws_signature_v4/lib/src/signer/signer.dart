import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/credentials/aws_credentials.dart';
import 'package:aws_signature_v4/src/signer/aws_algorithm.dart';
import 'package:meta/meta.dart';

import '../credentials/aws_credential_scope.dart';
import '../request/aws_sig_v4_signed_request.dart';

class AWSSigV4Signer {
  static const terminationString = 'aws4_request';

  final AWSCredentials credentials;
  final AWSAlgorithm algorithm;

  const AWSSigV4Signer(
    this.credentials, {
    this.algorithm = AWSAlgorithm.hmacSha256,
  });

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

  AWSSigV4SignedRequest sign(
    AWSHttpRequest request, {
    required AWSCredentialScope credentialScope,
    bool? presignedUrl,
    bool? normalizeUriPath,
    bool? omitSessionToken,
    int? expiresIn,
  }) {
    // TODO: Service-specific stuff, i.e. if service == s3, normalize = false
    bool normalize = normalizeUriPath ?? true;
    bool omitSTS = omitSessionToken ?? false;
    bool presigned = presignedUrl ?? false;
    final requestBuilder = CanonicalRequestBuilder(request);
    final canonicalRequest = requestBuilder.build(
      credentials: credentials,
      credentialScope: credentialScope,
      normalizeUriPath: normalize,
      presignedUrl: presigned,
      omitSessionToken: omitSTS,
      algorithm: algorithm,
      expiresIn: expiresIn,
    );
    final sts = stringToSign(
      algorithm: algorithm,
      credentialScope: credentialScope,
      canonicalRequestHash: canonicalRequest.hash,
    );
    final signingKey = algorithm.deriveSigningKey(credentials, credentialScope);
    final signature = algorithm.sign(sts, signingKey);

    return AWSSigV4SignedRequest(
      accessKeyId: credentials.accessKeyId,
      sessionToken: credentials.token,
      algorithm: algorithm,
      credentialScope: credentialScope,
      signature: signature,
      canonicalRequest: canonicalRequest,
    );
  }
}
