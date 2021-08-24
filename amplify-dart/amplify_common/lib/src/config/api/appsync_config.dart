part of 'api_config.dart';

/// Factory for [AppSyncPlugin].
class AppSyncPluginFactory extends AmplifyPluginConfigFactory<AppSyncPlugin> {
  const AppSyncPluginFactory();

  @override
  AppSyncPlugin build(Map<String, dynamic> json) {
    return AppSyncPlugin.fromJson(json);
  }

  @override
  String get name => 'awsAPIPlugin';
}

/// A map of AppSync plugins keyed by the API name.
class AppSyncPlugin extends DelegatingMap<String, AppSyncApiConfig>
    with AmplifySerializable, AmplifyEquatable
    implements AmplifyPluginConfig {
  const AppSyncPlugin(Map<String, AppSyncApiConfig> configs) : super(configs);

  @override
  String get name => 'awsAPIPlugin';

  @override
  List<Object?> get props => [this];

  static AppSyncPlugin fromJson(Map<String, dynamic> json) {
    final map = json.map((k, v) {
      if (v is! Map) {
        throw ArgumentError.value(v);
      }
      return MapEntry(k, AppSyncApiConfig.fromJson(v.cast()));
    });
    return AppSyncPlugin(map);
  }

  @override
  Map<String, dynamic> toJson() => map((k, v) => MapEntry(k, v.toJson()));

  AppSyncApiConfig? get $default => entries
      .firstWhereOrNull(
        (el) => el.value.authorizationType == ApiAuthorizationType.apiKey,
      )
      ?.value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSyncPlugin && const MapEquality().equals(this, other);

  @override
  int get hashCode => const MapEquality().hash(this);
}

@amplifySerializable
class AppSyncApiConfig with AmplifyEquatable, AmplifySerializable {
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

  factory AppSyncApiConfig.fromJson(Map<String, dynamic> json) =>
      _$AppSyncApiConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppSyncApiConfigToJson(this);
}
