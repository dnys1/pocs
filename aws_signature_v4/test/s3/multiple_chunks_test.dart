import 'package:test/scaffolding.dart';

import 'testdata/multiple_chunks_testdata.dart';

void main() {
  group('Multiple Chunks', () {
    group('PUT Object', () {
      putObjectTest.run();
    });
  });
}
