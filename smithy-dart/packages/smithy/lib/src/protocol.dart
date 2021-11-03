import 'dart:convert';

import 'package:http/http.dart' as http;

import 'operation.dart';
import 'serializer.dart';

abstract class HttpProtocol<T extends Object?, Input, Output> {
  void addBody(http.StreamedRequest request, Input input);
  Future<Output> parseResponse(http.StreamedResponse response);
  Constructor<T, Output> get responseConstructor;
}

mixin JsonProtocol<Input, Output>
    implements
        JsonSerializer<Input>,
        JsonDeserializer<Output>,
        HttpProtocol<Map<String, dynamic>, Input, Output> {
  @override
  void addBody(http.StreamedRequest request, input) {
    request.sink.add(utf8.encode(serialize(input)));
  }

  @override
  Future<Output> parseResponse(http.BaseResponse response) async {
    if (response is http.Response) {
      return deserialize(response.body);
    }
    response as http.StreamedResponse;
    final body = await response.stream.bytesToString();
    return deserialize(body);
  }
}
