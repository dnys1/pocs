// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthConfig _$AuthConfigFromJson(Map json) {
  return AuthConfig(
    (json['plugins'] as Map).map(
      (k, e) => MapEntry(k as String, Map<String, dynamic>.from(e as Map)),
    ),
  );
}

Map<String, dynamic> _$AuthConfigToJson(AuthConfig instance) =>
    <String, dynamic>{
      'plugins': instance.plugins,
    };

AWSCognitoAuthPlugin _$AWSCognitoAuthPluginFromJson(Map json) {
  return AWSCognitoAuthPlugin(
    userAgent: json['UserAgent'] as String,
    version: json['Version'] as String,
    userPool: (json['CognitoUserPool'] as Map?)?.map(
      (k, e) =>
          MapEntry(k as String, AWSCognitoUserPoolConfig.fromJson(e as Map)),
    ),
  );
}

Map<String, dynamic> _$AWSCognitoAuthPluginToJson(
        AWSCognitoAuthPlugin instance) =>
    <String, dynamic>{
      'UserAgent': instance.userAgent,
      'Version': instance.version,
      'CognitoUserPool': instance.userPool,
    };

AWSCognitoUserPoolConfig _$AWSCognitoUserPoolConfigFromJson(Map json) {
  return AWSCognitoUserPoolConfig(
    poolId: json['PoolId'] as String,
    appClientId: json['AppClientId'] as String,
    region: json['Region'] as String,
  );
}

Map<String, dynamic> _$AWSCognitoUserPoolConfigToJson(
        AWSCognitoUserPoolConfig instance) =>
    <String, dynamic>{
      'PoolId': instance.poolId,
      'AppClientId': instance.appClientId,
      'Region': instance.region,
    };
