import 'package:amplify_common/amplify_common.dart';

class AppSyncConfig {
  /// The GraphQL URI
  final Uri graphQLUri;

  /// The WebSocket URI
  final Uri realTimeGraphQLUri;

  /// The endpoint authorization.
  final ApiAuthorization authorization;

  const AppSyncConfig({
    required this.graphQLUri,
    required this.realTimeGraphQLUri,
    required this.authorization,
  });

  factory AppSyncConfig.fromAmplifyConfig(
    AmplifyConfig amplifyConfig, {
    String? apiName,
    ApiAuthorization? authorization,
  }) {
    final appSyncPlugin = amplifyConfig.api!.appSyncPlugin!;
    final AppSyncApiConfig appSyncConfig =
        apiName == null ? appSyncPlugin.values.single : appSyncPlugin[apiName]!;
    final authType = appSyncConfig.authorizationType;
    if (authType == ApiAuthorizationType.apiKey) {
      ArgumentError.checkNotNull(appSyncConfig.apiKey);
      authorization ??= ApiKeyAuthorization(appSyncConfig.apiKey!);
    } else {
      ArgumentError.checkNotNull(
        authorization,
        'Authorization required for all but API_KEY',
      );
    }
    final Uri graphQLUri = Uri.parse(appSyncConfig.endpoint);
    final String realTimeGraphQLUrl = appSyncConfig.endpoint
        .replaceFirst('appsync-api', 'appsync-realtime-api');
    final Uri realTimeGraphQLUri =
        Uri.parse(realTimeGraphQLUrl).replace(scheme: 'wss');

    return AppSyncConfig(
      graphQLUri: graphQLUri,
      realTimeGraphQLUri: realTimeGraphQLUri,
      authorization: authorization!,
    );
  }
}
