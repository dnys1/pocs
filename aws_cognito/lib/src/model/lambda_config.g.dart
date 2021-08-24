// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lambda_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LambdaConfig _$LambdaConfigFromJson(Map<String, dynamic> json) => LambdaConfig(
      customSMSSender: json['CustomSMSSender'] == null
          ? null
          : CustomSMSSender.fromJson(
              json['CustomSMSSender'] as Map<String, dynamic>),
      kmsKeyId: json['KMSKeyID'] as String?,
    );

Map<String, dynamic> _$LambdaConfigToJson(LambdaConfig instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('CustomSMSSender', instance.customSMSSender);
  writeNotNull('KMSKeyID', instance.kmsKeyId);
  return val;
}

CustomSMSSender _$CustomSMSSenderFromJson(Map<String, dynamic> json) =>
    CustomSMSSender(
      json['LambdaArn'] as String,
      json['LambdaVersion'] as String? ?? 'V1_0',
    );

Map<String, dynamic> _$CustomSMSSenderToJson(CustomSMSSender instance) =>
    <String, dynamic>{
      'LambdaVersion': instance.lambdaVersion,
      'LambdaArn': instance.lambdaArn,
    };
