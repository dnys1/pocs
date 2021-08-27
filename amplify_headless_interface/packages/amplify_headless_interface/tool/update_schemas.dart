import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:tar/tar.dart';

Future<void> main() async {
  // Remove all previous files
  for (var file
      in Directory.fromUri(Platform.script.resolve('../lib')).listSync()) {
    file.deleteSync(recursive: true);
  }

  // Download headless interface to temp directory
  final downloadProc = await Process.start(
    'npm',
    [
      'pack',
      'amplify-headless-interface',
    ],
    workingDirectory: Directory.systemTemp.path,
  );
  final filenameFuture = downloadProc.stdout
      .transform(const Utf8Decoder())
      .transform(const LineSplitter())
      .last;

  exitCode = await downloadProc.exitCode;
  if (exitCode != 0) {
    await downloadProc.stderr.pipe(stderr);
    return;
  }
  final filename = await filenameFuture;
  print('Successfully downloaded $filename');

  final downloadDir = Directory.systemTemp.createTempSync().path;
  print('Unzipping into: $downloadDir');

  // Decompress the npm archive
  final tarFile =
      File(path.join(Directory.systemTemp.path, filename)).openRead();
  final reader = TarReader(tarFile.transform(gzip.decoder));

  while (await reader.moveNext()) {
    final entry = reader.current;
    print(entry.header.name);
    final entryFile = File(path.join(downloadDir, entry.header.name))
      ..createSync(recursive: true);
    final contents = await entry.contents.toList();
    await entryFile.writeAsBytes(contents.expand((e) => e).toList());
  }

  // Copy schemas to lib/src
  final schemaDir = path.join(downloadDir, 'package', 'schemas') + '/';
  final outputDir = Platform.script.resolve('../lib/src').path;

  final copyProc = await Process.run(
    'cp',
    [
      '-R',
      schemaDir,
      outputDir,
    ],
    stderrEncoding: utf8,
    stdoutEncoding: utf8,
  );

  exitCode = copyProc.exitCode;
  if (exitCode != 0) {
    stderr.write(copyProc.stderr);
    return;
  }
  print('Successfully copied JSON schemas');

  // Rename files to snake case
  final filepaths = <String>[];
  for (var file in Directory(outputDir).listSync(recursive: true)) {
    if (file.statSync().type != FileSystemEntityType.file) {
      continue;
    }
    final newPath = path.join(
      path.dirname(file.path),
      path.basename(file.path).split('.').first.snakeCase,
    );
    file.renameSync(newPath + '.schema.json');
    filepaths.add(newPath + '.dart');
  }

  // Run json_schema_builder to update dart files
  final buildProc = await Process.start(
    'dart',
    [
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ],
    workingDirectory: Platform.script.resolve('..').path,
  );
  print('Generating Dart schemas...');

  buildProc.stdout.pipe(stdout);
  buildProc.stderr.pipe(stderr);

  exitCode = await buildProc.exitCode;
  if (exitCode != 0) {
    return;
  }

  // Create library file
  final headerFile = File.fromUri(Platform.script.resolve('header.txt'));
  final headerContents = headerFile.readAsStringSync();

  for (var filepath in filepaths..sort()) {
    final sb = StringBuffer();
    sb.write(headerContents);
    sb.writeln('library ${path.basenameWithoutExtension(filepath)};');
    sb.writeln();
    if (path.isAbsolute(filepath)) {
      filepath = path.relative(
        filepath,
        from: Platform.script.resolve('../lib').path,
      );
    }
    sb.writeln("export '$filepath';");
    final libraryContents = sb.toString();

    final libraryFile = File.fromUri(Platform.script.resolve(
      '../lib/${path.basename(filepath)}',
    ));

    libraryFile.writeAsStringSync(libraryContents);
  }
}
