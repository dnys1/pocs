// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cognito_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CognitoPluginConfig _$CognitoPluginConfigFromJson(Map<String, dynamic> json) =>
    CognitoPluginConfig(
      userAgent: json['UserAgent'] as String,
      version: json['Version'] as String,
      credentialsProvider:
          (json['CredentialsProvider'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Map<String, dynamic>),
      ),
      userPool: (json['CognitoUserPool'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, CognitoUserPoolConfig.fromJson(e as Map<String, dynamic>)),
      ),
      auth: (json['Auth'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, CognitoAuthConfig.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$CognitoPluginConfigToJson(CognitoPluginConfig instance) {
  final val = <String, dynamic>{
    'UserAgent': instance.userAgent,
    'Version': instance.version,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('CredentialsProvider', instance.credentialsProvider);
  writeNotNull('CognitoUserPool', instance.userPool);
  writeNotNull('Auth', instance.auth);
  return val;
}

CognitoIdentityCredentialsProvider _$CognitoIdentityCredentialsProviderFromJson(
        Map<String, dynamic> json) =>
    CognitoIdentityCredentialsProvider(
      poolId: json['PoolId'] as String,
      region: json['Region'] as String,
    );

Map<String, dynamic> _$CognitoIdentityCredentialsProviderToJson(
        CognitoIdentityCredentialsProvider instance) =>
    <String, dynamic>{
      'PoolId': instance.poolId,
      'Region': instance.region,
    };

CognitoUserPoolConfig _$CognitoUserPoolConfigFromJson(
        Map<String, dynamic> json) =>
    CognitoUserPoolConfig(
      poolId: json['PoolId'] as String,
      appClientId: json['AppClientId'] as String,
      region: json['Region'] as String,
    );

Map<String, dynamic> _$CognitoUserPoolConfigToJson(
        CognitoUserPoolConfig instance) =>
    <String, dynamic>{
      'PoolId': instance.poolId,
      'AppClientId': instance.appClientId,
      'Region': instance.region,
    };

CognitoAuthConfig _$CognitoAuthConfigFromJson(Map<String, dynamic> json) =>
    CognitoAuthConfig(
      oauth: json['OAuth'] == null
          ? null
          : CognitoOAuthConfig.fromJson(json['OAuth'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CognitoAuthConfigToJson(CognitoAuthConfig instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('OAuth', instance.oauth);
  return val;
}

CognitoOAuthConfig _$CognitoOAuthConfigFromJson(Map<String, dynamic> json) =>
    CognitoOAuthConfig(
      webDomain: json['WebDomain'] as String,
      appClientId: json['AppClientId'] as String,
      signInRedirectUri: Uri.parse(json['SignInRedirectURI'] as String),
      signOutRedirectUri: Uri.parse(json['SignOutRedirectURI'] as String),
      scopes:
          (json['Scopes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CognitoOAuthConfigToJson(CognitoOAuthConfig instance) =>
    <String, dynamic>{
      'WebDomain': instance.webDomain,
      'AppClientId': instance.appClientId,
      'SignInRedirectURI': instance.signInRedirectUri.toString(),
      'SignOutRedirectURI': instance.signOutRedirectUri.toString(),
      'Scopes': instance.scopes,
    };
