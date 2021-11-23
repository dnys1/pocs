import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/analytics/analytics_config.dart';
import 'package:amplify_common/src/config/api/appsync_config.dart';
import 'package:amplify_common/src/config/auth/cognito/auth.dart';
import 'package:amplify_common/src/config/auth/cognito/s3_transfer_utility.dart';
import 'package:aws_common/aws_common.dart';

import 'cognito/credentials_provider.dart';
import 'cognito/identity_manager.dart';
import 'cognito/user_pool.dart';

export 'cognito/auth.dart';
export 'cognito/authentication_flow_type.dart';
export 'cognito/credentials_provider.dart';
export 'cognito/identity_manager.dart';
export 'cognito/mfa.dart';
export 'cognito/oauth.dart';
export 'cognito/password_protection_settings.dart';
export 'cognito/s3_transfer_utility.dart';
export 'cognito/social_provider.dart';
export '../../auth/cognito/user_attribute_key.dart'
    hide CognitoUserAttributeKeyConverter;
export 'cognito/user_pool.dart';

part 'cognito_config.g.dart';

@awsSerializable
class CognitoPluginConfig
    with AWSEquatable<CognitoPluginConfig>, AWSSerializable
    implements AmplifyPluginConfig {
  static const pluginKey = 'awsCognitoAuthPlugin';

  @override
  String get name => pluginKey;

  final String userAgent;
  final String version;

  final CognitoIdentityManagers? identityManager;
  final CredentialsProvider? credentialsProvider;
  final CognitoUserPoolConfigs? cognitoUserPool;
  final CognitoAuthConfigs? auth;
  final Map<String, AppSyncApiConfig>? appSync;
  final Map<String, PinpointAnalytics>? pinpointAnalytics;
  final Map<String, PinpointTargeting>? pinpointTargeting;
  final Map<String, S3TransferUtility>? s3TransferUtility;

  const CognitoPluginConfig({
    this.userAgent = 'aws-amplify-cli/0.1.0',
    this.version = '0.1.0',
    this.identityManager,
    this.credentialsProvider,
    this.cognitoUserPool,
    this.auth,
    this.appSync,
    this.pinpointAnalytics,
    this.pinpointTargeting,
    this.s3TransferUtility,
  });

  @override
  List<Object?> get props => [
        userAgent,
        version,
        identityManager,
        credentialsProvider,
        cognitoUserPool,
        auth,
        appSync,
        pinpointAnalytics,
        pinpointTargeting,
        s3TransferUtility,
      ];

  factory CognitoPluginConfig.fromJson(Map<String, Object?> json) =>
      _$CognitoPluginConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$CognitoPluginConfigToJson(this);
}
