import 'package:test/test.dart';

import 'testdata/single_chunk_testdata.dart';

// From: https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html

void main() {
  group('S3', () {
    group('Single Chunk', () {
      for (var signerTest in testCases) {
        signerTest.run();
      }
    });
  });
}
