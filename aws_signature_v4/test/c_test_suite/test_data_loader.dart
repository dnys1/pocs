import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'context.dart';
import 'request_parser.dart';
import 'test_data.dart';

/// Handles parsing for one file.
typedef TestFileParser = Future<void> Function(SignerTestBuilder, String);

/// File parsers for the current test suite directory organization.
const Map<String, TestFileParser> _fileParsers = {
  'context.json': _parseContext,
  'request.txt': _parseRequest,
  'query-canonical-request.txt': _parseQueryCanonicalRequest,
  'query-string-to-sign.txt': _parseQueryStringToSign,
  'query-signature.txt': _parseQuerySignature,
  'query-signed-request.txt': _parseQuerySignedRequest,
  'header-canonical-request.txt': _parseHeaderCanonicalRequest,
  'header-string-to-sign.txt': _parseHeaderStringToSign,
  'header-signature.txt': _parseHeaderSignature,
  'header-signed-request.txt': _parseHeaderSignedRequest,
};

/// Parses raw HTTP requests.
final _requestParser = SignerRequestParser();

/// Loads all test cases in the C signer test suite by walking the file tree
/// and creating a [SignerTest] for each folder encountered where all requisite
/// files are available.
Future<List<SignerTest>> loadAllTests() async {
  await _requestParser.init();

  final testSuitePath = path.joinAll([
    Directory.current.path,
    'external',
    'aws-c-auth',
    'tests',
    'aws-signing-test-suite',
    'v4',
  ]);
  final testCases = <SignerTest>[];

  for (var entity in Directory(testSuitePath).listSync()) {
    final stat = entity.statSync();
    if (stat.type != FileSystemEntityType.directory) {
      throw StateError('Unexpected top level file found: ${entity.path}');
    }
    final testCaseDir = Directory(entity.path);
    final testCaseName = path.basename(entity.path);
    final testCaseBuilder = SignerTestBuilder(testCaseName);

    // List all the files in the test directory and sort them alphabetically.
    // This is required to ensure that `context.json` is the first file parsed,
    // since it's data is used to parse other files accordingly, namely `request.txt`.
    final testFiles =
        testCaseDir.listSync().map((ent) => File(ent.path)).toList()
          ..sort(
            (a, b) => path.basename(a.path).compareTo(
                  path.basename(b.path),
                ),
          );

    // Some folders do not include all the necessary files. Not sure why - maybe
    // they are borrowing the rest of the files from other folders, but it's not
    // clear. This represents only 2 tests, as of writing.
    if (testFiles.length < 10) {
      print('Warning: $testCaseName does not include all necessary files');
      continue;
    }

    for (var testFile in testFiles) {
      final filename = path.basename(testFile.path);
      final data = testFile.readAsStringSync();
      final parser = _fileParsers[filename]!;
      await parser(testCaseBuilder, data);
    }

    testCases.add(testCaseBuilder.build());
  }

  await _requestParser.close();

  return testCases;
}

/// Parses `context.json`.
Future<void> _parseContext(
  SignerTestBuilder builder,
  String data,
) async {
  final json = jsonDecode(data) as Map<String, dynamic>;
  builder.context = Context.fromJson(json);
}

/// Parses `request.txt`.
Future<void> _parseRequest(
  SignerTestBuilder builder,
  String data,
) async {
  builder.request = await _requestParser.parse(
    data,
    context: builder.context,
  );
}

/// query-canonical-request.txt`.
Future<void> _parseQueryCanonicalRequest(
  SignerTestBuilder builder,
  String data,
) async {
  builder.queryCanonicalRequest = data;
}

/// Parses `query-string-to-sign`.
Future<void> _parseQueryStringToSign(
  SignerTestBuilder builder,
  String data,
) async {
  builder.queryStringToSign = data;
}

/// Parses `query-signature.txt':`.
Future<void> _parseQuerySignature(
  SignerTestBuilder builder,
  String data,
) async {
  builder.querySignature = data;
}

/// Parses `query-signed-request.txt`.
Future<void> _parseQuerySignedRequest(
  SignerTestBuilder builder,
  String data,
) async {
  builder.querySignedRequest = await _requestParser.parse(
    data,
    context: builder.context,
  );
}

/// Parses `header-canonical-request.txt`.
Future<void> _parseHeaderCanonicalRequest(
  SignerTestBuilder builder,
  String data,
) async {
  builder.headerCanonicalRequest = data;
}

/// Parses `header-string-to-sign`.
Future<void> _parseHeaderStringToSign(
  SignerTestBuilder builder,
  String data,
) async {
  builder.headerStringToSign = data;
}

/// Parses `header-signature.txt':`.
Future<void> _parseHeaderSignature(
  SignerTestBuilder builder,
  String data,
) async {
  builder.headerSignature = data;
}

/// Parses `header-signed-request.txt`.
Future<void> _parseHeaderSignedRequest(
  SignerTestBuilder builder,
  String data,
) async {
  builder.headerSignedRequest = await _requestParser.parse(
    data,
    context: builder.context,
  );
}
