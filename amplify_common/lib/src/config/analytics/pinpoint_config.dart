part of 'analytics_config.dart';

/// {@template amplify_common.pinpoint_plugin_config_factory}
/// A factory for [PinpointPluginConfig].
/// {@endtemplate}
class PinpointPluginConfigFactory
    extends AmplifyPluginConfigFactory<PinpointPluginConfig> {
  /// {@macro amplify_common.pinpoint_plugin_config_factory}
  const PinpointPluginConfigFactory();

  @override
  PinpointPluginConfig build(Map<String, Object?> json) {
    return PinpointPluginConfig.fromJson(json);
  }

  @override
  String get name => PinpointPluginConfig.pluginKey;
}

/// {@template amplify_common.config.pinpoint_plugin_config}
/// The AWS Pinpoint plugin configuration.
/// {@endtemplate}
@amplifySerializable
class PinpointPluginConfig
    with AWSEquatable<PinpointPluginConfig>, AWSSerializable
    implements AmplifyPluginConfig {
  /// {@macro amplify_common.config.pinpoint_plugin_config}
  const PinpointPluginConfig({
    required this.pinpointAnalytics,
    required this.pinpointTargeting,
  });

  /// The plugin's configuration key.
  static const pluginKey = 'awsPinpointAnalyticsPlugin';

  final PinpointAnalytics pinpointAnalytics;
  final PinpointTargeting pinpointTargeting;

  @override
  List<Object?> get props => [pinpointAnalytics, pinpointTargeting];

  factory PinpointPluginConfig.fromJson(Map<String, Object?> json) =>
      _$PinpointPluginConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$PinpointPluginConfigToJson(this);

  @override
  String get name => pluginKey;
}

@amplifySerializable
class PinpointAnalytics with AWSEquatable<PinpointAnalytics>, AWSSerializable {
  const PinpointAnalytics({
    required this.appId,
    required this.region,
  });

  final String appId;
  final String region;

  @override
  List<Object?> get props => [appId, region];

  factory PinpointAnalytics.fromJson(Map<String, Object?> json) =>
      _$PinpointAnalyticsFromJson(json);

  @override
  Map<String, Object?> toJson() => _$PinpointAnalyticsToJson(this);
}

@amplifySerializable
class PinpointTargeting with AWSEquatable<PinpointTargeting>, AWSSerializable {
  const PinpointTargeting({
    required this.region,
  });

  final String region;

  @override
  List<Object?> get props => [region];

  factory PinpointTargeting.fromJson(Map<String, Object?> json) =>
      _$PinpointTargetingFromJson(json);

  @override
  Map<String, Object?> toJson() => _$PinpointTargetingToJson(this);
}
