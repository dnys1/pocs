// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amplify_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmplifyConfig _$AmplifyConfigFromJson(Map json) {
  return AmplifyConfig(
    userAgent: json['UserAgent'] as String,
    version: json['Version'] as String,
    api: json['api'] == null ? null : ApiConfig.fromJson(json['api'] as Map),
    auth:
        json['auth'] == null ? null : AuthConfig.fromJson(json['auth'] as Map),
  );
}

Map<String, dynamic> _$AmplifyConfigToJson(AmplifyConfig instance) =>
    <String, dynamic>{
      'UserAgent': instance.userAgent,
      'Version': instance.version,
      'api': instance.api,
      'auth': instance.auth,
    };
