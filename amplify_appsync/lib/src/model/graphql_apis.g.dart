// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_apis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphqlApis _$GraphqlApisFromJson(Map<String, dynamic> json) => GraphqlApis(
      apiId: json['apiId'] as String?,
      arn: json['arn'] as String?,
      authenticationType: _$enumDecodeNullable(
          _$AuthenticationTypeEnumMap, json['authenticationType']),
      name: json['name'] as String?,
      openIDConnectConfig: json['openIDConnectConfig'] == null
          ? null
          : OpenIDConnectConfig.fromJson(
              json['openIDConnectConfig'] as Map<String, dynamic>),
      tags: (json['tags'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      uris: (json['uris'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      wafWebAclArn: json['wafWebAclArn'] as String?,
      xrayEnabled: json['xrayEnabled'] as bool?,
    );

Map<String, dynamic> _$GraphqlApisToJson(GraphqlApis instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('apiId', instance.apiId);
  writeNotNull('arn', instance.arn);
  writeNotNull('authenticationType',
      _$AuthenticationTypeEnumMap[instance.authenticationType]);
  writeNotNull('name', instance.name);
  writeNotNull('openIDConnectConfig', instance.openIDConnectConfig);
  writeNotNull('tags', instance.tags);
  writeNotNull('uris', instance.uris);
  writeNotNull('wafWebAclArn', instance.wafWebAclArn);
  writeNotNull('xrayEnabled', instance.xrayEnabled);
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$AuthenticationTypeEnumMap = {
  AuthenticationType.apiKey: 'API_KEY',
  AuthenticationType.awsIam: 'AWS_IAM',
  AuthenticationType.cognitoUserPools: 'AMAZON_COGNITO_USER_POOLS',
  AuthenticationType.openIDConnect: 'OPENID_CONNECT',
  AuthenticationType.awsLambda: 'AWS_LAMBDA',
};
