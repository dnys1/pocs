import 'package:json_annotation/json_annotation.dart';

part 'log_stream.g.dart';

@JsonSerializable()
class CreateLogStreamInput {
  final String logGroupName;
  final String logStreamName;

  const CreateLogStreamInput({
    required this.logGroupName,
    required this.logStreamName,
  });

  factory CreateLogStreamInput.fromJson(Map<String, dynamic> json) =>
      _$CreateLogStreamInputFromJson(json);

  Map<String, dynamic> toJson() => _$CreateLogStreamInputToJson(this);
}

@JsonSerializable()
class PutLogEventsRequest {
  const PutLogEventsRequest({
    required this.logEvents,
    required this.logGroupName,
    required this.logStreamName,
    this.sequenceToken,
  });

  final List<LogEvent> logEvents;
  final String logGroupName;
  final String logStreamName;
  final String? sequenceToken;

  factory PutLogEventsRequest.fromJson(Map<String, Object?> json) =>
      _$PutLogEventsRequestFromJson(json);

  Map<String, Object?> toJson() => _$PutLogEventsRequestToJson(this);
}

DateTime _fromInt(int ts) => DateTime.fromMillisecondsSinceEpoch(ts);

int _toInt(DateTime dt) => dt.millisecondsSinceEpoch;

@JsonSerializable()
class LogEvent {
  const LogEvent({
    required this.message,
    required this.timestamp,
  });

  final String message;

  @JsonKey(
    toJson: _toInt,
    fromJson: _fromInt,
  )
  final DateTime timestamp;

  factory LogEvent.fromJson(Map<String, Object?> json) =>
      _$LogEventFromJson(json);

  Map<String, Object?> toJson() => _$LogEventToJson(this);
}

@JsonSerializable()
class PutLogEventsResponse {
  const PutLogEventsResponse({
    required this.nextSequenceToken,
  });

  final String nextSequenceToken;

  factory PutLogEventsResponse.fromJson(Map<String, Object?> json) =>
      _$PutLogEventsResponseFromJson(json);

  Map<String, Object?> toJson() => _$PutLogEventsResponseToJson(this);
}
