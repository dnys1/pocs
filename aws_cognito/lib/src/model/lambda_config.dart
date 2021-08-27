import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lambda_config.g.dart';

@awsSerializable
class LambdaConfig {
  final CustomSMSSender? customSMSSender;

  @JsonKey(name: 'KMSKeyID')
  final String? kmsKeyId;

  const LambdaConfig({
    this.customSMSSender,
    this.kmsKeyId,
  });

  factory LambdaConfig.fromJson(Map<String, dynamic> json) =>
      _$LambdaConfigFromJson(json);

  Map<String, dynamic> toJson() => _$LambdaConfigToJson(this);
}

@awsSerializable
class CustomSMSSender {
  final String lambdaVersion;
  final String lambdaArn;

  const CustomSMSSender(this.lambdaArn, [this.lambdaVersion = 'V1_0']);

  factory CustomSMSSender.fromJson(Map<String, dynamic> json) =>
      _$CustomSMSSenderFromJson(json);

  Map<String, dynamic> toJson() => _$CustomSMSSenderToJson(this);
}
