// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiConfig _$ApiConfigFromJson(Map json) {
  return ApiConfig(
    plugins: (json['plugins'] as Map).map(
      (k, e) => MapEntry(
          k as String,
          (e as Map).map(
            (k, e) => MapEntry(k as String, ApiPluginConfig.fromJson(e as Map)),
          )),
    ),
  );
}

Map<String, dynamic> _$ApiConfigToJson(ApiConfig instance) => <String, dynamic>{
      'plugins': instance.plugins,
    };

ApiPluginConfig _$ApiPluginConfigFromJson(Map json) {
  return ApiPluginConfig(
    endpointType: _$enumDecode(_$ApiEndpointTypeEnumMap, json['endpointType']),
    endpoint: json['endpoint'] as String,
    region: json['region'] as String,
    authorizationType:
        _$enumDecode(_$ApiAuthorizationTypeEnumMap, json['authorizationType']),
    apiKey: json['apiKey'] as String?,
  );
}

Map<String, dynamic> _$ApiPluginConfigToJson(ApiPluginConfig instance) =>
    <String, dynamic>{
      'endpointType': _$ApiEndpointTypeEnumMap[instance.endpointType],
      'endpoint': instance.endpoint,
      'region': instance.region,
      'authorizationType':
          _$ApiAuthorizationTypeEnumMap[instance.authorizationType],
      'apiKey': instance.apiKey,
    };

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
