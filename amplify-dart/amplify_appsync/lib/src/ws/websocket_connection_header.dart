import 'dart:convert';

import 'package:amplify_appsync/src/config/appsync_config.dart';
import 'package:amplify_common/amplify_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:equatable/equatable.dart';

class WebSocketConnectionHeader with EquatableMixin {
  final String host;
  final ApiAuthorization authorization;

  const WebSocketConnectionHeader({
    required this.host,
    required this.authorization,
  });

  factory WebSocketConnectionHeader.fromConfig(AppSyncConfig config) {
    return WebSocketConnectionHeader(
      host: config.graphQLUri.host,
      authorization: config.authorization,
    );
  }

  @override
  List<Object?> get props => [host, authorization];

  String encode() => base64.encode(utf8.encode(json.encode(this)));

  Map<String, dynamic> toJson() => authorization.connectionHeaders(
        AWSHttpRequest(
          method: HttpMethod.post,
          host: host,
          path: '/graphql/connect',
          headers: {
            AWSHeaders.accept.toLowerCase():
                'application/json, test/javascript',
            AWSHeaders.contentEncoding.toLowerCase(): 'amz-1.0',
            AWSHeaders.contentType.toLowerCase():
                'application/json; charset=UTF-8',
          },
          body: '{}'.codeUnits,
        ),
      );
}
