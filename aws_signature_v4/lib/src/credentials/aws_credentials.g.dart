// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aws_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AWSCredentials _$AWSCredentialsFromJson(Map<String, dynamic> json) {
  return AWSCredentials(
    json['access_key_id'] as String,
    json['secret_access_key'] as String,
    json['session_token'] as String?,
    json['expiration'] == null
        ? null
        : DateTime.parse(json['expiration'] as String),
  );
}

Map<String, dynamic> _$AWSCredentialsToJson(AWSCredentials instance) =>
    <String, dynamic>{
      'access_key_id': instance.accessKeyId,
      'secret_access_key': instance.secretAccessKey,
      'session_token': instance.sessionToken,
      'expiration': instance.expiration?.toIso8601String(),
    };
