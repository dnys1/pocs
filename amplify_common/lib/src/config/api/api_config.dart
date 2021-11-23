import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

import 'appsync_config.dart';

part 'api_config.g.dart';

@amplifySerializable
class ApiConfig with AWSEquatable<ApiConfig>, AWSSerializable {
  const ApiConfig({required this.plugins});

  @JsonKey(fromJson: AmplifyPluginRegistry.pluginConfigsFromJson)
  final AmplifyPlugins plugins;

  AppSyncPluginConfig? get appSyncPlugin =>
      plugins[AppSyncPluginConfig.pluginKey] as AppSyncPluginConfig?;

  @override
  List<Object?> get props => [plugins];

  factory ApiConfig.fromJson(Map<String, Object?> json) =>
      _$ApiConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ApiConfigToJson(this);
}

/// Factory for [AppSyncPluginConfig].
class AppSyncPluginFactory
    extends AmplifyPluginConfigFactory<AppSyncPluginConfig> {
  const AppSyncPluginFactory();

  @override
  AppSyncPluginConfig build(Map<String, Object?> json) {
    return AppSyncPluginConfig.fromJson(json);
  }

  @override
  String get name => AppSyncPluginConfig.pluginKey;
}
