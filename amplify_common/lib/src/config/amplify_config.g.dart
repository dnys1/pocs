// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amplify_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmplifyConfig _$AmplifyConfigFromJson(Map<String, dynamic> json) =>
    AmplifyConfig(
      userAgent: json['UserAgent'] as String,
      version: json['Version'] as String,
      api: json['api'] == null
          ? null
          : ApiConfig.fromJson(json['api'] as Map<String, dynamic>),
      analytics: json['analytics'] == null
          ? null
          : AnalyticsConfig.fromJson(json['analytics'] as Map<String, dynamic>),
      auth: json['auth'] == null
          ? null
          : AuthConfig.fromJson(json['auth'] as Map<String, dynamic>),
      geo: json['geo'] == null
          ? null
          : GeoConfig.fromJson(json['geo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AmplifyConfigToJson(AmplifyConfig instance) {
  final val = <String, dynamic>{
    'UserAgent': instance.userAgent,
    'Version': instance.version,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('api', instance.api);
  writeNotNull('analytics', instance.analytics);
  writeNotNull('auth', instance.auth);
  writeNotNull('geo', instance.geo);
  return val;
}
