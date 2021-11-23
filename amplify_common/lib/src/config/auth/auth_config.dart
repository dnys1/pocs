import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_config.g.dart';

@amplifySerializable
class AuthConfig with AWSEquatable<AuthConfig>, AWSSerializable {
  const AuthConfig({required this.plugins});

  @JsonKey(fromJson: AmplifyPluginRegistry.pluginConfigsFromJson)
  final AmplifyPlugins plugins;

  CognitoPluginConfig? get cognitoPlugin =>
      plugins[CognitoPluginConfig.pluginKey] as CognitoPluginConfig?;

  @override
  List<Object?> get props => [plugins];

  factory AuthConfig.fromJson(Map<String, Object?> json) =>
      _$AuthConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$AuthConfigToJson(this);
}

/// {@template amplify_common.cognito_plugin_config_factory}
/// Configuration factory for [CognitoPluginConfig].
/// {@endtemplate}
class CognitoPluginConfigFactory
    extends AmplifyPluginConfigFactory<CognitoPluginConfig> {
  /// {@macro amplify_common.cognito_plugin_config_factory}
  const CognitoPluginConfigFactory();

  @override
  CognitoPluginConfig build(Map<String, Object?> json) {
    return CognitoPluginConfig.fromJson(json);
  }

  @override
  String get name => CognitoPluginConfig.pluginKey;
}
