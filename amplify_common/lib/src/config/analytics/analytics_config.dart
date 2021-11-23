import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'analytics_config.g.dart';
part 'pinpoint_config.dart';

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
