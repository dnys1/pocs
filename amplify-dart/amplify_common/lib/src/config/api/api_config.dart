import 'package:amplify_common/src/config/api/endpoint_type.dart';
import 'package:amplify_common/src/serializable.dart';
import 'package:equatable/equatable.dart';

part 'api_config.g.dart';

@amplifySerializable
class ApiConfig with EquatableMixin {
  final Map<String, Map<String, ApiPluginConfig>> plugins;

  const ApiConfig({required this.plugins});

  @override
  List<Object?> get props => [plugins];

  factory ApiConfig.fromJson(Map json) => _$ApiConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ApiConfigToJson(this);
}

@amplifySerializable
class ApiPluginConfig with EquatableMixin {
  final ApiEndpointType endpointType;
  final String endpoint;
  final String region;
  final ApiAuthorizationType authorizationType;
  final String? apiKey;

  const ApiPluginConfig({
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

  factory ApiPluginConfig.fromJson(Map json) => _$ApiPluginConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ApiPluginConfigToJson(this);
}
