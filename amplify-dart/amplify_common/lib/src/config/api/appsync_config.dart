part of 'api_config.dart';

/// A map of api names to their config.
class AppSyncPlugin extends DelegatingMap<String, AppSyncApiConfig>
    implements ApiPlugin {
  const AppSyncPlugin(Map<String, AppSyncApiConfig> configs) : super(configs);

  factory AppSyncPlugin.fromJson(Map<String, dynamic> json) {
    final map = json.map((k, v) {
      if (v is! Map) {
        throw ArgumentError.value(v);
      }
      return MapEntry(k, AppSyncApiConfig.fromJson(v));
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
class AppSyncApiConfig with EquatableMixin {
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

  factory AppSyncApiConfig.fromJson(Map json) =>
      _$AppSyncApiConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppSyncApiConfigToJson(this);
}
