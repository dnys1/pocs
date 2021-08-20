import 'test_data.dart';

Future<void> main() async {
  final testCases = await loadAllTests();

  for (final testCase in testCases) {
    testCase.run();
  }
}
