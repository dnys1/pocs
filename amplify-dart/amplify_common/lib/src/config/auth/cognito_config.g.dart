// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cognito_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AWSCognitoAuthPlugin _$AWSCognitoAuthPluginFromJson(Map<String, dynamic> json) {
  return AWSCognitoAuthPlugin(
    userAgent: json['UserAgent'] as String,
    version: json['Version'] as String,
    credentialsProvider:
        (json['CredentialsProvider'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as Map<String, dynamic>),
    ),
    userPool: (json['CognitoUserPool'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(
          k, AWSCognitoUserPoolConfig.fromJson(e as Map<String, dynamic>)),
    ),
    auth: (json['Auth'] as Map<String, dynamic>?)?.map(
      (k, e) =>
          MapEntry(k, AWSCognitoAuthConfig.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$AWSCognitoAuthPluginToJson(
    AWSCognitoAuthPlugin instance) {
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

AWSCognitoIdentityCredentialsProvider
    _$AWSCognitoIdentityCredentialsProviderFromJson(Map<String, dynamic> json) {
  return AWSCognitoIdentityCredentialsProvider(
    poolId: json['PoolId'] as String,
    region: json['Region'] as String,
  );
}

Map<String, dynamic> _$AWSCognitoIdentityCredentialsProviderToJson(
        AWSCognitoIdentityCredentialsProvider instance) =>
    <String, dynamic>{
      'PoolId': instance.poolId,
      'Region': instance.region,
    };

AWSCognitoUserPoolConfig _$AWSCognitoUserPoolConfigFromJson(
    Map<String, dynamic> json) {
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

AWSCognitoAuthConfig _$AWSCognitoAuthConfigFromJson(Map<String, dynamic> json) {
  return AWSCognitoAuthConfig(
    oauth: json['OAuth'] == null
        ? null
        : AWSCognitoOAuthConfig.fromJson(json['OAuth'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AWSCognitoAuthConfigToJson(
    AWSCognitoAuthConfig instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('OAuth', instance.oauth);
  return val;
}

AWSCognitoOAuthConfig _$AWSCognitoOAuthConfigFromJson(
    Map<String, dynamic> json) {
  return AWSCognitoOAuthConfig(
    webDomain: json['WebDomain'] as String,
    appClientId: json['AppClientId'] as String,
    signInRedirectUri: Uri.parse(json['SignInRedirectURI'] as String),
    signOutRedirectUri: Uri.parse(json['SignOutRedirectURI'] as String),
    scopes: (json['Scopes'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$AWSCognitoOAuthConfigToJson(
        AWSCognitoOAuthConfig instance) =>
    <String, dynamic>{
      'WebDomain': instance.webDomain,
      'AppClientId': instance.appClientId,
      'SignInRedirectURI': instance.signInRedirectUri.toString(),
      'SignOutRedirectURI': instance.signOutRedirectUri.toString(),
      'Scopes': instance.scopes,
    };
