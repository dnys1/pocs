import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:smithy/smithy.dart';
import 'package:smithy/src/serializer.dart';
import 'package:smithy/src/types/timestamp.dart';

part 'kitchen_sink_model.g.dart';

class SmokeTest extends HttpOperation<SmokeTestRequest, SmokeTestResponse>
    with JsonSerializer<SmokeTestRequest> {
  const SmokeTest()
      : super(
          method: 'POST',
          path: '/smoketest/{label1}/foo',
        );

  @override
  Map<String, String> headers(SmokeTestRequest input) => {
        if (input.header1 != null) 'X-Header-1': input.header1!,
        if (input.header2 != null) 'X-Header-2': input.header2!,
      };

  @override
  Map<String, String> queryParameters(SmokeTestRequest input) => {
        if (input.query1 != null) 'Query1': input.query1!,
      };

  @override
  String label(SmokeTestRequest input, String key) {
    switch (key) {
      case 'label1':
        return input.label1;
    }
    return super.label(input, key);
  }

  @override
  SmokeTestResponse deserialize(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    return SmokeTestResponse.fromJson(json);
  }
}

@JsonSerializer.serializableRequest
class SmokeTestRequest {
  const SmokeTestRequest({
    this.header1,
    this.header2,
    this.query1,
    required this.label1,
    this.payload1,
    this.payload2,
    this.payload3,
  });

  @JsonKey(ignore: true)
  final String? header1;

  @JsonKey(ignore: true)
  final String? header2;

  @JsonKey(ignore: true)
  final String? query1;

  @JsonKey(ignore: true)
  final String label1;

  final String? payload1;
  final int? payload2;
  final Nested? payload3;

  Map<String, dynamic> toJson() => _$SmokeTestRequestToJson(this);
}

@JsonSerializable()
class Nested {
  const Nested({
    required this.member1,
    required this.member2,
  });

  factory Nested.fromJson(Map<String, dynamic> json) => _$NestedFromJson(json);

  final String member1;
  final String member2;

  Map<String, dynamic> toJson() => _$NestedToJson(this);
}

@JsonSerializer.serializableResponse
@TimestampSerializer.dateTime
class SmokeTestResponse {
  const SmokeTestResponse({
    this.strHeader,
    this.intHeader,
    this.tsListHeader,
    this.payload1,
    this.payload2,
    this.nested,
    this.payload4,
  });

  @JsonKey(ignore: true)
  final String? strHeader;

  @JsonKey(ignore: true)
  final int? intHeader;

  @JsonKey(ignore: true)
  final List<Timestamp>? tsListHeader;

  final String? payload1;
  final String? payload2;
  final Nested? nested;

  @JsonKey(
    toJson: TimestampSerializer.dateTimeToJson,
    fromJson: TimestampSerializer.dateTimeFromJson,
  )
  final Timestamp? payload4;

  factory SmokeTestResponse.fromJson(Map<String, dynamic> json) =>
      _$SmokeTestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SmokeTestResponseToJson(this);
}

class SmokeTestError implements Exception {
  const SmokeTestError(this.nested);

  final NestedErrorData nested;
}

class NestedErrorData {
  const NestedErrorData({
    this.field1,
  });

  final int? field1;
}
