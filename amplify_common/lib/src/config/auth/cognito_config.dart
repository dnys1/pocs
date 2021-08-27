import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:amplify_common/src/util/serializable.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cognito_config.g.dart';

/// Factory for [CognitoPlugin].
class CognitoPluginFactory
    extends AmplifyPluginConfigFactory<CognitoPluginConfig> {
  const CognitoPluginFactory();

  @override
  CognitoPluginConfig build(Map<String, dynamic> json) {
    return CognitoPluginConfig.fromJson(json);
  }

  @override
  String get name => CognitoPluginConfig.pluginKey;
}

typedef CognitoUserPoolConfigs = Map<String, CognitoUserPoolConfig>;

extension CognitoUserPoolConfigsX on CognitoUserPoolConfigs {
  CognitoUserPoolConfig? get $default => this['Default'];
}

typedef CognitoAuthConfigs = Map<String, CognitoAuthConfig>;

extension CognitoAuthConfigsX on CognitoAuthConfigs {
  CognitoAuthConfig? get $default => this['Default'];
}

@awsSerializable
class CognitoPluginConfig
    with AWSEquatable, AWSSerializable
    implements AmplifyPluginConfig {
  static const pluginKey = 'awsCognitoAuthPlugin';

  @override
  String get name => pluginKey;

  final String userAgent;
  final String version;
  final CredentialsProvider? credentialsProvider;

  @JsonKey(name: 'CognitoUserPool')
  final CognitoUserPoolConfigs? userPool;
  final CognitoAuthConfigs? auth;

  const CognitoPluginConfig({
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

  factory CognitoPluginConfig.fromJson(Map<String, dynamic> json) =>
      _$CognitoPluginConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CognitoPluginConfigToJson(this);
}

@awsSerializable
class CognitoIdentityCredentialsProvider with AWSEquatable, AWSSerializable {
  final String poolId;
  final String region;

  const CognitoIdentityCredentialsProvider({
    required this.poolId,
    required this.region,
  });

  @override
  List<Object> get props => [poolId, region];

  factory CognitoIdentityCredentialsProvider.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CognitoIdentityCredentialsProviderFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$CognitoIdentityCredentialsProviderToJson(this);
}

typedef CredentialsProvider = Map<String, Map<String, dynamic>>;

extension CredentialsProviderX on CredentialsProvider {
  CognitoCredentialsProviders? get cognitoIdentity {
    final cognitoIdentityMap = this['CognitoIdentity'];
    if (cognitoIdentityMap == null) {
      return null;
    }
    return cognitoIdentityMap.map(
      (key, json) => MapEntry(
        key,
        CognitoIdentityCredentialsProvider.fromJson(json),
      ),
    );
  }
}

typedef CognitoCredentialsProviders
    = Map<String, CognitoIdentityCredentialsProvider>;

extension CognitoCredentialsProvidersX on CognitoCredentialsProviders {
  CognitoIdentityCredentialsProvider? get $default => this['Default'];
}

@awsSerializable
class CognitoUserPoolConfig with AWSEquatable, AWSSerializable {
  final String poolId;
  final String appClientId;
  final String region;

  const CognitoUserPoolConfig({
    required this.poolId,
    required this.appClientId,
    required this.region,
  });

  @override
  List<Object?> get props => [poolId, appClientId, region];

  factory CognitoUserPoolConfig.fromJson(Map<String, dynamic> json) =>
      _$CognitoUserPoolConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CognitoUserPoolConfigToJson(this);
}

@amplifySerializable
class CognitoAuthConfig with AWSEquatable, AWSSerializable {
  @JsonKey(name: 'OAuth')
  final CognitoOAuthConfig? oauth;

  const CognitoAuthConfig({
    this.oauth,
  });

  @override
  List<Object?> get props => [oauth];

  factory CognitoAuthConfig.fromJson(Map<String, dynamic> json) =>
      _$CognitoAuthConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CognitoAuthConfigToJson(this);
}

@awsSerializable
class CognitoOAuthConfig with AWSEquatable, AWSSerializable {
  final String webDomain;
  final String appClientId;

  @JsonKey(name: 'SignInRedirectURI')
  final Uri signInRedirectUri;

  @JsonKey(name: 'SignOutRedirectURI')
  final Uri signOutRedirectUri;
  final List<String> scopes;

  const CognitoOAuthConfig({
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

  factory CognitoOAuthConfig.fromJson(Map<String, dynamic> json) =>
      _$CognitoOAuthConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CognitoOAuthConfigToJson(this);
}
