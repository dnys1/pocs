import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/auth/cognito/mfa.dart';
import 'package:amplify_common/src/config/auth/cognito/social_provider.dart';
import 'package:amplify_common/src/config/auth/cognito/user_attribute_key.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

import 'authentication_flow_type.dart';
import 'oauth.dart';
import 'password_protection_settings.dart';

part 'auth.g.dart';

typedef CognitoAuthConfigs = Map<String, CognitoAuthConfig>;

extension CognitoAuthConfigsX on CognitoAuthConfigs {
  CognitoAuthConfig? get default$ => this['Default'];
}

@amplifySerializable
@CognitoUserAttributeKeyConverter()
class CognitoAuthConfig with AWSEquatable<CognitoAuthConfig>, AWSSerializable {
  const CognitoAuthConfig({
    this.oAuth,
    this.authenticationFlowType,
    this.usernameAttributes = const [],
    this.socialProviders = const [],
    this.signupAttributes = const [],
    this.passwordProtectionSettings,
    this.mfaConfiguration,
    this.mfaTypes,
    this.verificationMechanisms = const [],
  });

  @JsonKey(name: 'OAuth')
  final CognitoOAuthConfig? oAuth;

  @JsonKey(
    unknownEnumValue: JsonKey.nullForUndefinedEnumValue,
  )
  final AuthenticationFlowType? authenticationFlowType;
  final List<SocialProvider> socialProviders;
  final List<CognitoUserAttributeKey> usernameAttributes;
  final List<CognitoUserAttributeKey> signupAttributes;
  final PasswordProtectionSettings? passwordProtectionSettings;
  final MfaConfiguration? mfaConfiguration;
  final List<MfaType>? mfaTypes;
  final List<CognitoUserAttributeKey> verificationMechanisms;

  @override
  List<Object?> get props => [
        oAuth,
        authenticationFlowType,
        socialProviders,
        usernameAttributes,
        signupAttributes,
        passwordProtectionSettings,
        mfaConfiguration,
        mfaTypes,
        verificationMechanisms,
      ];

  factory CognitoAuthConfig.fromJson(Map<String, Object?> json) =>
      _$CognitoAuthConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$CognitoAuthConfigToJson(this);
}
