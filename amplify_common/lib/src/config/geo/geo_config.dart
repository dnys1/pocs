import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geo_config.g.dart';

@amplifySerializable
class GeoConfig with AWSEquatable, AWSSerializable {
  const GeoConfig({required this.plugins});

  @JsonKey(fromJson: AmplifyPluginRegistry.pluginConfigsFromJson)
  final AmplifyPlugins plugins;

  AmazonLocationServicesPluginConfig? get awsPlugin =>
      plugins[AmazonLocationServicesPluginConfig.pluginKey]
          as AmazonLocationServicesPluginConfig?;

  @override
  List<Object?> get props => [plugins];

  factory GeoConfig.fromJson(Map<String, dynamic> json) =>
      _$GeoConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GeoConfigToJson(this);
}
