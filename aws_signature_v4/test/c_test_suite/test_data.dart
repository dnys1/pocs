import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/configuration/service_configuration.dart';
import 'package:aws_signature_v4/src/credentials/credentials_provider.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import 'context.dart';

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
  final AWSBaseHttpRequest signedRequest;

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
  late final AWSBaseHttpRequest request;
  late final String queryCanonicalRequest;
  late final String queryStringToSign;
  late final String querySignature;
  late final AWSBaseHttpRequest querySignedRequest;
  late final String headerCanonicalRequest;
  late final String headerStringToSign;
  late final String headerSignature;
  late final AWSBaseHttpRequest headerSignedRequest;

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
  final AWSBaseHttpRequest request;
  final SignerTestMethodData? headerTestData;
  final SignerTestMethodData? queryTestData;
  final ServiceConfiguration serviceConfiguration;

  final AWSSigV4Signer signer;
  final AWSCredentialScope credentialScope;

  SignerTest({
    required this.name,
    required this.context,
    required this.request,
    this.headerTestData,
    this.queryTestData,
    this.serviceConfiguration = const BaseServiceConfiguration(),
  })  : signer = AWSSigV4Signer(
          credentialsProvider: AWSCredentialsProvider(context.credentials),
          algorithm: algorithm,
        ),
        credentialScope = AWSCredentialScope(
          dateTime: context.awsDateTime,
          region: context.region,
          service: context.service,
        );

  void _runMethod(SignerTestMethod method) {
    final testMethodData =
        method == SignerTestMethod.header ? headerTestData : queryTestData;
    if (testMethodData == null) {
      return;
    }
    final presignedUrl = method == SignerTestMethod.query;
    final payloadHash = serviceConfiguration.hashPayloadSync(request);
    final contentLength = request.contentLength as int;
    final CanonicalRequest canonicalRequest = CanonicalRequest(
      request: request,
      credentials: context.credentials,
      credentialScope: credentialScope,
      payloadHash: payloadHash,
      contentLength: contentLength,
      algorithm: algorithm,
      presignedUrl: presignedUrl,
      normalizePath: context.normalize,
      omitSessionTokenFromSigning: context.omitSessionToken ?? false,
      expiresIn: context.expirationInSeconds,
      configuration: serviceConfiguration,
    );
    final String stringToSign = signer.stringToSign(
      algorithm: algorithm,
      credentialScope: credentialScope,
      canonicalRequest: canonicalRequest,
    );

    group(method.string, () {
      test('canonical request', () {
        expect(
          canonicalRequest.toString(),
          equals(testMethodData.canonicalRequest),
        );
      });
      test('sts', () {
        expect(stringToSign, equals(testMethodData.stringToSign));
      });
      if (presignedUrl) {
        group('presigned url', () {
          final Uri uri = signer.presignSync(
            request as AWSHttpRequest,
            credentialScope: credentialScope,
            normalizePath: context.normalize,
            omitSessionTokenFromSigning: context.omitSessionToken,
            expiresIn: context.expirationInSeconds,
            serviceConfiguration: serviceConfiguration,
          );

          test('signature', () {
            expect(
              uri.queryParameters[AWSHeaders.signature],
              equals(testMethodData.signature),
            );
          });
        });
      } else {
        group('signed request', () {
          final AWSSignedRequest signedRequest = signer.signSync(
            request,
            credentialScope: credentialScope,
            normalizePath: context.normalize,
            omitSessionTokenFromSigning: context.omitSessionToken,
            expiresIn: context.expirationInSeconds,
            serviceConfiguration: serviceConfiguration,
          );

          test('signature', () {
            expect(signedRequest.signature, equals(testMethodData.signature));
          });
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
          test('body', () async {
            final body = await ByteStream(signedRequest.body).toBytes();
            final expected =
                await ByteStream(testMethodData.signedRequest.body).toBytes();
            expect(body, orderedEquals(expected));
          });
        }, skip: presignedUrl);
      }
    });
  }

  void run() {
    group(name, () {
      _runMethod(SignerTestMethod.header);
      _runMethod(SignerTestMethod.query);
    });
  }
}
