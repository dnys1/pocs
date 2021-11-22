import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path/path.dart' as path;
import 'package:pub_api_client/pub_api_client.dart';
import 'package:retry/retry.dart';
import 'package:yaml/yaml.dart';

class RetryClient extends oauth2.Client {
  final int maxAttempts;

  RetryClient({
    required oauth2.Credentials credentials,
    this.maxAttempts = 3,
  }) : super(credentials);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return retry(
      () => super.send(request),
      maxAttempts: maxAttempts,
    );
  }
}

Future<PubClient> loadClient() async {
  final dartLocation = '${Platform.environment['HOME']}/.pub-cache';
  final flutterLocation = '${Platform.environment['HOME']}/flutter/.pub-cache';

  String? credentialsPath;
  if (Directory(dartLocation).existsSync()) {
    credentialsPath = path.join(dartLocation, 'credentials.json');
  }
  if (Directory(flutterLocation).existsSync()) {
    credentialsPath ??= path.join(flutterLocation, 'credentials.json');
  }

  File? credentialsFile =
      credentialsPath == null ? null : File(credentialsPath);
  if (credentialsFile == null || !credentialsFile.existsSync()) {
    print('Could not locate pub credentials');
    return PubClient();
  }
  final credentialsJson = jsonDecode(credentialsFile.readAsStringSync()) as Map;
  final expInt = credentialsJson['expiration'] as int?;
  final credentials = oauth2.Credentials(
    credentialsJson['accessToken'] as String,
    refreshToken: credentialsJson['refreshToken'] as String,
    idToken: credentialsJson['idToken'] as String?,
    scopes: (credentialsJson['scopes'] as List?)?.cast<String>(),
    expiration:
        expInt == null ? null : DateTime.fromMillisecondsSinceEpoch(expInt),
    tokenEndpoint: Uri.parse(credentialsJson['tokenEndpoint'] as String),
  );
  final retryClient = RetryClient(
    credentials: credentials,
  );

  return PubClient(client: retryClient);
}

Future<void> main(List<String> arguments) async {
  final lock = File.fromUri(Platform.script.resolve('pubspec.lock'));
  final data = lock.readAsStringSync();
  final yaml = loadYamlDocument(data);
  final deps = getDependencies(yaml);
  final pubClient = await loadClient();

  final publisherFutures = <String, Future<String?>>{
    for (var dep in deps) dep: getPublisher(pubClient, dep),
  };
  final publishers = await Future.wait(publisherFutures.keys.map((key) async {
    return MapEntry(key, await publisherFutures[key]);
  }));
  final packagesByPublisher = <String, List<String>>{};
  for (var packagePublisher in publishers) {
    final package = packagePublisher.key;
    final publisher = packagePublisher.value ?? 'null';
    (packagesByPublisher[publisher] ??= []).add(package);
  }

  File('out.json').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(packagesByPublisher),
  );
}

Future<String?> getPublisher(PubClient client, String packageName) async {
  final publisher = await client.packagePublisher(packageName);
  final publisherId = publisher.publisherId;
  if (publisherId != null) {
    return publisherId;
  }
  final packageInfo = await client.packageInfo(packageName);
  final githubUrl =
      packageInfo.latestPubspec.unParsedYaml?['repository'] as String? ??
          packageInfo.latestPubspec.homepage;
  if (githubUrl == null) {
    return null;
  }
  final reg = RegExp(r'https://github.com/(\w+)/.*');
  if (reg.hasMatch(githubUrl)) {
    final match = reg.firstMatch(githubUrl)?.group(1);
    if (match != null) {
      return match;
    }
  }
  return githubUrl;
}

List<String> getDependencies(YamlDocument doc) {
  final value = doc.contents.value as YamlMap;
  final packages = value['packages'] as YamlMap;
  final packageNames = <String>[];
  for (var package in packages.entries) {
    final name = package.key as String;
    final val = package.value as YamlMap;
    if (val['source'] != 'path') {
      packageNames.add(name);
    }
  }
  return packageNames;
}
