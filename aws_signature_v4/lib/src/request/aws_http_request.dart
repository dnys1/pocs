import 'package:aws_signature_v4/src/request/http_method.dart';
import 'package:http/http.dart' as http;

export 'package:aws_signature_v4/src/request/http_method.dart';

class AWSHttpRequest {
  final HttpMethod httpMethod;
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

  AWSHttpRequest({
    required this.httpMethod,
    required this.host,
    required this.path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    List<int>? body,
  })  : queryParameters = queryParameters ?? const {},
        headers = headers ?? const {},
        body = body ?? const [];

  factory AWSHttpRequest.fromHttpRequest(
    http.BaseRequest request, {
    List<int>? body,
  }) {
    return AWSHttpRequest(
      httpMethod: HttpMethodX.fromString(request.method),
      host: request.url.authority,
      path: request.url.path,
      queryParameters: request.url.queryParameters,
      headers: request.headers,
      body: body,
    );
  }

  http.BaseRequest toHttpRequest() {
    final request = http.Request(httpMethod.value, uri);
    request.headers.addAll(headers);
    request.bodyBytes = body;
    return request;
  }

  Future<http.Response> send() async {
    final client = http.Client();
    try {
      switch (httpMethod) {
        case HttpMethod.get:
          return await client.get(uri, headers: headers);
        case HttpMethod.head:
          return await client.head(uri, headers: headers);
        case HttpMethod.post:
          return await client.post(uri, headers: headers, body: body);
        case HttpMethod.put:
          return await client.put(uri, headers: headers, body: body);
        case HttpMethod.patch:
          return await client.patch(uri, headers: headers, body: body);
        case HttpMethod.delete:
          return await client.delete(uri, headers: headers);
      }
    } finally {
      client.close();
    }
  }

  @override
  String toString() => uri.toString();
}
