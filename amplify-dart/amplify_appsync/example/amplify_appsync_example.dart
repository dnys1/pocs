import 'dart:convert';

import 'package:amplify_appsync/src/config/appsync_config.dart';
import 'package:amplify_appsync/src/graphql/request.dart';
import 'package:amplify_appsync/src/ws/websocket_connection.dart';
import 'package:amplify_common/amplify_common.dart';

import 'amplifyconfiguration.dart';

void main() async {
  final amplifyConfigMap = jsonDecode(amplifyconfig) as Map;
  final amplifyConfig = AmplifyConfig.fromJson(amplifyConfigMap);
  final appSyncConfig = AppSyncConfig.fromAmplifyConfig(amplifyConfig);
  final webSocketConnection = WebSocketConnection(appSyncConfig);
  await webSocketConnection.init();
  await webSocketConnection.subscribe(GraphQLRequest(
    '''
    subscription OnUpdateTodo {
      onUpdateTodo {
        id
        name
        description
      }
    }
    ''',
  ));
}
