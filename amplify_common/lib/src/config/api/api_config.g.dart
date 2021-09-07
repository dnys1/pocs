// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiConfig _$ApiConfigFromJson(Map<String, dynamic> json) => ApiConfig(
      plugins: AmplifyPluginRegistry.pluginConfigsFromJson(json['plugins']),
    );

Map<String, dynamic> _$ApiConfigToJson(ApiConfig instance) => <String, dynamic>{
      'plugins': instance.plugins,
    };

AppSyncApiConfig _$AppSyncApiConfigFromJson(Map<String, dynamic> json) =>
    AppSyncApiConfig(
      endpointType:
          _$enumDecode(_$ApiEndpointTypeEnumMap, json['endpointType']),
      endpoint: json['endpoint'] as String,
      region: json['region'] as String,
      authorizationType: _$enumDecode(
          _$ApiAuthorizationTypeEnumMap, json['authorizationType']),
      apiKey: json['apiKey'] as String?,
    );

Map<String, dynamic> _$AppSyncApiConfigToJson(AppSyncApiConfig instance) {
  final val = <String, dynamic>{
    'endpointType': _$ApiEndpointTypeEnumMap[instance.endpointType],
    'endpoint': instance.endpoint,
    'region': instance.region,
    'authorizationType':
        _$ApiAuthorizationTypeEnumMap[instance.authorizationType],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('apiKey', instance.apiKey);
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

const _$ApiEndpointTypeEnumMap = {
  ApiEndpointType.REST: 'REST',
  ApiEndpointType.GraphQL: 'GraphQL',
};

const _$ApiAuthorizationTypeEnumMap = {
  ApiAuthorizationType.apiKey: 'API_KEY',
  ApiAuthorizationType.awsIAM: 'AWS_IAM',
  ApiAuthorizationType.userPool: 'AMAZON_COGNITO_USER_POOLS',
  ApiAuthorizationType.oidc: 'OPENID_CONNECT',
};
