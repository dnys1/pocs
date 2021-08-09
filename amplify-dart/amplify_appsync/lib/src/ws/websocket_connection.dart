import 'dart:async';
import 'dart:convert';

import 'package:amplify_appsync/src/config/appsync_config.dart';
import 'package:amplify_appsync/src/graphql/request.dart';
import 'package:amplify_appsync/src/ws/websocket_message.dart';
import 'package:amplify_appsync/src/ws/websocket_connection_header.dart';
import 'package:async/async.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'websocket_connection_payload.dart';

class WebSocketMessageStreamTransformer
    extends StreamTransformerBase<dynamic, WebSocketMessage> {
  const WebSocketMessageStreamTransformer();

  @override
  Stream<WebSocketMessage> bind(Stream stream) {
    return stream.map((dynamic data) {
      final json = jsonDecode(data as String) as Map;
      return WebSocketMessage.fromJson(json);
    });
  }
}

class WebSocketConnection {
  static const webSocketProtocols = ['graphql-ws'];

  late final WebSocketConnectionHeader _authorization;
  late final WebSocketChannel _channel;
  late final StreamSubscription<WebSocketMessage> _subscription;
  late final RestartableTimer _timeoutTimer;

  // Add connection error variable to throw in `init`.

  Future<void>? _initFuture;
  final Completer<void> _connectionReady = Completer<void>();

  /// Fires when the connection is ready to be listened to, i.e.
  /// after the first `connection_ack` message.
  Future<void> get ready => _connectionReady.future;

  final StreamController<WebSocketMessage> _messageController =
      StreamController<WebSocketMessage>.broadcast();

  /// Re-broadcast message stream.
  Stream<WebSocketMessage> get _messageStream => _messageController.stream;

  WebSocketConnection(AppSyncConfig config) {
    _authorization = WebSocketConnectionHeader.fromConfig(config);
    _connect(config);
  }

  /// Connects to the real time WebSocket.
  void _connect(AppSyncConfig config) {
    final payload = WebSocketConnectionPayload.fromConfig(config);

    final connectionUri = config.realTimeGraphQLUri.replace(queryParameters: {
      'header': _authorization.encode(),
      'payload': payload.encode(),
    });
    _channel = IOWebSocketChannel.connect(
      connectionUri,
      protocols: webSocketProtocols,
    );
    _subscription = _channel.stream
        .transform(const WebSocketMessageStreamTransformer())
        .listen(_onData);
  }

  void close() {
    _subscription.cancel();
    _channel.sink.close();
  }

  /// Initializes the connection.
  Future<void> init() {
    return _initFuture ??= _init();
  }

  Future<void> _init() async {
    if (_connectionReady.isCompleted) return;
    send(MessageType.connectionInit);
    return ready;
  }

  /// Subscribes to the given GraphQL request. Returns the subscription object,
  /// or throws an [Exception] if there's an error.
  Future<Stream<SubscriptionDataPayload>> subscribe(
      GraphQLRequest request) async {
    final subRegistration = WebSocketMessage(
      messageType: MessageType.start,
      payload: SubscriptionRegistrationPayload(
        request: request,
        authorization: _authorization,
      ),
    );
    final subscriptionId = subRegistration.id;
    _send(subRegistration);
    final subscription = _messageStream
        .where(
          (msg) =>
              msg.messageType == MessageType.data && msg.id == subscriptionId,
        )
        .map((msg) => msg.payload as SubscriptionDataPayload);
    await Future.any([
      _messageStream.firstWhere((msg) =>
          msg.messageType == MessageType.startAck && msg.id == subscriptionId),
      _messageStream
          .firstWhere((msg) =>
              msg.messageType == MessageType.error && msg.id == subscriptionId)
          .then((msg) => throw Exception(msg.toString())),
    ]);
    return subscription;
  }

  /// Sends a structured message over the WebSocket.
  void send(MessageType type, {WebSocketMessagePayload? payload}) {
    final message = WebSocketMessage(messageType: type, payload: payload);
    _send(message);
  }

  /// Sends a structured message over the WebSocket.
  void _send(WebSocketMessage message) {
    final msgJson = json.encode(message.toJson());
    print('Sent: $msgJson');
    _channel.sink.add(msgJson);
  }

  /// Times out the connection (usually if a keep alive has not been received in time).
  void _timeout() {
    print('Connection timeout');
    close();
  }

  /// Handles incoming data on the WebSocket.
  void _onData(WebSocketMessage message) {
    print('Received: $message');
    _messageController.add(message);
    switch (message.messageType) {
      case MessageType.connectionAck:
        final messageAck = message.payload as ConnectionAckMessagePayload;
        _timeoutTimer = RestartableTimer(
          Duration(milliseconds: messageAck.connectionTimeoutMs),
          _timeout,
        );
        if (!_connectionReady.isCompleted) {
          _connectionReady.complete();
        }
        print('Registered timer');
        break;
      case MessageType.keepAlive:
        _timeoutTimer.reset();
        print('Reset timer');
        break;
      case MessageType.startAck:
        print('Subscription registered: ${message.id}');
        break;
      case MessageType.data:
        // final messageData = message.payload as SubscriptionDataPayload;
        break;
      default:
        print('Unhandled message: $message');
    }
  }
}
