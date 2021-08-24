import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/util/equatable.dart';
import 'package:amplify_common/src/util/serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_config.g.dart';

@amplifySerializable
class AuthConfig with AmplifyEquatable, AmplifySerializable {
  const AuthConfig({required this.plugins});

  @JsonKey(fromJson: AmplifyPluginRegistry.pluginConfigsFromJson)
  final AmplifyPlugins plugins;

  CognitoPluginConfig? get cognitoPlugin =>
      plugins[CognitoPluginConfig.pluginKey] as CognitoPluginConfig?;

  @override
  List<Object?> get props => [plugins];

  factory AuthConfig.fromJson(Map<String, dynamic> json) =>
      _$AuthConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthConfigToJson(this);
}
