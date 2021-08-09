import 'package:amplify_common/src/serializable.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_config.g.dart';

typedef AWSCognitoUserPoolConfigs = Map<String, AWSCognitoUserPoolConfig>;

extension AWSCognitoUserPoolConfigsX on AWSCognitoUserPoolConfigs {
  AWSCognitoUserPoolConfig? get defaultConfig => this['Default'];
}

@awsSerializable
class AuthConfig with EquatableMixin {
  final Map<String, Map<String, dynamic>> plugins;

  AWSCognitoAuthPlugin? get awsCognitoAuthPlugin {
    final json = plugins['awsCognitoAuthPlugin'];
    if (json == null) return null;
    return AWSCognitoAuthPlugin.fromJson(json);
  }

  const AuthConfig(this.plugins);

  @override
  List<Object?> get props => [plugins];

  factory AuthConfig.fromJson(Map json) => _$AuthConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AuthConfigToJson(this);
}

@awsSerializable
class AWSCognitoAuthPlugin with EquatableMixin {
  @JsonKey(name: 'UserAgent')
  final String userAgent;

  @JsonKey(name: 'Version')
  final String version;

  @JsonKey(name: 'CognitoUserPool')
  final AWSCognitoUserPoolConfigs? userPool;

  const AWSCognitoAuthPlugin({
    required this.userAgent,
    required this.version,
    this.userPool,
  });

  @override
  List<Object?> get props => [
        userAgent,
        version,
        userPool,
      ];

  factory AWSCognitoAuthPlugin.fromJson(Map json) =>
      _$AWSCognitoAuthPluginFromJson(json);

  Map<String, dynamic> toJson() => _$AWSCognitoAuthPluginToJson(this);
}

@awsSerializable
class AWSCognitoUserPoolConfig with EquatableMixin {
  @JsonKey(name: 'PoolId')
  final String poolId;

  @JsonKey(name: 'AppClientId')
  final String appClientId;

  @JsonKey(name: 'Region')
  final String region;

  const AWSCognitoUserPoolConfig({
    required this.poolId,
    required this.appClientId,
    required this.region,
  });

  @override
  List<Object?> get props => [poolId, appClientId, region];

  factory AWSCognitoUserPoolConfig.fromJson(Map json) =>
      _$AWSCognitoUserPoolConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AWSCognitoUserPoolConfigToJson(this);
}
