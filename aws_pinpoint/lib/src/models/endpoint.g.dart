// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EndpointRequest _$EndpointRequestFromJson(Map<String, dynamic> json) =>
    EndpointRequest(
      user: json['User'] == null
          ? null
          : EndpointUser.fromJson(json['User'] as Map<String, dynamic>),
      channelType:
          $enumDecodeNullable(_$ChannelTypeEnumMap, json['ChannelType']),
    );

Map<String, dynamic> _$EndpointRequestToJson(EndpointRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('User', instance.user);
  writeNotNull('ChannelType', _$ChannelTypeEnumMap[instance.channelType]);
  return val;
}

const _$ChannelTypeEnumMap = {
  ChannelType.push: 'PUSH',
  ChannelType.gcm: 'GCM',
  ChannelType.apns: 'APNS',
  ChannelType.apnsSandbox: 'APNS_SANDBOX',
  ChannelType.apnsVoip: 'APNS_VOIP',
  ChannelType.apnsVoipSandbox: 'APNS_VOIP_SANDBOX',
  ChannelType.adm: 'ADM',
  ChannelType.sms: 'SMS',
  ChannelType.voice: 'VOICE',
  ChannelType.email: 'EMAIL',
  ChannelType.baidu: 'BAIDU',
  ChannelType.custom: 'CUSTOM',
  ChannelType.inApp: 'IN_APP',
};

EndpointUser _$EndpointUserFromJson(Map<String, dynamic> json) => EndpointUser(
      userId: json['UserId'] as String?,
      userAttributes: (json['UserAttributes'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

Map<String, dynamic> _$EndpointUserToJson(EndpointUser instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('UserId', instance.userId);
  writeNotNull('UserAttributes', instance.userAttributes);
  return val;
}

EndpointResponse _$EndpointResponseFromJson(Map<String, dynamic> json) =>
    EndpointResponse(
      id: json['Id'] as String?,
    );

Map<String, dynamic> _$EndpointResponseToJson(EndpointResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Id', instance.id);
  return val;
}
