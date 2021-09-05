import 'package:async/async.dart';
import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/request/http_method.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

export 'http_method.dart';

/// {@template aws_http_request}
/// A parameterized HTTP request.
///
/// The request is typically passed to a signer for signing, although it can be
/// used unsigned as well for sending unauthenticated requests.
/// {@endtemplate}
@immutable
class AWSHttpRequest with AWSEquatable {
  final HttpMethod method;
  final String host;
  final String path;
  final Map<String, String> queryParameters;
  final Map<String, String> headers;

  final StreamSplitter<List<int>> _body;
  Stream<List<int>> get body => _body.split();
  final int contentLength;

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
        _body = StreamSplitter(
          body == null || body.isEmpty
              ? const http.ByteStream(Stream.empty())
              : http.ByteStream.fromBytes(body),
        ),
        contentLength = body?.length ?? 0;

  AWSHttpRequest.streamed({
    required this.method,
    required this.host,
    required this.path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    required Stream<List<int>> body,
    required this.contentLength,
  })  : queryParameters = queryParameters ?? const {},
        headers = headers ?? const {},
        _body = StreamSplitter(body);

  @override
  List<Object?> get props => [
        method,
        host,
        path,
        queryParameters,
        headers,
        body,
      ];

  /// Creates a `package:http` request from this request.
  http.BaseRequest get httpRequest {
    final request = http.StreamedRequest(method.value, uri);
    request.headers.addAll(headers);
    request.contentLength = contentLength;

    body.listen(request.sink.add,
        onError: request.sink.addError,
        onDone: request.sink.close,
        cancelOnError: true);

    return request;
  }

  /// Sends the HTTP request.
  ///
  /// If [client] is not provided, a short-lived one is created for this request.
  Future<http.Response> send([http.Client? client]) async {
    final _client = client ?? http.Client();
    try {
      final resp = await _client.send(httpRequest);
      return http.Response.fromStream(resp);
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
