import 'package:json_annotation/json_annotation.dart';

enum SocialProvider {
  @JsonValue('FACEBOOK')
  facebook,

  @JsonValue('GOOGLE')
  google,

  @JsonValue('AMAZON')
  amazon,

  @JsonValue('APPLE')
  apple,
}
