import 'package:amplify_common/amplify_common.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

import 'authorization_type.dart';
import 'endpoint_type.dart';

part 'api_config.g.dart';

@amplifySerializable
class AppSyncApiConfig with AWSEquatable<AppSyncApiConfig>, AWSSerializable {
  final EndpointType endpointType;
  final String endpoint;
  final String region;
  final APIAuthorizationType authorizationType;
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
