import 'dart:collection';

import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/services/policies/s3.dart';
import 'package:aws_signature_v4/src/signer/aws_algorithm.dart';
import 'package:collection/collection.dart';
import 'package:test/test.dart';

import '../c_test_suite/test_data.dart';

// From: https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html

void main() {
  const serviceConfiguration = S3ServiceConfiguration();
  const credentials = AWSCredentials(
    'AKIAIOSFODNN7EXAMPLE',
    'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
  );
  const bucketName = 'examplebucket';
  final timestamp = AWSDateTime(DateTime.parse('20130524T000000Z'));
  const region = 'us-east-1';
  final credentialScope = AWSCredentialScope(
    region: region,
    service: 's3',
    dateTime: timestamp,
  );
  final signer = AWSSigV4Signer(credentials);
  group('S3', () {
    group('Single Chunk', () {
      test('GET Object', () {
        final request = AWSHttpRequest(
          method: HttpMethod.get,
          host: 'examplebucket.s3.amazonaws.com',
          path: '/test.txt',
          headers: {
            'Range': 'bytes=0-9',
          },
        );
        final canonicalRequest = CanonicalRequest(
          request: request,
          credentials: credentials,
          credentialScope: credentialScope,
          normalizePath: false,
          serviceConfiguration: serviceConfiguration,
        );
        final testData = SignerTestMethodData(
          method: SignerTestMethod.header,
          canonicalRequest: '''
GET
/test.txt

host:examplebucket.s3.amazonaws.com
range:bytes=0-9
x-amz-content-sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
x-amz-date:20130524T000000Z

host;range;x-amz-content-sha256;x-amz-date
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855''',
          stringToSign: '''
AWS4-HMAC-SHA256
20130524T000000Z
20130524/us-east-1/s3/aws4_request
7344ae5b7ee6c3e7e6b0fe0640412a37625d1fbfff95c48bbb2dc43964946972''',
          signature:
              'f0e8bdb87c964420e857bd35b5d6ed310bd44f0170aba48dd91039c6036bdb41',
          signedRequest: AWSSigV4SignedRequest(
            method: HttpMethod.get,
            host: 'examplebucket.s3.amazonaws.com',
            path: '/test.txt',
            headers: {
              'Host': 'examplebucket.s3.amazonaws.com',
              'x-amz-date': '20130524T000000Z',
              'Range': 'bytes=0-9',
              'x-amz-content-sha256':
                  'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
              'Authorization':
                  'AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20130524/us-east-1/s3/aws4_request, SignedHeaders=host;range;x-amz-content-sha256;x-amz-date, Signature=f0e8bdb87c964420e857bd35b5d6ed310bd44f0170aba48dd91039c6036bdb41',
            },
            canonicalRequest: canonicalRequest,
            signature:
                'f0e8bdb87c964420e857bd35b5d6ed310bd44f0170aba48dd91039c6036bdb41',
          ),
        );
        expect(canonicalRequest.toString(), equals(testData.canonicalRequest));

        final stringToSign = signer.stringToSign(
          algorithm: AWSAlgorithm.hmacSha256,
          credentialScope: credentialScope,
          canonicalRequestHash: canonicalRequest.hash,
        );
        expect(stringToSign, equals(testData.stringToSign));

        final signedRequest = signer.sign(
          request,
          credentialScope: credentialScope,
          serviceConfiguration: serviceConfiguration,
        );
        expect(
          const MapEquality(keys: CaseInsensitiveEquality()).equals(
            signedRequest.headers,
            testData.signedRequest.headers,
          ),
          isTrue,
        );
      });
    });
  });
}

Map<String, V> caseInsensitiveMap<V>(Map<String, V> other) {
  return HashMap(
    equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
  )..addAll(other);
}
