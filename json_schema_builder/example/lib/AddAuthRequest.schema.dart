/// The auth type that will be used by default.
class DefaultAuthType {
  DefaultAuthType(
      {this.appSyncAPIKeyAuthType,
      this.appSyncAWSIAMAuthType,
      this.appSyncCognitoUserPoolsAuthType,
      this.appSyncOpenIDConnectAuthType});

  /// Specifies that the AppSync API should be secured using an API key.
  final AppSyncAPIKeyAuthType? appSyncAPIKeyAuthType;

  /// Specifies that the AppSync API should be secured using AWS IAM.
  final AppSyncAWSIAMAuthType? appSyncAWSIAMAuthType;

  /// Specifies that the AppSync API should be secured using Cognito.
  final AppSyncCognitoUserPoolsAuthType? appSyncCognitoUserPoolsAuthType;

  /// Specifies that the AppSync API should be secured using OpenID.
  final AppSyncOpenIDConnectAuthType? appSyncOpenIDConnectAuthType;
}

class Items {
  Items(
      {this.appSyncAPIKeyAuthType,
      this.appSyncAWSIAMAuthType,
      this.appSyncCognitoUserPoolsAuthType,
      this.appSyncOpenIDConnectAuthType});

  /// Specifies that the AppSync API should be secured using an API key.
  final AppSyncAPIKeyAuthType? appSyncAPIKeyAuthType;

  /// Specifies that the AppSync API should be secured using AWS IAM.
  final AppSyncAWSIAMAuthType? appSyncAWSIAMAuthType;

  /// Specifies that the AppSync API should be secured using Cognito.
  final AppSyncCognitoUserPoolsAuthType? appSyncCognitoUserPoolsAuthType;

  /// Specifies that the AppSync API should be secured using OpenID.
  final AppSyncOpenIDConnectAuthType? appSyncOpenIDConnectAuthType;
}

/// Configuration exposed by AppSync. Currently this is the only API type supported by Amplify headless mode.
class AppSyncServiceConfiguration {
  const AppSyncServiceConfiguration(
      {required this.serviceName,
      required this.apiName,
      required this.transformSchema,
      required this.defaultAuthType,
      this.additionalAuthTypes,
      this.conflictResolution});

  /// The service name of the resource provider.
  final String serviceName;

  /// The name of the API that will be created.
  final String apiName;

  /// The annotated GraphQL schema that defines the AppSync API.
  final String transformSchema;

  /// The auth type that will be used by default.
  final DefaultAuthType defaultAuthType;

  /// Additional methods of authenticating API requests.
  final List<Items>? additionalAuthTypes;

  /// Defines a strategy for resolving API write conflicts.
  final ConflictResolution? conflictResolution;
}

/// Specifies that the AppSync API should be secured using an API key.
class AppSyncAPIKeyAuthType {
  const AppSyncAPIKeyAuthType(
      {required this.mode, this.expirationTime, this.keyDescription});

  final String mode;

  final double? expirationTime;

  final String? keyDescription;
}

/// Specifies that the AppSync API should be secured using AWS IAM.
class AppSyncAWSIAMAuthType {
  const AppSyncAWSIAMAuthType({required this.mode});

  final String mode;
}

/// Specifies that the AppSync API should be secured using Cognito.
class AppSyncCognitoUserPoolsAuthType {
  const AppSyncCognitoUserPoolsAuthType(
      {required this.mode, this.cognitoUserPoolId});

  final String mode;

  /// The user pool that will be used to authenticate requests.
  final String? cognitoUserPoolId;
}

/// Specifies that the AppSync API should be secured using OpenID.
class AppSyncOpenIDConnectAuthType {
  const AppSyncOpenIDConnectAuthType(
      {required this.mode,
      required this.openIDProviderName,
      required this.openIDIssuerURL,
      required this.openIDClientID,
      this.openIDAuthTTL,
      this.openIDIatTTL});

  final String mode;

  final String openIDProviderName;

  final String openIDIssuerURL;

  final String openIDClientID;

  final String? openIDAuthTTL;

  final String? openIDIatTTL;
}

/// The strategy that will be used for all models by default.
class DefaultResolutionStrategy {
  DefaultResolutionStrategy(
      {this.predefinedResolutionStrategy, this.lambdaResolutionStrategy});

  /// Resolution strategies provided by AppSync. See https://docs.aws.amazon.com/appsync/latest/devguide/conflict-detection-and-sync.html for details.
  final PredefinedResolutionStrategy? predefinedResolutionStrategy;

  /// Resolution strategy using a custom lambda function.
  final LambdaResolutionStrategy? lambdaResolutionStrategy;
}

/// Defines a strategy for resolving API write conflicts.
class ConflictResolution {
  const ConflictResolution(
      {required this.defaultResolutionStrategy,
      this.perModelResolutionStrategy});

  /// The strategy that will be used for all models by default.
  final DefaultResolutionStrategy defaultResolutionStrategy;

  /// Strategies that will be used for individual models.
  final List<PerModelResolutionstrategy>? perModelResolutionStrategy;
}

/// Resolution strategies provided by AppSync. See https://docs.aws.amazon.com/appsync/latest/devguide/conflict-detection-and-sync.html for details.
class PredefinedResolutionStrategy {
  const PredefinedResolutionStrategy({required this.type});

  final String type;
}

/// The lambda function used to resolve conflicts.
class Resolver {
  Resolver(
      {this.newLambdaConflictResolver, this.existingLambdaConflictResolver});

  /// Defines a new lambda conflict resolver. Using this resolver type will create a new lambda function with boilerplate resolver logic.
  final NewLambdaConflictResolver? newLambdaConflictResolver;

  /// Defines an lambda conflict resolver that uses an existing lambda function.
  final ExistingLambdaConflictResolver? existingLambdaConflictResolver;
}

/// Resolution strategy using a custom lambda function.
class LambdaResolutionStrategy {
  const LambdaResolutionStrategy({required this.type, required this.resolver});

  final String type;

  /// The lambda function used to resolve conflicts.
  final Resolver resolver;
}

/// Defines a new lambda conflict resolver. Using this resolver type will create a new lambda function with boilerplate resolver logic.
class NewLambdaConflictResolver {
  const NewLambdaConflictResolver({required this.type});

  final String type;
}

/// Defines an lambda conflict resolver that uses an existing lambda function.
class ExistingLambdaConflictResolver {
  const ExistingLambdaConflictResolver(
      {required this.type, required this.name, this.region, this.arn});

  final String type;

  /// The name of the lambda function (this must be a lambda function that exists in the Amplify project).
  final String name;

  /// The lambda function region.
  final String? region;

  /// A lambda function ARN. This could be an ARN outside of the Amplify project but in that case extra care must be taken to ensure the AppSync API has access to the Lambda.
  final String? arn;
}

/// The resolution strategy for the model.
class ResolutionStrategy {
  ResolutionStrategy(
      {this.predefinedResolutionStrategy, this.lambdaResolutionStrategy});

  /// Resolution strategies provided by AppSync. See https://docs.aws.amazon.com/appsync/latest/devguide/conflict-detection-and-sync.html for details.
  final PredefinedResolutionStrategy? predefinedResolutionStrategy;

  /// Resolution strategy using a custom lambda function.
  final LambdaResolutionStrategy? lambdaResolutionStrategy;
}

/// Defines a resolution strategy for a single model.
class PerModelResolutionstrategy {
  const PerModelResolutionstrategy(
      {required this.resolutionStrategy, required this.entityName});

  /// The resolution strategy for the model.
  final ResolutionStrategy resolutionStrategy;

  /// The model name.
  final String entityName;
}

/// Defines the json object expected by `amplify add api --headless`
class AddAuthRequestSchema {
  const AddAuthRequestSchema(
      {required this.version, this.appSyncServiceConfiguration});

  /// The schema version.
  final double version;

  /// Configuration exposed by AppSync. Currently this is the only API type supported by Amplify headless mode.
  final AppSyncServiceConfiguration? appSyncServiceConfiguration;
}
