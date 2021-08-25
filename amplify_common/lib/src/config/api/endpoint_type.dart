import 'package:json_annotation/json_annotation.dart';

enum ApiEndpointType { REST, GraphQL }

enum ApiAuthorizationType {
  @JsonValue('API_KEY')
  apiKey,
  @JsonValue('AWS_IAM')
  awsIAM,
  @JsonValue('AMAZON_COGNITO_USER_POOLS')
  userPool,
  @JsonValue('OPENID_CONNECT')
  oidc,
}
