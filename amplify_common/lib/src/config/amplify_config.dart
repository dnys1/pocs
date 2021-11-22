import 'package:amplify_common/src/config/analytics/analytics_config.dart';
import 'package:amplify_common/src/config/api/api_config.dart';
import 'package:amplify_common/src/config/auth/auth_config.dart';
import 'package:amplify_common/src/util/serializable.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

import 'geo/geo_config.dart';

part 'amplify_config.g.dart';

@amplifySerializable
class AmplifyConfig with AWSEquatable, AWSSerializable {
  @JsonKey(name: 'UserAgent')
  final String userAgent;

  @JsonKey(name: 'Version')
  final String version;

  final ApiConfig? api;
  final AnalyticsConfig? analytics;
  final AuthConfig? auth;
  final GeoConfig? geo;

  const AmplifyConfig({
    required this.userAgent,
    required this.version,
    this.api,
    this.analytics,
    this.auth,
    this.geo,
  });

  @override
  List<Object?> get props => [userAgent, version, api, auth];

  factory AmplifyConfig.fromJson(Map<String, Object?> json) =>
      _$AmplifyConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$AmplifyConfigToJson(this);
}
