import 'dart:convert';

import 'package:amplify_appsync/src/graphql/request.dart';
import 'package:amplify_appsync/src/ws/websocket_connection_header.dart';
import 'package:amplify_common/amplify_common.dart';
import 'package:uuid/uuid.dart';

class MessageType {
  final String type;

  const MessageType._(this.type);

  factory MessageType.fromJson(dynamic json) =>
      values.firstWhere((el) => json == el.type);

  static const List<MessageType> values = [
    connectionInit,
    connectionAck,
    connectionError,
    start,
    startAck,
    error,
    data,
    stop,
    keepAlive,
  ];

  static const connectionInit = MessageType._('connection_init');
  static const connectionAck = MessageType._('connection_ack');
  static const connectionError = MessageType._('connection_error');
  static const error = MessageType._('error');
  static const start = MessageType._('start');
  static const startAck = MessageType._('start_ack');
  static const data = MessageType._('data');
  static const stop = MessageType._('stop');
  static const keepAlive = MessageType._('ka');

  @override
  String toString() => type;
}

typedef WebSocketConnectionPayloadFactory = WebSocketMessagePayload Function(
    Map);

abstract class WebSocketMessagePayload {
  const WebSocketMessagePayload();

  static const Map<MessageType, WebSocketConnectionPayloadFactory> _factories =
      {
    MessageType.connectionAck: ConnectionAckMessagePayload.fromJson,
    MessageType.data: SubscriptionDataPayload.fromJson,
    MessageType.error: ErrorPayload.fromJson,
  };

  static WebSocketMessagePayload? fromJson(Map json, MessageType type) {
    return _factories[type]?.call(json);
  }

  Map<String, dynamic> toJson();
}

class ConnectionAckMessagePayload extends WebSocketMessagePayload {
  final int connectionTimeoutMs;

  const ConnectionAckMessagePayload(this.connectionTimeoutMs);

  static ConnectionAckMessagePayload fromJson(Map json) {
    final connectionTimeoutMs = json['connectionTimeoutMs'] as int;
    return ConnectionAckMessagePayload(connectionTimeoutMs);
  }

  @override
  Map<String, dynamic> toJson() => {
        'connectionTimeoutMs': connectionTimeoutMs,
      };
}

class SubscriptionRegistrationPayload extends WebSocketMessagePayload {
  final GraphQLRequest request;
  final WebSocketConnectionHeader authorization;

  const SubscriptionRegistrationPayload({
    required this.request,
    required this.authorization,
  });

  @override
  Map<String, dynamic> toJson() => {
        'data': jsonEncode(request.toJson()),
        'extensions': {
          'authorization': authorization.toJson(),
        },
      };
}

class SubscriptionDataPayload extends WebSocketMessagePayload {
  final Map<String, dynamic>? data;

  const SubscriptionDataPayload(this.data);

  static SubscriptionDataPayload fromJson(Map json) {
    final data = json['data'] as Map;
    return SubscriptionDataPayload(data.cast());
  }

  @override
  Map<String, dynamic> toJson() => {
        'data': data,
      };
}

class ErrorPayload extends WebSocketMessagePayload {
  final List<Map> errors;

  const ErrorPayload(this.errors);

  static ErrorPayload fromJson(Map json) {
    final errors = json['errors'] as List?;
    return ErrorPayload(errors?.cast() ?? []);
  }

  @override
  Map<String, dynamic> toJson() => {
        'errors': errors,
      };
}

// How to handle deserializing an abstract type?
// How to handle associated enums (enums with underlying values)

class WebSocketMessage {
  final String? id;
  final MessageType messageType;
  final WebSocketMessagePayload? payload;

  WebSocketMessage({
    String? id,
    required this.messageType,
    this.payload,
  }) : id = id ?? const Uuid().v4();

  WebSocketMessage._({
    this.id,
    required this.messageType,
    this.payload,
  });

  factory WebSocketMessage.fromJson(Map json) {
    final id = json['id'] as String?;
    final type = json['type'] as String;
    final messageType = MessageType.fromJson(type);
    final payloadMap = json['payload'] as Map?;
    final payload = payloadMap == null
        ? null
        : WebSocketMessagePayload.fromJson(
            payloadMap,
            messageType,
          );
    return WebSocketMessage._(
      id: id,
      messageType: messageType,
      payload: payload,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'type': messageType.type,
        if (payload != null) 'payload': payload!.toJson(),
      };

  @override
  String toString() {
    return prettyPrintJson(this);
  }
}
