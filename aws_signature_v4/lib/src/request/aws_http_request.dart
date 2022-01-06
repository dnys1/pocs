import 'package:aws_common/aws_common.dart';
import 'package:http/http.dart' as http;

/// Utilities for working with `package:http` types on [AWSBaseHttpRequest].
extension AWSHttpRequestHelpers on AWSBaseHttpRequest {
  /// Creates a `package:http` request from this request.
  http.BaseRequest get httpRequest {
    final request = http.StreamedRequest(method.value, uri);
    request.headers.addAll(headers);
    var _contentLength = contentLength;
    if (_contentLength is int) {
      request.contentLength = _contentLength;
    }

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
}
