import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

import 'pinpoint_config.dart';

part 'analytics_config.g.dart';

/// {@template amplify_common.config.analytics_config}
/// The Analytics category configuration.
/// {@endtemplate}
@amplifySerializable
class AnalyticsConfig with AWSEquatable<AnalyticsConfig>, AWSSerializable {
  /// {@macro amplify_common.config.analytics_config}
  const AnalyticsConfig({required this.plugins});

  /// All Analytics category plugin configurations.
  @JsonKey(fromJson: AmplifyPluginRegistry.pluginConfigsFromJson)
  final AmplifyPlugins plugins;

  /// The AWS Pinpoint plugin configuration, if available.
  PinpointPluginConfig? get pinpointPlugin =>
      plugins[PinpointPluginConfig.pluginKey] as PinpointPluginConfig?;

  @override
  List<Object?> get props => [plugins];

  factory AnalyticsConfig.fromJson(Map<String, Object?> json) =>
      _$AnalyticsConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$AnalyticsConfigToJson(this);
}

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
