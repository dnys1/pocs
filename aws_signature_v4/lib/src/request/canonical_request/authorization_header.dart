import 'package:aws_signature_v4/aws_signature_v4.dart';

String createAuthorizationHeader({
  required AWSAlgorithm algorithm,
  required AWSCredentials credentials,
  required AWSCredentialScope credentialScope,
  required SignedHeaders signedHeaders,
  required String signature,
}) {
  return [
    algorithm.id,
    'Credential=${credentials.accessKeyId}/$credentialScope,',
    'SignedHeaders=$signedHeaders,',
    'Signature=$signature',
  ].join(' ');
}
