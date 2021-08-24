// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_id_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetIdRequest _$GetIdRequestFromJson(Map<String, dynamic> json) => GetIdRequest(
      accountId: json['AccountId'] as String?,
      identityPoolId: json['IdentityPoolId'] as String,
      logins: (json['Logins'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$GetIdRequestToJson(GetIdRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('AccountId', instance.accountId);
  val['IdentityPoolId'] = instance.identityPoolId;
  writeNotNull('Logins', instance.logins);
  return val;
}
