import 'dart:convert';
import 'dart:io';

import 'package:amplify_common/amplify_common.dart';
import 'package:test/test.dart';

void main() {
  final amplifyConfigStr =
      File('test/amplifyconfiguration.json').readAsStringSync();
  final amplifyConfigJson = json.decode(amplifyConfigStr) as Map;

  group('AmplifyConfig', () {
    group('API', () {
      group('Parse', () {
        test('Valid config', () {
          final amplifyConfig = AmplifyConfig.fromJson(amplifyConfigJson);
          final expectedConfig = ApiConfig(
            plugins: {
              'awsAPIPlugin': {
                'habitr': ApiPluginConfig(
                  endpointType: ApiEndpointType.GraphQL,
                  endpoint:
                      'https://erwya6udtvgenibxo5mr2viwqa.appsync-api.us-west-2.amazonaws.com/graphql',
                  region: 'us-west-2',
                  authorizationType: ApiAuthorizationType.userPool,
                  apiKey: 'da2-t3gfrcaenrdstlphhfwsmtgiqq',
                ),
                'habitrAPI': ApiPluginConfig(
                  endpointType: ApiEndpointType.REST,
                  endpoint:
                      'https://4ccix50n24.execute-api.us-west-2.amazonaws.com/dev',
                  region: 'us-west-2',
                  authorizationType: ApiAuthorizationType.awsIAM,
                ),
              },
            },
          );
          expect(amplifyConfig.api, expectedConfig);
        });
      });
    });
  });
}
