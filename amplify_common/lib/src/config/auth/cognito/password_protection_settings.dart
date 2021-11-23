import 'package:amplify_common/amplify_common.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'password_protection_settings.g.dart';

@amplifySerializable
class PasswordProtectionSettings
    with AWSEquatable<PasswordProtectionSettings>, AWSSerializable {
  const PasswordProtectionSettings({
    this.passwordPolicyMinLength,
    this.passwordPolicyCharacters = const [],
  });

  final int? passwordPolicyMinLength;
  final List<PasswordPolicyCharacters> passwordPolicyCharacters;

  @override
  List<Object?> get props => [
        passwordPolicyMinLength,
        passwordPolicyCharacters,
      ];

  factory PasswordProtectionSettings.fromJson(Map<String, Object?> json) =>
      _$PasswordProtectionSettingsFromJson(json);

  @override
  Map<String, Object?> toJson() => _$PasswordProtectionSettingsToJson(this);
}

enum PasswordPolicyCharacters {
  @JsonValue('REQUIRES_LOWERCASE')
  requiresLowercase,

  @JsonValue('REQUIRES_UPPERCASE')
  requiresUppercase,

  @JsonValue('REQUIRES_NUMBERS')
  requiresNumbers,

  @JsonValue('REQUIRES_SYMBOLS')
  requiresSymbols
}
