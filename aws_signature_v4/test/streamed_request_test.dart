import 'dart:async';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

const _dummyCredentials = AWSCredentials('accessKeyId', 'secretAccessKey');

void main() {
  group('AWSStreamedHttpRequest', () {
    final signer = AWSSigV4Signer(
      credentialsProvider: AWSCredentialsProvider(_dummyCredentials),
    );
    final mockClient = MockHttpClient();
    Stream<List<int>> makeBody() => Stream.fromIterable([
          [0],
          [1],
          [2]
        ]);

    group('base service configuration', () {
      test('| body is split twice with contentLength given', () async {
        final request = AWSStreamedHttpRequest(
          method: HttpMethod.post,
          host: 'example.com',
          path: '/',
          body: makeBody(),
          contentLength: 3,
        );
        final signedRequest = await signer.sign(
          request,
          credentialScope: AWSCredentialScope(
            region: 'us-west-2',
            service: 'service',
          ),
        );
        await signedRequest.send(mockClient);

        // Body is split twice, once to hash the payload, then again to read the
        // body which cannot be read from the original body stream.
        expect(request.debugNumSplits, equals(2));
      });

      test('| body is split thrice without contentLength given', () async {
        final request = AWSStreamedHttpRequest(
          method: HttpMethod.post,
          host: 'example.com',
          path: '/',
          body: makeBody(),
        );
        final signedRequest = await signer.sign(
          request,
          credentialScope: AWSCredentialScope(
            region: 'us-west-2',
            service: 'service',
          ),
        );
        await signedRequest.send(mockClient);

        // Body is split thrice, once to hash the payload, once to get the content
        // length, then again to read the body which cannot be read from the
        // original body stream.
        expect(request.debugNumSplits, equals(3));
      });
    });

    group('s3 service configuration', () {
      test('| body is not split when contentLength is given', () async {
        final request = AWSStreamedHttpRequest(
          method: HttpMethod.post,
          host: 'example.com',
          path: '/',
          body: makeBody(),
          contentLength: 3,
        );
        final signedRequest = await signer.sign(
          request,
          credentialScope: AWSCredentialScope(
            region: 'us-west-2',
            service: 'service',
          ),
          serviceConfiguration: S3ServiceConfiguration(),
        );
        await signedRequest.send(mockClient);

        // Body is not split, and the original body stream is used.
        expect(request.debugNumSplits, equals(0));
      });

      test('| body is split twice when contentLength is not given', () async {
        final request = AWSStreamedHttpRequest(
          method: HttpMethod.post,
          host: 'example.com',
          path: '/',
          body: makeBody(),
        );
        final signedRequest = await signer.sign(
          request,
          credentialScope: AWSCredentialScope(
            region: 'us-west-2',
            service: 'service',
          ),
          serviceConfiguration: S3ServiceConfiguration(),
        );
        await signedRequest.send(mockClient);

        // Body is split twice, once to get the content length, then again to
        // read the body which cannot be read from the original body stream.
        expect(request.debugNumSplits, equals(2));
      });
    });
  });
}

class MockHttpClient extends MockClient {
  MockHttpClient() : super(_send);

  static Future<Response> _send(Request request) async {
    // Assert the request is finalized.
    final _ = request.body;
    return Response('', 200);
  }
}
