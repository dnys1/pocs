import 'dart:convert';

import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/analytics/analytics_config.dart';
import 'package:amplify_common/src/config/auth/cognito_config.dart';
import 'package:test/test.dart';

import 'testdata/testdata.dart';

void main() {
  group('Config', () {
    for (var testData in allTests) {
      final name = testData.name;
      test(name, () {
        final json = jsonDecode(testData.config) as Map;
        final parsed = AmplifyConfig.fromJson(json.cast());
        expect(parsed, equals(expected[name]!));
      });
    }
  });
}

const region = 'us-west-2';

const expected = {
  'Empty': AmplifyConfig(),
  'Analytics': AmplifyConfig(
    analytics: AnalyticsConfig(
      plugins: {
        PinpointPluginConfig.pluginKey: PinpointPluginConfig(
          pinpointAnalytics: PinpointAnalytics(appId: '12345', region: region),
          pinpointTargeting: PinpointTargeting(region: region),
        ),
      },
    ),
  ),
  'API': AmplifyConfig(
    api: ApiConfig(
      plugins: {
        AppSyncPluginConfig.pluginKey: AppSyncPluginConfig({
          'API_KEY': AppSyncApiConfig(
            endpointType: ApiEndpointType.graphQL,
            endpoint: 'example.com',
            region: region,
            authorizationType: APIAuthorizationType.apiKey,
            apiKey: '12345',
          ),
          'AWS_IAM': AppSyncApiConfig(
            endpointType: ApiEndpointType.graphQL,
            endpoint: 'example.com',
            region: region,
            authorizationType: APIAuthorizationType.iam,
          ),
          'REST': AppSyncApiConfig(
            endpointType: ApiEndpointType.rest,
            endpoint: 'example.com',
            region: region,
            authorizationType: APIAuthorizationType.userPools,
          ),
        }),
      },
    ),
  ),
  'Auth': AmplifyConfig(
    auth: AuthConfig(
      plugins: {
        CognitoPluginConfig.pluginKey: CognitoPluginConfig(
          userAgent: 'aws-amplify/cli',
          version: '0.1.0',
          identityManager: {'Default': CognitoIdentityManager()},
          auth: {
            'Default': CognitoAuthConfig(
              oAuth: CognitoOAuthConfig(
                appClientId: 'client_id',
                appClientSecret: 'client_secret',
                scopes: {'openid', 'email'},
                signInRedirectUri: 'myapp://',
                signOutRedirectUri: 'myapp://',
                webDomain: 'example.com',
              ),
            ),
            'DefaultCustomAuth': CognitoAuthConfig(
              authenticationFlowType: AuthenticationFlowType.customAuth,
            ),
          },
          cognitoUserPool: {
            'CustomEndpoint': CognitoUserPoolConfig(
              poolId: 'us-west-2_AbcDefGHi',
              appClientId: 'client_id',
              appClientSecret: 'client_secret',
              endpoint: 'example.com',
              region: region,
            ),
            'Default': CognitoUserPoolConfig(
              poolId: 'us-west-2_AbcDefGHi',
              appClientId: 'client_id',
              appClientSecret: 'client_secret',
              region: region,
              hostedUI: CognitoOAuthConfig(
                appClientId: 'client_id',
                appClientSecret: 'client_secret',
                scopes: {'openid', 'email'},
                signInRedirectUri: 'myapp://',
                signOutRedirectUri: 'myapp://',
                webDomain: 'https://example.com',
              ),
            ),
            'DefaultCustomAuth': CognitoUserPoolConfig(
              poolId: 'us-west-2_A1BcDefGH',
              appClientId: 'client_id',
              appClientSecret: 'client_secret',
              region: region,
            ),
          },
          credentialsProvider: {
            'CognitoIdentity': {
              'Default': {
                'PoolId': 'us-west-2:72c95e50-b409-49cb-9a78-81c243989b82',
                'Region': region,
              },
            },
          },
          s3TransferUtility: {
            'Default': S3TransferUtility(
              bucket: 'my-bucket',
              region: region,
            ),
          },
        ),
      },
    ),
  ),
};
