// GENERATED FILE. DO NOT MODIFY BY HAND.

class TestData {
  const TestData(this.name, this.config);

  final String name;
  final String config;
}

const _empty = r'''
{}
''';

const _analytics = r'''
{
  "analytics": {
    "plugins": {
      "awsPinpointAnalyticsPlugin": {
        "pinpointAnalytics": {
          "appId": "12345",
          "region": "us-west-2"
        },
        "pinpointTargeting": {
          "region": "us-west-2"
        }
      }
    }
  }
}
''';

const _auth = r'''
{
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify/cli",
        "Version": "0.1.0",
        "Auth0FederationProviderName": "xxxxxxxx.auth0.com",
        "IdentityManager": {
          "Default": {}
        },
        "Auth": {
          "Default": {
            "OAuth": {
              "AppClientId": "client_id",
              "AppClientSecret": "client_secret",
              "Scopes": [
                "openid",
                "email"
              ],
              "SignOutRedirectURI": "myapp://",
              "WebDomain": "example.com",
              "SignInRedirectURI": "myapp://"
            }
          },
          "DefaultCustomAuth": {
            "authenticationFlowType": "CUSTOM_AUTH"
          }
        },
        "CognitoUserPool": {
          "CustomEndpoint": {
            "AppClientId": "client_id",
            "AppClientSecret": "client_secret",
            "Endpoint": "example.com",
            "PoolId": "us-west-2_AbcDefGHi",
            "Region": "us-west-2"
          },
          "Default": {
            "AppClientId": "client_id",
            "AppClientSecret": "client_secret",
            "Region": "us-west-2",
            "HostedUI": {
              "AppClientId": "client_id",
              "AppClientSecret": "client_secret",
              "Scopes": [
                "openid",
                "email"
              ],
              "SignInRedirectURI": "myapp://",
              "SignOutRedirectURI": "myapp://",
              "WebDomain": "https://example.com"
            },
            "PoolId": "us-west-2_AbcDefGHi"
          },
          "DefaultCustomAuth": {
            "AppClientId": "client_id",
            "AppClientSecret": "client_secret",
            "Region": "us-west-2",
            "PoolId": "us-west-2_A1BcDefGH"
          }
        },
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {
              "PoolId": "us-west-2:72c95e50-b409-49cb-9a78-81c243989b82",
              "Region": "us-west-2"
            }
          }
        },
        "S3TransferUtility": {
          "Default": {
            "Bucket": "my-bucket",
            "Region": "us-west-2"
          }
        }
      }
    }
  }
}
''';

const _api = r'''
{
  "api": {
    "plugins": {
      "awsAPIPlugin": {
        "API_KEY": {
          "endpointType": "GraphQL",
          "endpoint": "example.com",
          "region": "us-west-2",
          "authorizationType": "API_KEY",
          "apiKey": "12345"
        },
        "AWS_IAM": {
          "endpointType": "GraphQL",
          "endpoint": "example.com",
          "region": "us-west-2",
          "authorizationType": "AWS_IAM",
          "apiKey": null
        },
        "REST": {
          "endpointType": "REST",
          "endpoint": "example.com",
          "region": "us-west-2",
          "authorizationType": "AMAZON_COGNITO_USER_POOLS"
        }
      }
    }
  }
}
''';

const allTests = [
  TestData('Empty', _empty),
  TestData('Analytics', _analytics),
  TestData('Auth', _auth),
  TestData('API', _api),
];
