import 'dart:io';

import 'package:aws_signature_v4/aws_signature_v4.dart';

import 'context.dart';

/// Uses `dart:io` server to parse HTTP request data.
class SignerRequestParser {
  late final HttpServer _server;
  late final Stream<HttpRequest> _serverStream;
  late Socket _sendSocket;

  Future<void> init() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _serverStream = _server.asBroadcastStream();
  }

  Future<void> close() => _server.close();

  String _parseRequestUri(String requestLine) {
    final s1 = requestLine.indexOf(' ');
    final s2 = requestLine.lastIndexOf(' ');
    final requestUri = requestLine.substring(s1 + 1, s2).replaceAll(' ', '%20');
    return requestUri;
  }

  /// Parses the request path from the first line of the HTTP request.
  String _parseRequestPath(String requestLine) {
    return _parseRequestUri(requestLine).split('?').first;
  }

  Map<String, String>? _parseQueryString(String requestLine) {
    final requestUriParts = _parseRequestUri(requestLine).split('?');
    if (requestUriParts.length < 2) return null;
    return Map.fromEntries(requestUriParts[1].split('&').map((q) {
      final parts = q.split('=');
      return MapEntry(parts[0], parts[1]);
    }));
  }

  /// Parses the request by sending it to the local server.
  Future<AWSHttpRequest> parse(String request,
      {required Context context}) async {
    request = _preprocessRequest(request);
    _sendSocket =
        await Socket.connect(InternetAddress.loopbackIPv4, _server.port);
    final nextRequest = _serverStream.first;
    _sendSocket.write(request);
    _sendSocket.writeln();
    await _sendSocket.flush();
    await _sendSocket.close();
    final httpRequest = await nextRequest;
    List<int>? body;
    if (context.signBody) {
      body = await httpRequest.reduce(
        (previous, element) => previous..addAll(element),
      );
    }
    final headers = httpRequest.headers;
    final mapHeaders = <String, String>{};
    headers.forEach((name, values) {
      mapHeaders[name] = values.join(',');
    });
    final requestLine = request.split('\n').first;
    await httpRequest.response.close();
    return AWSHttpRequest(
      method: HttpMethodX.fromString(httpRequest.method),
      host: headers.host!,
      path: _parseRequestPath(requestLine),
      headers: mapHeaders,
      queryParameters: _parseQueryString(requestLine),
      body: body,
    );
  }

  String _preprocessRequest(String request) {
    // Encode spaces in URI (invalid request URI otherwise)
    final requestLines = request.split('\n');
    var requestLine = requestLines.first;
    final requestParts = requestLine.split(' ');
    final requestPartsLength = requestParts.length;
    if (requestPartsLength > 3) {
      requestLine = [
        requestParts.first,
        requestParts.sublist(1, requestPartsLength - 1).join('%20'),
        requestParts.last,
      ].join(' ');
      request = [
        requestLine,
        ...requestLines.sublist(1),
      ].join('\n');
    }
    return request;
  }
}
