import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin.dart';
import 'package:amplify_common/src/config/api/api_config.dart';

/// Default plugins known to Amplify. Users can register additional plugins
/// through the [AmplifyPluginRegistry] interface.
const _defaultPlugins = <AmplifyPluginFactory>[
  AppSyncPluginFactory(),
  CognitoPluginFactory(),
];

/// A builder for Amplify plugins.
typedef PluginFactory<T extends AmplifyPlugin> = T Function(
    Map<String, dynamic>);

/// A class for building plugins of type [T].
abstract class AmplifyPluginFactory<T extends AmplifyPlugin> {
  const AmplifyPluginFactory();

  String get name;
  T build(Map<String, dynamic> json);
}

/// A registry for [AmplifyPlugin] types. Used for serializing and deserializing
/// plugin configurations.
///
/// Unknown plugins are deserialized as an opaque map of type [UnknownPlugin].
///
/// Use [AmplifyPluginRegistry.shared] to access the global registry.
class AmplifyPluginRegistry {
  AmplifyPluginRegistry._() {
    _registerDefaultPlugins();
  }

  /// The global, shared plugin registry.
  static late final shared = AmplifyPluginRegistry._();

  final Map<String, PluginFactory> _plugins = {};

  void _registerDefaultPlugins() {
    _plugins.addAll({
      for (var plugin in _defaultPlugins) plugin.name: plugin.build,
    });
  }

  /// Registers a factory for plugin type [T].
  void register<T extends AmplifyPlugin>(
    AmplifyPluginFactory<T> pluginFactory,
  ) {
    if (_plugins.containsKey(pluginFactory.name)) {
      throw ArgumentError(
        'Plugin already registered for ${pluginFactory.name}',
      );
    }
    _plugins[pluginFactory.name] = pluginFactory.build;
  }

  /// Builds a plugin from the given [name] and [json]. If [name] is registered,
  /// this will build a plugin using the registered factory. Otherwise, an
  /// [UnknownPlugin] instance is returned.
  AmplifyPlugin build(String name, Map<String, dynamic> json) {
    final factory = _plugins[name];
    if (factory == null) {
      return UnknownPluginFactory(name).build(json);
    }
    return factory(json);
  }

  /// Deserializes plugins from a json [Map].
  static AmplifyPlugins pluginsFromJson(dynamic json) {
    if (json is! Map) {
      throw ArgumentError.value(
        json,
        'json',
        '${json.runtimeType} is not a Map',
      );
    }
    return json.cast<String, dynamic>().map((key, value) {
      if (value is! Map) {
        throw ArgumentError.value(value, key, 'Invalid plugin');
      }
      final plugin = AmplifyPluginRegistry.shared.build(key, value.cast());
      return MapEntry(key, plugin);
    });
  }
}
