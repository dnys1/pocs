/// Configuration exposed by AppSync. Currently this is the only API type supported by Amplify headless mode.
class AppSyncServiceConfigurationServiceName {
  const AppSyncServiceConfigurationServiceName._(this._value);

  final String _value;

  /// `AppSync`
  static const $appSync = AppSyncServiceConfigurationServiceName._('AppSync');

  static const List<AppSyncServiceConfigurationServiceName> values = [$appSync];

  String toJson() => _value;
}

class DefaultAuthTypeMode {
  const DefaultAuthTypeMode._(this._value);

  final String _value;

  /// `API_KEY`
  static const $apiKey = DefaultAuthTypeMode._('API_KEY');

  /// `AWS_IAM`
  static const $awsIam = DefaultAuthTypeMode._('AWS_IAM');

  /// `AMAZON_COGNITO_USER_POOLS`
  static const $amazonCognitoUserPools =
      DefaultAuthTypeMode._('AMAZON_COGNITO_USER_POOLS');

  /// `OPENID_CONNECT`
  static const $openidConnect = DefaultAuthTypeMode._('OPENID_CONNECT');

  static const List<DefaultAuthTypeMode> values = [
    $apiKey,
    $awsIam,
    $amazonCognitoUserPools,
    $openidConnect
  ];

  String toJson() => _value;
}

/// The auth type that will be used by default.
class DefaultAuthType {
  DefaultAuthType(
      {required this.mode,
      this.expirationTime,
      this.keyDescription,
      this.cognitoUserPoolId,
      this.openIDProviderName,
      this.openIDIssuerURL,
      this.openIDClientID,
      this.openIDAuthTTL,
      this.openIDIatTTL});

  final DefaultAuthTypeMode mode;

  final double? expirationTime;

  final String? keyDescription;

  /// The user pool that will be used to authenticate requests.
  final String? cognitoUserPoolId;

  final String? openIDProviderName;

  final String? openIDIssuerURL;

  final String? openIDClientID;

  final String? openIDAuthTTL;

  final String? openIDIatTTL;

  Map<String, dynamic> toJson() => {
        'mode': mode,
        if (expirationTime != null) 'expirationTime': expirationTime,
        if (keyDescription != null) 'keyDescription': keyDescription,
        if (cognitoUserPoolId != null) 'cognitoUserPoolId': cognitoUserPoolId,
        if (openIDProviderName != null)
          'openIDProviderName': openIDProviderName,
        if (openIDIssuerURL != null) 'openIDIssuerURL': openIDIssuerURL,
        if (openIDClientID != null) 'openIDClientID': openIDClientID,
        if (openIDAuthTTL != null) 'openIDAuthTTL': openIDAuthTTL,
        if (openIDIatTTL != null) 'openIDIatTTL': openIDIatTTL,
      };
}

/// Specifies that the AppSync API should be secured using an API key.
class AppSyncAPIKeyAuthTypeMode implements DefaultAuthTypeMode {
  const AppSyncAPIKeyAuthTypeMode._(this._value);

  final String _value;

  /// `API_KEY`
  static const $apiKey = AppSyncAPIKeyAuthTypeMode._('API_KEY');

  static const List<AppSyncAPIKeyAuthTypeMode> values = [$apiKey];

  String toJson() => _value;
}

/// Specifies that the AppSync API should be secured using an API key.
class AppSyncAPIKeyAuthType implements DefaultAuthType {
  const AppSyncAPIKeyAuthType({this.expirationTime, this.keyDescription});

  final AppSyncAPIKeyAuthTypeMode mode = AppSyncAPIKeyAuthTypeMode.$apiKey;

  final double? expirationTime;

  final String? keyDescription;

  @override
  String? get cognitoUserPoolId => null;
  @override
  String? get openIDProviderName => null;
  @override
  String? get openIDIssuerURL => null;
  @override
  String? get openIDClientID => null;
  @override
  String? get openIDAuthTTL => null;
  @override
  String? get openIDIatTTL => null;
  Map<String, dynamic> toJson() => {
        'mode': mode,
        if (expirationTime != null) 'expirationTime': expirationTime,
        if (keyDescription != null) 'keyDescription': keyDescription,
      };
}

/// Specifies that the AppSync API should be secured using AWS IAM.
class AppSyncAWSIAMAuthTypeMode implements DefaultAuthTypeMode {
  const AppSyncAWSIAMAuthTypeMode._(this._value);

  final String _value;

  /// `AWS_IAM`
  static const $awsIam = AppSyncAWSIAMAuthTypeMode._('AWS_IAM');

  static const List<AppSyncAWSIAMAuthTypeMode> values = [$awsIam];

  String toJson() => _value;
}

/// Specifies that the AppSync API should be secured using AWS IAM.
class AppSyncAWSIAMAuthType implements DefaultAuthType {
  const AppSyncAWSIAMAuthType();

  final AppSyncAWSIAMAuthTypeMode mode = AppSyncAWSIAMAuthTypeMode.$awsIam;

  @override
  double? get expirationTime => null;
  @override
  String? get keyDescription => null;
  @override
  String? get cognitoUserPoolId => null;
  @override
  String? get openIDProviderName => null;
  @override
  String? get openIDIssuerURL => null;
  @override
  String? get openIDClientID => null;
  @override
  String? get openIDAuthTTL => null;
  @override
  String? get openIDIatTTL => null;
  Map<String, dynamic> toJson() => {
        'mode': mode,
      };
}

/// Specifies that the AppSync API should be secured using Cognito.
class AppSyncCognitoUserPoolsAuthTypeMode implements DefaultAuthTypeMode {
  const AppSyncCognitoUserPoolsAuthTypeMode._(this._value);

  final String _value;

  /// `AMAZON_COGNITO_USER_POOLS`
  static const $amazonCognitoUserPools =
      AppSyncCognitoUserPoolsAuthTypeMode._('AMAZON_COGNITO_USER_POOLS');

  static const List<AppSyncCognitoUserPoolsAuthTypeMode> values = [
    $amazonCognitoUserPools
  ];

  String toJson() => _value;
}

/// Specifies that the AppSync API should be secured using Cognito.
class AppSyncCognitoUserPoolsAuthType implements DefaultAuthType {
  const AppSyncCognitoUserPoolsAuthType({this.cognitoUserPoolId});

  final AppSyncCognitoUserPoolsAuthTypeMode mode =
      AppSyncCognitoUserPoolsAuthTypeMode.$amazonCognitoUserPools;

  /// The user pool that will be used to authenticate requests.
  final String? cognitoUserPoolId;

  @override
  double? get expirationTime => null;
  @override
  String? get keyDescription => null;
  @override
  String? get openIDProviderName => null;
  @override
  String? get openIDIssuerURL => null;
  @override
  String? get openIDClientID => null;
  @override
  String? get openIDAuthTTL => null;
  @override
  String? get openIDIatTTL => null;
  Map<String, dynamic> toJson() => {
        'mode': mode,
        if (cognitoUserPoolId != null) 'cognitoUserPoolId': cognitoUserPoolId,
      };
}

/// Specifies that the AppSync API should be secured using OpenID.
class AppSyncOpenIDConnectAuthTypeMode implements DefaultAuthTypeMode {
  const AppSyncOpenIDConnectAuthTypeMode._(this._value);

  final String _value;

  /// `OPENID_CONNECT`
  static const $openidConnect =
      AppSyncOpenIDConnectAuthTypeMode._('OPENID_CONNECT');

  static const List<AppSyncOpenIDConnectAuthTypeMode> values = [$openidConnect];

  String toJson() => _value;
}

/// Specifies that the AppSync API should be secured using OpenID.
class AppSyncOpenIDConnectAuthType implements DefaultAuthType {
  const AppSyncOpenIDConnectAuthType(
      {required this.openIDProviderName,
      required this.openIDIssuerURL,
      required this.openIDClientID,
      this.openIDAuthTTL,
      this.openIDIatTTL});

  final AppSyncOpenIDConnectAuthTypeMode mode =
      AppSyncOpenIDConnectAuthTypeMode.$openidConnect;

  final String openIDProviderName;

  final String openIDIssuerURL;

  final String openIDClientID;

  final String? openIDAuthTTL;

  final String? openIDIatTTL;

  @override
  double? get expirationTime => null;
  @override
  String? get keyDescription => null;
  @override
  String? get cognitoUserPoolId => null;
  Map<String, dynamic> toJson() => {
        'mode': mode,
        'openIDProviderName': openIDProviderName,
        'openIDIssuerURL': openIDIssuerURL,
        'openIDClientID': openIDClientID,
        if (openIDAuthTTL != null) 'openIDAuthTTL': openIDAuthTTL,
        if (openIDIatTTL != null) 'openIDIatTTL': openIDIatTTL,
      };
}

class AdditionalAuthTypesMode {
  const AdditionalAuthTypesMode._(this._value);

  final String _value;

  /// `API_KEY`
  static const $apiKey = AdditionalAuthTypesMode._('API_KEY');

  /// `AWS_IAM`
  static const $awsIam = AdditionalAuthTypesMode._('AWS_IAM');

  /// `AMAZON_COGNITO_USER_POOLS`
  static const $amazonCognitoUserPools =
      AdditionalAuthTypesMode._('AMAZON_COGNITO_USER_POOLS');

  /// `OPENID_CONNECT`
  static const $openidConnect = AdditionalAuthTypesMode._('OPENID_CONNECT');

  static const List<AdditionalAuthTypesMode> values = [
    $apiKey,
    $awsIam,
    $amazonCognitoUserPools,
    $openidConnect
  ];

  String toJson() => _value;
}

class AdditionalAuthTypes {
  AdditionalAuthTypes(
      {required this.mode,
      this.expirationTime,
      this.keyDescription,
      this.cognitoUserPoolId,
      this.openIDProviderName,
      this.openIDIssuerURL,
      this.openIDClientID,
      this.openIDAuthTTL,
      this.openIDIatTTL});

  final AdditionalAuthTypesMode mode;

  final double? expirationTime;

  final String? keyDescription;

  /// The user pool that will be used to authenticate requests.
  final String? cognitoUserPoolId;

  final String? openIDProviderName;

  final String? openIDIssuerURL;

  final String? openIDClientID;

  final String? openIDAuthTTL;

  final String? openIDIatTTL;

  Map<String, dynamic> toJson() => {
        'mode': mode,
        if (expirationTime != null) 'expirationTime': expirationTime,
        if (keyDescription != null) 'keyDescription': keyDescription,
        if (cognitoUserPoolId != null) 'cognitoUserPoolId': cognitoUserPoolId,
        if (openIDProviderName != null)
          'openIDProviderName': openIDProviderName,
        if (openIDIssuerURL != null) 'openIDIssuerURL': openIDIssuerURL,
        if (openIDClientID != null) 'openIDClientID': openIDClientID,
        if (openIDAuthTTL != null) 'openIDAuthTTL': openIDAuthTTL,
        if (openIDIatTTL != null) 'openIDIatTTL': openIDIatTTL,
      };
}

/// Configuration exposed by AppSync. Currently this is the only API type supported by Amplify headless mode.
class AppSyncServiceConfiguration {
  const AppSyncServiceConfiguration(
      {required this.apiName,
      required this.transformSchema,
      required this.defaultAuthType,
      this.additionalAuthTypes,
      this.conflictResolution});

  /// The service name of the resource provider.
  final AppSyncServiceConfigurationServiceName serviceName =
      AppSyncServiceConfigurationServiceName.$appSync;

  /// The name of the API that will be created.
  final String apiName;

  /// The annotated GraphQL schema that defines the AppSync API.
  final String transformSchema;

  /// The auth type that will be used by default.
  final DefaultAuthType defaultAuthType;

  /// Additional methods of authenticating API requests.
  final List<AdditionalAuthTypes>? additionalAuthTypes;

  /// Defines a strategy for resolving API write conflicts.
  final ConflictResolution? conflictResolution;

  Map<String, dynamic> toJson() => {
        'serviceName': serviceName,
        'apiName': apiName,
        'transformSchema': transformSchema,
        'defaultAuthType': defaultAuthType,
        if (additionalAuthTypes != null)
          'additionalAuthTypes': additionalAuthTypes,
        if (conflictResolution != null)
          'conflictResolution': conflictResolution,
      };
}

class DefaultResolutionStrategyType {
  const DefaultResolutionStrategyType._(this._value);

  final String _value;

  /// `AUTOMERGE`
  static const $automerge = DefaultResolutionStrategyType._('AUTOMERGE');

  /// `NONE`
  static const $none = DefaultResolutionStrategyType._('NONE');

  /// `OPTIMISTIC_CONCURRENCY`
  static const $optimisticConcurrency =
      DefaultResolutionStrategyType._('OPTIMISTIC_CONCURRENCY');

  /// `LAMBDA`
  static const $lambda = DefaultResolutionStrategyType._('LAMBDA');

  static const List<DefaultResolutionStrategyType> values = [
    $automerge,
    $none,
    $optimisticConcurrency,
    $lambda
  ];

  String toJson() => _value;
}

class ResolverType {
  const ResolverType._(this._value);

  final String _value;

  /// `NEW`
  static const $new = ResolverType._('NEW');

  /// `EXISTING`
  static const $existing = ResolverType._('EXISTING');

  static const List<ResolverType> values = [$new, $existing];

  String toJson() => _value;
}

/// The lambda function used to resolve conflicts.
class Resolver {
  Resolver({required this.type, this.name, this.region, this.arn});

  final ResolverType type;

  /// The name of the lambda function (this must be a lambda function that exists in the Amplify project).
  final String? name;

  /// The lambda function region.
  final String? region;

  /// A lambda function ARN. This could be an ARN outside of the Amplify project but in that case extra care must be taken to ensure the AppSync API has access to the Lambda.
  final String? arn;

  Map<String, dynamic> toJson() => {
        'type': type,
        if (name != null) 'name': name,
        if (region != null) 'region': region,
        if (arn != null) 'arn': arn,
      };
}

/// Defines a new lambda conflict resolver. Using this resolver type will create a new lambda function with boilerplate resolver logic.
class NewLambdaConflictResolverType implements ResolverType {
  const NewLambdaConflictResolverType._(this._value);

  final String _value;

  /// `NEW`
  static const $new = NewLambdaConflictResolverType._('NEW');

  static const List<NewLambdaConflictResolverType> values = [$new];

  String toJson() => _value;
}

/// Defines a new lambda conflict resolver. Using this resolver type will create a new lambda function with boilerplate resolver logic.
class NewLambdaConflictResolver implements Resolver {
  const NewLambdaConflictResolver();

  final NewLambdaConflictResolverType type = NewLambdaConflictResolverType.$new;

  @override
  String? get name => null;
  @override
  String? get region => null;
  @override
  String? get arn => null;
  Map<String, dynamic> toJson() => {
        'type': type,
      };
}

/// Defines an lambda conflict resolver that uses an existing lambda function.
class ExistingLambdaConflictResolverType implements ResolverType {
  const ExistingLambdaConflictResolverType._(this._value);

  final String _value;

  /// `EXISTING`
  static const $existing = ExistingLambdaConflictResolverType._('EXISTING');

  static const List<ExistingLambdaConflictResolverType> values = [$existing];

  String toJson() => _value;
}

/// Defines an lambda conflict resolver that uses an existing lambda function.
class ExistingLambdaConflictResolver implements Resolver {
  const ExistingLambdaConflictResolver(
      {required this.name, this.region, this.arn});

  final ExistingLambdaConflictResolverType type =
      ExistingLambdaConflictResolverType.$existing;

  /// The name of the lambda function (this must be a lambda function that exists in the Amplify project).
  final String name;

  /// The lambda function region.
  final String? region;

  /// A lambda function ARN. This could be an ARN outside of the Amplify project but in that case extra care must be taken to ensure the AppSync API has access to the Lambda.
  final String? arn;

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        if (region != null) 'region': region,
        if (arn != null) 'arn': arn,
      };
}

/// The strategy that will be used for all models by default.
class DefaultResolutionStrategy {
  DefaultResolutionStrategy({required this.type, this.resolver});

  final DefaultResolutionStrategyType type;

  /// The lambda function used to resolve conflicts.
  final Resolver? resolver;

  Map<String, dynamic> toJson() => {
        'type': type,
        if (resolver != null) 'resolver': resolver,
      };
}

/// Resolution strategies provided by AppSync. See https://docs.aws.amazon.com/appsync/latest/devguide/conflict-detection-and-sync.html for details.
class PredefinedResolutionStrategyType
    implements DefaultResolutionStrategyType {
  const PredefinedResolutionStrategyType._(this._value);

  final String _value;

  /// `AUTOMERGE`
  static const $automerge = PredefinedResolutionStrategyType._('AUTOMERGE');

  /// `NONE`
  static const $none = PredefinedResolutionStrategyType._('NONE');

  /// `OPTIMISTIC_CONCURRENCY`
  static const $optimisticConcurrency =
      PredefinedResolutionStrategyType._('OPTIMISTIC_CONCURRENCY');

  static const List<PredefinedResolutionStrategyType> values = [
    $automerge,
    $none,
    $optimisticConcurrency
  ];

  String toJson() => _value;
}

/// Resolution strategies provided by AppSync. See https://docs.aws.amazon.com/appsync/latest/devguide/conflict-detection-and-sync.html for details.
class PredefinedResolutionStrategy implements DefaultResolutionStrategy {
  const PredefinedResolutionStrategy({required this.type});

  final PredefinedResolutionStrategyType type;

  @override
  Resolver? get resolver => null;
  Map<String, dynamic> toJson() => {
        'type': type,
      };
}

/// Defines a strategy for resolving API write conflicts.
class ConflictResolution {
  const ConflictResolution(
      {this.defaultResolutionStrategy, this.perModelResolutionStrategy});

  /// The strategy that will be used for all models by default.
  final DefaultResolutionStrategy? defaultResolutionStrategy;

  /// Strategies that will be used for individual models.
  final List<PerModelResolutionstrategy>? perModelResolutionStrategy;

  Map<String, dynamic> toJson() => {
        if (defaultResolutionStrategy != null)
          'defaultResolutionStrategy': defaultResolutionStrategy,
        if (perModelResolutionStrategy != null)
          'perModelResolutionStrategy': perModelResolutionStrategy,
      };
}

class ResolutionStrategyType {
  const ResolutionStrategyType._(this._value);

  final String _value;

  /// `AUTOMERGE`
  static const $automerge = ResolutionStrategyType._('AUTOMERGE');

  /// `NONE`
  static const $none = ResolutionStrategyType._('NONE');

  /// `OPTIMISTIC_CONCURRENCY`
  static const $optimisticConcurrency =
      ResolutionStrategyType._('OPTIMISTIC_CONCURRENCY');

  /// `LAMBDA`
  static const $lambda = ResolutionStrategyType._('LAMBDA');

  static const List<ResolutionStrategyType> values = [
    $automerge,
    $none,
    $optimisticConcurrency,
    $lambda
  ];

  String toJson() => _value;
}

/// The resolution strategy for the model.
class ResolutionStrategy {
  ResolutionStrategy({required this.type, this.resolver});

  final ResolutionStrategyType type;

  /// The lambda function used to resolve conflicts.
  final Resolver? resolver;

  Map<String, dynamic> toJson() => {
        'type': type,
        if (resolver != null) 'resolver': resolver,
      };
}

/// Resolution strategy using a custom lambda function.
class LambdaResolutionStrategyType
    implements DefaultResolutionStrategyType, ResolutionStrategyType {
  const LambdaResolutionStrategyType._(this._value);

  final String _value;

  /// `LAMBDA`
  static const $lambda = LambdaResolutionStrategyType._('LAMBDA');

  static const List<LambdaResolutionStrategyType> values = [$lambda];

  String toJson() => _value;
}

/// Resolution strategy using a custom lambda function.
class LambdaResolutionStrategy
    implements DefaultResolutionStrategy, ResolutionStrategy {
  const LambdaResolutionStrategy({required this.resolver});

  final LambdaResolutionStrategyType type =
      LambdaResolutionStrategyType.$lambda;

  /// The lambda function used to resolve conflicts.
  final Resolver resolver;

  Map<String, dynamic> toJson() => {
        'type': type,
        'resolver': resolver,
      };
}

/// Defines a resolution strategy for a single model.
class PerModelResolutionstrategy {
  const PerModelResolutionstrategy(
      {required this.resolutionStrategy, required this.entityName});

  /// The resolution strategy for the model.
  final ResolutionStrategy resolutionStrategy;

  /// The model name.
  final String entityName;

  Map<String, dynamic> toJson() => {
        'resolutionStrategy': resolutionStrategy,
        'entityName': entityName,
      };
}

/// Defines the json object expected by `amplify add api --headless`
class AddApiRequestVersion {
  const AddApiRequestVersion._(this._value);

  final double _value;

  /// `1`
  static const $1 = AddApiRequestVersion._(1);

  static const List<AddApiRequestVersion> values = [$1];

  double toJson() => _value;
}

/// Defines the json object expected by `amplify add api --headless`
class AddApiRequest {
  const AddApiRequest({this.appSyncServiceConfiguration});

  /// The schema version.
  final AddApiRequestVersion version = AddApiRequestVersion.$1;

  /// Configuration exposed by AppSync. Currently this is the only API type supported by Amplify headless mode.
  final AppSyncServiceConfiguration? appSyncServiceConfiguration;

  Map<String, dynamic> toJson() => {
        'version': version,
        if (appSyncServiceConfiguration != null)
          'appSyncServiceConfiguration': appSyncServiceConfiguration,
      };
}
