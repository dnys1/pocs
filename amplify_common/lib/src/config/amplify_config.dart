import 'package:amplify_common/src/config/analytics/analytics_config.dart';
import 'package:amplify_common/src/config/api/api_config.dart';
import 'package:amplify_common/src/config/auth/auth_config.dart';
import 'package:amplify_common/src/config/storage/storage_config.dart';
import 'package:amplify_common/src/util/serializable.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

import 'geo/geo_config.dart';

part 'amplify_config.g.dart';

/// {@template amplify_common.amplify_config}
/// The configuration for Amplify libraries.
/// {@endtemplate}
@amplifySerializable
class AmplifyConfig with AWSEquatable<AmplifyConfig>, AWSSerializable {
  @JsonKey(name: 'UserAgent')
  final String userAgent;

  @JsonKey(name: 'Version')
  final String version;

  /// The API category configuration, if available.
  final ApiConfig? api;

  /// The Analytics category configuration, if available.
  final AnalyticsConfig? analytics;

  /// The Auth category configuration, if available.
  final AuthConfig? auth;

  /// The Geo category configuration, if available.
  final GeoConfig? geo;

  /// The Storage category configuration, if available.
  final StorageConfig? storage;

  /// {@macro amplify_common.amplify_config}
  const AmplifyConfig({
    this.userAgent = 'aws-amplify-cli/2.0',
    this.version = '1.0',
    this.api,
    this.analytics,
    this.auth,
    this.geo,
    this.storage,
  });

  @override
  List<Object?> get props => [userAgent, version, api, auth];

  factory AmplifyConfig.fromJson(Map<String, Object?> json) =>
      _$AmplifyConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$AmplifyConfigToJson(this);
}
