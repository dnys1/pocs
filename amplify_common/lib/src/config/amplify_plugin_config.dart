import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:aws_common/aws_common.dart';
import 'package:collection/collection.dart';

/// Plugins must implement this class before they can be registered with [PluginRegistry].
abstract class AmplifyPluginConfig {
  const AmplifyPluginConfig._();

  String get name;
  Map<String, Object?> toJson();
}

/// Category plugins by name.
typedef AmplifyPlugins = Map<String, AmplifyPluginConfig>;

class UnknownPluginConfigFactory
    extends AmplifyPluginConfigFactory<UnknownPluginConfig> {
  const UnknownPluginConfigFactory(this.name);

  @override
  final String name;

  @override
  UnknownPluginConfig build(Map<String, Object?> json) {
    return UnknownPluginConfig.fromJson(name, json);
  }
}

class UnknownPluginConfig extends DelegatingMap<String, Object?>
    with AWSSerializable, AWSEquatable
    implements AmplifyPluginConfig {
  const UnknownPluginConfig(this.name, Map<String, Object?> plugin)
      : super(plugin);

  @override
  final String name;

  @override
  List<Object?> get props => [name, this];

  factory UnknownPluginConfig.fromJson(String name, Map<String, Object?> json) {
    return UnknownPluginConfig(name, json);
  }

  @override
  Map<String, Object?> toJson() {
    return this;
  }
}
