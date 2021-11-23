import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/analytics/analytics_config.dart';
import 'package:amplify_common/src/config/api/api_config.dart';
import 'package:amplify_common/src/config/auth/auth_config.dart';
import 'package:amplify_common/src/config/geo/geo_config.dart';
import 'package:amplify_common/src/config/storage/storage_config.dart';

/// Default plugins known to Amplify. Users can register additional plugins
/// through the [AmplifyPluginRegistry] interface.
const _defaultPlugins = <AmplifyPluginConfigFactory>[
  // API
  AppSyncPluginFactory(),

  // Analytics
  PinpointPluginConfigFactory(),

  // Auth
  CognitoPluginConfigFactory(),

  // Geo
  AmazonLocationServicesPluginConfigFactory(),

  // Storage
  S3PluginConfigFactory(),
];

/// A builder for Amplify plugins.
typedef PluginConfigFactory<T extends AmplifyPluginConfig> = T Function(
    Map<String, Object?>);

/// {@template amplify_common.amplify_plugin_config_factory}
/// A class for building plugins of type [T].
/// {@endtemplate}
abstract class AmplifyPluginConfigFactory<T extends AmplifyPluginConfig> {
  /// {@macro amplify_common.amplify_plugin_config_factory}
  const AmplifyPluginConfigFactory();

  /// The name of the plugin, as registered in the "plugins" dictionary of
  /// the Amplify configuration.
  String get name;

  /// Builder for a plugin config from a serialized JSON [Map].
  T build(Map<String, Object?> json);
}

/// A registry for [AmplifyPluginConfig] types. Used for serializing and
/// deserializing plugin configurations.
///
/// Unknown plugins are deserialized as an opaque map of type [UnknownPluginConfig].
///
/// Use [AmplifyPluginRegistry.shared] to access the global registry.
class AmplifyPluginRegistry {
  AmplifyPluginRegistry._() {
    _registerDefaultPlugins();
  }

  /// The global, shared plugin registry.
  static late final shared = AmplifyPluginRegistry._();

  final Map<String, AmplifyPluginConfigFactory> _plugins = {};

  void _registerDefaultPlugins() {
    _plugins.addAll({
      for (var plugin in _defaultPlugins) plugin.name: plugin,
    });
  }

  /// Registers a factory for plugin type [T].
  void register<T extends AmplifyPluginConfig>(
    AmplifyPluginConfigFactory<T> pluginFactory,
  ) {
    if (_plugins.containsKey(pluginFactory.name)) {
      throw ArgumentError(
        'Plugin already registered for ${pluginFactory.name}',
      );
    }
    _plugins[pluginFactory.name] = pluginFactory;
  }

  /// Builds a plugin from the given [name] and [json]. If [name] is registered,
  /// this will build a plugin using the registered factory. Otherwise, an
  /// [UnknownPluginConfig] instance is returned.
  AmplifyPluginConfig build(String name, Map<String, Object?> json) {
    final factory = _plugins[name] ?? UnknownPluginConfigFactory(name);
    return factory.build(json);
  }

  /// Deserializes plugins from a json [Map].
  static AmplifyPlugins pluginConfigsFromJson(Object? json) {
    if (json is! Map) {
      throw ArgumentError.value(
        json,
        'json',
        '${json.runtimeType} is not a Map',
      );
    }
    return json.cast<String, Object?>().map((key, value) {
      if (value is! Map) {
        throw ArgumentError.value(value, key, 'Invalid plugin');
      }
      final plugin = shared.build(key, value.cast());
      return MapEntry(key, plugin);
    });
  }
}
