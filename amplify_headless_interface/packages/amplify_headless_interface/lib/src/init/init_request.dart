import 'dart:convert';

import 'dart:io';

class InitRequest {
  final AmplifyConfig amplify;
  final FrontendConfig frontend;
  final Providers providers;

  const InitRequest({
    required this.amplify,
    required this.frontend,
    required this.providers,
  });

  InitRequest.flutterDefaults(
    String projectName,
    CloudFormationConfig cloudFormation, {
    String envName = 'dev',
  })  : amplify = AmplifyConfig(
          projectName: projectName,
          envName: envName,
          defaultEditor: 'code',
        ),
        frontend = FrontendConfig(
          frontend: 'flutter',
          config: FlutterConfig(resDir: './lib/'),
        ),
        providers = Providers(awsCloudFormation: cloudFormation);

  Future<Process> start({
    String? workingDirectory,
    Map<String, String>? environment,
    bool runInShell = false,
  }) async {
    final proc = await Process.start(
      'amplify',
      [
        'init',
        '--amplify',
        jsonEncode(amplify),
        '--frontend',
        jsonEncode(frontend),
        '--providers',
        jsonEncode(providers),
        '--yes',
      ],
      workingDirectory: workingDirectory,
      environment: environment,
      runInShell: runInShell,
    );

    return proc;
  }
}

class Providers {
  final CloudFormationConfig? awsCloudFormation;

  const Providers({
    this.awsCloudFormation,
  });

  Map<String, dynamic> toJson() => {
        if (awsCloudFormation != null)
          'awscloudformation': awsCloudFormation!.toJson(),
      };
}

class CloudFormationConfig {
  final String configLevel;
  final bool useProfile;
  final String? profileName;
  final String? accessKeyId;
  final String? secretAccessKey;
  final String region;

  CloudFormationConfig({
    required this.configLevel,
    required this.useProfile,
    this.profileName,
    this.accessKeyId,
    this.secretAccessKey,
    required this.region,
  }) {
    if (useProfile) {
      ArgumentError.checkNotNull(profileName);
    } else {
      ArgumentError.checkNotNull(accessKeyId);
      ArgumentError.checkNotNull(secretAccessKey);
    }
  }

  Map<String, dynamic> toJson() => {
        'configLevel': configLevel,
        'useProfile': useProfile,
        if (profileName != null) 'profileName': profileName,
        if (accessKeyId != null) 'accessKeyId': accessKeyId,
        if (secretAccessKey != null) 'secretAccessKey': secretAccessKey,
        'region': region,
      };
}

class FrontendConfig {
  final String frontend;
  final String? framework;
  final FlutterConfig config;

  const FrontendConfig({
    required this.frontend,
    this.framework,
    required this.config,
  });

  Map<String, dynamic> toJson() => {
        'frontend': frontend,
        if (framework != null) 'framework': framework,
        'config': config.toJson(),
      };
}

class AmplifyConfig {
  final String projectName;
  final String envName;
  final String defaultEditor;

  const AmplifyConfig({
    required this.projectName,
    required this.envName,
    required this.defaultEditor,
  });

  Map<String, dynamic> toJson() => {
        'projectName': projectName,
        'envName': envName,
        'defaultEditor': defaultEditor,
      };
}

class FlutterConfig {
  final String resDir;

  const FlutterConfig({
    required this.resDir,
  });

  Map<String, dynamic> toJson() => {
        'ResDir': resDir,
      };
}
