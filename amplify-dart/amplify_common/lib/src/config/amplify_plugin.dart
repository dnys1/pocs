import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:amplify_common/src/util/equatable.dart';
import 'package:amplify_common/src/util/serializable.dart';
import 'package:collection/collection.dart';

/// Plugins must implement this class before they can be registered with [PluginRegistry].
abstract class AmplifyPlugin {
  const AmplifyPlugin._();

  String get name;
  Map<String, dynamic> toJson();
}

/// Category plugins by name.
typedef AmplifyPlugins = Map<String, AmplifyPlugin>;

class UnknownPluginFactory extends AmplifyPluginFactory<UnknownPlugin> {
  const UnknownPluginFactory(this.name);

  @override
  final String name;

  @override
  UnknownPlugin build(Map<String, dynamic> json) {
    return UnknownPlugin.fromJson(name, json);
  }
}

class UnknownPlugin extends DelegatingMap<String, dynamic>
    with AmplifySerializable, AmplifyEquatable
    implements AmplifyPlugin {
  const UnknownPlugin(this.name, Map<String, dynamic> plugin) : super(plugin);

  @override
  final String name;

  @override
  List<Object?> get props => [name, this];

  factory UnknownPlugin.fromJson(String name, Map<String, dynamic> json) {
    return UnknownPlugin(name, json);
  }

  @override
  Map<String, dynamic> toJson() {
    return this;
  }
}
