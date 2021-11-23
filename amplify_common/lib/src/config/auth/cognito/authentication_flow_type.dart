import 'package:json_annotation/json_annotation.dart';

enum AuthenticationFlowType {
  @JsonValue('USER_SRP_AUTH')
  userSrpAuth,

  @JsonValue('CUSTOM_AUTH')
  customAuth,
}
