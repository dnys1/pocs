part of 'analytics_config.dart';

/// Factory for [PinpointPluginConfig].
class PinpointPluginConfigFactory
    extends AmplifyPluginConfigFactory<PinpointPluginConfig> {
  const PinpointPluginConfigFactory();

  @override
  PinpointPluginConfig build(Map<String, Object?> json) {
    return PinpointPluginConfig.fromJson(json);
  }

  @override
  String get name => 'awsPinpointAnalyticsPlugin';
}

@amplifySerializable
class PinpointPluginConfig
    with AWSEquatable, AWSSerializable
    implements AmplifyPluginConfig {
  const PinpointPluginConfig({
    required this.pinpointAnalytics,
    required this.pinpointTargeting,
  });

  final PinpointAnalytics pinpointAnalytics;
  final PinpointTargeting pinpointTargeting;

  @override
  List<Object?> get props => [pinpointAnalytics, pinpointTargeting];

  factory PinpointPluginConfig.fromJson(Map<String, Object?> json) =>
      _$PinpointPluginConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$PinpointPluginConfigToJson(this);

  @override
  String get name => 'awsPinpointAnalyticsPlugin';
}

@amplifySerializable
class PinpointAnalytics with AWSEquatable, AWSSerializable {
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
class PinpointTargeting with AWSEquatable, AWSSerializable {
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
