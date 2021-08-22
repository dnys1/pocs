import 'package:amplify_common/src/config/api/endpoint_type.dart';
import 'package:amplify_common/src/serializable.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appsync_config.dart';
part 'api_config.g.dart';

/// API category plugins by name.
typedef ApiPlugins = Map<String, ApiPlugin>;

@amplifySerializable
class ApiConfig with EquatableMixin {
  const ApiConfig({required this.plugins});

  @JsonKey(fromJson: _apiPluginsFromJson)
  final ApiPlugins plugins;

  AppSyncPlugin? get appSyncPlugin => plugins['awsAPIPlugin'] as AppSyncPlugin?;

  @override
  List<Object?> get props => [plugins];

  factory ApiConfig.fromJson(Map json) => _$ApiConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ApiConfigToJson(this);
}

ApiPlugins _apiPluginsFromJson(Object? json) {
  if (json is! Map) {
    throw ArgumentError.value(json);
  }
  return json.cast<String, dynamic>().map((key, value) {
    if (value is! Map) {
      throw ArgumentError.value(value, key, 'Invalid plugin');
    }
    ApiPlugin plugin;
    switch (key) {
      case 'awsAPIPlugin':
        plugin = AppSyncPlugin.fromJson(value.cast());
        break;
      default:
        plugin = UnknownApiPlugin.fromJson(value.cast());
        break;
    }
    return MapEntry(key, plugin);
  });
}

abstract class ApiPlugin {
  const ApiPlugin._();

  Map<String, dynamic> toJson();
}

class UnknownApiPlugin extends DelegatingMap<String, dynamic>
    implements ApiPlugin {
  const UnknownApiPlugin(Map<String, dynamic> plugin) : super(plugin);

  factory UnknownApiPlugin.fromJson(Map<String, dynamic> json) {
    return UnknownApiPlugin(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return this;
  }
}
