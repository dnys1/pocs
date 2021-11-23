import 'package:json_annotation/json_annotation.dart';

enum ApiEndpointType {
  @JsonValue('REST')
  rest,

  @JsonValue('GraphQL')
  graphQL,
}
