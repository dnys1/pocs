import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum AuthenticationFlowType {
  @JsonValue('USER_SRP_AUTH')
  userSrpAuth,

  @JsonValue('CUSTOM_AUTH')
  customAuth,
}
