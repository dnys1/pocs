import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:smithy/smithy.dart';

abstract class Serializer<T, WireType> {
  WireType serialize(T input);
}

abstract class Deserializer<WireType, T> {
  T deserialize(WireType data);
}

mixin JsonSerializer<T> implements Serializer<T, String> {
  static const serializableRequest = JsonSerializable(createFactory: false);
  static const serializableResponse = JsonSerializable();

  @override
  String serialize(T input) {
    return json.encode(input);
  }
}

const int64Serializer = Int64Serializer();

class Int64Serializer extends JsonConverter<Int64?, String?>
    implements Serializer<Int64?, String?>, Deserializer<String?, Int64?> {
  const Int64Serializer();

  @override
  Int64? fromJson(String? json) {
    return deserialize(json);
  }

  @override
  String? toJson(Int64? object) {
    return serialize(object);
  }

  @override
  String? serialize(Int64? input) {
    if (input == null) {
      return null;
    }
    return input.toString();
  }

  @override
  Int64? deserialize(String? data) {
    if (data == null) {
      return null;
    }
    return Int64.parseInt(data);
  }
}
