import 'package:amplify_common/src/config/api/api_config.dart';
import 'package:amplify_common/src/config/auth/auth_config.dart';
import 'package:amplify_common/src/util/equatable.dart';
import 'package:amplify_common/src/util/serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'amplify_config.g.dart';

@amplifySerializable
class AmplifyConfig with AmplifyEquatable, AmplifySerializable {
  @JsonKey(name: 'UserAgent')
  final String userAgent;

  @JsonKey(name: 'Version')
  final String version;

  final ApiConfig? api;
  final AuthConfig? auth;

  const AmplifyConfig({
    required this.userAgent,
    required this.version,
    this.api,
    this.auth,
  });

  @override
  List<Object?> get props => [userAgent, version, api, auth];

  factory AmplifyConfig.fromJson(Map<String, dynamic> json) =>
      _$AmplifyConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AmplifyConfigToJson(this);
}
