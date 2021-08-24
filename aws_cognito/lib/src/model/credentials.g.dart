// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credentials _$CredentialsFromJson(Map<String, dynamic> json) => Credentials(
      accessKeyId: json['AccessKeyId'] as String?,
      secretKey: json['SecretKey'] as String?,
      sessionToken: json['SessionToken'] as String?,
      expiration: (json['Expiration'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CredentialsToJson(Credentials instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('AccessKeyId', instance.accessKeyId);
  writeNotNull('SecretKey', instance.secretKey);
  writeNotNull('SessionToken', instance.sessionToken);
  writeNotNull('Expiration', instance.expiration);
  return val;
}
