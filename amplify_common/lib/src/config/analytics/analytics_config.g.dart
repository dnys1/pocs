// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsConfig _$AnalyticsConfigFromJson(Map<String, dynamic> json) =>
    AnalyticsConfig(
      plugins: AmplifyPluginRegistry.pluginConfigsFromJson(json['plugins']),
    );

Map<String, dynamic> _$AnalyticsConfigToJson(AnalyticsConfig instance) =>
    <String, dynamic>{
      'plugins': instance.plugins.map((k, e) => MapEntry(k, e.toJson())),
    };

PinpointPluginConfig _$PinpointPluginConfigFromJson(
        Map<String, dynamic> json) =>
    PinpointPluginConfig(
      pinpointAnalytics: PinpointAnalytics.fromJson(
          json['pinpointAnalytics'] as Map<String, dynamic>),
      pinpointTargeting: PinpointTargeting.fromJson(
          json['pinpointTargeting'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PinpointPluginConfigToJson(
        PinpointPluginConfig instance) =>
    <String, dynamic>{
      'pinpointAnalytics': instance.pinpointAnalytics.toJson(),
      'pinpointTargeting': instance.pinpointTargeting.toJson(),
    };

PinpointAnalytics _$PinpointAnalyticsFromJson(Map<String, dynamic> json) =>
    PinpointAnalytics(
      appId: json['appId'] as String,
      region: json['region'] as String,
    );

Map<String, dynamic> _$PinpointAnalyticsToJson(PinpointAnalytics instance) =>
    <String, dynamic>{
      'appId': instance.appId,
      'region': instance.region,
    };

PinpointTargeting _$PinpointTargetingFromJson(Map<String, dynamic> json) =>
    PinpointTargeting(
      region: json['region'] as String,
    );

Map<String, dynamic> _$PinpointTargetingToJson(PinpointTargeting instance) =>
    <String, dynamic>{
      'region': instance.region,
    };
