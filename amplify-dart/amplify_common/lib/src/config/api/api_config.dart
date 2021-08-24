import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:amplify_common/src/config/api/endpoint_type.dart';
import 'package:amplify_common/src/util/equatable.dart';
import 'package:amplify_common/src/util/serializable.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appsync_config.dart';
part 'api_config.g.dart';

@amplifySerializable
class ApiConfig with AmplifyEquatable, AmplifySerializable {
  const ApiConfig({required this.plugins});

  @JsonKey(fromJson: AmplifyPluginRegistry.pluginConfigsFromJson)
  final AmplifyPlugins plugins;

  AppSyncPlugin? get appSyncPlugin => plugins['awsAPIPlugin'] as AppSyncPlugin?;

  @override
  List<Object?> get props => [plugins];

  factory ApiConfig.fromJson(Map<String, dynamic> json) => _$ApiConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ApiConfigToJson(this);
}
