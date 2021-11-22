// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_stream.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLogStreamInput _$CreateLogStreamInputFromJson(
        Map<String, dynamic> json) =>
    CreateLogStreamInput(
      logGroupName: json['logGroupName'] as String,
      logStreamName: json['logStreamName'] as String,
    );

Map<String, dynamic> _$CreateLogStreamInputToJson(
        CreateLogStreamInput instance) =>
    <String, dynamic>{
      'logGroupName': instance.logGroupName,
      'logStreamName': instance.logStreamName,
    };

PutLogEventsRequest _$PutLogEventsRequestFromJson(Map<String, dynamic> json) =>
    PutLogEventsRequest(
      logEvents: (json['logEvents'] as List<dynamic>)
          .map((e) => LogEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      logGroupName: json['logGroupName'] as String,
      logStreamName: json['logStreamName'] as String,
      sequenceToken: json['sequenceToken'] as String?,
    );

Map<String, dynamic> _$PutLogEventsRequestToJson(
        PutLogEventsRequest instance) =>
    <String, dynamic>{
      'logEvents': instance.logEvents,
      'logGroupName': instance.logGroupName,
      'logStreamName': instance.logStreamName,
      'sequenceToken': instance.sequenceToken,
    };

LogEvent _$LogEventFromJson(Map<String, dynamic> json) => LogEvent(
      message: json['message'] as String,
      timestamp: _fromInt(json['timestamp'] as int),
    );

Map<String, dynamic> _$LogEventToJson(LogEvent instance) => <String, dynamic>{
      'message': instance.message,
      'timestamp': _toInt(instance.timestamp),
    };

PutLogEventsResponse _$PutLogEventsResponseFromJson(
        Map<String, dynamic> json) =>
    PutLogEventsResponse(
      nextSequenceToken: json['nextSequenceToken'] as String,
    );

Map<String, dynamic> _$PutLogEventsResponseToJson(
        PutLogEventsResponse instance) =>
    <String, dynamic>{
      'nextSequenceToken': instance.nextSequenceToken,
    };
