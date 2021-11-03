import 'package:meta/meta.dart';
import 'package:smithy/src/client.dart';
import 'package:http/http.dart' as http;
import 'package:smithy/src/serializer.dart';

abstract class StreamingInput {
  const StreamingInput(this._body);

  final Stream<List<int>> _body;
}

abstract class Operation<Input, Output> {
  const Operation();

  Future<Output> run(covariant Client client, Input input);
}

abstract class HttpOperation<Input, Output> extends Operation<Input, Output> {
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
  http.BaseRequest createRequest(Uri baseUri, Input input);

  @visibleForTesting
  @nonVirtual
  Future<http.StreamedResponse> sendRequest(HttpClient client, Input input) {
    final request = createRequest(client.baseUri, input);
    return client.send(request);
  }

  @override
  Future<Output> run(HttpClient client, Input input);
}

abstract class HttpStaticOperation<Input, Output>
    extends HttpOperation<Input, Output>
    implements Serializer<Input, String>, Deserializer<String, Output> {
  const HttpStaticOperation({
    required String method,
    required String path,
  }) : super._(
          method: method,
          path: path,
        );

  @override
  http.BaseRequest createRequest(Uri baseUri, Input input) {
    return http.Request(
      method,
      baseUri.resolve(path(input))
        ..queryParameters.addAll(queryParameters(input)),
    )
      ..body = serialize(input)
      ..headers.addAll(headers(input));
  }

  @override
  Future<Output> run(HttpClient client, Input input) async {
    final response = await sendRequest(client, input);
    final responseBody = await response.stream.bytesToString();
    return deserialize(responseBody);
  }
}

abstract class HttpStreamingOperation<Input extends StreamingInput, Output>
    extends HttpOperation<Input, Output> {
  const HttpStreamingOperation({
    required String method,
    required String path,
    required this.outputFactory,
  }) : super._(
          method: method,
          path: path,
        );

  final Output Function(Stream<List<int>>) outputFactory;

  @override
  http.BaseRequest createRequest(Uri baseUri, Input input) {
    final request = http.StreamedRequest(
      method,
      baseUri.resolve(path(input))
        ..queryParameters.addAll(queryParameters(input)),
    )..headers.addAll(headers(input));
    input._body.listen(
      request.sink.add,
      onError: request.sink.addError,
    );
    return request;
  }

  @override
  Future<Output> run(HttpClient client, Input input) async {
    final response = await sendRequest(client, input);
    return outputFactory(response.stream);
  }
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
