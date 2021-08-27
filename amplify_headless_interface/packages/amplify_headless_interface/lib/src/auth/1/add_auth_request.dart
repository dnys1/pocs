import 'package:json_schema2/json_schema2.dart'
    show ValidationError, JsonSchema;

/// Configuration that applies to all Cognito configuration.
class BaseCognitoServiceConfigurationServiceName {
  const BaseCognitoServiceConfigurationServiceName._(this._value);

  final String _value;

  /// `Cognito`
  static const $cognito =
      BaseCognitoServiceConfigurationServiceName._('Cognito');

  static const List<BaseCognitoServiceConfigurationServiceName> values = [
    $cognito
  ];

  String toJson() => _value;
}

/// Configuration that applies to all Cognito configuration.
class BaseCognitoServiceConfiguration {
  const BaseCognitoServiceConfiguration({this.cognitoUserPoolConfiguration});

  /// The name of the service providing the resource.
  final BaseCognitoServiceConfigurationServiceName serviceName =
      BaseCognitoServiceConfigurationServiceName.$cognito;

  /// Cognito configuration exposed by Amplify.
  final CognitoUserPoolConfiguration? cognitoUserPoolConfiguration;

  Map<String, dynamic> toJson() => {
        'serviceName': serviceName,
        if (cognitoUserPoolConfiguration != null)
          'cognitoUserPoolConfiguration': cognitoUserPoolConfiguration,
      };
}

/// Account attributes that must be specified to sign up.
class CognitoUserPoolConfigurationRequiredSignupAttributes {
  const CognitoUserPoolConfigurationRequiredSignupAttributes._(this._value);

  final String _value;

  /// `ADDRESS`
  static const $address =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('ADDRESS');

  /// `BIRTHDATE`
  static const $birthdate =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('BIRTHDATE');

  /// `EMAIL`
  static const $email =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('EMAIL');

  /// `FAMILY_NAME`
  static const $familyName =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('FAMILY_NAME');

  /// `GENDER`
  static const $gender =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('GENDER');

  /// `GIVEN_NAME`
  static const $givenName =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('GIVEN_NAME');

  /// `LOCALE`
  static const $locale =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('LOCALE');

  /// `MIDDLE_NAME`
  static const $middleName =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('MIDDLE_NAME');

  /// `NAME`
  static const $name =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('NAME');

  /// `NICKNAME`
  static const $nickname =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('NICKNAME');

  /// `PHONE_NUMBER`
  static const $phoneNumber =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('PHONE_NUMBER');

  /// `PICTURE`
  static const $picture =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('PICTURE');

  /// `PREFERRED_USERNAME`
  static const $preferredUsername =
      CognitoUserPoolConfigurationRequiredSignupAttributes._(
          'PREFERRED_USERNAME');

  /// `PROFILE`
  static const $profile =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('PROFILE');

  /// `UPDATED_AT`
  static const $updatedAt =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('UPDATED_AT');

  /// `WEBSITE`
  static const $website =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('WEBSITE');

  /// `ZONE_INFO`
  static const $zoneInfo =
      CognitoUserPoolConfigurationRequiredSignupAttributes._('ZONE_INFO');

  static const List<CognitoUserPoolConfigurationRequiredSignupAttributes>
      values = [
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

/// Alias attributes that can be used for sign-up/sign-in
class CognitoUserPoolConfigurationAliasAttributes {
  const CognitoUserPoolConfigurationAliasAttributes._(this._value);

  final String _value;

  /// `EMAIL`
  static const $email = CognitoUserPoolConfigurationAliasAttributes._('EMAIL');

  /// `PHONE_NUMBER`
  static const $phoneNumber =
      CognitoUserPoolConfigurationAliasAttributes._('PHONE_NUMBER');

  /// `PREFERRED_USERNAME`
  static const $preferredUsername =
      CognitoUserPoolConfigurationAliasAttributes._('PREFERRED_USERNAME');

  static const List<CognitoUserPoolConfigurationAliasAttributes> values = [
    $email,
    $phoneNumber,
    $preferredUsername
  ];

  String toJson() => _value;
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
  Mfa({required this.mode, this.mfaTypes, this.smsMessage});

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
  PasswordRecovery(
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
class CognitoUserPoolConfigurationReadAttributes {
  const CognitoUserPoolConfigurationReadAttributes._(this._value);

  final String _value;

  /// `ADDRESS`
  static const $address =
      CognitoUserPoolConfigurationReadAttributes._('ADDRESS');

  /// `BIRTHDATE`
  static const $birthdate =
      CognitoUserPoolConfigurationReadAttributes._('BIRTHDATE');

  /// `EMAIL`
  static const $email = CognitoUserPoolConfigurationReadAttributes._('EMAIL');

  /// `EMAIL_VERIFIED`
  static const $emailVerified =
      CognitoUserPoolConfigurationReadAttributes._('EMAIL_VERIFIED');

  /// `FAMILY_NAME`
  static const $familyName =
      CognitoUserPoolConfigurationReadAttributes._('FAMILY_NAME');

  /// `GENDER`
  static const $gender = CognitoUserPoolConfigurationReadAttributes._('GENDER');

  /// `GIVEN_NAME`
  static const $givenName =
      CognitoUserPoolConfigurationReadAttributes._('GIVEN_NAME');

  /// `LOCALE`
  static const $locale = CognitoUserPoolConfigurationReadAttributes._('LOCALE');

  /// `MIDDLE_NAME`
  static const $middleName =
      CognitoUserPoolConfigurationReadAttributes._('MIDDLE_NAME');

  /// `NAME`
  static const $name = CognitoUserPoolConfigurationReadAttributes._('NAME');

  /// `NICKNAME`
  static const $nickname =
      CognitoUserPoolConfigurationReadAttributes._('NICKNAME');

  /// `PHONE_NUMBER`
  static const $phoneNumber =
      CognitoUserPoolConfigurationReadAttributes._('PHONE_NUMBER');

  /// `PHONE_NUMBER_VERIFIED`
  static const $phoneNumberVerified =
      CognitoUserPoolConfigurationReadAttributes._('PHONE_NUMBER_VERIFIED');

  /// `PICTURE`
  static const $picture =
      CognitoUserPoolConfigurationReadAttributes._('PICTURE');

  /// `PREFERRED_USERNAME`
  static const $preferredUsername =
      CognitoUserPoolConfigurationReadAttributes._('PREFERRED_USERNAME');

  /// `PROFILE`
  static const $profile =
      CognitoUserPoolConfigurationReadAttributes._('PROFILE');

  /// `UPDATED_AT`
  static const $updatedAt =
      CognitoUserPoolConfigurationReadAttributes._('UPDATED_AT');

  /// `WEBSITE`
  static const $website =
      CognitoUserPoolConfigurationReadAttributes._('WEBSITE');

  /// `ZONE_INFO`
  static const $zoneInfo =
      CognitoUserPoolConfigurationReadAttributes._('ZONE_INFO');

  static const List<CognitoUserPoolConfigurationReadAttributes> values = [
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
class CognitoUserPoolConfigurationWriteAttributes {
  const CognitoUserPoolConfigurationWriteAttributes._(this._value);

  final String _value;

  /// `ADDRESS`
  static const $address =
      CognitoUserPoolConfigurationWriteAttributes._('ADDRESS');

  /// `BIRTHDATE`
  static const $birthdate =
      CognitoUserPoolConfigurationWriteAttributes._('BIRTHDATE');

  /// `EMAIL`
  static const $email = CognitoUserPoolConfigurationWriteAttributes._('EMAIL');

  /// `FAMILY_NAME`
  static const $familyName =
      CognitoUserPoolConfigurationWriteAttributes._('FAMILY_NAME');

  /// `GENDER`
  static const $gender =
      CognitoUserPoolConfigurationWriteAttributes._('GENDER');

  /// `GIVEN_NAME`
  static const $givenName =
      CognitoUserPoolConfigurationWriteAttributes._('GIVEN_NAME');

  /// `LOCALE`
  static const $locale =
      CognitoUserPoolConfigurationWriteAttributes._('LOCALE');

  /// `MIDDLE_NAME`
  static const $middleName =
      CognitoUserPoolConfigurationWriteAttributes._('MIDDLE_NAME');

  /// `NAME`
  static const $name = CognitoUserPoolConfigurationWriteAttributes._('NAME');

  /// `NICKNAME`
  static const $nickname =
      CognitoUserPoolConfigurationWriteAttributes._('NICKNAME');

  /// `PHONE_NUMBER`
  static const $phoneNumber =
      CognitoUserPoolConfigurationWriteAttributes._('PHONE_NUMBER');

  /// `PICTURE`
  static const $picture =
      CognitoUserPoolConfigurationWriteAttributes._('PICTURE');

  /// `PREFERRED_USERNAME`
  static const $preferredUsername =
      CognitoUserPoolConfigurationWriteAttributes._('PREFERRED_USERNAME');

  /// `PROFILE`
  static const $profile =
      CognitoUserPoolConfigurationWriteAttributes._('PROFILE');

  /// `UPDATED_AT`
  static const $updatedAt =
      CognitoUserPoolConfigurationWriteAttributes._('UPDATED_AT');

  /// `WEBSITE`
  static const $website =
      CognitoUserPoolConfigurationWriteAttributes._('WEBSITE');

  /// `ZONE_INFO`
  static const $zoneInfo =
      CognitoUserPoolConfigurationWriteAttributes._('ZONE_INFO');

  static const List<CognitoUserPoolConfigurationWriteAttributes> values = [
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

/// Defines acceptable payloads to amplify add auth --headless.
class CognitoUserPoolConfigurationCognitoUserPoolSigninMethod {
  const CognitoUserPoolConfigurationCognitoUserPoolSigninMethod._(this._value);

  final String _value;

  /// `EMAIL`
  static const $email =
      CognitoUserPoolConfigurationCognitoUserPoolSigninMethod._('EMAIL');

  /// `EMAIL_AND_PHONE_NUMBER`
  static const $emailAndPhoneNumber =
      CognitoUserPoolConfigurationCognitoUserPoolSigninMethod._(
          'EMAIL_AND_PHONE_NUMBER');

  /// `PHONE_NUMBER`
  static const $phoneNumber =
      CognitoUserPoolConfigurationCognitoUserPoolSigninMethod._('PHONE_NUMBER');

  /// `USERNAME`
  static const $username =
      CognitoUserPoolConfigurationCognitoUserPoolSigninMethod._('USERNAME');

  static const List<CognitoUserPoolConfigurationCognitoUserPoolSigninMethod>
      values = [$email, $emailAndPhoneNumber, $phoneNumber, $username];

  String toJson() => _value;
}

/// Cognito configuration exposed by Amplify.
class CognitoUserPoolConfiguration {
  const CognitoUserPoolConfiguration(
      {required this.requiredSignupAttributes,
      this.aliasAttributes,
      this.userPoolName,
      this.userPoolGroups,
      this.mfa,
      this.passwordRecovery,
      this.refreshTokenPeriod,
      this.readAttributes,
      this.writeAttributes,
      this.cognitoUserPoolSigninMethod,
      this.cognitoAdminQueries,
      this.cognitoPasswordPolicy,
      this.cognitoOAuthConfiguration});

  /// Account attributes that must be specified to sign up.
  final List<CognitoUserPoolConfigurationRequiredSignupAttributes>
      requiredSignupAttributes;

  /// Alias attributes that can be used for sign-up/sign-in
  final List<CognitoUserPoolConfigurationAliasAttributes>? aliasAttributes;

  /// The name of the user pool. If not specified, a unique string will be generated.
  final String? userPoolName;

  /// User pool groups to create within the user pool. If not specified, no groups are created.
  final List<CognitoUserPoolGroup>? userPoolGroups;

  /// If defined, specifies MFA configuration. Default is MFA off.
  final Mfa? mfa;

  /// If defined, specifies password recovery configiuration. Default is email recovery.
  final PasswordRecovery? passwordRecovery;

  /// Defines how long refresh tokens are valid in days. Default is 30 days.
  final double? refreshTokenPeriod;

  /// Defines which user attributes can be read by the app. Default is email.
  final List<CognitoUserPoolConfigurationReadAttributes>? readAttributes;

  /// Defines which user attributes can be written by the app. Default is none.
  final List<CognitoUserPoolConfigurationWriteAttributes>? writeAttributes;

  final CognitoUserPoolConfigurationCognitoUserPoolSigninMethod?
      cognitoUserPoolSigninMethod;

  /// Configuration for the AdminQueries API
  final CognitoAdminQueries? cognitoAdminQueries;

  final CognitoPasswordPolicy? cognitoPasswordPolicy;

  /// Cognito OAuth configuration exposed by Amplify
  final CognitoOAuthConfiguration? cognitoOAuthConfiguration;

  Map<String, dynamic> toJson() => {
        'requiredSignupAttributes': requiredSignupAttributes,
        if (aliasAttributes != null) 'aliasAttributes': aliasAttributes,
        if (userPoolName != null) 'userPoolName': userPoolName,
        if (userPoolGroups != null) 'userPoolGroups': userPoolGroups,
        if (mfa != null) 'mfa': mfa,
        if (passwordRecovery != null) 'passwordRecovery': passwordRecovery,
        if (refreshTokenPeriod != null)
          'refreshTokenPeriod': refreshTokenPeriod,
        if (readAttributes != null) 'readAttributes': readAttributes,
        if (writeAttributes != null) 'writeAttributes': writeAttributes,
        if (cognitoUserPoolSigninMethod != null)
          'cognitoUserPoolSigninMethod': cognitoUserPoolSigninMethod,
        if (cognitoAdminQueries != null)
          'cognitoAdminQueries': cognitoAdminQueries,
        if (cognitoPasswordPolicy != null)
          'cognitoPasswordPolicy': cognitoPasswordPolicy,
        if (cognitoOAuthConfiguration != null)
          'cognitoOAuthConfiguration': cognitoOAuthConfiguration,
      };
}

/// Defines acceptable payloads to amplify add auth --headless.
class AddAuthRequestCognitoUserPoolSigninMethod {
  const AddAuthRequestCognitoUserPoolSigninMethod._(this._value);

  final String _value;

  /// `EMAIL`
  static const $email = AddAuthRequestCognitoUserPoolSigninMethod._('EMAIL');

  /// `EMAIL_AND_PHONE_NUMBER`
  static const $emailAndPhoneNumber =
      AddAuthRequestCognitoUserPoolSigninMethod._('EMAIL_AND_PHONE_NUMBER');

  /// `PHONE_NUMBER`
  static const $phoneNumber =
      AddAuthRequestCognitoUserPoolSigninMethod._('PHONE_NUMBER');

  /// `USERNAME`
  static const $username =
      AddAuthRequestCognitoUserPoolSigninMethod._('USERNAME');

  static const List<AddAuthRequestCognitoUserPoolSigninMethod> values = [
    $email,
    $emailAndPhoneNumber,
    $phoneNumber,
    $username
  ];

  String toJson() => _value;
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

/// Cognito OAuth configuration exposed by Amplify
class CognitoOAuthConfigurationOAuthGrantType {
  const CognitoOAuthConfigurationOAuthGrantType._(this._value);

  final String _value;

  /// `CODE`
  static const $code = CognitoOAuthConfigurationOAuthGrantType._('CODE');

  /// `IMPLICIT`
  static const $implicit =
      CognitoOAuthConfigurationOAuthGrantType._('IMPLICIT');

  static const List<CognitoOAuthConfigurationOAuthGrantType> values = [
    $code,
    $implicit
  ];

  String toJson() => _value;
}

/// The oAuth scopes granted by signin.
class CognitoOAuthConfigurationOAuthScopes {
  const CognitoOAuthConfigurationOAuthScopes._(this._value);

  final String _value;

  /// `AWS.COGNITO.SIGNIN.USER.ADMIN`
  static const $awsCognitoSigninUserAdmin =
      CognitoOAuthConfigurationOAuthScopes._('AWS.COGNITO.SIGNIN.USER.ADMIN');

  /// `EMAIL`
  static const $email = CognitoOAuthConfigurationOAuthScopes._('EMAIL');

  /// `OPENID`
  static const $openid = CognitoOAuthConfigurationOAuthScopes._('OPENID');

  /// `PHONE`
  static const $phone = CognitoOAuthConfigurationOAuthScopes._('PHONE');

  /// `PROFILE`
  static const $profile = CognitoOAuthConfigurationOAuthScopes._('PROFILE');

  static const List<CognitoOAuthConfigurationOAuthScopes> values = [
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
  SocialProviderConfigurations(
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

/// Cognito OAuth configuration exposed by Amplify
class CognitoOAuthConfiguration {
  const CognitoOAuthConfiguration(
      {this.domainPrefix,
      required this.redirectSigninURIs,
      required this.redirectSignoutURIs,
      required this.oAuthGrantType,
      required this.oAuthScopes,
      this.socialProviderConfigurations});

  /// Your hosted UI domain name.
  final String? domainPrefix;

  /// Valid signin redirect URIs.
  final List<String> redirectSigninURIs;

  /// Valid signout redirect URIs.
  final List<String> redirectSignoutURIs;

  /// The oAuth grant type.
  final CognitoOAuthConfigurationOAuthGrantType oAuthGrantType;

  /// The oAuth scopes granted by signin.
  final List<CognitoOAuthConfigurationOAuthScopes> oAuthScopes;

  /// If defined, users will be able to login with the specified social providers.
  final List<SocialProviderConfigurations>? socialProviderConfigurations;

  Map<String, dynamic> toJson() => {
        if (domainPrefix != null) 'domainPrefix': domainPrefix,
        'redirectSigninURIs': redirectSigninURIs,
        'redirectSignoutURIs': redirectSignoutURIs,
        'oAuthGrantType': oAuthGrantType,
        'oAuthScopes': oAuthScopes,
        if (socialProviderConfigurations != null)
          'socialProviderConfigurations': socialProviderConfigurations,
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

/// Specifies that the Cognito configuration includes an identity pool configuration.
class CognitoIdentityPoolIncludeIdentityPool {
  const CognitoIdentityPoolIncludeIdentityPool._(this._value);

  final bool _value;

  /// `true`
  static const $true = CognitoIdentityPoolIncludeIdentityPool._(true);

  static const List<CognitoIdentityPoolIncludeIdentityPool> values = [$true];

  bool toJson() => _value;
}

/// Specifies that the Cognito configuration includes an identity pool configuration.
class CognitoIdentityPool {
  const CognitoIdentityPool({this.cognitoIdentityPoolConfiguration});

  /// Indicates an identity pool should be configured.
  final CognitoIdentityPoolIncludeIdentityPool includeIdentityPool =
      CognitoIdentityPoolIncludeIdentityPool.$true;

  final CognitoIdentityPoolConfiguration? cognitoIdentityPoolConfiguration;

  Map<String, dynamic> toJson() => {
        'includeIdentityPool': includeIdentityPool,
        if (cognitoIdentityPoolConfiguration != null)
          'cognitoIdentityPoolConfiguration': cognitoIdentityPoolConfiguration,
      };
}

class CognitoIdentityPoolConfiguration {
  const CognitoIdentityPoolConfiguration(
      {this.identityPoolName,
      this.unauthenticatedLogin,
      this.identitySocialFederation});

  /// If not specified, a random string is generated.
  final String? identityPoolName;

  /// Allow guest login or not. Default is false.
  final bool? unauthenticatedLogin;

  /// If specified, Cognito will allow the specified providers to federate into the IdentityPool.
  final List<CognitoIdentitySocialFederation>? identitySocialFederation;

  Map<String, dynamic> toJson() => {
        if (identityPoolName != null) 'identityPoolName': identityPoolName,
        if (unauthenticatedLogin != null)
          'unauthenticatedLogin': unauthenticatedLogin,
        if (identitySocialFederation != null)
          'identitySocialFederation': identitySocialFederation,
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

/// Defines acceptable payloads to amplify add auth --headless.
class AddAuthRequestVersion {
  const AddAuthRequestVersion._(this._value);

  final double _value;

  /// `1`
  static const $1 = AddAuthRequestVersion._(1);

  static const List<AddAuthRequestVersion> values = [$1];

  double toJson() => _value;
}

/// Configuration that applies to all Cognito configuration.
class ServiceConfigurationServiceName {
  const ServiceConfigurationServiceName._(this._value);

  final String _value;

  /// `Cognito`
  static const $cognito = ServiceConfigurationServiceName._('Cognito');

  static const List<ServiceConfigurationServiceName> values = [$cognito];

  String toJson() => _value;
}

/// The configuration that defines the auth resource.
class ServiceConfiguration {
  ServiceConfiguration(
      {this.cognitoUserPoolConfiguration,
      required this.includeIdentityPool,
      this.cognitoIdentityPoolConfiguration});

  /// The name of the service providing the resource.
  final ServiceConfigurationServiceName serviceName =
      ServiceConfigurationServiceName.$cognito;

  /// Cognito configuration exposed by Amplify.
  final CognitoUserPoolConfiguration? cognitoUserPoolConfiguration;

  /// Indicates an indentity pool should not be configured.
  final bool includeIdentityPool;

  final CognitoIdentityPoolConfiguration? cognitoIdentityPoolConfiguration;

  Map<String, dynamic> toJson() => {
        'serviceName': serviceName,
        if (cognitoUserPoolConfiguration != null)
          'cognitoUserPoolConfiguration': cognitoUserPoolConfiguration,
        'includeIdentityPool': includeIdentityPool,
        if (cognitoIdentityPoolConfiguration != null)
          'cognitoIdentityPoolConfiguration': cognitoIdentityPoolConfiguration,
      };
}

/// Defines acceptable payloads to amplify add auth --headless.
class AddAuthRequest {
  const AddAuthRequest(
      {required this.resourceName, required this.serviceConfiguration});

  /// The schema version.
  final AddAuthRequestVersion version = AddAuthRequestVersion.$1;

  /// A name for the auth resource.
  final String resourceName;

  /// The configuration that defines the auth resource.
  final ServiceConfiguration serviceConfiguration;

  static const Map<String, dynamic> _schema = {
    "description":
        "Defines acceptable payloads to amplify add auth --headless.",
    "type": "object",
    "properties": {
      "version": {
        "description": "The schema version.",
        "type": "number",
        "enum": [1]
      },
      "resourceName": {
        "description": "A name for the auth resource.",
        "type": "string"
      },
      "serviceConfiguration": {
        "description": "The configuration that defines the auth resource.",
        "anyOf": [
          {
            "allOf": [
              {"\$ref": "#/definitions/BaseCognitoServiceConfiguration"},
              {"\$ref": "#/definitions/NoCognitoIdentityPool"}
            ]
          },
          {
            "allOf": [
              {"\$ref": "#/definitions/BaseCognitoServiceConfiguration"},
              {"\$ref": "#/definitions/CognitoIdentityPool"}
            ]
          }
        ]
      }
    },
    "required": ["resourceName", "serviceConfiguration", "version"],
    "definitions": {
      "BaseCognitoServiceConfiguration": {
        "description":
            "Configuration that applies to all Cognito configuration.",
        "type": "object",
        "properties": {
          "serviceName": {
            "description": "The name of the service providing the resource.",
            "type": "string",
            "enum": ["Cognito"]
          },
          "userPoolConfiguration": {
            "\$ref": "#/definitions/CognitoUserPoolConfiguration",
            "description": "The Cognito user pool configuration."
          }
        },
        "required": ["serviceName", "userPoolConfiguration"]
      },
      "CognitoUserPoolConfiguration": {
        "description": "Cognito configuration exposed by Amplify.",
        "type": "object",
        "properties": {
          "signinMethod": {
            "\$ref": "#/definitions/CognitoUserPoolSigninMethod",
            "description": "How users will signin to their account."
          },
          "requiredSignupAttributes": {
            "description":
                "Account attributes that must be specified to sign up.",
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
          },
          "aliasAttributes": {
            "description":
                "Alias attributes that can be used for sign-up/sign-in",
            "type": "array",
            "items": {
              "enum": ["EMAIL", "PHONE_NUMBER", "PREFERRED_USERNAME"],
              "type": "string"
            }
          },
          "userPoolName": {
            "description":
                "The name of the user pool. If not specified, a unique string will be generated.",
            "type": "string"
          },
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
          "passwordPolicy": {
            "\$ref": "#/definitions/CognitoPasswordPolicy",
            "description":
                "If defined, specifies password constraint configuration. Default is minimum length of 8 characters."
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
          },
          "oAuth": {
            "\$ref": "#/definitions/CognitoOAuthConfiguration",
            "description":
                "If defined, specified oAuth configuration will be applied to the user pool."
          }
        },
        "required": ["requiredSignupAttributes", "signinMethod"]
      },
      "CognitoUserPoolSigninMethod": {
        "enum": ["EMAIL", "EMAIL_AND_PHONE_NUMBER", "PHONE_NUMBER", "USERNAME"],
        "type": "string"
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
      "CognitoOAuthConfiguration": {
        "description": "Cognito OAuth configuration exposed by Amplify",
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
        },
        "required": [
          "oAuthGrantType",
          "oAuthScopes",
          "redirectSigninURIs",
          "redirectSignoutURIs"
        ]
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
      "CognitoIdentityPool": {
        "description":
            "Specifies that the Cognito configuration includes an identity pool configuration.",
        "type": "object",
        "properties": {
          "includeIdentityPool": {
            "description": "Indicates an identity pool should be configured.",
            "type": "boolean",
            "enum": [true]
          },
          "identityPoolConfiguration": {
            "\$ref": "#/definitions/CognitoIdentityPoolConfiguration",
            "description":
                "The identity pool configuration. If not specified, defaults are applied."
          }
        },
        "required": ["includeIdentityPool"]
      },
      "CognitoIdentityPoolConfiguration": {
        "type": "object",
        "properties": {
          "identityPoolName": {
            "description": "If not specified, a random string is generated.",
            "type": "string"
          },
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
        'resourceName': resourceName,
        'serviceConfiguration': serviceConfiguration,
      };
  List<ValidationError> validate() {
    final schema = JsonSchema.createSchema(_schema);
    return schema.validateWithErrors(toJson());
  }
}
