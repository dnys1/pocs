import 'package:aws_signature_v4/src/request/aws_date_time.dart';
import 'package:aws_signature_v4/src/credentials/aws_credentials.dart';
import 'package:json_annotation/json_annotation.dart';

part 'context.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class Context {
  final AWSCredentials credentials;
  final int expirationInSeconds;
  final bool normalize;
  final String region;
  final String service;
  final bool signBody;
  final DateTime timestamp;
  final bool? omitSessionToken;

  AWSDateTime get awsDateTime => AWSDateTime(timestamp);

  const Context({
    required this.credentials,
    required this.expirationInSeconds,
    required this.normalize,
    required this.region,
    required this.service,
    required this.signBody,
    required this.timestamp,
    this.omitSessionToken,
  });

  factory Context.fromJson(Map<String, dynamic> json) =>
      _$ContextFromJson(json);
}
