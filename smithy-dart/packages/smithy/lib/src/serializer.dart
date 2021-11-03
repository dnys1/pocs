import 'dart:convert';
import 'dart:typed_data';

import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smithy/smithy.dart';

abstract class Serializer<T, WireType> {
  WireType serialize(T input);
}

abstract class Deserializer<WireType, T> {
  T deserialize(WireType data);
}

mixin JsonSerializer<T> implements Serializer<T, String> {
  static const serializableRequest = JsonSerializable(
    createFactory: false,
    explicitToJson: true,
    checked: true,
  );
  static const serializableResponse = JsonSerializable(
    explicitToJson: true,
    checked: true,
  );
  static const serializable = JsonSerializable(
    explicitToJson: true,
    checked: true,
  );

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

const blobSerializer = BlobSerializer();

class BlobSerializer extends JsonConverter<Uint8List?, String?>
    implements
        Serializer<Uint8List?, String?>,
        Deserializer<String?, Uint8List?> {
  const BlobSerializer();

  @override
  Uint8List? deserialize(String? data) {
    if (data == null) {
      return null;
    }
    final json = (jsonDecode(data) as List).cast<int>();
    return Uint8List.fromList(json);
  }

  @override
  Uint8List? fromJson(String? json) {
    return deserialize(json);
  }

  @override
  String? serialize(Uint8List? input) {
    if (input == null) {
      return null;
    }
    return jsonEncode(input);
  }

  @override
  String? toJson(Uint8List? object) {
    return serialize(object);
  }
}
