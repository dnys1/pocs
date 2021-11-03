import 'dart:convert';

import 'package:aws_common/aws_common.dart';
import 'package:meta/meta.dart';
import 'package:smithy/smithy.dart';
import 'package:smithy/src/client.dart';
import 'package:http/http.dart' as http;
import 'package:smithy/src/serializer.dart';

import 'protocol.dart';

typedef Constructor<T extends Object?, Output> = Output Function(T);
typedef StreamingResponseContructor<T extends Object?, Output> = Output
    Function(Stream<T>);
typedef RawResponseConstructor<T extends Object?, Output> = Output Function(T);
typedef JsonConstructor<Output> = Output Function(Map<String, dynamic>);

abstract class StreamingInput<T extends Object?> {
  const StreamingInput(this._body);

  final Stream<T> _body;
}

abstract class Operation<Input, Output> {
  const Operation();

  Future<Output> run(covariant Client client, Input input);
}

abstract class InputPayload<T extends Object?> {
  T getPayload();
}

abstract class HttpOperation<T extends Object?, Input, Output>
    extends Operation<Input, Output> implements HttpProtocol<T, Input, Output> {
  const HttpOperation._({
    required this.method,
    required String path,
  }) : _path = path;

  static final _pathRegex = RegExp(r'{(\w+)}');

  final String method;
  final String _path;

  /// Returns the label for the given [key] and [input].
  String label(Input input, String key) => throw MissingLabelError(input, key);

  /// Returns the headers for [input].
  Map<String, String> headers(Input input) => const {};

  /// Returns the query paramters for [input].
  Map<String, String> queryParameters(Input input) => const {};

  String path(Input input) {
    return _path.replaceAllMapped(_pathRegex, (match) {
      final key = match.group(0)!;
      return label(input, key);
    });
  }

  @visibleForTesting
  http.BaseRequest createRequest(Uri baseUri, Input input) {
    final request = http.StreamedRequest(
      method,
      baseUri.resolve(path(input))
        ..queryParameters.addAll(queryParameters(input)),
    )..headers.addAll(headers(input));
    addBody(request, input);
    return request;
  }

  @visibleForTesting
  @nonVirtual
  Future<http.StreamedResponse> sendRequest(HttpClient client, Input input) {
    final request = createRequest(client.baseUri, input);
    return client.send(request);
  }

  @override
  Future<Output> run(HttpClient client, Input input);
}

abstract class HttpStaticOperation<T extends Object?, Input, Output>
    extends HttpOperation<T, Input, Output> {
  const HttpStaticOperation({
    required String method,
    required String path,
  }) : super._(
          method: method,
          path: path,
        );

  @override
  Future<Output> parseResponse(http.StreamedResponse response);

  @override
  Future<Output> run(HttpClient client, Input input) async {
    final response = await sendRequest(client, input);
    return parseResponse(response);
  }
}

abstract class HttpRawOperation<
        T extends Object?,
        Input extends InputPayload<T>,
        Output> extends HttpStaticOperation<T, Input, Output>
    with RawBody<T, Input, Output> {
  const HttpRawOperation({
    required String method,
    required String path,
  }) : super(
          method: method,
          path: path,
        );

  @override
  RawResponseConstructor<T, Output> get responseConstructor;
}

mixin RawBody<T extends Object?, Input extends InputPayload<T>, Output>
    on HttpOperation<T, Input, Output> {
  @override
  void addBody(http.StreamedRequest request, Input input) {
    var payload = input.getPayload();
    if (payload == null) {
      return;
    }
    if (payload is String) {
      request.sink.add(utf8.encode(payload));
    } else if (payload is List<int>) {
      request.sink.add(payload);
    } else {
      throw ArgumentError(
        'Invalid raw payload type: $T. '
            'Only String and List<int> are supported.',
        'T',
      );
    }
  }

  @override
  Future<Output> parseResponse(http.StreamedResponse response) async {
    if (T == String) {
      final body = await response.stream.bytesToString();
      return responseConstructor(body as T);
    } else if (T == List<int>) {
      final bodyBytes = await response.stream.toBytes();
      return responseConstructor(bodyBytes as T);
    } else {
      throw ArgumentError(
        'Invalid raw payload type: $T. '
            'Only String and List<int> are supported.',
        'T',
      );
    }
  }
}

abstract class HttpJsonOperation<Input, Output>
    extends HttpStaticOperation<Map<String, dynamic>, Input, Output>
    with
        JsonSerializer<Input>,
        JsonDeserializer<Output>,
        JsonProtocol<Input, Output> {
  const HttpJsonOperation({
    required String method,
    required String path,
  }) : super(
          method: method,
          path: path,
        );
}

abstract class HttpStreamingOperation<
    T extends Object?,
    Input extends InputPayload<Stream<T>>,
    Output> extends HttpOperation<Stream<T>, Input, Output> {
  const HttpStreamingOperation._({
    required String method,
    required String path,
  }) : super._(
          method: method,
          path: path,
        );

  @override
  StreamingResponseContructor<T, Output> get responseConstructor;

  @override
  Future<Output> run(HttpClient client, Input input) async {
    final response = await sendRequest(client, input);
    return parseResponse(response);
  }
}

abstract class HttpStreamingRawOperation<
        T extends Object?,
        Input extends InputPayload<Stream<T>>,
        Output> extends HttpStreamingOperation<T, Input, Output>
    with RawBody<Stream<T>, Input, Output> {
  const HttpStreamingRawOperation({
    required String method,
    required String path,
  }) : super._(
          method: method,
          path: path,
        );
}

abstract class HttpStreamingJsonOperation<
        T extends AWSSerializable,
        Input extends InputPayload<Stream<T>>,
        Output> extends HttpStreamingOperation<T, Input, Output>
    with JsonSerializer<Input> {
  const HttpStreamingJsonOperation({
    required String method,
    required String path,
  }) : super._(
          method: method,
          path: path,
        );
}

class MissingLabelError<T> extends Error {
  MissingLabelError(this.input, this.label);

  final T input;
  final String label;

  @override
  String toString() {
    return 'Missing label {$label} for input $input';
  }
}
