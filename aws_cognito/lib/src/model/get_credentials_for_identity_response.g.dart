// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_credentials_for_identity_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCredentialsForIdentityResponse _$GetCredentialsForIdentityResponseFromJson(
        Map<String, dynamic> json) =>
    GetCredentialsForIdentityResponse(
      credentials:
          Credentials.fromJson(json['Credentials'] as Map<String, dynamic>),
      identityId: json['IdentityId'] as String,
    );

Map<String, dynamic> _$GetCredentialsForIdentityResponseToJson(
        GetCredentialsForIdentityResponse instance) =>
    <String, dynamic>{
      'Credentials': instance.credentials,
      'IdentityId': instance.identityId,
    };
