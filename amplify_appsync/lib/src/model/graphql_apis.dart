import 'package:json_annotation/json_annotation.dart';

import 'authentication_type.dart';
import 'openid_connect_config.dart';

part 'graphql_apis.g.dart';

@JsonSerializable(includeIfNull: false)
class GraphqlApis {
  // A list of additional authentication providers for the GraphqlApi API.
  // final List<AdditionalAuthenticationProviders>?
  //     additionalAuthenticationProviders;

  // The API ID.
  final String? apiId;

  // The ARN.
  final String? arn;

  // The authentication type.
  final AuthenticationType? authenticationType;

  // Configuration for AWS Lambda function authorization.
  // final LambdaAuthorizerConfig? lambdaAuthorizerConfig;

  // The Amazon CloudWatch Logs configuration.
  // final LogConfig? logConfig;

  // The API name.
  final String? name;

  // The OpenID Connect configuration.
  final OpenIDConnectConfig? openIDConnectConfig;

  // The tags.
  final Map<String, String>? tags;

  // The URIs.
  final Map<String, String>? uris;

  // The Amazon Cognito user pool configuration.
  // final CognitoUserPoolConfig? userPoolConfig;

  // The ARN of the WAF ACL associated with this GraphqlApi, if one exists.
  final String? wafWebAclArn;

  // A flag representing whether X-Ray tracing is enabled for this GraphqlApi.
  final bool? xrayEnabled;

  const GraphqlApis({
    // this.additionalAuthenticationProviders,
    this.apiId,
    this.arn,
    this.authenticationType,
    // this.lambdaAuthorizerConfig,
    // this.logConfig,
    this.name,
    this.openIDConnectConfig,
    this.tags,
    this.uris,
    // this.userPoolConfig,
    this.wafWebAclArn,
    this.xrayEnabled,
  });

  factory GraphqlApis.fromJson(Map<String, dynamic> json) =>
      _$GraphqlApisFromJson(json);

  Map<String, dynamic> toJson() => _$GraphqlApisToJson(this);
}
