// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_pool_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPoolConfig _$UserPoolConfigFromJson(Map<String, dynamic> json) =>
    UserPoolConfig(
      UserPool.fromJson(json['UserPool'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserPoolConfigToJson(UserPoolConfig instance) =>
    <String, dynamic>{
      'UserPool': instance.userPool,
    };

UserPool _$UserPoolFromJson(Map<String, dynamic> json) => UserPool(
      id: json['Id'] as String,
      name: json['Name'] as String,
      lambdaConfig: json['LambdaConfig'] == null
          ? null
          : LambdaConfig.fromJson(json['LambdaConfig'] as Map<String, dynamic>),
      schemaAttributes: (json['SchemaAttributes'] as List<dynamic>)
          .map((e) => SchemaAttribute.fromJson(e as Map<String, dynamic>))
          .toList(),
      deviceConfiguration: json['DeviceConfiguration'] == null
          ? null
          : DeviceConfiguration.fromJson(
              json['DeviceConfiguration'] as Map<String, dynamic>),
      autoVerifiedAttributes: (json['AutoVerifiedAttributes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      usernameAttributes: (json['UsernameAttributes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      smsVerificationMessage: json['SmsVerificationMessage'] as String?,
      emailVerificationMessage: json['EmailVerificationMessage'] as String?,
      emailVerificationSubject: json['EmailVerificationSubject'] as String?,
      verificationMessageTemplate: json['VerificationMessageTemplate'] == null
          ? null
          : VerificationMessageTemplate.fromJson(
              json['VerificationMessageTemplate'] as Map<String, dynamic>),
      smsAuthenticationMessage: json['SmsAuthenticationMessage'] as String?,
      mfaConfiguration: json['MfaConfiguration'] as String?,
      estimatedNumberOfUsers: json['EstimatedNumberOfUsers'] as int?,
      emailConfiguration: json['EmailConfiguration'] == null
          ? null
          : EmailConfiguration.fromJson(
              json['EmailConfiguration'] as Map<String, dynamic>),
      smsConfiguration: json['SmsConfiguration'] == null
          ? null
          : SMSConfiguration.fromJson(
              json['SmsConfiguration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserPoolToJson(UserPool instance) {
  final val = <String, dynamic>{
    'Id': instance.id,
    'Name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('LambdaConfig', instance.lambdaConfig);
  val['SchemaAttributes'] = instance.schemaAttributes;
  val['DeviceConfiguration'] = instance.deviceConfiguration;
  writeNotNull('AutoVerifiedAttributes', instance.autoVerifiedAttributes);
  writeNotNull('UsernameAttributes', instance.usernameAttributes);
  writeNotNull('SmsVerificationMessage', instance.smsVerificationMessage);
  writeNotNull('EmailVerificationMessage', instance.emailVerificationMessage);
  writeNotNull('EmailVerificationSubject', instance.emailVerificationSubject);
  writeNotNull(
      'VerificationMessageTemplate', instance.verificationMessageTemplate);
  writeNotNull('SmsAuthenticationMessage', instance.smsAuthenticationMessage);
  writeNotNull('MfaConfiguration', instance.mfaConfiguration);
  writeNotNull('EstimatedNumberOfUsers', instance.estimatedNumberOfUsers);
  writeNotNull('EmailConfiguration', instance.emailConfiguration);
  writeNotNull('SmsConfiguration', instance.smsConfiguration);
  return val;
}

SchemaAttribute _$SchemaAttributeFromJson(Map<String, dynamic> json) =>
    SchemaAttribute(
      name: json['Name'] as String,
      attributeDataType: json['AttributeDataType'] as String,
      developerOnlyAttribute: json['DeveloperOnlyAttribute'] as bool,
      isMutable: json['Mutable'] as bool,
      isRequired: json['Required'] as bool,
      stringAttributeConstraints: json['StringAttributeConstraints'] == null
          ? null
          : StringAttributeConstraints.fromJson(
              json['StringAttributeConstraints'] as Map<String, dynamic>),
      numberAttributeConstraints: json['NumberAttributeConstraints'] == null
          ? null
          : NumberAttributeConstraints.fromJson(
              json['NumberAttributeConstraints'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SchemaAttributeToJson(SchemaAttribute instance) {
  final val = <String, dynamic>{
    'Name': instance.name,
    'AttributeDataType': instance.attributeDataType,
    'DeveloperOnlyAttribute': instance.developerOnlyAttribute,
    'Mutable': instance.isMutable,
    'Required': instance.isRequired,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'StringAttributeConstraints', instance.stringAttributeConstraints);
  writeNotNull(
      'NumberAttributeConstraints', instance.numberAttributeConstraints);
  return val;
}

StringAttributeConstraints _$StringAttributeConstraintsFromJson(
        Map<String, dynamic> json) =>
    StringAttributeConstraints(
      json['MinLength'] as String,
      json['MaxLength'] as String,
    );

Map<String, dynamic> _$StringAttributeConstraintsToJson(
        StringAttributeConstraints instance) =>
    <String, dynamic>{
      'MinLength': instance.minLength,
      'MaxLength': instance.maxLength,
    };

NumberAttributeConstraints _$NumberAttributeConstraintsFromJson(
        Map<String, dynamic> json) =>
    NumberAttributeConstraints(
      json['MinValue'] as String,
    );

Map<String, dynamic> _$NumberAttributeConstraintsToJson(
        NumberAttributeConstraints instance) =>
    <String, dynamic>{
      'MinValue': instance.minValue,
    };

VerificationMessageTemplate _$VerificationMessageTemplateFromJson(
        Map<String, dynamic> json) =>
    VerificationMessageTemplate(
      smsMessage: json['SmsMessage'] as String,
      emailMessage: json['EmailMessage'] as String,
      emailSubject: json['EmailSubject'] as String,
      defaultEmailOption: json['DefaultEmailOption'] as String,
    );

Map<String, dynamic> _$VerificationMessageTemplateToJson(
        VerificationMessageTemplate instance) =>
    <String, dynamic>{
      'SmsMessage': instance.smsMessage,
      'EmailMessage': instance.emailMessage,
      'EmailSubject': instance.emailSubject,
      'DefaultEmailOption': instance.defaultEmailOption,
    };

EmailConfiguration _$EmailConfigurationFromJson(Map<String, dynamic> json) =>
    EmailConfiguration(
      emailSendingAccount: json['EmailSendingAccount'] as String,
    );

Map<String, dynamic> _$EmailConfigurationToJson(EmailConfiguration instance) =>
    <String, dynamic>{
      'EmailSendingAccount': instance.emailSendingAccount,
    };

SMSConfiguration _$SMSConfigurationFromJson(Map<String, dynamic> json) =>
    SMSConfiguration(
      snsCallerArn: json['SnsCallerArn'] as String,
      externalId: json['ExternalId'] as String,
    );

Map<String, dynamic> _$SMSConfigurationToJson(SMSConfiguration instance) =>
    <String, dynamic>{
      'SnsCallerArn': instance.snsCallerArn,
      'ExternalId': instance.externalId,
    };
