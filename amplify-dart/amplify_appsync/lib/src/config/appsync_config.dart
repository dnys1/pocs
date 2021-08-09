import 'package:amplify_common/amplify_common.dart';

class AppSyncConfig {
  /// The GraphQL URI
  final Uri graphQLUri;

  /// The WebSocket URI
  final Uri realTimeGraphQLUri;

  /// The authorization mode
  final ApiAuthorizationType authMode;

  /// The API key, if [authMode] is [ApiAuthorizationMode.API_KEY]
  final String? apiKey;

  const AppSyncConfig({
    required this.graphQLUri,
    required this.realTimeGraphQLUri,
    required this.authMode,
    this.apiKey,
  });

  factory AppSyncConfig.fromAmplifyConfig(
    AmplifyConfig amplifyConfig, {
    String? apiName,
  }) {
    final apiPlugins = amplifyConfig.api!.plugins['awsAPIPlugin']!;
    final ApiPluginConfig appSyncPlugin =
        apiName == null ? apiPlugins.values.single : apiPlugins[apiName]!;
    final Uri graphQLUri = Uri.parse(appSyncPlugin.endpoint);
    final String realTimeGraphQLUrl = appSyncPlugin.endpoint
        .replaceFirst('appsync-api', 'appsync-realtime-api');
    final Uri realTimeGraphQLUri =
        Uri.parse(realTimeGraphQLUrl).replace(scheme: 'wss');

    return AppSyncConfig(
      graphQLUri: graphQLUri,
      realTimeGraphQLUri: realTimeGraphQLUri,
      authMode: appSyncPlugin.authorizationType,
      apiKey: appSyncPlugin.apiKey,
    );
  }
}
