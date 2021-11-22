part of 'api_config.dart';

/// Factory for [AppSyncPluginConfig].
class AppSyncPluginFactory
    extends AmplifyPluginConfigFactory<AppSyncPluginConfig> {
  const AppSyncPluginFactory();

  @override
  AppSyncPluginConfig build(Map<String, Object?> json) {
    return AppSyncPluginConfig.fromJson(json);
  }

  @override
  String get name => 'awsAPIPlugin';
}

/// A map of AppSync plugins keyed by the API name.
@immutable
class AppSyncPluginConfig extends DelegatingMap<String, AppSyncApiConfig>
    with AWSSerializable, AWSEquatable
    implements AmplifyPluginConfig {
  const AppSyncPluginConfig(Map<String, AppSyncApiConfig> configs)
      : super(configs);

  @override
  String get name => 'awsAPIPlugin';

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
        (el) => el.value.authorizationType == ApiAuthorizationType.apiKey,
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

@amplifySerializable
class AppSyncApiConfig with AWSEquatable, AWSSerializable {
  final ApiEndpointType endpointType;
  final String endpoint;
  final String region;
  final ApiAuthorizationType authorizationType;
  final String? apiKey;

  const AppSyncApiConfig({
    required this.endpointType,
    required this.endpoint,
    required this.region,
    required this.authorizationType,
    this.apiKey,
  });

  @override
  List<Object?> get props => [
        endpointType,
        endpoint,
        region,
        authorizationType,
        apiKey,
      ];

  factory AppSyncApiConfig.fromJson(Map<String, Object?> json) =>
      _$AppSyncApiConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$AppSyncApiConfigToJson(this);
}
