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
///
/// See also:
/// - [AWSHttpRequest]
/// - [AWSStreamedHttpRequest]
@immutable
abstract class AWSBaseHttpRequest with AWSEquatable {
  final HttpMethod method;
  final String host;
  final String path;
  final Map<String, String> queryParameters;
  final Map<String, String> headers;
  final int contentLength;

  Stream<List<int>> get body;

  late final Uri uri = Uri(
    scheme: 'https',
    host: host,
    path: path,
    queryParameters: queryParameters,
  );

  /// {@macro aws_http_request}
  AWSBaseHttpRequest._({
    required this.method,
    required this.host,
    required this.path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    required this.contentLength,
  })  : queryParameters = queryParameters ?? const {},
        headers = headers ?? const {};

  @override
  List<Object?> get props => [
        method,
        host,
        path,
        queryParameters,
        headers,
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

/// {@macro aws_http_request}
class AWSHttpRequest extends AWSBaseHttpRequest {
  /// {@macro aws_http_request}
  AWSHttpRequest({
    required HttpMethod method,
    required String host,
    required String path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    List<int>? body,
  })  : bodyBytes = body ?? const [],
        super._(
          method: method,
          host: host,
          path: path,
          queryParameters: queryParameters,
          headers: headers,
          contentLength: body?.length ?? 0,
        );

  @override
  Stream<List<int>> get body => bodyBytes.isEmpty
      ? const http.ByteStream(Stream.empty())
      : http.ByteStream.fromBytes(bodyBytes);

  /// The body bytes.
  final List<int> bodyBytes;
}

/// {@template aws_http_streamed_request}
/// A streaming HTTP request.
/// {@endtemplate}
class AWSStreamedHttpRequest extends AWSBaseHttpRequest {
  /// @{macro aws_http_streamed_request}
  ///
  /// For signed requests, [body] is read once, in chunks, as it is sent to AWS.
  /// It is required that [contentLength] be provided so that [body] does not
  /// have to be read twice, since the content length must be known when
  /// calculating the signature.
  AWSStreamedHttpRequest({
    required HttpMethod method,
    required String host,
    required String path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    required this.body,
    required int contentLength,
  }) : super._(
          method: method,
          host: host,
          path: path,
          queryParameters: queryParameters,
          headers: headers,
          contentLength: contentLength,
        );

  @override
  final Stream<List<int>> body;
}
