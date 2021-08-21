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
    final apiPlugins = amplifyConfig.api!.plugins['awsAPIPlugin']!;
    final ApiPluginConfig appSyncPlugin =
        apiName == null ? apiPlugins.values.single : apiPlugins[apiName]!;
    final authType = appSyncPlugin.authorizationType;
    if (authType == ApiAuthorizationType.apiKey) {
      ArgumentError.checkNotNull(appSyncPlugin.apiKey);
      authorization ??= ApiKeyAuthorization(appSyncPlugin.apiKey!);
    } else {
      ArgumentError.checkNotNull(
        authorization,
        'Authorization required for all but API_KEY',
      );
    }
    final Uri graphQLUri = Uri.parse(appSyncPlugin.endpoint);
    final String realTimeGraphQLUrl = appSyncPlugin.endpoint
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
