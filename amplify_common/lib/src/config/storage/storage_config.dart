import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

import 's3_config.dart';

part 'storage_config.g.dart';

/// {@template amplify_common.config.storage_config}
/// The Storage category configuration.
/// {@endtemplate}
@amplifySerializable
class StorageConfig with AWSEquatable<StorageConfig>, AWSSerializable {
  /// {@macro amplify_common.config.storage_config}
  const StorageConfig({required this.plugins});

  /// All Storage category plugin configurations.
  @JsonKey(fromJson: AmplifyPluginRegistry.pluginConfigsFromJson)
  final AmplifyPlugins plugins;

  /// The AWS S3 plugin configuration, if available.
  // S3PluginConfig? get pinpointPlugin =>
  //     plugins[S3PluginConfig.pluginKey] as S3PluginConfig?;

  @override
  List<Object?> get props => [plugins];

  factory StorageConfig.fromJson(Map<String, Object?> json) =>
      _$StorageConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$StorageConfigToJson(this);
}

/// {@template amplify_common.s3_plugin_config_factory}
/// A factory for [S3PluginConfig].
/// {@endtemplate}
class S3PluginConfigFactory extends AmplifyPluginConfigFactory<S3PluginConfig> {
  /// {@macro amplify_common.s3_plugin_config_factory}
  const S3PluginConfigFactory();

  @override
  S3PluginConfig build(Map<String, Object?> json) {
    return S3PluginConfig.fromJson(json);
  }

  @override
  String get name => S3PluginConfig.pluginKey;
}
