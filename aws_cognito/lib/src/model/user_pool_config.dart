import 'package:aws_common/aws_common.dart';
import 'package:aws_cognito/aws_cognito.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_pool_config.g.dart';

@awsSerializable
class UserPoolConfig {
  final UserPool userPool;

  const UserPoolConfig(this.userPool);

  factory UserPoolConfig.fromJson(Map<String, dynamic> json) =>
      _$UserPoolConfigFromJson(json);

  Map<String, dynamic> toJson() => _$UserPoolConfigToJson(this);
}

@awsSerializable
class UserPool {
  final String id;
  final String name;
  /* final Policies policies; */
  final LambdaConfig? lambdaConfig;
  final List<SchemaAttribute> schemaAttributes;

  @JsonKey(includeIfNull: true)
  final DeviceConfiguration? deviceConfiguration;

  final List<String>? autoVerifiedAttributes;
  final List<String>? usernameAttributes;
  final String? smsVerificationMessage;
  final String? emailVerificationMessage;
  final String? emailVerificationSubject;
  final VerificationMessageTemplate? verificationMessageTemplate;
  final String? smsAuthenticationMessage;
  final String? mfaConfiguration;
  final int? estimatedNumberOfUsers;
  final EmailConfiguration? emailConfiguration;
  final SMSConfiguration? smsConfiguration;

  const UserPool({
    required this.id,
    required this.name,
    this.lambdaConfig,
    required this.schemaAttributes,
    this.deviceConfiguration,
    this.autoVerifiedAttributes,
    this.usernameAttributes,
    this.smsVerificationMessage,
    this.emailVerificationMessage,
    this.emailVerificationSubject,
    this.verificationMessageTemplate,
    this.smsAuthenticationMessage,
    this.mfaConfiguration,
    this.estimatedNumberOfUsers,
    this.emailConfiguration,
    this.smsConfiguration,
  });

  factory UserPool.fromJson(Map<String, dynamic> json) =>
      _$UserPoolFromJson(json);

  Map<String, dynamic> toJson() => _$UserPoolToJson(this);
}

@awsSerializable
class SchemaAttribute {
  final String name;
  final String attributeDataType;
  final bool developerOnlyAttribute;

  @JsonKey(name: 'Mutable')
  final bool isMutable;

  @JsonKey(name: 'Required')
  final bool isRequired;

  final StringAttributeConstraints? stringAttributeConstraints;
  final NumberAttributeConstraints? numberAttributeConstraints;

  const SchemaAttribute({
    required this.name,
    required this.attributeDataType,
    required this.developerOnlyAttribute,
    required this.isMutable,
    required this.isRequired,
    required this.stringAttributeConstraints,
    required this.numberAttributeConstraints,
  });

  factory SchemaAttribute.fromJson(Map<String, dynamic> json) =>
      _$SchemaAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$SchemaAttributeToJson(this);
}

@awsSerializable
class StringAttributeConstraints {
  final String minLength;
  final String maxLength;

  const StringAttributeConstraints(this.minLength, this.maxLength);

  factory StringAttributeConstraints.fromJson(Map<String, dynamic> json) =>
      _$StringAttributeConstraintsFromJson(json);

  Map<String, dynamic> toJson() => _$StringAttributeConstraintsToJson(this);
}

@awsSerializable
class NumberAttributeConstraints {
  final String minValue;

  const NumberAttributeConstraints(this.minValue);

  factory NumberAttributeConstraints.fromJson(Map<String, dynamic> json) =>
      _$NumberAttributeConstraintsFromJson(json);

  Map<String, dynamic> toJson() => _$NumberAttributeConstraintsToJson(this);
}

@awsSerializable
class VerificationMessageTemplate {
  final String smsMessage;
  final String emailMessage;
  final String emailSubject;
  final String defaultEmailOption;

  const VerificationMessageTemplate({
    required this.smsMessage,
    required this.emailMessage,
    required this.emailSubject,
    required this.defaultEmailOption,
  });

  factory VerificationMessageTemplate.fromJson(Map<String, dynamic> json) =>
      _$VerificationMessageTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationMessageTemplateToJson(this);
}

@awsSerializable
class EmailConfiguration {
  final String emailSendingAccount;

  const EmailConfiguration({
    required this.emailSendingAccount,
  });

  factory EmailConfiguration.fromJson(Map<String, dynamic> json) =>
      _$EmailConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$EmailConfigurationToJson(this);
}

@awsSerializable
class SMSConfiguration {
  final String snsCallerArn;
  final String externalId;

  const SMSConfiguration({
    required this.snsCallerArn,
    required this.externalId,
  });

  factory SMSConfiguration.fromJson(Map<String, dynamic> json) =>
      _$SMSConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$SMSConfigurationToJson(this);
}
