// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_credentials_for_identity_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCredentialsForIdentityRequest _$GetCredentialsForIdentityRequestFromJson(
        Map<String, dynamic> json) =>
    GetCredentialsForIdentityRequest(
      customRoleArn: json['CustomRoleArn'] as String?,
      identityId: json['IdentityId'] as String,
      logins: (json['Logins'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$GetCredentialsForIdentityRequestToJson(
    GetCredentialsForIdentityRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('CustomRoleArn', instance.customRoleArn);
  val['IdentityId'] = instance.identityId;
  writeNotNull('Logins', instance.logins);
  return val;
}
