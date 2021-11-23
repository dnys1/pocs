// GENERATED CODE - DO NOT MODIFY BY HAND

part of 's3_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

S3PluginConfig _$S3PluginConfigFromJson(Map<String, dynamic> json) =>
    S3PluginConfig(
      bucket: json['bucket'] as String,
      region: json['region'] as String,
      defaultAccessLevel: json['defaultAccessLevel'] as String,
    );

Map<String, dynamic> _$S3PluginConfigToJson(S3PluginConfig instance) =>
    <String, dynamic>{
      'bucket': instance.bucket,
      'region': instance.region,
      'defaultAccessLevel': instance.defaultAccessLevel,
    };
