import 'package:json_annotation/json_annotation.dart';

enum MfaType {
  @JsonValue('SMS')
  sms,

  @JsonValue('TOTP')
  totp,
}

enum MfaConfiguration {
  @JsonValue('OPTIONAL')
  optional,

  @JsonValue('ON')
  on,

  @JsonValue('OFF')
  off,
}
