import 'dart:convert';

import 'package:amplify_appsync/src/config/appsync_config.dart';
import 'package:equatable/equatable.dart';

class WebSocketConnectionHeader with EquatableMixin {
  final String host;
  final String? apiKey;

  const WebSocketConnectionHeader({required this.host, this.apiKey});

  factory WebSocketConnectionHeader.fromConfig(AppSyncConfig config) {
    return WebSocketConnectionHeader(
      host: config.graphQLUri.host,
      apiKey: config.apiKey,
    );
  }

  @override
  List<Object?> get props => [host, apiKey];

  String encode() => base64.encode(utf8.encode(json.encode(this)));

  Map<String, dynamic> toJson() => {
        'host': host,
        if (apiKey != null) 'x-api-key': apiKey,
      };
}
