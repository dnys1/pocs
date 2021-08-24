import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:amplify_common/src/util/equatable.dart';
import 'package:amplify_common/src/util/serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cognito_config.g.dart';

/// Factory for [CognitoPlugin].
class CognitoPluginFactory
    extends AmplifyPluginConfigFactory<AWSCognitoAuthPlugin> {
  const CognitoPluginFactory();

  @override
  AWSCognitoAuthPlugin build(Map<String, dynamic> json) {
    return AWSCognitoAuthPlugin.fromJson(json);
  }

  @override
  String get name => 'awsCognitoAuthPlugin';
}

typedef AWSCognitoUserPoolConfigs = Map<String, AWSCognitoUserPoolConfig>;

extension AWSCognitoUserPoolConfigsX on AWSCognitoUserPoolConfigs {
  AWSCognitoUserPoolConfig? get $default => this['Default'];
}

typedef AWSCognitoAuthConfigs = Map<String, AWSCognitoAuthConfig>;

extension AWSCognitoAuthConfigsX on AWSCognitoAuthConfigs {
  AWSCognitoAuthConfig? get $default => this['Default'];
}

@awsSerializable
class AWSCognitoAuthPlugin
    with AmplifyEquatable, AmplifySerializable
    implements AmplifyPluginConfig {
  @override
  String get name => 'awsCognitoAuthPlugin';

  final String userAgent;
  final String version;
  final AWSCredentialsProvider? credentialsProvider;

  @JsonKey(name: 'CognitoUserPool')
  final AWSCognitoUserPoolConfigs? userPool;
  final AWSCognitoAuthConfigs? auth;

  const AWSCognitoAuthPlugin({
    required this.userAgent,
    required this.version,
    this.credentialsProvider,
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

  factory AWSCognitoAuthPlugin.fromJson(Map<String, dynamic> json) =>
      _$AWSCognitoAuthPluginFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AWSCognitoAuthPluginToJson(this);
}

@awsSerializable
class AWSCognitoIdentityCredentialsProvider
    with AmplifyEquatable, AmplifySerializable {
  final String poolId;
  final String region;

  const AWSCognitoIdentityCredentialsProvider({
    required this.poolId,
    required this.region,
  });

  @override
  List<Object> get props => [poolId, region];

  factory AWSCognitoIdentityCredentialsProvider.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AWSCognitoIdentityCredentialsProviderFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$AWSCognitoIdentityCredentialsProviderToJson(this);
}

typedef AWSCredentialsProvider = Map<String, Map<String, dynamic>>;

extension AWSCredentialsProviderX on AWSCredentialsProvider {
  AWSCognitoCredentialsProviders? get cognitoIdentity {
    final cognitoIdentityMap = this['CognitoIdentity'];
    if (cognitoIdentityMap == null) {
      return null;
    }
    return cognitoIdentityMap.map(
      (key, json) => MapEntry(
        key,
        AWSCognitoIdentityCredentialsProvider.fromJson(json),
      ),
    );
  }
}

typedef AWSCognitoCredentialsProviders
    = Map<String, AWSCognitoIdentityCredentialsProvider>;

extension AWSCognitoCredentialsProvidersX on AWSCognitoCredentialsProviders {
  AWSCognitoIdentityCredentialsProvider? get $default => this['Default'];
}

@awsSerializable
class AWSCognitoUserPoolConfig with AmplifyEquatable, AmplifySerializable {
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

  factory AWSCognitoUserPoolConfig.fromJson(Map<String, dynamic> json) =>
      _$AWSCognitoUserPoolConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AWSCognitoUserPoolConfigToJson(this);
}

@amplifySerializable
class AWSCognitoAuthConfig with AmplifyEquatable, AmplifySerializable {
  @JsonKey(name: 'OAuth')
  final AWSCognitoOAuthConfig? oauth;

  const AWSCognitoAuthConfig({
    this.oauth,
  });

  @override
  List<Object?> get props => [oauth];

  factory AWSCognitoAuthConfig.fromJson(Map<String, dynamic> json) =>
      _$AWSCognitoAuthConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AWSCognitoAuthConfigToJson(this);
}

@awsSerializable
class AWSCognitoOAuthConfig with AmplifyEquatable, AmplifySerializable {
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

  factory AWSCognitoOAuthConfig.fromJson(Map<String, dynamic> json) =>
      _$AWSCognitoOAuthConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AWSCognitoOAuthConfigToJson(this);
}
