import 'dart:convert' show jsonEncode;
import 'dart:io' show Process;

import 'package:json_schema2/json_schema2.dart'
    show ValidationError, JsonSchema;

class BaseCognitoServiceModificationServiceName {
  const BaseCognitoServiceModificationServiceName._(this._value);

  final String _value;

  /// `Cognito`
  static const $cognito =
      BaseCognitoServiceModificationServiceName._('Cognito');

  static const List<BaseCognitoServiceModificationServiceName> values = [
    $cognito
  ];

  String toJson() => _value;
}

/// Make all properties in T optional
class UserPoolModificationOAuthGrantType {
  const UserPoolModificationOAuthGrantType._(this._value);

  final String _value;

  /// `CODE`
  static const $code = UserPoolModificationOAuthGrantType._('CODE');

  /// `IMPLICIT`
  static const $implicit = UserPoolModificationOAuthGrantType._('IMPLICIT');

  static const List<UserPoolModificationOAuthGrantType> values = [
    $code,
    $implicit
  ];

  String toJson() => _value;
}

/// The oAuth scopes granted by signin.
class UserPoolModificationOAuthScopes {
  const UserPoolModificationOAuthScopes._(this._value);

  final String _value;

  /// `AWS.COGNITO.SIGNIN.USER.ADMIN`
  static const $awsCognitoSigninUserAdmin =
      UserPoolModificationOAuthScopes._('AWS.COGNITO.SIGNIN.USER.ADMIN');

  /// `EMAIL`
  static const $email = UserPoolModificationOAuthScopes._('EMAIL');

  /// `OPENID`
  static const $openid = UserPoolModificationOAuthScopes._('OPENID');

  /// `PHONE`
  static const $phone = UserPoolModificationOAuthScopes._('PHONE');

  /// `PROFILE`
  static const $profile = UserPoolModificationOAuthScopes._('PROFILE');

  static const List<UserPoolModificationOAuthScopes> values = [
    $awsCognitoSigninUserAdmin,
    $email,
    $openid,
    $phone,
    $profile
  ];

  String toJson() => _value;
}

class SocialProviderConfigurationsProvider {
  const SocialProviderConfigurationsProvider._(this._value);

  final String _value;

  /// `FACEBOOK`
  static const $facebook = SocialProviderConfigurationsProvider._('FACEBOOK');

  /// `GOOGLE`
  static const $google = SocialProviderConfigurationsProvider._('GOOGLE');

  /// `LOGIN_WITH_AMAZON`
  static const $loginWithAmazon =
      SocialProviderConfigurationsProvider._('LOGIN_WITH_AMAZON');

  /// `SIGN_IN_WITH_APPLE`
  static const $signInWithApple =
      SocialProviderConfigurationsProvider._('SIGN_IN_WITH_APPLE');

  static const List<SocialProviderConfigurationsProvider> values = [
    $facebook,
    $google,
    $loginWithAmazon,
    $signInWithApple
  ];

  String toJson() => _value;
}

class SocialProviderConfigurations {
  const SocialProviderConfigurations(
      {required this.provider,
      required this.clientId,
      this.clientSecret,
      this.teamId,
      this.keyId,
      this.privateKey});

  /// Social providers supported by Amplify and Cognito
  final SocialProviderConfigurationsProvider provider;

  /// The client ID (sometimes called app ID) configured with the provider.
  final String clientId;

  /// The client secret (sometimes called an app secret) configured with the provider.
  final String? clientSecret;

  /// The team ID configured with the provider
  final String? teamId;

  /// The key ID (sometimes called apple private key ID) configured with the provider.
  final String? keyId;

  /// The private key configured with the provider. Value can be undefined on an update request.
  /// Every member can be updated except the privateKey because the privateKey isn't easily retrievable.
  final String? privateKey;

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'clientId': clientId,
        if (clientSecret != null) 'clientSecret': clientSecret,
        if (teamId != null) 'teamId': teamId,
        if (keyId != null) 'keyId': keyId,
        if (privateKey != null) 'privateKey': privateKey,
      };
}

/// Defines a Cognito oAuth social provider
class SocialProviderConfigProvider
    implements SocialProviderConfigurationsProvider {
  const SocialProviderConfigProvider._(this._value);

  final String _value;

  /// `FACEBOOK`
  static const $facebook = SocialProviderConfigProvider._('FACEBOOK');

  /// `GOOGLE`
  static const $google = SocialProviderConfigProvider._('GOOGLE');

  /// `LOGIN_WITH_AMAZON`
  static const $loginWithAmazon =
      SocialProviderConfigProvider._('LOGIN_WITH_AMAZON');

  static const List<SocialProviderConfigProvider> values = [
    $facebook,
    $google,
    $loginWithAmazon
  ];

  String toJson() => _value;
}

/// Defines a Cognito oAuth social provider
class SocialProviderConfig implements SocialProviderConfigurations {
  const SocialProviderConfig(
      {required this.provider,
      required this.clientId,
      required this.clientSecret});

  /// Social providers supported by Amplify and Cognito
  final SocialProviderConfigProvider provider;

  /// The client ID (sometimes called app ID) configured with the provider.
  final String clientId;

  /// The client secret (sometimes called an app secret) configured with the provider.
  final String clientSecret;

  @override
  String? get teamId => null;
  @override
  String? get keyId => null;
  @override
  String? get privateKey => null;
  Map<String, dynamic> toJson() => {
        'provider': provider,
        'clientId': clientId,
        'clientSecret': clientSecret,
      };
}

/// Defines a Cognito Sign in with Apple oAuth social provider
class SignInWithAppleSocialProviderConfigProvider
    implements SocialProviderConfigurationsProvider {
  const SignInWithAppleSocialProviderConfigProvider._(this._value);

  final String _value;

  /// `SIGN_IN_WITH_APPLE`
  static const $signInWithApple =
      SignInWithAppleSocialProviderConfigProvider._('SIGN_IN_WITH_APPLE');

  static const List<SignInWithAppleSocialProviderConfigProvider> values = [
    $signInWithApple
  ];

  String toJson() => _value;
}

/// Defines a Cognito Sign in with Apple oAuth social provider
class SignInWithAppleSocialProviderConfig
    implements SocialProviderConfigurations {
  const SignInWithAppleSocialProviderConfig(
      {required this.clientId,
      required this.teamId,
      required this.keyId,
      this.privateKey});

  final SignInWithAppleSocialProviderConfigProvider provider =
      SignInWithAppleSocialProviderConfigProvider.$signInWithApple;

  /// The client ID (sometimes called apple services ID) configured with the provider.
  final String clientId;

  /// The team ID configured with the provider
  final String teamId;

  /// The key ID (sometimes called apple private key ID) configured with the provider.
  final String keyId;

  /// The private key configured with the provider. Value can be undefined on an update request.
  /// Every member can be updated except the privateKey because the privateKey isn't easily retrievable.
  final String? privateKey;

  @override
  String? get clientSecret => null;
  Map<String, dynamic> toJson() => {
        'provider': provider,
        'clientId': clientId,
        'teamId': teamId,
        'keyId': keyId,
        if (privateKey != null) 'privateKey': privateKey,
      };
}

class MfaMode {
  const MfaMode._(this._value);

  final String _value;

  /// `OFF`
  static const $off = MfaMode._('OFF');

  /// `ON`
  static const $on = MfaMode._('ON');

  /// `OPTIONAL`
  static const $optional = MfaMode._('OPTIONAL');

  static const List<MfaMode> values = [$off, $on, $optional];

  String toJson() => _value;
}

/// MFA delivery options.
class MfaMfaTypes {
  const MfaMfaTypes._(this._value);

  final String _value;

  /// `SMS`
  static const $sms = MfaMfaTypes._('SMS');

  /// `TOTP`
  static const $totp = MfaMfaTypes._('TOTP');

  static const List<MfaMfaTypes> values = [$sms, $totp];

  String toJson() => _value;
}

/// If defined, specifies MFA configuration. Default is MFA off.
class Mfa {
  const Mfa({required this.mode, this.mfaTypes, this.smsMessage});

  final MfaMode mode;

  /// MFA delivery options.
  final List<MfaMfaTypes>? mfaTypes;

  /// If SMS is specified in "mfaTypes" this specifies the smsMessage that will be sent to the user.
  final String? smsMessage;

  Map<String, dynamic> toJson() => {
        'mode': mode,
        if (mfaTypes != null) 'mfaTypes': mfaTypes,
        if (smsMessage != null) 'smsMessage': smsMessage,
      };
}

/// Specifies that MFA should not be enabled for the user pool.
class CognitoMFAOffMode implements MfaMode {
  const CognitoMFAOffMode._(this._value);

  final String _value;

  /// `OFF`
  static const $off = CognitoMFAOffMode._('OFF');

  static const List<CognitoMFAOffMode> values = [$off];

  String toJson() => _value;
}

/// Specifies that MFA should not be enabled for the user pool.
class CognitoMFAOff implements Mfa {
  const CognitoMFAOff();

  final CognitoMFAOffMode mode = CognitoMFAOffMode.$off;

  @override
  List<MfaMfaTypes>? get mfaTypes => null;
  @override
  String? get smsMessage => null;
  Map<String, dynamic> toJson() => {
        'mode': mode,
      };
}

/// Specifies that MFA is enabled for the user pool.
class CognitoMFASettingsMode implements MfaMode {
  const CognitoMFASettingsMode._(this._value);

  final String _value;

  /// `ON`
  static const $on = CognitoMFASettingsMode._('ON');

  /// `OPTIONAL`
  static const $optional = CognitoMFASettingsMode._('OPTIONAL');

  static const List<CognitoMFASettingsMode> values = [$on, $optional];

  String toJson() => _value;
}

/// MFA delivery options.
class CognitoMFASettingsMfaTypes implements MfaMfaTypes {
  const CognitoMFASettingsMfaTypes._(this._value);

  final String _value;

  /// `SMS`
  static const $sms = CognitoMFASettingsMfaTypes._('SMS');

  /// `TOTP`
  static const $totp = CognitoMFASettingsMfaTypes._('TOTP');

  static const List<CognitoMFASettingsMfaTypes> values = [$sms, $totp];

  String toJson() => _value;
}

/// Specifies that MFA is enabled for the user pool.
class CognitoMFASettings implements Mfa {
  const CognitoMFASettings(
      {required this.mode, required this.mfaTypes, required this.smsMessage});

  /// ON requires users to set up MFA when creating an account. OPTIONAL means the user has the option to set up MFA.
  final CognitoMFASettingsMode mode;

  /// MFA delivery options.
  final List<CognitoMFASettingsMfaTypes> mfaTypes;

  /// If SMS is specified in "mfaTypes" this specifies the smsMessage that will be sent to the user.
  final String smsMessage;

  Map<String, dynamic> toJson() => {
        'mode': mode,
        'mfaTypes': mfaTypes,
        'smsMessage': smsMessage,
      };
}

class PasswordRecoveryDeliveryMethod {
  const PasswordRecoveryDeliveryMethod._(this._value);

  final String _value;

  /// `EMAIL`
  static const $email = PasswordRecoveryDeliveryMethod._('EMAIL');

  /// `SMS`
  static const $sms = PasswordRecoveryDeliveryMethod._('SMS');

  static const List<PasswordRecoveryDeliveryMethod> values = [$email, $sms];

  String toJson() => _value;
}

/// If defined, specifies password recovery configiuration. Default is email recovery.
class PasswordRecovery {
  const PasswordRecovery(
      {required this.deliveryMethod,
      this.emailMessage,
      this.emailSubject,
      this.smsMessage});

  final PasswordRecoveryDeliveryMethod deliveryMethod;

  final String? emailMessage;

  final String? emailSubject;

  final String? smsMessage;

  Map<String, dynamic> toJson() => {
        'deliveryMethod': deliveryMethod,
        if (emailMessage != null) 'emailMessage': emailMessage,
        if (emailSubject != null) 'emailSubject': emailSubject,
        if (smsMessage != null) 'smsMessage': smsMessage,
      };
}

/// Defines the email that will be sent to users to recover their password.
class CognitoEmailPasswordRecoveryConfigurationDeliveryMethod
    implements PasswordRecoveryDeliveryMethod {
  const CognitoEmailPasswordRecoveryConfigurationDeliveryMethod._(this._value);

  final String _value;

  /// `EMAIL`
  static const $email =
      CognitoEmailPasswordRecoveryConfigurationDeliveryMethod._('EMAIL');

  static const List<CognitoEmailPasswordRecoveryConfigurationDeliveryMethod>
      values = [$email];

  String toJson() => _value;
}

/// Defines the email that will be sent to users to recover their password.
class CognitoEmailPasswordRecoveryConfiguration implements PasswordRecovery {
  const CognitoEmailPasswordRecoveryConfiguration(
      {required this.emailMessage, required this.emailSubject});

  final CognitoEmailPasswordRecoveryConfigurationDeliveryMethod deliveryMethod =
      CognitoEmailPasswordRecoveryConfigurationDeliveryMethod.$email;

  final String emailMessage;

  final String emailSubject;

  @override
  String? get smsMessage => null;
  Map<String, dynamic> toJson() => {
        'deliveryMethod': deliveryMethod,
        'emailMessage': emailMessage,
        'emailSubject': emailSubject,
      };
}

/// Defines the SMS message that will be send to users to recover their password
class CognitoSMSPasswordRecoveryConfigurationDeliveryMethod
    implements PasswordRecoveryDeliveryMethod {
  const CognitoSMSPasswordRecoveryConfigurationDeliveryMethod._(this._value);

  final String _value;

  /// `SMS`
  static const $sms =
      CognitoSMSPasswordRecoveryConfigurationDeliveryMethod._('SMS');

  static const List<CognitoSMSPasswordRecoveryConfigurationDeliveryMethod>
      values = [$sms];

  String toJson() => _value;
}

/// Defines the SMS message that will be send to users to recover their password
class CognitoSMSPasswordRecoveryConfiguration implements PasswordRecovery {
  const CognitoSMSPasswordRecoveryConfiguration({required this.smsMessage});

  final CognitoSMSPasswordRecoveryConfigurationDeliveryMethod deliveryMethod =
      CognitoSMSPasswordRecoveryConfigurationDeliveryMethod.$sms;

  final String smsMessage;

  @override
  String? get emailMessage => null;
  @override
  String? get emailSubject => null;
  Map<String, dynamic> toJson() => {
        'deliveryMethod': deliveryMethod,
        'smsMessage': smsMessage,
      };
}

/// Defines which user attributes can be read by the app. Default is email.
class UserPoolModificationReadAttributes {
  const UserPoolModificationReadAttributes._(this._value);

  final String _value;

  /// `ADDRESS`
  static const $address = UserPoolModificationReadAttributes._('ADDRESS');

  /// `BIRTHDATE`
  static const $birthdate = UserPoolModificationReadAttributes._('BIRTHDATE');

  /// `EMAIL`
  static const $email = UserPoolModificationReadAttributes._('EMAIL');

  /// `EMAIL_VERIFIED`
  static const $emailVerified =
      UserPoolModificationReadAttributes._('EMAIL_VERIFIED');

  /// `FAMILY_NAME`
  static const $familyName =
      UserPoolModificationReadAttributes._('FAMILY_NAME');

  /// `GENDER`
  static const $gender = UserPoolModificationReadAttributes._('GENDER');

  /// `GIVEN_NAME`
  static const $givenName = UserPoolModificationReadAttributes._('GIVEN_NAME');

  /// `LOCALE`
  static const $locale = UserPoolModificationReadAttributes._('LOCALE');

  /// `MIDDLE_NAME`
  static const $middleName =
      UserPoolModificationReadAttributes._('MIDDLE_NAME');

  /// `NAME`
  static const $name = UserPoolModificationReadAttributes._('NAME');

  /// `NICKNAME`
  static const $nickname = UserPoolModificationReadAttributes._('NICKNAME');

  /// `PHONE_NUMBER`
  static const $phoneNumber =
      UserPoolModificationReadAttributes._('PHONE_NUMBER');

  /// `PHONE_NUMBER_VERIFIED`
  static const $phoneNumberVerified =
      UserPoolModificationReadAttributes._('PHONE_NUMBER_VERIFIED');

  /// `PICTURE`
  static const $picture = UserPoolModificationReadAttributes._('PICTURE');

  /// `PREFERRED_USERNAME`
  static const $preferredUsername =
      UserPoolModificationReadAttributes._('PREFERRED_USERNAME');

  /// `PROFILE`
  static const $profile = UserPoolModificationReadAttributes._('PROFILE');

  /// `UPDATED_AT`
  static const $updatedAt = UserPoolModificationReadAttributes._('UPDATED_AT');

  /// `WEBSITE`
  static const $website = UserPoolModificationReadAttributes._('WEBSITE');

  /// `ZONE_INFO`
  static const $zoneInfo = UserPoolModificationReadAttributes._('ZONE_INFO');

  static const List<UserPoolModificationReadAttributes> values = [
    $address,
    $birthdate,
    $email,
    $emailVerified,
    $familyName,
    $gender,
    $givenName,
    $locale,
    $middleName,
    $name,
    $nickname,
    $phoneNumber,
    $phoneNumberVerified,
    $picture,
    $preferredUsername,
    $profile,
    $updatedAt,
    $website,
    $zoneInfo
  ];

  String toJson() => _value;
}

/// Defines which user attributes can be written by the app. Default is none.
class UserPoolModificationWriteAttributes {
  const UserPoolModificationWriteAttributes._(this._value);

  final String _value;

  /// `ADDRESS`
  static const $address = UserPoolModificationWriteAttributes._('ADDRESS');

  /// `BIRTHDATE`
  static const $birthdate = UserPoolModificationWriteAttributes._('BIRTHDATE');

  /// `EMAIL`
  static const $email = UserPoolModificationWriteAttributes._('EMAIL');

  /// `FAMILY_NAME`
  static const $familyName =
      UserPoolModificationWriteAttributes._('FAMILY_NAME');

  /// `GENDER`
  static const $gender = UserPoolModificationWriteAttributes._('GENDER');

  /// `GIVEN_NAME`
  static const $givenName = UserPoolModificationWriteAttributes._('GIVEN_NAME');

  /// `LOCALE`
  static const $locale = UserPoolModificationWriteAttributes._('LOCALE');

  /// `MIDDLE_NAME`
  static const $middleName =
      UserPoolModificationWriteAttributes._('MIDDLE_NAME');

  /// `NAME`
  static const $name = UserPoolModificationWriteAttributes._('NAME');

  /// `NICKNAME`
  static const $nickname = UserPoolModificationWriteAttributes._('NICKNAME');

  /// `PHONE_NUMBER`
  static const $phoneNumber =
      UserPoolModificationWriteAttributes._('PHONE_NUMBER');

  /// `PICTURE`
  static const $picture = UserPoolModificationWriteAttributes._('PICTURE');

  /// `PREFERRED_USERNAME`
  static const $preferredUsername =
      UserPoolModificationWriteAttributes._('PREFERRED_USERNAME');

  /// `PROFILE`
  static const $profile = UserPoolModificationWriteAttributes._('PROFILE');

  /// `UPDATED_AT`
  static const $updatedAt = UserPoolModificationWriteAttributes._('UPDATED_AT');

  /// `WEBSITE`
  static const $website = UserPoolModificationWriteAttributes._('WEBSITE');

  /// `ZONE_INFO`
  static const $zoneInfo = UserPoolModificationWriteAttributes._('ZONE_INFO');

  static const List<UserPoolModificationWriteAttributes> values = [
    $address,
    $birthdate,
    $email,
    $familyName,
    $gender,
    $givenName,
    $locale,
    $middleName,
    $name,
    $nickname,
    $phoneNumber,
    $picture,
    $preferredUsername,
    $profile,
    $updatedAt,
    $website,
    $zoneInfo
  ];

  String toJson() => _value;
}

/// A subset of properties from CognitoUserPoolConfiguration that can be modified.
///
/// Each field will overwrite the entire previous configuration of that field, but omitted fields will not be removed.
/// For example, adding auth with
///
/// {
///    readAttributes: ['EMAIL', 'NAME', 'PHONE_NUMBER'],
///    passwordPolicy: {
///      minimumLength: 10,
///      additionalConstraints: [
///        REQUIRE_LOWERCASE, REQUIRE_UPPERCASE
///      ]
///    }
/// }
///
/// and then updating auth with
///
/// {
///    passwordPolicy: {
///      minimumLength: 8
///    }
/// }
///
/// will overwrite the entire passwordPolicy (removing the lowercase and uppercase constraints)
/// but will leave the readAttributes unaffected.
///
/// However, the oAuth field is treated slightly differently:
///    Omitting the oAuth field entirely will leave oAuth configuration unchanged.
///    Setting oAuth to {} (an empty object) will remove oAuth from the auth resource.
///    Including a non-empty oAuth configuration will overwrite the previous oAuth configuration.
class UserPoolModification {
  const UserPoolModification(
      {this.domainPrefix,
      this.redirectSigninURIs,
      this.redirectSignoutURIs,
      this.oAuthGrantType,
      this.oAuthScopes,
      this.socialProviderConfigurations,
      this.userPoolGroups,
      this.mfa,
      this.passwordRecovery,
      this.refreshTokenPeriod,
      this.readAttributes,
      this.writeAttributes,
      this.adminQueries,
      this.passwordPolicy});

  /// Your hosted UI domain name.
  final String? domainPrefix;

  /// Valid signin redirect URIs.
  final List<String>? redirectSigninURIs;

  /// Valid signout redirect URIs.
  final List<String>? redirectSignoutURIs;

  /// The oAuth grant type.
  final UserPoolModificationOAuthGrantType? oAuthGrantType;

  /// The oAuth scopes granted by signin.
  final List<UserPoolModificationOAuthScopes>? oAuthScopes;

  /// If defined, users will be able to login with the specified social providers.
  final List<SocialProviderConfigurations>? socialProviderConfigurations;

  /// User pool groups to create within the user pool. If not specified, no groups are created.
  final List<CognitoUserPoolGroup>? userPoolGroups;

  /// If defined, specifies MFA configuration. Default is MFA off.
  final Mfa? mfa;

  /// If defined, specifies password recovery configiuration. Default is email recovery.
  final PasswordRecovery? passwordRecovery;

  /// Defines how long refresh tokens are valid in days. Default is 30 days.
  final double? refreshTokenPeriod;

  /// Defines which user attributes can be read by the app. Default is email.
  final List<UserPoolModificationReadAttributes>? readAttributes;

  /// Defines which user attributes can be written by the app. Default is none.
  final List<UserPoolModificationWriteAttributes>? writeAttributes;

  /// Configuration for the AdminQueries API
  final CognitoAdminQueries? adminQueries;

  final CognitoPasswordPolicy? passwordPolicy;

  Map<String, dynamic> toJson() => {
        if (domainPrefix != null) 'domainPrefix': domainPrefix,
        if (redirectSigninURIs != null)
          'redirectSigninURIs': redirectSigninURIs,
        if (redirectSignoutURIs != null)
          'redirectSignoutURIs': redirectSignoutURIs,
        if (oAuthGrantType != null) 'oAuthGrantType': oAuthGrantType,
        if (oAuthScopes != null) 'oAuthScopes': oAuthScopes,
        if (socialProviderConfigurations != null)
          'socialProviderConfigurations': socialProviderConfigurations,
        if (userPoolGroups != null) 'userPoolGroups': userPoolGroups,
        if (mfa != null) 'mfa': mfa,
        if (passwordRecovery != null) 'passwordRecovery': passwordRecovery,
        if (refreshTokenPeriod != null)
          'refreshTokenPeriod': refreshTokenPeriod,
        if (readAttributes != null) 'readAttributes': readAttributes,
        if (writeAttributes != null) 'writeAttributes': writeAttributes,
        if (adminQueries != null) 'adminQueries': adminQueries,
        if (passwordPolicy != null) 'passwordPolicy': passwordPolicy,
      };
}

/// Defines which user attributes can be read by the app. Default is email.
class UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes
    implements UserPoolModificationReadAttributes {
  const UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._(
      this._value);

  final String _value;

  /// `ADDRESS`
  static const $address =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._('ADDRESS');

  /// `BIRTHDATE`
  static const $birthdate =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._(
          'BIRTHDATE');

  /// `EMAIL`
  static const $email =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._('EMAIL');

  /// `EMAIL_VERIFIED`
  static const $emailVerified =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._(
          'EMAIL_VERIFIED');

  /// `FAMILY_NAME`
  static const $familyName =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._(
          'FAMILY_NAME');

  /// `GENDER`
  static const $gender =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._('GENDER');

  /// `GIVEN_NAME`
  static const $givenName =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._(
          'GIVEN_NAME');

  /// `LOCALE`
  static const $locale =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._('LOCALE');

  /// `MIDDLE_NAME`
  static const $middleName =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._(
          'MIDDLE_NAME');

  /// `NAME`
  static const $name =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._('NAME');

  /// `NICKNAME`
  static const $nickname =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._('NICKNAME');

  /// `PHONE_NUMBER`
  static const $phoneNumber =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._(
          'PHONE_NUMBER');

  /// `PHONE_NUMBER_VERIFIED`
  static const $phoneNumberVerified =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._(
          'PHONE_NUMBER_VERIFIED');

  /// `PICTURE`
  static const $picture =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._('PICTURE');

  /// `PREFERRED_USERNAME`
  static const $preferredUsername =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._(
          'PREFERRED_USERNAME');

  /// `PROFILE`
  static const $profile =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._('PROFILE');

  /// `UPDATED_AT`
  static const $updatedAt =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._(
          'UPDATED_AT');

  /// `WEBSITE`
  static const $website =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._('WEBSITE');

  /// `ZONE_INFO`
  static const $zoneInfo =
      UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes._(
          'ZONE_INFO');

  static const List<UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes>
      values = [
    $address,
    $birthdate,
    $email,
    $emailVerified,
    $familyName,
    $gender,
    $givenName,
    $locale,
    $middleName,
    $name,
    $nickname,
    $phoneNumber,
    $phoneNumberVerified,
    $picture,
    $preferredUsername,
    $profile,
    $updatedAt,
    $website,
    $zoneInfo
  ];

  String toJson() => _value;
}

/// Defines which user attributes can be written by the app. Default is none.
class UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes
    implements UserPoolModificationWriteAttributes {
  const UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._(
      this._value);

  final String _value;

  /// `ADDRESS`
  static const $address =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._('ADDRESS');

  /// `BIRTHDATE`
  static const $birthdate =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._(
          'BIRTHDATE');

  /// `EMAIL`
  static const $email =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._('EMAIL');

  /// `FAMILY_NAME`
  static const $familyName =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._(
          'FAMILY_NAME');

  /// `GENDER`
  static const $gender =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._('GENDER');

  /// `GIVEN_NAME`
  static const $givenName =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._(
          'GIVEN_NAME');

  /// `LOCALE`
  static const $locale =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._('LOCALE');

  /// `MIDDLE_NAME`
  static const $middleName =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._(
          'MIDDLE_NAME');

  /// `NAME`
  static const $name =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._('NAME');

  /// `NICKNAME`
  static const $nickname =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._(
          'NICKNAME');

  /// `PHONE_NUMBER`
  static const $phoneNumber =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._(
          'PHONE_NUMBER');

  /// `PICTURE`
  static const $picture =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._('PICTURE');

  /// `PREFERRED_USERNAME`
  static const $preferredUsername =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._(
          'PREFERRED_USERNAME');

  /// `PROFILE`
  static const $profile =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._('PROFILE');

  /// `UPDATED_AT`
  static const $updatedAt =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._(
          'UPDATED_AT');

  /// `WEBSITE`
  static const $website =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._('WEBSITE');

  /// `ZONE_INFO`
  static const $zoneInfo =
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes._(
          'ZONE_INFO');

  static const List<
      UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes> values = [
    $address,
    $birthdate,
    $email,
    $familyName,
    $gender,
    $givenName,
    $locale,
    $middleName,
    $name,
    $nickname,
    $phoneNumber,
    $picture,
    $preferredUsername,
    $profile,
    $updatedAt,
    $website,
    $zoneInfo
  ];

  String toJson() => _value;
}

class UpdateAuthRequestCognitoUserPoolConfiguration
    implements UserPoolModification {
  const UpdateAuthRequestCognitoUserPoolConfiguration(
      {this.userPoolGroups,
      this.mfa,
      this.passwordRecovery,
      this.refreshTokenPeriod,
      this.readAttributes,
      this.writeAttributes,
      this.adminQueries,
      this.passwordPolicy});

  /// User pool groups to create within the user pool. If not specified, no groups are created.
  final List<CognitoUserPoolGroup>? userPoolGroups;

  /// If defined, specifies MFA configuration. Default is MFA off.
  final Mfa? mfa;

  /// If defined, specifies password recovery configiuration. Default is email recovery.
  final PasswordRecovery? passwordRecovery;

  /// Defines how long refresh tokens are valid in days. Default is 30 days.
  final double? refreshTokenPeriod;

  /// Defines which user attributes can be read by the app. Default is email.
  final List<UpdateAuthRequestCognitoUserPoolConfigurationReadAttributes>?
      readAttributes;

  /// Defines which user attributes can be written by the app. Default is none.
  final List<UpdateAuthRequestCognitoUserPoolConfigurationWriteAttributes>?
      writeAttributes;

  /// Configuration for the AdminQueries API
  final CognitoAdminQueries? adminQueries;

  final CognitoPasswordPolicy? passwordPolicy;

  @override
  String? get domainPrefix => null;
  @override
  List<String>? get redirectSigninURIs => null;
  @override
  List<String>? get redirectSignoutURIs => null;
  @override
  UserPoolModificationOAuthGrantType? get oAuthGrantType => null;
  @override
  List<UserPoolModificationOAuthScopes>? get oAuthScopes => null;
  @override
  List<SocialProviderConfigurations>? get socialProviderConfigurations => null;
  Map<String, dynamic> toJson() => {
        if (userPoolGroups != null) 'userPoolGroups': userPoolGroups,
        if (mfa != null) 'mfa': mfa,
        if (passwordRecovery != null) 'passwordRecovery': passwordRecovery,
        if (refreshTokenPeriod != null)
          'refreshTokenPeriod': refreshTokenPeriod,
        if (readAttributes != null) 'readAttributes': readAttributes,
        if (writeAttributes != null) 'writeAttributes': writeAttributes,
        if (adminQueries != null) 'adminQueries': adminQueries,
        if (passwordPolicy != null) 'passwordPolicy': passwordPolicy,
      };
}

class BaseCognitoServiceModification {
  const BaseCognitoServiceModification({required this.userPoolModification});

  final BaseCognitoServiceModificationServiceName serviceName =
      BaseCognitoServiceModificationServiceName.$cognito;

  /// A subset of properties from CognitoUserPoolConfiguration that can be modified.
  ///
  /// Each field will overwrite the entire previous configuration of that field, but omitted fields will not be removed.
  /// For example, adding auth with
  ///
  /// {
  ///    readAttributes: ['EMAIL', 'NAME', 'PHONE_NUMBER'],
  ///    passwordPolicy: {
  ///      minimumLength: 10,
  ///      additionalConstraints: [
  ///        REQUIRE_LOWERCASE, REQUIRE_UPPERCASE
  ///      ]
  ///    }
  /// }
  ///
  /// and then updating auth with
  ///
  /// {
  ///    passwordPolicy: {
  ///      minimumLength: 8
  ///    }
  /// }
  ///
  /// will overwrite the entire passwordPolicy (removing the lowercase and uppercase constraints)
  /// but will leave the readAttributes unaffected.
  ///
  /// However, the oAuth field is treated slightly differently:
  ///    Omitting the oAuth field entirely will leave oAuth configuration unchanged.
  ///    Setting oAuth to {} (an empty object) will remove oAuth from the auth resource.
  ///    Including a non-empty oAuth configuration will overwrite the previous oAuth configuration.
  final UserPoolModification userPoolModification;

  Map<String, dynamic> toJson() => {
        'serviceName': serviceName,
        'userPoolModification': userPoolModification,
      };
}

/// Defines a Cognito user pool group.
class CognitoUserPoolGroup {
  const CognitoUserPoolGroup({this.customPolicy, required this.groupName});

  /// Not implemented and should not be used.
  final String? customPolicy;

  /// The group name.
  final String groupName;

  Map<String, dynamic> toJson() => {
        if (customPolicy != null) 'customPolicy': customPolicy,
        'groupName': groupName,
      };
}

/// Defines the API permissions. groupName must only be specified if restrictAccess is true, in which case only the specified user pool group will have access to the Admin Queries API.
class Permissions {
  const Permissions({required this.restrictAccess, this.groupName});

  final bool restrictAccess;

  final String? groupName;

  Map<String, dynamic> toJson() => {
        'restrictAccess': restrictAccess,
        if (groupName != null) 'groupName': groupName,
      };
}

/// Configuration for the AdminQueries API
class CognitoAdminQueries {
  const CognitoAdminQueries({required this.permissions});

  /// Defines the API permissions. groupName must only be specified if restrictAccess is true, in which case only the specified user pool group will have access to the Admin Queries API.
  final Permissions permissions;

  Map<String, dynamic> toJson() => {
        'permissions': permissions,
      };
}

class CognitoPasswordPolicyAdditionalConstraints {
  const CognitoPasswordPolicyAdditionalConstraints._(this._value);

  final String _value;

  /// `REQUIRE_DIGIT`
  static const $requireDigit =
      CognitoPasswordPolicyAdditionalConstraints._('REQUIRE_DIGIT');

  /// `REQUIRE_LOWERCASE`
  static const $requireLowercase =
      CognitoPasswordPolicyAdditionalConstraints._('REQUIRE_LOWERCASE');

  /// `REQUIRE_SYMBOL`
  static const $requireSymbol =
      CognitoPasswordPolicyAdditionalConstraints._('REQUIRE_SYMBOL');

  /// `REQUIRE_UPPERCASE`
  static const $requireUppercase =
      CognitoPasswordPolicyAdditionalConstraints._('REQUIRE_UPPERCASE');

  static const List<CognitoPasswordPolicyAdditionalConstraints> values = [
    $requireDigit,
    $requireLowercase,
    $requireSymbol,
    $requireUppercase
  ];

  String toJson() => _value;
}

class CognitoPasswordPolicy {
  const CognitoPasswordPolicy({this.minimumLength, this.additionalConstraints});

  final double? minimumLength;

  final List<CognitoPasswordPolicyAdditionalConstraints>? additionalConstraints;

  Map<String, dynamic> toJson() => {
        if (minimumLength != null) 'minimumLength': minimumLength,
        if (additionalConstraints != null)
          'additionalConstraints': additionalConstraints,
      };
}

/// Specifies that the Cognito configuration should not include an identity pool.
class NoCognitoIdentityPoolIncludeIdentityPool {
  const NoCognitoIdentityPoolIncludeIdentityPool._(this._value);

  final bool _value;

  /// `false`
  static const $false = NoCognitoIdentityPoolIncludeIdentityPool._(false);

  static const List<NoCognitoIdentityPoolIncludeIdentityPool> values = [$false];

  bool toJson() => _value;
}

/// Specifies that the Cognito configuration should not include an identity pool.
class NoCognitoIdentityPool {
  const NoCognitoIdentityPool();

  /// Indicates an indentity pool should not be configured.
  final NoCognitoIdentityPoolIncludeIdentityPool includeIdentityPool =
      NoCognitoIdentityPoolIncludeIdentityPool.$false;

  Map<String, dynamic> toJson() => {
        'includeIdentityPool': includeIdentityPool,
      };
}

class ModifyCognitoIdentityPoolIncludeIdentityPool {
  const ModifyCognitoIdentityPoolIncludeIdentityPool._(this._value);

  final bool _value;

  /// `true`
  static const $true = ModifyCognitoIdentityPoolIncludeIdentityPool._(true);

  static const List<ModifyCognitoIdentityPoolIncludeIdentityPool> values = [
    $true
  ];

  bool toJson() => _value;
}

class UpdateAuthRequestCognitoIdentityPoolConfiguration {
  const UpdateAuthRequestCognitoIdentityPoolConfiguration(
      {this.unauthenticatedLogin, this.identitySocialFederation});

  /// Allow guest login or not. Default is false.
  final bool? unauthenticatedLogin;

  /// If specified, Cognito will allow the specified providers to federate into the IdentityPool.
  final List<CognitoIdentitySocialFederation>? identitySocialFederation;

  Map<String, dynamic> toJson() => {
        if (unauthenticatedLogin != null)
          'unauthenticatedLogin': unauthenticatedLogin,
        if (identitySocialFederation != null)
          'identitySocialFederation': identitySocialFederation,
      };
}

class ModifyCognitoIdentityPool {
  const ModifyCognitoIdentityPool({required this.identityPoolModification});

  final ModifyCognitoIdentityPoolIncludeIdentityPool includeIdentityPool =
      ModifyCognitoIdentityPoolIncludeIdentityPool.$true;

  final UpdateAuthRequestCognitoIdentityPoolConfiguration
      identityPoolModification;

  Map<String, dynamic> toJson() => {
        'includeIdentityPool': includeIdentityPool,
        'identityPoolModification': identityPoolModification,
      };
}

/// Defines a social federation provider.
class CognitoIdentitySocialFederationProvider {
  const CognitoIdentitySocialFederationProvider._(this._value);

  final String _value;

  /// `AMAZON`
  static const $amazon = CognitoIdentitySocialFederationProvider._('AMAZON');

  /// `APPLE`
  static const $apple = CognitoIdentitySocialFederationProvider._('APPLE');

  /// `FACEBOOK`
  static const $facebook =
      CognitoIdentitySocialFederationProvider._('FACEBOOK');

  /// `GOOGLE`
  static const $google = CognitoIdentitySocialFederationProvider._('GOOGLE');

  static const List<CognitoIdentitySocialFederationProvider> values = [
    $amazon,
    $apple,
    $facebook,
    $google
  ];

  String toJson() => _value;
}

/// Defines a social federation provider.
class CognitoIdentitySocialFederation {
  const CognitoIdentitySocialFederation(
      {required this.provider, required this.clientId});

  final CognitoIdentitySocialFederationProvider provider;

  /// ClientId unique to your client and the provider.
  final String clientId;

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'clientId': clientId,
      };
}

/// Defines the payload expected by `amplify update auth --headless`
class UpdateAuthRequestVersion {
  const UpdateAuthRequestVersion._(this._value);

  final double _value;

  /// `1`
  static const $1 = UpdateAuthRequestVersion._(1);

  static const List<UpdateAuthRequestVersion> values = [$1];

  double toJson() => _value;
}

class ServiceModificationServiceName {
  const ServiceModificationServiceName._(this._value);

  final String _value;

  /// `Cognito`
  static const $cognito = ServiceModificationServiceName._('Cognito');

  static const List<ServiceModificationServiceName> values = [$cognito];

  String toJson() => _value;
}

class ServiceModification {
  const ServiceModification(
      {required this.userPoolModification,
      required this.includeIdentityPool,
      this.unauthenticatedLogin,
      this.identitySocialFederation});

  final ServiceModificationServiceName serviceName =
      ServiceModificationServiceName.$cognito;

  /// A subset of properties from CognitoUserPoolConfiguration that can be modified.
  ///
  /// Each field will overwrite the entire previous configuration of that field, but omitted fields will not be removed.
  /// For example, adding auth with
  ///
  /// {
  ///    readAttributes: ['EMAIL', 'NAME', 'PHONE_NUMBER'],
  ///    passwordPolicy: {
  ///      minimumLength: 10,
  ///      additionalConstraints: [
  ///        REQUIRE_LOWERCASE, REQUIRE_UPPERCASE
  ///      ]
  ///    }
  /// }
  ///
  /// and then updating auth with
  ///
  /// {
  ///    passwordPolicy: {
  ///      minimumLength: 8
  ///    }
  /// }
  ///
  /// will overwrite the entire passwordPolicy (removing the lowercase and uppercase constraints)
  /// but will leave the readAttributes unaffected.
  ///
  /// However, the oAuth field is treated slightly differently:
  ///    Omitting the oAuth field entirely will leave oAuth configuration unchanged.
  ///    Setting oAuth to {} (an empty object) will remove oAuth from the auth resource.
  ///    Including a non-empty oAuth configuration will overwrite the previous oAuth configuration.
  final UserPoolModification userPoolModification;

  /// Indicates an indentity pool should not be configured.
  final bool includeIdentityPool;

  /// Allow guest login or not. Default is false.
  final bool? unauthenticatedLogin;

  /// If specified, Cognito will allow the specified providers to federate into the IdentityPool.
  final List<CognitoIdentitySocialFederation>? identitySocialFederation;

  Map<String, dynamic> toJson() => {
        'serviceName': serviceName,
        'userPoolModification': userPoolModification,
        'includeIdentityPool': includeIdentityPool,
        if (unauthenticatedLogin != null)
          'unauthenticatedLogin': unauthenticatedLogin,
        if (identitySocialFederation != null)
          'identitySocialFederation': identitySocialFederation,
      };
}

/// Defines the payload expected by `amplify update auth --headless`
class UpdateAuthRequest {
  const UpdateAuthRequest({required this.serviceModification});

  final UpdateAuthRequestVersion version = UpdateAuthRequestVersion.$1;

  final ServiceModification serviceModification;

  static const Map<String, dynamic> _schema = {
    "description":
        "Defines the payload expected by `amplify update auth --headless`",
    "type": "object",
    "properties": {
      "version": {
        "type": "number",
        "enum": [1]
      },
      "serviceModification": {
        "anyOf": [
          {
            "allOf": [
              {"\$ref": "#/definitions/BaseCognitoServiceModification"},
              {"\$ref": "#/definitions/NoCognitoIdentityPool"}
            ]
          },
          {
            "allOf": [
              {"\$ref": "#/definitions/BaseCognitoServiceModification"},
              {"\$ref": "#/definitions/ModifyCognitoIdentityPool"}
            ]
          }
        ]
      }
    },
    "required": ["serviceModification", "version"],
    "definitions": {
      "BaseCognitoServiceModification": {
        "type": "object",
        "properties": {
          "serviceName": {
            "type": "string",
            "enum": ["Cognito"]
          },
          "userPoolModification": {
            "description":
                "A subset of properties from CognitoUserPoolConfiguration that can be modified.\n\nEach field will overwrite the entire previous configuration of that field, but omitted fields will not be removed.\nFor example, adding auth with\n\n{\n   readAttributes: ['EMAIL', 'NAME', 'PHONE_NUMBER'],\n   passwordPolicy: {\n     minimumLength: 10,\n     additionalConstraints: [\n       REQUIRE_LOWERCASE, REQUIRE_UPPERCASE\n     ]\n   }\n}\n\nand then updating auth with\n\n{\n   passwordPolicy: {\n     minimumLength: 8\n   }\n}\n\nwill overwrite the entire passwordPolicy (removing the lowercase and uppercase constraints)\nbut will leave the readAttributes unaffected.\n\nHowever, the oAuth field is treated slightly differently:\n   Omitting the oAuth field entirely will leave oAuth configuration unchanged.\n   Setting oAuth to {} (an empty object) will remove oAuth from the auth resource.\n   Including a non-empty oAuth configuration will overwrite the previous oAuth configuration.",
            "allOf": [
              {
                "\$ref":
                    "#/definitions/Pick<CognitoUserPoolConfiguration,\"userPoolGroups\"|\"adminQueries\"|\"mfa\"|\"passwordPolicy\"|\"passwordRecovery\"|\"refreshTokenPeriod\"|\"readAttributes\"|\"writeAttributes\">"
              },
              {
                "type": "object",
                "properties": {
                  "oAuth": {
                    "\$ref": "#/definitions/Partial<CognitoOAuthConfiguration>"
                  }
                }
              }
            ]
          }
        },
        "required": ["serviceName", "userPoolModification"]
      },
      "Pick<CognitoUserPoolConfiguration,\"userPoolGroups\"|\"adminQueries\"|\"mfa\"|\"passwordPolicy\"|\"passwordRecovery\"|\"refreshTokenPeriod\"|\"readAttributes\"|\"writeAttributes\">":
          {
        "type": "object",
        "properties": {
          "userPoolGroups": {
            "description":
                "User pool groups to create within the user pool. If not specified, no groups are created.",
            "type": "array",
            "items": {"\$ref": "#/definitions/CognitoUserPoolGroup"}
          },
          "adminQueries": {
            "\$ref": "#/definitions/CognitoAdminQueries",
            "description": "If defined, an Admin Queries API is created."
          },
          "mfa": {
            "description":
                "If defined, specifies MFA configuration. Default is MFA off.",
            "anyOf": [
              {"\$ref": "#/definitions/CognitoMFAOff"},
              {"\$ref": "#/definitions/CognitoMFASettings"}
            ]
          },
          "passwordPolicy": {
            "\$ref": "#/definitions/CognitoPasswordPolicy",
            "description":
                "If defined, specifies password constraint configuration. Default is minimum length of 8 characters."
          },
          "passwordRecovery": {
            "description":
                "If defined, specifies password recovery configiuration. Default is email recovery.",
            "anyOf": [
              {
                "\$ref":
                    "#/definitions/CognitoEmailPasswordRecoveryConfiguration"
              },
              {"\$ref": "#/definitions/CognitoSMSPasswordRecoveryConfiguration"}
            ]
          },
          "refreshTokenPeriod": {
            "description":
                "Defines how long refresh tokens are valid in days. Default is 30 days.",
            "type": "number"
          },
          "readAttributes": {
            "description":
                "Defines which user attributes can be read by the app. Default is email.",
            "type": "array",
            "items": {
              "enum": [
                "ADDRESS",
                "BIRTHDATE",
                "EMAIL",
                "EMAIL_VERIFIED",
                "FAMILY_NAME",
                "GENDER",
                "GIVEN_NAME",
                "LOCALE",
                "MIDDLE_NAME",
                "NAME",
                "NICKNAME",
                "PHONE_NUMBER",
                "PHONE_NUMBER_VERIFIED",
                "PICTURE",
                "PREFERRED_USERNAME",
                "PROFILE",
                "UPDATED_AT",
                "WEBSITE",
                "ZONE_INFO"
              ],
              "type": "string"
            }
          },
          "writeAttributes": {
            "description":
                "Defines which user attributes can be written by the app. Default is none.",
            "type": "array",
            "items": {
              "enum": [
                "ADDRESS",
                "BIRTHDATE",
                "EMAIL",
                "FAMILY_NAME",
                "GENDER",
                "GIVEN_NAME",
                "LOCALE",
                "MIDDLE_NAME",
                "NAME",
                "NICKNAME",
                "PHONE_NUMBER",
                "PICTURE",
                "PREFERRED_USERNAME",
                "PROFILE",
                "UPDATED_AT",
                "WEBSITE",
                "ZONE_INFO"
              ],
              "type": "string"
            }
          }
        }
      },
      "CognitoUserPoolGroup": {
        "description": "Defines a Cognito user pool group.",
        "type": "object",
        "properties": {
          "customPolicy": {
            "description": "Not implemented and should not be used.",
            "type": "string"
          },
          "groupName": {"description": "The group name.", "type": "string"}
        },
        "required": ["groupName"]
      },
      "CognitoAdminQueries": {
        "description": "Configuration for the AdminQueries API",
        "type": "object",
        "properties": {
          "permissions": {
            "description":
                "Defines the API permissions. groupName must only be specified if restrictAccess is true, in which case only the specified user pool group will have access to the Admin Queries API.",
            "type": "object",
            "properties": {
              "restrictAccess": {"type": "boolean"},
              "groupName": {"type": "string"}
            },
            "required": ["restrictAccess"]
          }
        },
        "required": ["permissions"]
      },
      "CognitoMFAOff": {
        "description":
            "Specifies that MFA should not be enabled for the user pool.",
        "type": "object",
        "properties": {
          "mode": {
            "type": "string",
            "enum": ["OFF"]
          }
        },
        "required": ["mode"]
      },
      "CognitoMFASettings": {
        "description": "Specifies that MFA is enabled for the user pool.",
        "type": "object",
        "properties": {
          "mode": {
            "description":
                "ON requires users to set up MFA when creating an account. OPTIONAL means the user has the option to set up MFA.",
            "enum": ["ON", "OPTIONAL"],
            "type": "string"
          },
          "mfaTypes": {
            "description": "MFA delivery options.",
            "type": "array",
            "items": {
              "enum": ["SMS", "TOTP"],
              "type": "string"
            }
          },
          "smsMessage": {
            "description":
                "If SMS is specified in \"mfaTypes\" this specifies the smsMessage that will be sent to the user.",
            "type": "string"
          }
        },
        "required": ["mfaTypes", "mode", "smsMessage"]
      },
      "CognitoPasswordPolicy": {
        "type": "object",
        "properties": {
          "minimumLength": {"type": "number"},
          "additionalConstraints": {
            "type": "array",
            "items": {
              "description":
                  "Password contraints that can be applied to Cognito user pools.",
              "enum": [
                "REQUIRE_DIGIT",
                "REQUIRE_LOWERCASE",
                "REQUIRE_SYMBOL",
                "REQUIRE_UPPERCASE"
              ],
              "type": "string"
            }
          }
        }
      },
      "CognitoEmailPasswordRecoveryConfiguration": {
        "description":
            "Defines the email that will be sent to users to recover their password.",
        "type": "object",
        "properties": {
          "deliveryMethod": {
            "type": "string",
            "enum": ["EMAIL"]
          },
          "emailMessage": {"type": "string"},
          "emailSubject": {"type": "string"}
        },
        "required": ["deliveryMethod", "emailMessage", "emailSubject"]
      },
      "CognitoSMSPasswordRecoveryConfiguration": {
        "description":
            "Defines the SMS message that will be send to users to recover their password",
        "type": "object",
        "properties": {
          "deliveryMethod": {
            "type": "string",
            "enum": ["SMS"]
          },
          "smsMessage": {"type": "string"}
        },
        "required": ["deliveryMethod", "smsMessage"]
      },
      "Partial<CognitoOAuthConfiguration>": {
        "description": "Make all properties in T optional",
        "type": "object",
        "properties": {
          "domainPrefix": {
            "description": "Your hosted UI domain name.",
            "type": "string"
          },
          "redirectSigninURIs": {
            "description": "Valid signin redirect URIs.",
            "type": "array",
            "items": {"type": "string"}
          },
          "redirectSignoutURIs": {
            "description": "Valid signout redirect URIs.",
            "type": "array",
            "items": {"type": "string"}
          },
          "oAuthGrantType": {
            "description": "The oAuth grant type.",
            "enum": ["CODE", "IMPLICIT"],
            "type": "string"
          },
          "oAuthScopes": {
            "description": "The oAuth scopes granted by signin.",
            "type": "array",
            "items": {
              "enum": [
                "AWS.COGNITO.SIGNIN.USER.ADMIN",
                "EMAIL",
                "OPENID",
                "PHONE",
                "PROFILE"
              ],
              "type": "string"
            }
          },
          "socialProviderConfigurations": {
            "description":
                "If defined, users will be able to login with the specified social providers.",
            "type": "array",
            "items": {
              "anyOf": [
                {"\$ref": "#/definitions/SocialProviderConfig"},
                {"\$ref": "#/definitions/SignInWithAppleSocialProviderConfig"}
              ]
            }
          }
        }
      },
      "SocialProviderConfig": {
        "description": "Defines a Cognito oAuth social provider",
        "type": "object",
        "properties": {
          "provider": {
            "description": "Social providers supported by Amplify and Cognito",
            "enum": ["FACEBOOK", "GOOGLE", "LOGIN_WITH_AMAZON"],
            "type": "string"
          },
          "clientId": {
            "description":
                "The client ID (sometimes called app ID) configured with the provider.",
            "type": "string"
          },
          "clientSecret": {
            "description":
                "The client secret (sometimes called an app secret) configured with the provider.",
            "type": "string"
          }
        },
        "required": ["clientId", "clientSecret", "provider"]
      },
      "SignInWithAppleSocialProviderConfig": {
        "description":
            "Defines a Cognito Sign in with Apple oAuth social provider",
        "type": "object",
        "properties": {
          "provider": {
            "type": "string",
            "enum": ["SIGN_IN_WITH_APPLE"]
          },
          "clientId": {
            "description":
                "The client ID (sometimes called apple services ID) configured with the provider.",
            "type": "string"
          },
          "teamId": {
            "description": "The team ID configured with the provider",
            "type": "string"
          },
          "keyId": {
            "description":
                "The key ID (sometimes called apple private key ID) configured with the provider.",
            "type": "string"
          },
          "privateKey": {
            "description":
                "The private key configured with the provider. Value can be undefined on an update request.\nEvery member can be updated except the privateKey because the privateKey isn't easily retrievable.",
            "type": "string"
          }
        },
        "required": ["clientId", "keyId", "provider", "teamId"]
      },
      "NoCognitoIdentityPool": {
        "description":
            "Specifies that the Cognito configuration should not include an identity pool.",
        "type": "object",
        "properties": {
          "includeIdentityPool": {
            "description":
                "Indicates an indentity pool should not be configured.",
            "type": "boolean",
            "enum": [false]
          }
        },
        "required": ["includeIdentityPool"]
      },
      "ModifyCognitoIdentityPool": {
        "type": "object",
        "properties": {
          "includeIdentityPool": {
            "type": "boolean",
            "enum": [true]
          },
          "identityPoolModification": {
            "\$ref":
                "#/definitions/Pick<CognitoIdentityPoolConfiguration,\"unauthenticatedLogin\"|\"identitySocialFederation\">"
          }
        },
        "required": ["identityPoolModification", "includeIdentityPool"]
      },
      "Pick<CognitoIdentityPoolConfiguration,\"unauthenticatedLogin\"|\"identitySocialFederation\">":
          {
        "type": "object",
        "properties": {
          "unauthenticatedLogin": {
            "description": "Allow guest login or not. Default is false.",
            "type": "boolean"
          },
          "identitySocialFederation": {
            "description":
                "If specified, Cognito will allow the specified providers to federate into the IdentityPool.",
            "type": "array",
            "items": {"\$ref": "#/definitions/CognitoIdentitySocialFederation"}
          }
        }
      },
      "CognitoIdentitySocialFederation": {
        "description": "Defines a social federation provider.",
        "type": "object",
        "properties": {
          "provider": {
            "enum": ["AMAZON", "APPLE", "FACEBOOK", "GOOGLE"],
            "type": "string"
          },
          "clientId": {
            "description": "ClientId unique to your client and the provider.",
            "type": "string"
          }
        },
        "required": ["clientId", "provider"]
      }
    },
    "\$schema": "http://json-schema.org/draft-06/schema#"
  };

  Map<String, dynamic> toJson() => {
        'version': version,
        'serviceModification': serviceModification,
      };
  List<ValidationError> validate() {
    final schema = JsonSchema.createSchema(_schema);
    return schema.validateWithErrors(jsonEncode(toJson()), parseJson: true);
  }

  Future<Process> start(
      {String? workingDirectory,
      Map<String, String>? environment,
      bool runInShell = false}) async {
    final proc = await Process.start(
      'amplify',
      [
        'update',
        'auth',
        '--headless',
      ],
      workingDirectory: workingDirectory,
      environment: environment,
      runInShell: runInShell,
    );
    proc.stdin.writeln(jsonEncode(this));

    return proc;
  }
}
