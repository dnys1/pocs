// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cognito_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CognitoPluginConfig _$CognitoPluginConfigFromJson(Map<String, dynamic> json) =>
    CognitoPluginConfig(
      userAgent: json['UserAgent'] as String? ?? 'aws-amplify-cli/0.1.0',
      version: json['Version'] as String? ?? '0.1.0',
      identityManager: (json['IdentityManager'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, CognitoIdentityManager.fromJson(e as Map<String, dynamic>)),
      ),
      credentialsProvider:
          (json['CredentialsProvider'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Map<String, dynamic>),
      ),
      cognitoUserPool: (json['CognitoUserPool'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, CognitoUserPoolConfig.fromJson(e as Map<String, dynamic>)),
      ),
      auth: (json['Auth'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, CognitoAuthConfig.fromJson(e as Map<String, dynamic>)),
      ),
      appSync: (json['AppSync'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, AppSyncApiConfig.fromJson(e as Map<String, dynamic>)),
      ),
      pinpointAnalytics:
          (json['PinpointAnalytics'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, PinpointAnalytics.fromJson(e as Map<String, dynamic>)),
      ),
      pinpointTargeting:
          (json['PinpointTargeting'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, PinpointTargeting.fromJson(e as Map<String, dynamic>)),
      ),
      s3TransferUtility:
          (json['S3TransferUtility'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, S3TransferUtility.fromJson(e as Map<String, dynamic>)),
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

  writeNotNull('IdentityManager',
      instance.identityManager?.map((k, e) => MapEntry(k, e.toJson())));
  writeNotNull('CredentialsProvider', instance.credentialsProvider);
  writeNotNull('CognitoUserPool',
      instance.cognitoUserPool?.map((k, e) => MapEntry(k, e.toJson())));
  writeNotNull('Auth', instance.auth?.map((k, e) => MapEntry(k, e.toJson())));
  writeNotNull(
      'AppSync', instance.appSync?.map((k, e) => MapEntry(k, e.toJson())));
  writeNotNull('PinpointAnalytics',
      instance.pinpointAnalytics?.map((k, e) => MapEntry(k, e.toJson())));
  writeNotNull('PinpointTargeting',
      instance.pinpointTargeting?.map((k, e) => MapEntry(k, e.toJson())));
  writeNotNull('S3TransferUtility',
      instance.s3TransferUtility?.map((k, e) => MapEntry(k, e.toJson())));
  return val;
}
