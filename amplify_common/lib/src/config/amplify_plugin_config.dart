import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:aws_common/aws_common.dart';
import 'package:collection/collection.dart';

/// Plugins must implement this class before they can be registered with
/// [AmplifyPluginRegistry].
abstract class AmplifyPluginConfig with AWSSerializable {
  const AmplifyPluginConfig._();

  /// The name of the plugin, as registered in the "plugins" dictionary of
  /// the Amplify configuration.
  String get name;

  @override
  Map<String, Object?> toJson();
}

/// Category plugins by name.
typedef AmplifyPlugins = Map<String, AmplifyPluginConfig>;

/// {@template amplify_common.unknown_plugin_config_factory}
/// A plugin factory for unknown plugin configs.
/// @{endtemplate}
class UnknownPluginConfigFactory
    extends AmplifyPluginConfigFactory<UnknownPluginConfig> {
  /// {@macro amplify_common.unknown_plugin_config_factory}
  const UnknownPluginConfigFactory(this.name);

  @override
  final String name;

  @override
  UnknownPluginConfig build(Map<String, Object?> json) {
    return UnknownPluginConfig.fromJson(name, json);
  }
}

/// {@template amplify_common.unknown_plugin_config}
/// A plugin configuration for unknown plugins. Delegates to a [Map].
/// {@endtemplate}
class UnknownPluginConfig extends DelegatingMap<String, Object?>
    with AWSSerializable, AWSEquatable<UnknownPluginConfig>
    implements AmplifyPluginConfig {
  /// {@macro amplify_common.unknown_plugin_config}
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
  Map<String, Object?> toJson() => this;
}
