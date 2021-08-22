import 'package:amplify_common/src/util/equatable.dart';
import 'package:amplify_common/src/util/serializable.dart';

part 'auth_config.g.dart';

@amplifySerializable
class AuthConfig with AmplifyEquatable, AmplifySerializable {
  final Map<String, Map<String, dynamic>> plugins;

  const AuthConfig(this.plugins);

  @override
  List<Object?> get props => [plugins];

  factory AuthConfig.fromJson(Map<String, dynamic> json) =>
      _$AuthConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthConfigToJson(this);
}
