import 'dart:convert';
import 'dart:io';

import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/credentials/aws_credential_scope.dart';
import 'package:aws_signature_v4/src/request/canonical_request/canonical_request.dart';
import 'package:aws_signature_v4/src/signer/aws_signer.dart';
import 'package:aws_signature_v4/src/signer/aws_algorithm.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'context.dart';
import 'request_parser.dart';

enum SignerTestMethod { query, header }

extension on SignerTestMethod {
  String get string => toString().split('.')[1];
}

/// Test-specific data for verifiying.
///
/// Each test class carries two instances of `SignerTestMethodData`: one where
/// the signature info should be attached to the headers and one where it should
/// be attached via query parameters.
class SignerTestMethodData {
  final SignerTestMethod method;
  final String canonicalRequest;
  final String stringToSign;
  final String signature;
  final AWSHttpRequest signedRequest;

  const SignerTestMethodData({
    required this.method,
    required this.canonicalRequest,
    required this.stringToSign,
    required this.signature,
    required this.signedRequest,
  });
}

/// Builder class to make it easy to lazily create a [SignerTest].
class SignerTestBuilder {
  final String name;

  SignerTestBuilder(this.name);

  late final Context context;
  late final AWSHttpRequest request;
  late final String queryCanonicalRequest;
  late final String queryStringToSign;
  late final String querySignature;
  late final AWSHttpRequest querySignedRequest;
  late final String headerCanonicalRequest;
  late final String headerStringToSign;
  late final String headerSignature;
  late final AWSHttpRequest headerSignedRequest;

  SignerTest build() {
    return SignerTest(
      name: name,
      context: context,
      request: request,
      headerTestData: SignerTestMethodData(
        method: SignerTestMethod.header,
        canonicalRequest: headerCanonicalRequest,
        stringToSign: headerStringToSign,
        signature: headerSignature,
        signedRequest: headerSignedRequest,
      ),
      queryTestData: SignerTestMethodData(
        method: SignerTestMethod.query,
        canonicalRequest: queryCanonicalRequest,
        stringToSign: queryStringToSign,
        signature: querySignature,
        signedRequest: querySignedRequest,
      ),
    );
  }
}

/// A single signer test.
///
/// Each folder in the test suite is built into an instance of this class, where
/// [name] is the name of the folder used.
class SignerTest {
  /// Only V4 (e.g. HMAC/SHA-2) is supported for signer tests.
  static const algorithm = AWSAlgorithm.hmacSha256;

  final String name;
  final Context context;
  final AWSHttpRequest request;
  final SignerTestMethodData headerTestData;
  final SignerTestMethodData queryTestData;

  final AWSSigV4Signer signer;
  final AWSCredentialScope credentialScope;

  SignerTest({
    required this.name,
    required this.context,
    required this.request,
    required this.headerTestData,
    required this.queryTestData,
  })  : signer = AWSSigV4Signer(context.credentials, algorithm: algorithm),
        credentialScope = AWSCredentialScope(
          dateTime: context.awsDateTime,
          region: context.region,
          service: context.service,
        );

  void _runMethod(SignerTestMethod method) {
    final testMethodData =
        method == SignerTestMethod.header ? headerTestData : queryTestData;
    final presignedUrl = method == SignerTestMethod.query;

    group(method.string, () {
      final canonicalRequest = CanonicalRequest(
        request: request,
        credentials: context.credentials,
        credentialScope: credentialScope,
        algorithm: algorithm,
        presignedUrl: presignedUrl,
        normalizePath: context.normalize,
        omitSessionTokenFromSigning: context.omitSessionToken ?? false,
        expiresIn: context.expirationInSeconds,
      );
      final stringToSign = signer.stringToSign(
        algorithm: algorithm,
        credentialScope: credentialScope,
        canonicalRequestHash: canonicalRequest.hash,
      );
      final signedRequest = signer.sign(
        request,
        credentialScope: credentialScope,
        presignedUrl: presignedUrl,
        normalizePath: context.normalize,
        omitSessionTokenFromSigning: context.omitSessionToken,
        expiresIn: context.expirationInSeconds,
      );
      test('canonical request', () {
        expect(
          canonicalRequest.toString(),
          equals(testMethodData.canonicalRequest),
        );
      });
      test('sts', () {
        expect(stringToSign, equals(testMethodData.stringToSign));
      });
      test('signature', () {
        expect(signedRequest.signature, equals(testMethodData.signature));
      });
      group('signed request', () {
        test('headers', () {
          expect(
            const MapEquality<String, String>(keys: CaseInsensitiveEquality())
                .equals(
              signedRequest.headers,
              testMethodData.signedRequest.headers,
            ),
            isTrue,
          );
        });
        test('path', () {
          expect(
            signedRequest.path,
            equals(testMethodData.signedRequest.path),
          );
        });
        test('query parameters', () {
          expect(
            const MapEquality<String, String>().equals(
              signedRequest.queryParameters,
              testMethodData.signedRequest.queryParameters,
            ),
            isTrue,
          );
        });
      });
    });
  }

  void run() {
    group(name, () {
      _runMethod(SignerTestMethod.header);
      _runMethod(SignerTestMethod.query);
    });
  }
}
