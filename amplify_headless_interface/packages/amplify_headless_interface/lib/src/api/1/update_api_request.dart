import 'dart:convert' show jsonEncode;
import 'dart:io' show Process;

import 'package:json_schema2/json_schema2.dart'
    show ValidationError, JsonSchema;

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
  const Resolver({required this.type, this.name, this.region, this.arn});

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
  const DefaultResolutionStrategy({required this.type, this.resolver});

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
  const ResolutionStrategy({required this.type, this.resolver});

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

class UpdateApiRequestVersion {
  const UpdateApiRequestVersion._(this._value);

  final double _value;

  /// `1`
  static const $1 = UpdateApiRequestVersion._(1);

  static const List<UpdateApiRequestVersion> values = [$1];

  double toJson() => _value;
}

class ServiceModificationServiceName {
  const ServiceModificationServiceName._(this._value);

  final String _value;

  /// `AppSync`
  static const $appSync = ServiceModificationServiceName._('AppSync');

  static const List<ServiceModificationServiceName> values = [$appSync];

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
  const DefaultAuthType(
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
  const AdditionalAuthTypes(
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

/// Service modifications that will be interpreted by Amplify.
class ServiceModification {
  const ServiceModification(
      {this.transformSchema,
      this.defaultAuthType,
      this.additionalAuthTypes,
      this.conflictResolution});

  /// The service name of the resource provider.
  final ServiceModificationServiceName serviceName =
      ServiceModificationServiceName.$appSync;

  /// The annotated GraphQL schema that defines the AppSync API.
  final String? transformSchema;

  /// The auth type that will be used by default.
  final DefaultAuthType? defaultAuthType;

  /// Additional methods of authenticating API requests.
  final List<AdditionalAuthTypes>? additionalAuthTypes;

  /// Defines a strategy for resolving API write conflicts.
  final ConflictResolution? conflictResolution;

  Map<String, dynamic> toJson() => {
        'serviceName': serviceName,
        if (transformSchema != null) 'transformSchema': transformSchema,
        if (defaultAuthType != null) 'defaultAuthType': defaultAuthType,
        if (additionalAuthTypes != null)
          'additionalAuthTypes': additionalAuthTypes,
        if (conflictResolution != null)
          'conflictResolution': conflictResolution,
      };
}

class UpdateApiRequestAppSyncServiceConfigurationServiceName
    implements ServiceModificationServiceName {
  const UpdateApiRequestAppSyncServiceConfigurationServiceName._(this._value);

  final String _value;

  /// `AppSync`
  static const $appSync =
      UpdateApiRequestAppSyncServiceConfigurationServiceName._('AppSync');

  static const List<UpdateApiRequestAppSyncServiceConfigurationServiceName>
      values = [$appSync];

  String toJson() => _value;
}

class UpdateApiRequestAppSyncServiceConfiguration
    implements ServiceModification {
  const UpdateApiRequestAppSyncServiceConfiguration();

  /// The service name of the resource provider.
  final UpdateApiRequestAppSyncServiceConfigurationServiceName serviceName =
      UpdateApiRequestAppSyncServiceConfigurationServiceName.$appSync;

  @override
  String? get transformSchema => null;
  @override
  DefaultAuthType? get defaultAuthType => null;
  @override
  List<AdditionalAuthTypes>? get additionalAuthTypes => null;
  @override
  ConflictResolution? get conflictResolution => null;
  Map<String, dynamic> toJson() => {
        'serviceName': serviceName,
      };
}

class UpdateApiRequestPickAppSyncServiceConfiguration
    implements ServiceModification {
  const UpdateApiRequestPickAppSyncServiceConfiguration(
      {this.transformSchema,
      this.defaultAuthType,
      this.additionalAuthTypes,
      this.conflictResolution});

  /// The annotated GraphQL schema that defines the AppSync API.
  final String? transformSchema;

  /// The auth type that will be used by default.
  final DefaultAuthType? defaultAuthType;

  /// Additional methods of authenticating API requests.
  final List<AdditionalAuthTypes>? additionalAuthTypes;

  /// Defines a strategy for resolving API write conflicts.
  final ConflictResolution? conflictResolution;

  @override
  ServiceModificationServiceName get serviceName =>
      ServiceModificationServiceName.$appSync;
  Map<String, dynamic> toJson() => {
        if (transformSchema != null) 'transformSchema': transformSchema,
        if (defaultAuthType != null) 'defaultAuthType': defaultAuthType,
        if (additionalAuthTypes != null)
          'additionalAuthTypes': additionalAuthTypes,
        if (conflictResolution != null)
          'conflictResolution': conflictResolution,
      };
}

class UpdateApiRequest {
  const UpdateApiRequest({required this.serviceModification});

  /// The schema version.
  final UpdateApiRequestVersion version = UpdateApiRequestVersion.$1;

  /// Service modifications that will be interpreted by Amplify.
  final ServiceModification serviceModification;

  static const Map<String, dynamic> _schema = {
    "type": "object",
    "properties": {
      "version": {
        "description": "The schema version.",
        "type": "number",
        "enum": [1]
      },
      "serviceModification": {
        "description":
            "Service modifications that will be interpreted by Amplify.",
        "allOf": [
          {
            "\$ref":
                "#/definitions/Pick<AppSyncServiceConfiguration,\"serviceName\">"
          },
          {
            "\$ref":
                "#/definitions/Partial<Pick<AppSyncServiceConfiguration,\"transformSchema\"|\"defaultAuthType\"|\"additionalAuthTypes\"|\"conflictResolution\">>"
          }
        ]
      }
    },
    "required": ["serviceModification", "version"],
    "definitions": {
      "Pick<AppSyncServiceConfiguration,\"serviceName\">": {
        "type": "object",
        "properties": {
          "serviceName": {
            "description": "The service name of the resource provider.",
            "type": "string",
            "enum": ["AppSync"]
          }
        },
        "required": ["serviceName"]
      },
      "Partial<Pick<AppSyncServiceConfiguration,\"transformSchema\"|\"defaultAuthType\"|\"additionalAuthTypes\"|\"conflictResolution\">>":
          {
        "type": "object",
        "properties": {
          "transformSchema": {
            "description":
                "The annotated GraphQL schema that defines the AppSync API.",
            "type": "string"
          },
          "defaultAuthType": {
            "description": "The auth type that will be used by default.",
            "anyOf": [
              {"\$ref": "#/definitions/AppSyncAPIKeyAuthType"},
              {"\$ref": "#/definitions/AppSyncAWSIAMAuthType"},
              {"\$ref": "#/definitions/AppSyncCognitoUserPoolsAuthType"},
              {"\$ref": "#/definitions/AppSyncOpenIDConnectAuthType"}
            ]
          },
          "additionalAuthTypes": {
            "description": "Additional methods of authenticating API requests.",
            "type": "array",
            "items": {
              "anyOf": [
                {"\$ref": "#/definitions/AppSyncAPIKeyAuthType"},
                {"\$ref": "#/definitions/AppSyncAWSIAMAuthType"},
                {"\$ref": "#/definitions/AppSyncCognitoUserPoolsAuthType"},
                {"\$ref": "#/definitions/AppSyncOpenIDConnectAuthType"}
              ]
            }
          },
          "conflictResolution": {
            "\$ref": "#/definitions/ConflictResolution",
            "description": "The strategy for resolving API write conflicts."
          }
        }
      },
      "AppSyncAPIKeyAuthType": {
        "description":
            "Specifies that the AppSync API should be secured using an API key.",
        "type": "object",
        "properties": {
          "mode": {
            "type": "string",
            "enum": ["API_KEY"]
          },
          "expirationTime": {"type": "number"},
          "keyDescription": {"type": "string"}
        },
        "required": ["mode"]
      },
      "AppSyncAWSIAMAuthType": {
        "description":
            "Specifies that the AppSync API should be secured using AWS IAM.",
        "type": "object",
        "properties": {
          "mode": {
            "type": "string",
            "enum": ["AWS_IAM"]
          }
        },
        "required": ["mode"]
      },
      "AppSyncCognitoUserPoolsAuthType": {
        "description":
            "Specifies that the AppSync API should be secured using Cognito.",
        "type": "object",
        "properties": {
          "mode": {
            "type": "string",
            "enum": ["AMAZON_COGNITO_USER_POOLS"]
          },
          "cognitoUserPoolId": {
            "description":
                "The user pool that will be used to authenticate requests.",
            "type": "string"
          }
        },
        "required": ["mode"]
      },
      "AppSyncOpenIDConnectAuthType": {
        "description":
            "Specifies that the AppSync API should be secured using OpenID.",
        "type": "object",
        "properties": {
          "mode": {
            "type": "string",
            "enum": ["OPENID_CONNECT"]
          },
          "openIDProviderName": {"type": "string"},
          "openIDIssuerURL": {"type": "string"},
          "openIDClientID": {"type": "string"},
          "openIDAuthTTL": {"type": "string"},
          "openIDIatTTL": {"type": "string"}
        },
        "required": [
          "mode",
          "openIDClientID",
          "openIDIssuerURL",
          "openIDProviderName"
        ]
      },
      "ConflictResolution": {
        "description": "Defines a strategy for resolving API write conflicts.",
        "type": "object",
        "properties": {
          "defaultResolutionStrategy": {
            "description":
                "The strategy that will be used for all models by default.",
            "anyOf": [
              {"\$ref": "#/definitions/PredefinedResolutionStrategy"},
              {"\$ref": "#/definitions/LambdaResolutionStrategy"}
            ]
          },
          "perModelResolutionStrategy": {
            "description":
                "Strategies that will be used for individual models.",
            "type": "array",
            "items": {"\$ref": "#/definitions/PerModelResolutionstrategy"}
          }
        }
      },
      "PredefinedResolutionStrategy": {
        "description":
            "Resolution strategies provided by AppSync. See https://docs.aws.amazon.com/appsync/latest/devguide/conflict-detection-and-sync.html for details.",
        "type": "object",
        "properties": {
          "type": {
            "enum": ["AUTOMERGE", "NONE", "OPTIMISTIC_CONCURRENCY"],
            "type": "string"
          }
        },
        "required": ["type"]
      },
      "LambdaResolutionStrategy": {
        "description": "Resolution strategy using a custom lambda function.",
        "type": "object",
        "properties": {
          "type": {
            "type": "string",
            "enum": ["LAMBDA"]
          },
          "resolver": {
            "description": "The lambda function used to resolve conflicts.",
            "anyOf": [
              {"\$ref": "#/definitions/NewLambdaConflictResolver"},
              {"\$ref": "#/definitions/ExistingLambdaConflictResolver"}
            ]
          }
        },
        "required": ["resolver", "type"]
      },
      "NewLambdaConflictResolver": {
        "description":
            "Defines a new lambda conflict resolver. Using this resolver type will create a new lambda function with boilerplate resolver logic.",
        "type": "object",
        "properties": {
          "type": {
            "type": "string",
            "enum": ["NEW"]
          }
        },
        "required": ["type"]
      },
      "ExistingLambdaConflictResolver": {
        "description":
            "Defines an lambda conflict resolver that uses an existing lambda function.",
        "type": "object",
        "properties": {
          "type": {
            "type": "string",
            "enum": ["EXISTING"]
          },
          "name": {
            "description":
                "The name of the lambda function (this must be a lambda function that exists in the Amplify project).",
            "type": "string"
          },
          "region": {
            "description": "The lambda function region.",
            "type": "string"
          },
          "arn": {
            "description":
                "A lambda function ARN. This could be an ARN outside of the Amplify project but in that case extra care must be taken to ensure the AppSync API has access to the Lambda.",
            "type": "string"
          }
        },
        "required": ["name", "type"]
      },
      "PerModelResolutionstrategy": {
        "description": "Defines a resolution strategy for a single model.",
        "type": "object",
        "properties": {
          "resolutionStrategy": {
            "description": "The resolution strategy for the model.",
            "anyOf": [
              {"\$ref": "#/definitions/PredefinedResolutionStrategy"},
              {"\$ref": "#/definitions/LambdaResolutionStrategy"}
            ]
          },
          "entityName": {"description": "The model name.", "type": "string"}
        },
        "required": ["entityName", "resolutionStrategy"]
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
        'api',
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
