import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:aws_common/aws_common.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'appsync/api_config.dart';
import 'appsync/authorization_type.dart';

export 'appsync/api_config.dart';
export 'appsync/authorization_type.dart';
export 'appsync/endpoint_type.dart';

/// A map of AppSync plugins keyed by the API name.
@immutable
class AppSyncPluginConfig extends DelegatingMap<String, AppSyncApiConfig>
    with AWSSerializable, AWSEquatable<AppSyncPluginConfig>
    implements AmplifyPluginConfig {
  const AppSyncPluginConfig(Map<String, AppSyncApiConfig> configs)
      : super(configs);

  static const pluginKey = 'awsAPIPlugin';

  @override
  String get name => pluginKey;

  @override
  List<Object?> get props => [this];

  static AppSyncPluginConfig fromJson(Map<String, Object?> json) {
    final map = json.map((k, v) {
      if (v is! Map) {
        throw ArgumentError.value(v);
      }
      return MapEntry(k, AppSyncApiConfig.fromJson(v.cast<String, Object?>()));
    });
    return AppSyncPluginConfig(map);
  }

  @override
  Map<String, Object?> toJson() => map((k, v) => MapEntry(k, v.toJson()));

  AppSyncApiConfig? get $default => entries
      .firstWhereOrNull(
        (el) => el.value.authorizationType == APIAuthorizationType.apiKey,
      )
      ?.value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSyncPluginConfig &&
          const MapEquality<String, AppSyncApiConfig>().equals(this, other);

  @override
  int get hashCode => const MapEquality<String, AppSyncApiConfig>().hash(this);
}
