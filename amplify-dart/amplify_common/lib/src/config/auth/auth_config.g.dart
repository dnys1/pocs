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
