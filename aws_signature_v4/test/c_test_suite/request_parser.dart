import 'dart:io';

import 'package:aws_signature_v4/aws_signature_v4.dart';

import 'context.dart';

/// Uses `dart:io` server to parse HTTP request data from the C auth library's
/// signer test suite.
class SignerRequestParser {
  late final HttpServer _server;
  late final Stream<HttpRequest> _serverStream;
  late Socket _sendSocket;

  /// Starts a local HTTP server.
  Future<void> init() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _serverStream = _server.asBroadcastStream();
  }

  /// Close the local HTTP server.
  Future<void> close() => _server.close();

  /// Returns the full request path with query parameters and fragments.
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

  /// Parses the query string into a map of query parameters.
  Map<String, String>? _parseQueryString(String requestLine) {
    final requestUriParts = _parseRequestUri(requestLine).split('?');
    if (requestUriParts.length < 2) return null;
    return Map.fromEntries(requestUriParts[1].split('&').map((q) {
      final parts = q.split('=');
      return MapEntry(parts[0], parts[1]);
    }));
  }

  /// Writes the raw request to the HTTP server and listens for the server to
  /// emit the parsed [HttpRequest].
  Future<AWSHttpRequest> parse(
    String request, {
    required Context context,
  }) async {
    // Some request files have paths with space characters. The Dart server will
    // not accept these and they must be percent-encoded.
    request = _preprocessRequest(request);

    // Use a different connection each time so don't need to bother sending
    // a response from the server.
    _sendSocket = await Socket.connect(
      InternetAddress.loopbackIPv4,
      _server.port,
    );

    // Send request and wait for server to process it.
    final nextRequest = _serverStream.first;
    _sendSocket.write(request);
    _sendSocket.writeln();
    await _sendSocket.flush();
    await _sendSocket.close();
    final httpRequest = await nextRequest;

    // Capture the body bytes of the request.
    List<int>? body;
    if (context.signBody) {
      body = await httpRequest.reduce(
        (previous, element) => previous..addAll(element),
      );
    }

    // Map headers from HttpHeaders to Map.
    final headers = httpRequest.headers;
    final mapHeaders = <String, String>{};
    headers.forEach((name, values) {
      mapHeaders[name] = values.join(',');
    });

    // Close request when done with it.
    await httpRequest.response.close();

    final requestLine = request.split('\n').first;

    // Parse these parameters manually since they are modified, normalized, etc.
    // by the Dart server.
    final path = _parseRequestPath(requestLine);
    final queryParameters = _parseQueryString(requestLine);

    return AWSHttpRequest(
      method: HttpMethodX.fromString(httpRequest.method),
      host: headers.host!,
      path: path,
      headers: mapHeaders,
      queryParameters: queryParameters,
      body: body,
    );
  }

  /// Encodes spaces in the URI before sending to the Dart server. This might
  /// be an implementation detail of the server but it cannot process the request
  /// otherwise.
  String _preprocessRequest(String request) {
    final requestLines = request.split('\n');
    var requestLine = requestLines.first;

    final requestParts = requestLine.split(' ');
    final requestPartsLength = requestParts.length;

    // Only perform work if the request path has spaces.
    //
    // e.g. requestLine = 'GET /abc 123/ HTTP/1.1'
    //   => requestParts = ['GET', '/abc', '123/', 'HTTP/1.1']
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
