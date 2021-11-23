import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum MfaType {
  @JsonValue('SMS')
  sms,

  @JsonValue('TOTP')
  totp,
}

@JsonEnum()
enum MfaConfiguration {
  @JsonValue('OPTIONAL')
  optional,

  @JsonValue('ON')
  on,

  @JsonValue('OFF')
  off,
}
