import 'package:aws_common/aws_common.dart';

import 'oauth.dart';

part 'user_pool.g.dart';

typedef CognitoUserPoolConfigs = Map<String, CognitoUserPoolConfig>;

extension CognitoUserPoolConfigsX on CognitoUserPoolConfigs {
  CognitoUserPoolConfig? get default$ => this['Default'];
}

@awsSerializable
class CognitoUserPoolConfig
    with AWSEquatable<CognitoUserPoolConfig>, AWSSerializable {
  final String poolId;
  final String appClientId;
  final String? appClientSecret;
  final String region;
  final CognitoOAuthConfig? hostedUI;
  final String? endpoint;

  const CognitoUserPoolConfig({
    required this.poolId,
    required this.appClientId,
    this.appClientSecret,
    required this.region,
    this.hostedUI,
    this.endpoint,
  });

  @override
  List<Object?> get props => [
        poolId,
        appClientId,
        appClientSecret,
        region,
        hostedUI,
        endpoint,
      ];

  factory CognitoUserPoolConfig.fromJson(Map<String, Object?> json) =>
      _$CognitoUserPoolConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$CognitoUserPoolConfigToJson(this);
}
