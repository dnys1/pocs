import 'package:amplify_common/src/serializable.dart';
import 'package:equatable/equatable.dart';

part 'auth_config.g.dart';

@amplifySerializable
class AuthConfig with EquatableMixin {
  final Map<String, Map<String, dynamic>> plugins;

  const AuthConfig(this.plugins);

  @override
  List<Object?> get props => [plugins];

  factory AuthConfig.fromJson(Map json) => _$AuthConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AuthConfigToJson(this);
}
