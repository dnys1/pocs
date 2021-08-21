import 'dart:convert';
import 'dart:io';

import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/credentials/aws_credential_scope.dart';
import 'package:aws_signature_v4/src/request/canonical_request/canonical_request.dart';
import 'package:aws_signature_v4/src/signer/signer.dart';
import 'package:aws_signature_v4/src/signer/aws_algorithm.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'context.dart';
import 'request_parser.dart';

enum SignerTestMethod { query, header }

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

class _SignerTestBuilder {
  final String name;

  _SignerTestBuilder(this.name);

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

class SignerTest {
  final String name;
  final Context context;
  final AWSHttpRequest request;
  final SignerTestMethodData headerTestData;
  final SignerTestMethodData queryTestData;

  const SignerTest({
    required this.name,
    required this.context,
    required this.request,
    required this.headerTestData,
    required this.queryTestData,
  });

  void run() {
    group(name, () {
      const algorithm = AWSAlgorithm.hmacSha256;
      final signer = AWSSigV4Signer(context.credentials, algorithm: algorithm);
      final requestBuilder = CanonicalRequestBuilder(request);
      final dateTime = context.awsDateTime;
      final credentialScope = AWSCredentialScope(
        dateTime: dateTime,
        region: context.region,
        service: context.service,
      );

      group('header', () {
        final headerRequest = requestBuilder.build(
          credentials: context.credentials,
          credentialScope: credentialScope,
          algorithm: algorithm,
          presignedUrl: false,
          normalizeUriPath: context.normalize,
          omitSessionToken: context.omitSessionToken ?? false,
        );
        final stringToSign = signer.stringToSign(
          algorithm: algorithm,
          credentialScope: credentialScope,
          canonicalRequestHash: headerRequest.hash,
        );
        final signedRequest = signer.sign(
          request,
          credentialScope: credentialScope,
          presignedUrl: false,
          normalizeUriPath: context.normalize,
          omitSessionToken: context.omitSessionToken,
        );
        test('canonical request', () {
          expect(
            headerRequest.toString(),
            equals(headerTestData.canonicalRequest),
          );
        });
        test('sts', () {
          expect(stringToSign, equals(headerTestData.stringToSign));
        });
        test('signature', () {
          expect(signedRequest.signature, equals(headerTestData.signature));
        });
        test('request', () {
          expect(
            const MapEquality<String, String>(keys: CaseInsensitiveEquality())
                .equals(
              signedRequest.headers,
              headerTestData.signedRequest.headers,
            ),
            isTrue,
          );
          expect(
            signedRequest.path,
            equals(headerTestData.signedRequest.path),
          );
          expect(
            const MapEquality<String, String>().equals(
              signedRequest.queryParameters,
              headerTestData.signedRequest.queryParameters,
            ),
            isTrue,
          );
        });
      });

      group('query', () {
        final queryRequest = requestBuilder.build(
          credentials: context.credentials,
          credentialScope: credentialScope,
          presignedUrl: true,
          normalizeUriPath: context.normalize,
          omitSessionToken: context.omitSessionToken ?? false,
          algorithm: algorithm,
          expiresIn: context.expirationInSeconds,
        );
        final stringToSign = signer.stringToSign(
          algorithm: algorithm,
          credentialScope: credentialScope,
          canonicalRequestHash: queryRequest.hash,
        );
        final signedRequest = signer.sign(
          request,
          credentialScope: credentialScope,
          presignedUrl: true,
          normalizeUriPath: context.normalize,
          omitSessionToken: context.omitSessionToken,
          expiresIn: context.expirationInSeconds,
        );
        test('canonical request', () {
          expect(
            queryRequest.toString(),
            equals(queryTestData.canonicalRequest),
          );
        });
        test('sts', () {
          expect(stringToSign, equals(queryTestData.stringToSign));
        });
        test('signature', () {
          expect(signedRequest.signature, equals(queryTestData.signature));
        });
        test('request', () {
          expect(
            const MapEquality<String, String>(keys: CaseInsensitiveEquality())
                .equals(
              signedRequest.headers,
              queryTestData.signedRequest.headers,
            ),
            isTrue,
          );
          expect(
            signedRequest.path,
            equals(queryTestData.signedRequest.path),
          );
          expect(
            const MapEquality<String, String>().equals(
              signedRequest.queryParameters,
              queryTestData.signedRequest.queryParameters,
            ),
            isTrue,
          );
        });
      });
      // }, skip: name != 'get-header-key-duplicate');
      // }, skip: context.credentials.token != null);
    }, skip: name == 'get-header-value-multiline');
  }
}

/// Loads all test cases in the C signer test suite.
Future<List<SignerTest>> loadAllTests() async {
  final testSuitePath = path.joinAll([
    Directory.current.path,
    'external',
    'aws-c-auth',
    'tests',
    'aws-signing-test-suite',
    'v4',
  ]);
  final testCases = <SignerTest>[];
  final requestParser = SignerRequestParser();
  await requestParser.init();
  for (var entity in Directory(testSuitePath).listSync()) {
    final stat = entity.statSync();
    if (stat.type != FileSystemEntityType.directory) continue;
    final testCaseDir = Directory(entity.path);
    final testCaseName = path.basename(entity.path);
    final testCase = _SignerTestBuilder(testCaseName);
    final testFiles =
        testCaseDir.listSync().map((fse) => File(fse.path)).toList()
          ..sort(
            (a, b) => path.basename(a.path).compareTo(
                  path.basename(b.path),
                ),
          );
    if (testFiles.length < 10) continue;
    for (var testFile in testFiles) {
      final data = testFile.readAsStringSync();
      switch (path.basename(testFile.path)) {
        case 'context.json':
          final json = jsonDecode(data) as Map<String, dynamic>;
          testCase.context = Context.fromJson(json);
          break;
        case 'request.txt':
          testCase.request =
              await requestParser.parse(data, context: testCase.context);
          break;
        case 'query-canonical-request.txt':
          testCase.queryCanonicalRequest = data;
          break;
        case 'query-string-to-sign.txt':
          testCase.queryStringToSign = data;
          break;
        case 'query-signature.txt':
          testCase.querySignature = data;
          break;
        case 'query-signed-request.txt':
          testCase.querySignedRequest =
              await requestParser.parse(data, context: testCase.context);
          break;
        case 'header-canonical-request.txt':
          testCase.headerCanonicalRequest = data;
          break;
        case 'header-string-to-sign.txt':
          testCase.headerStringToSign = data;
          break;
        case 'header-signature.txt':
          testCase.headerSignature = data;
          break;
        case 'header-signed-request.txt':
          testCase.headerSignedRequest =
              await requestParser.parse(data, context: testCase.context);
          break;
      }
    }
    testCases.add(testCase.build());
  }
  await requestParser.close();

  return testCases;
}
