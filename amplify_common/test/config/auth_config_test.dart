// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:convert';
import 'dart:io';

import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/auth/cognito_config.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('Config', () {
    group('Auth', () {
      void testDirectory(String dir) {
        final directory = Directory(dir);
        for (var file in directory.listSync()) {
          final name = path.basenameWithoutExtension(file.path);
          test(name, () {
            final json = File(file.path).readAsStringSync();
            final configJson = jsonDecode(json) as Map<String, Object?>;
            final config = AmplifyConfig.fromJson(configJson);
            final expectedConfig = expected[name]!;
            final cognitoConfig = config.auth!.cognitoPlugin!.auth!['Default']!;
            expect(cognitoConfig, equals(expectedConfig));
          });
        }
      }

      group('Old', () {
        testDirectory('test/config/testdata/auth/old');
      });

      group('Zero Config', () {
        testDirectory('test/config/testdata/auth/zero_config');
      });
    });
  });
}

const expected = <String, CognitoAuthConfig>{
  'auth_with_all_attributes': CognitoAuthConfig(
    authenticationFlowType: AuthenticationFlowType.userSrpAuth,
    loginMechanisms: [
      CognitoUserAttributeKey.preferredUsername,
    ],
    signupAttributes: [
      CognitoUserAttributeKey.address,
      CognitoUserAttributeKey.birthdate,
      CognitoUserAttributeKey.email,
      CognitoUserAttributeKey.familyName,
      CognitoUserAttributeKey.middleName,
      CognitoUserAttributeKey.gender,
      CognitoUserAttributeKey.locale,
      CognitoUserAttributeKey.givenName,
      CognitoUserAttributeKey.name,
      CognitoUserAttributeKey.nickname,
      CognitoUserAttributeKey.phoneNumber,
      CognitoUserAttributeKey.preferredUsername,
      CognitoUserAttributeKey.picture,
      CognitoUserAttributeKey.profile,
      CognitoUserAttributeKey.updatedAt,
      CognitoUserAttributeKey.website,
      CognitoUserAttributeKey.zoneinfo,
    ],
    passwordProtectionSettings: PasswordProtectionSettings(
      passwordPolicyMinLength: 8,
    ),
    mfaConfiguration: MfaConfiguration.off,
    mfaTypes: [
      MfaType.sms,
    ],
    verificationMechanisms: [
      CognitoUserAttributeKey.email,
    ],
  ),
  'auth_with_email': CognitoAuthConfig(
    authenticationFlowType: AuthenticationFlowType.userSrpAuth,
    loginMechanisms: [
      CognitoUserAttributeKey.email,
    ],
    signupAttributes: [
      CognitoUserAttributeKey.email,
    ],
    passwordProtectionSettings: PasswordProtectionSettings(
      passwordPolicyMinLength: 8,
      passwordPolicyCharacters: [
        PasswordPolicyCharacters.requiresSymbols,
        PasswordPolicyCharacters.requiresLowercase,
        PasswordPolicyCharacters.requiresNumbers,
        PasswordPolicyCharacters.requiresUppercase,
      ],
    ),
    mfaConfiguration: MfaConfiguration.off,
    mfaTypes: [
      MfaType.sms,
    ],
    verificationMechanisms: [
      CognitoUserAttributeKey.email,
    ],
    usernameAttributes: [
      CognitoUserAttributeKey.email,
    ],
  ),
  'auth_with_multi_alias': CognitoAuthConfig(
    authenticationFlowType: AuthenticationFlowType.userSrpAuth,
    loginMechanism: [
      CognitoUserAttributeKey.email,
      CognitoUserAttributeKey.phoneNumber,
    ],
    signupAttributes: [
      CognitoUserAttributeKey.email,
      CognitoUserAttributeKey.phoneNumber,
    ],
    passwordProtectionSettings: PasswordProtectionSettings(
      passwordPolicyMinLength: 8,
    ),
    mfaConfiguration: MfaConfiguration.off,
    mfaTypes: [
      MfaType.sms,
    ],
    verificationMechanisms: [
      CognitoUserAttributeKey.email,
    ],
  ),
  'auth_with_username_no_attributes': CognitoAuthConfig(
    authenticationFlowType: AuthenticationFlowType.userSrpAuth,
    loginMechanisms: [
      CognitoUserAttributeKey.preferredUsername,
    ],
    signupAttributes: [
      CognitoUserAttributeKey.email,
    ],
    passwordProtectionSettings: PasswordProtectionSettings(
      passwordPolicyMinLength: 8,
    ),
    mfaConfiguration: MfaConfiguration.off,
    mfaTypes: [
      MfaType.sms,
    ],
    verificationMechanisms: [
      CognitoUserAttributeKey.email,
    ],
  ),
  'auth_with_email_or_phone': CognitoAuthConfig(
    authenticationFlowType: AuthenticationFlowType.userSrpAuth,
    usernameAttributes: [
      CognitoUserAttributeKey.email,
      CognitoUserAttributeKey.phoneNumber,
    ],
    signupAttributes: [
      CognitoUserAttributeKey.email,
      CognitoUserAttributeKey.phoneNumber,
    ],
    passwordProtectionSettings: PasswordProtectionSettings(
      passwordPolicyMinLength: 8,
    ),
    mfaConfiguration: MfaConfiguration.on,
    mfaTypes: [
      MfaType.sms,
    ],
    verificationMechanisms: [
      CognitoUserAttributeKey.email,
    ],
  ),
  'auth_with_federated': CognitoAuthConfig(
    oAuth: CognitoOAuthConfig(
      appClientId: 'client_id',
      scopes: {
        'phone',
        'email',
        'openid',
        'profile',
        'aws.cognito.signin.user.admin'
      },
      signInRedirectUri: 'myapp://',
      signOutRedirectUri: 'myapp://',
      webDomain: 'example.auth.us-west-2.amazoncognito.com',
    ),
    authenticationFlowType: AuthenticationFlowType.userSrpAuth,
    socialProviders: [
      SocialProvider.amazon,
      SocialProvider.facebook,
      SocialProvider.google,
    ],
    usernameAttributes: [
      CognitoUserAttributeKey.email,
    ],
    signupAttributes: [
      CognitoUserAttributeKey.email,
    ],
    passwordProtectionSettings: PasswordProtectionSettings(
      passwordPolicyMinLength: 8,
      passwordPolicyCharacters: [
        PasswordPolicyCharacters.requiresSymbols,
        PasswordPolicyCharacters.requiresLowercase,
        PasswordPolicyCharacters.requiresNumbers,
        PasswordPolicyCharacters.requiresUppercase,
      ],
    ),
    mfaConfiguration: MfaConfiguration.off,
    mfaTypes: [
      MfaType.sms,
    ],
    verificationMechanisms: [
      CognitoUserAttributeKey.email,
    ],
  ),
  'auth_with_username': CognitoAuthConfig(
    authenticationFlowType: AuthenticationFlowType.userSrpAuth,
    signupAttributes: [
      CognitoUserAttributeKey.preferredUsername,
    ],
    passwordProtectionSettings: PasswordProtectionSettings(
      passwordPolicyMinLength: 8,
      passwordPolicyCharacters: [
        PasswordPolicyCharacters.requiresSymbols,
        PasswordPolicyCharacters.requiresLowercase,
        PasswordPolicyCharacters.requiresNumbers,
        PasswordPolicyCharacters.requiresUppercase,
      ],
    ),
    mfaConfiguration: MfaConfiguration.off,
    mfaTypes: [
      MfaType.sms,
    ],
    verificationMechanisms: [
      CognitoUserAttributeKey.email,
    ],
  ),
};