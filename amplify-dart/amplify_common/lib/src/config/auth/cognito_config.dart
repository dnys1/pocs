import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/serializable.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cognito_config.g.dart';

typedef AWSCognitoUserPoolConfigs = Map<String, AWSCognitoUserPoolConfig>;

extension AWSCognitoUserPoolConfigsX on AWSCognitoUserPoolConfigs {
  AWSCognitoUserPoolConfig? get defaultConfig => this['Default'];
}

typedef AWSCognitoAuthConfigs = Map<String, AWSCognitoAuthConfig>;

extension AWSCognitoAuthConfigsX on AWSCognitoAuthConfigs {
  AWSCognitoAuthConfig? get defaultConfig => this['Default'];
}

extension AuthConfigCognitoX on AuthConfig {
  AWSCognitoAuthPlugin? get awsCognitoAuthPlugin {
    final json = plugins['awsCognitoAuthPlugin'];
    if (json == null) return null;
    return AWSCognitoAuthPlugin.fromJson(json);
  }
}

@awsSerializable
class AWSCognitoAuthPlugin with EquatableMixin {
  final String userAgent;
  final String version;

  @JsonKey(name: 'CognitoUserPool')
  final AWSCognitoUserPoolConfigs? userPool;
  final AWSCognitoAuthConfigs? auth;

  const AWSCognitoAuthPlugin({
    required this.userAgent,
    required this.version,
    this.userPool,
    this.auth,
  });

  @override
  List<Object?> get props => [
        userAgent,
        version,
        userPool,
        auth,
      ];

  factory AWSCognitoAuthPlugin.fromJson(Map json) =>
      _$AWSCognitoAuthPluginFromJson(json);

  Map<String, dynamic> toJson() => _$AWSCognitoAuthPluginToJson(this);
}

@awsSerializable
class AWSCognitoUserPoolConfig with EquatableMixin {
  final String poolId;
  final String appClientId;
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

@amplifySerializable
class AWSCognitoAuthConfig with EquatableMixin {
  @JsonKey(name: 'OAuth')
  final AWSCognitoOAuthConfig? oauth;

  const AWSCognitoAuthConfig({
    this.oauth,
  });

  @override
  List<Object?> get props => [oauth];

  factory AWSCognitoAuthConfig.fromJson(Map json) =>
      _$AWSCognitoAuthConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AWSCognitoAuthConfigToJson(this);
}

@awsSerializable
class AWSCognitoOAuthConfig with EquatableMixin {
  final String webDomain;
  final String appClientId;

  @JsonKey(name: 'SignInRedirectURI')
  final Uri signInRedirectUri;

  @JsonKey(name: 'SignOutRedirectURI')
  final Uri signOutRedirectUri;
  final List<String> scopes;

  const AWSCognitoOAuthConfig({
    required this.webDomain,
    required this.appClientId,
    required this.signInRedirectUri,
    required this.signOutRedirectUri,
    required this.scopes,
  });

  @override
  List<Object?> get props => [
        webDomain,
        appClientId,
        signInRedirectUri,
        signOutRedirectUri,
        scopes,
      ];

  factory AWSCognitoOAuthConfig.fromJson(Map json) =>
      _$AWSCognitoOAuthConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AWSCognitoOAuthConfigToJson(this);
}
