import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:aws_common/aws_common.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'analytics_config.g.dart';
part 'pinpoint_config.dart';

@amplifySerializable
class AnalyticsConfig with AWSEquatable, AWSSerializable {
  const AnalyticsConfig({required this.plugins});

  @JsonKey(fromJson: AmplifyPluginRegistry.pluginConfigsFromJson)
  final AmplifyPlugins plugins;

  PinpointPluginConfig? get pinpointPlugin =>
      plugins['awsPinpointAnalyticsPlugin'] as PinpointPluginConfig?;

  @override
  List<Object?> get props => [plugins];

  factory AnalyticsConfig.fromJson(Map<String, Object?> json) =>
      _$AnalyticsConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$AnalyticsConfigToJson(this);
}
