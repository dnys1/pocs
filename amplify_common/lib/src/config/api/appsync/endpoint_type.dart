import 'package:json_annotation/json_annotation.dart';

enum EndpointType {
  @JsonValue('REST')
  rest,

  @JsonValue('GraphQL')
  graphQL,
}
