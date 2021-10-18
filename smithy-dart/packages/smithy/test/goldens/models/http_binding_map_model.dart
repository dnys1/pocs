// @dart=2.13

library com.test.http_binding_map_model;

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:smithy/smithy.dart';

part 'http_binding_map_model.g.dart';

typedef IntList = List<int>;
typedef MapOfLists = Map<String, IntList>;

@JsonSerializable(
  createToJson: true,
  createFactory: false,
)
class MapInputRequest {
  const MapInputRequest({
    required this.mapOfLists,
  });

  final MapOfLists mapOfLists;

  Map<String, dynamic> toJson() => _$MapInputRequestToJson(this);
}

class MapInputOperation extends HttpOperation<MapInputRequest, void> {
  const MapInputOperation() : super(method: 'POST', path: '/input/map');

  @override
  void deserialize(String body) {}

  @override
  String serialize(MapInputRequest input) {
    return jsonEncode(input);
  }
}
