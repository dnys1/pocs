import 'package:meta/meta.dart';
import 'package:smithy/src/client.dart';
import 'package:http/http.dart' as http;
import 'package:smithy/src/serializer.dart';

abstract class Operation<Input, Output> {
  const Operation();

  Future<Output> run(covariant Client client, Input input);
}

abstract class HttpOperation<Input, Output> extends Operation<Input, Output>
    implements Serializer<Input, String>, Deserializer<String, Output> {
  const HttpOperation({
    required this.method,
    required this.path,
  });

  static final _pathRegex = RegExp(r'{(\w+)}');

  final String method;
  final String path;

  /// Returns the label for the given [key] and [input].
  String label(Input input, String key) => throw MissingLabelError(input, key);

  /// Returns the headers for [input].
  Map<String, String> headers(Input input) => const {};

  /// Returns the query paramters for [input].
  Map<String, String> queryParameters(Input input) => const {};

  @visibleForTesting
  http.Request createRequest(Uri baseUri, Input input) {
    final path = this.path.replaceAllMapped(_pathRegex, (match) {
      final key = match.group(0)!;
      return label(input, key);
    });
    return http.Request(
      method,
      baseUri.resolve(path)..queryParameters.addAll(queryParameters(input)),
    )
      ..body = serialize(input)
      ..headers.addAll(headers(input));
  }

  @override
  Future<Output> run(HttpClient client, Input input) async {
    final request = createRequest(client.baseUri, input);
    final response = await client.send(request);
    final responseBody = await response.stream.bytesToString();
    return deserialize(responseBody);
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
