import 'package:aws_signature_v4/src/request/http_method.dart';
import 'package:http/http.dart' as http;

export 'package:aws_signature_v4/src/request/http_method.dart';

/// {@template aws_http_request}
/// A parameterized HTTP request.
///
/// The request is typically passed to a signer for signing, although it can be
/// used unsigned as well for sending unauthenticated requests.
/// {@endtemplate}
class AWSHttpRequest {
  final HttpMethod method;
  final String host;
  final String path;
  final Map<String, String> queryParameters;
  final Map<String, String> headers;
  final List<int> body;

  late final Uri uri = Uri(
    scheme: 'https',
    host: host,
    path: path,
    queryParameters: queryParameters,
  );

  /// {@macro aws_http_request}
  AWSHttpRequest({
    required this.method,
    required this.host,
    required this.path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    List<int>? body,
  })  : queryParameters = queryParameters ?? const {},
        headers = headers ?? const {},
        body = body ?? const [];

  /// Creates a request from a `package:http` request object.
  factory AWSHttpRequest.fromHttpRequest(
    http.BaseRequest request, {
    List<int>? body,
  }) {
    return AWSHttpRequest(
      method: HttpMethodX.fromString(request.method),
      host: request.url.authority,
      path: request.url.path,
      queryParameters: request.url.queryParameters,
      headers: request.headers,
      body: body,
    );
  }

  /// Creates a `package:http` request from this request.
  http.BaseRequest toHttpRequest() {
    final request = http.Request(method.value, uri);
    request.headers.addAll(headers);
    request.bodyBytes = body;
    return request;
  }

  /// Sends the HTTP request.
  ///
  /// If [client] is not provided, a short-lived one is created for this request.
  Future<http.Response> send([http.Client? client]) async {
    final _client = client ?? http.Client();
    try {
      switch (method) {
        case HttpMethod.get:
          return await _client.get(uri, headers: headers);
        case HttpMethod.head:
          return await _client.head(uri, headers: headers);
        case HttpMethod.post:
          return await _client.post(uri, headers: headers, body: body);
        case HttpMethod.put:
          return await _client.put(uri, headers: headers, body: body);
        case HttpMethod.patch:
          return await _client.patch(uri, headers: headers, body: body);
        case HttpMethod.delete:
          return await _client.delete(uri, headers: headers);
      }
    } finally {
      // Only close a client we created.
      if (client == null) {
        _client.close();
      }
    }
  }

  @override
  String toString() => uri.toString();
}
