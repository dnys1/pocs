import 'test_data_loader.dart';

/// Runs all tests in the C signer test suite.
Future<void> main() async {
  final testCases = await loadAllTests();

  for (final testCase in testCases) {
    testCase.run();
  }
}
