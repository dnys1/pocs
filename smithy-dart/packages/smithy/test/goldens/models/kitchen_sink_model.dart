import 'dart:convert';
import 'dart:typed_data';

import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smithy/smithy.dart';
import 'package:smithy/src/serializer.dart';
import 'package:smithy/src/types/timestamp.dart';

part 'kitchen_sink_model.g.dart';

class SmokeTest extends HttpStaticOperation<SmokeTestRequest, SmokeTestResponse>
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
class SmokeTestRequest with AWSSerializable {
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
  @HttpHeader('X-Header1')
  final String? header1;

  @JsonKey(ignore: true)
  @HttpHeader('X-Header2')
  final String? header2;

  @JsonKey(ignore: true)
  @HttpQuery('Query1')
  final String? query1;

  @JsonKey(ignore: true)
  @HttpLabel()
  final String label1;

  final String? payload1;
  final int? payload2;
  final Nested? payload3;

  @override
  Map<String, dynamic> toJson() => _$SmokeTestRequestToJson(this);
}

@JsonSerializer.serializable
class Nested with AWSSerializable {
  const Nested({
    required this.member1,
    required this.member2,
  });

  factory Nested.fromJson(Map<String, dynamic> json) => _$NestedFromJson(json);

  final String member1;
  final String member2;

  @override
  Map<String, dynamic> toJson() => _$NestedToJson(this);
}

@JsonSerializer.serializableResponse
class SmokeTestResponse with AWSSerializable {
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
  @HttpHeader('X-Header1')
  final String? strHeader;

  @JsonKey(ignore: true)
  @HttpHeader('X-Header2')
  final int? intHeader;

  @JsonKey(ignore: true)
  @HttpHeader('X-Header3')
  final List<Timestamp>? tsListHeader;

  final String? payload1;
  final String? payload2;
  final Nested? nested;

  @TimestampSerializer.dateTime
  @TimestampFormat(TimestampSerializationFormat.dateTime)
  final Timestamp? payload4;

  factory SmokeTestResponse.fromJson(Map<String, dynamic> json) =>
      _$SmokeTestResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SmokeTestResponseToJson(this);
}

class SmokeTestError extends SmithyClientException {
  const SmokeTestError(this.nested);

  final NestedErrorData nested;
}

class NestedErrorData {
  const NestedErrorData({
    this.field1,
  });

  final int? field1;
}

class ExplicitStringOperation
    extends HttpStaticOperation<ExplicitStringRequest, ExplicitStringResponse>
    with JsonSerializer<ExplicitStringRequest> {
  const ExplicitStringOperation()
      : super(
          method: 'POST',
          path: '/explicit/string',
        );

  @override
  ExplicitStringResponse deserialize(String data) {
    final json = (jsonDecode(data) as Map).cast<String, dynamic>();
    return ExplicitStringResponse.fromJson(json);
  }
}

@JsonSerializer.serializableRequest
class ExplicitStringRequest with AWSSerializable {
  const ExplicitStringRequest({
    required this.payload1,
  });

  @HttpPayload()
  final String? payload1;

  @override
  Map<String, dynamic> toJson() => _$ExplicitStringRequestToJson(this);
}

@JsonSerializer.serializableResponse
class ExplicitStringResponse with AWSSerializable {
  const ExplicitStringResponse({
    required this.payload1,
  });

  @HttpPayload()
  final String? payload1;

  factory ExplicitStringResponse.fromJson(Map<String, dynamic> json) =>
      _$ExplicitStringResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ExplicitStringResponseToJson(this);
}

class ExplicitBlobOperation
    extends HttpStaticOperation<ExplicitBlobRequest, ExplicitBlobResponse>
    with JsonSerializer<ExplicitBlobRequest> {
  const ExplicitBlobOperation()
      : super(
          method: 'POST',
          path: '/explicit/string',
        );

  @override
  ExplicitBlobResponse deserialize(String data) {
    final json = (jsonDecode(data) as Map).cast<String, dynamic>();
    return ExplicitBlobResponse.fromJson(json);
  }
}

@JsonSerializer.serializableRequest
class ExplicitBlobRequest with AWSSerializable {
  const ExplicitBlobRequest({
    required this.payload1,
  });

  @blobSerializer
  @HttpPayload()
  final Uint8List? payload1;

  @override
  Map<String, dynamic> toJson() => _$ExplicitBlobRequestToJson(this);
}

@JsonSerializer.serializableResponse
class ExplicitBlobResponse with AWSSerializable {
  const ExplicitBlobResponse({
    required this.payload1,
  });

  @blobSerializer
  @HttpPayload()
  final Uint8List? payload1;

  factory ExplicitBlobResponse.fromJson(Map<String, dynamic> json) =>
      _$ExplicitBlobResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ExplicitBlobResponseToJson(this);
}

typedef BodyStream = Stream<List<int>>;

class ExplicitBlobStream extends HttpStreamingOperation<
    ExplicitBlobStreamRequest, ExplicitBlobStreamResponse> {
  ExplicitBlobStream()
      : super(
          method: 'POST',
          path: '/explicit/struct',
          outputFactory: ExplicitBlobStreamResponse.new,
        );
}

class ExplicitBlobStreamRequest extends StreamingInput {
  const ExplicitBlobStreamRequest({
    required this.payload1,
  }) : super(payload1);

  final BodyStream payload1;
}

class ExplicitBlobStreamResponse {
  const ExplicitBlobStreamResponse(this.payload1);

  final BodyStream payload1;
}
