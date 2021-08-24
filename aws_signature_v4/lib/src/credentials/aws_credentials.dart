import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'aws_credentials.g.dart';

/// A set of credentials used for accessing AWS services. Temporary credentials
/// should include an STS [sessionToken].
@JsonSerializable(fieldRename: FieldRename.snake)
class AWSCredentials with EquatableMixin {
  final String accessKeyId;
  final String secretAccessKey;
  final String? sessionToken;
  final DateTime? expiration;

  const AWSCredentials(
    this.accessKeyId,
    this.secretAccessKey, [
    this.sessionToken,
    this.expiration,
  ]);

  @override
  List<Object?> get props => [accessKeyId, secretAccessKey, sessionToken];

  factory AWSCredentials.fromJson(Map<String, dynamic> json) =>
      _$AWSCredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$AWSCredentialsToJson(this);
}
