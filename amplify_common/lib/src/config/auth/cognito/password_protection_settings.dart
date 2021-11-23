import 'package:amplify_common/amplify_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'password_protection_settings.g.dart';

@amplifySerializable
class PasswordProtectionSettings {
  final int? passwordPolicyMinLength;

  final List<PasswordPolicyCharacters>? passwordPolicyCharacters;

  const PasswordProtectionSettings({
    this.passwordPolicyMinLength,
    this.passwordPolicyCharacters,
  });

  factory PasswordProtectionSettings.fromJson(Map<String, Object?> json) =>
      _$PasswordProtectionSettingsFromJson(json);

  Map<String, Object?> toJson() => _$PasswordProtectionSettingsToJson(this);
}

@JsonEnum()
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
