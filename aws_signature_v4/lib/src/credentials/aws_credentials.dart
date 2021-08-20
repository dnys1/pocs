import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'aws_credentials.g.dart';

/// A set of credentials used for accessing AWS services. Temporary credentials
/// should include an STS [token].
@JsonSerializable(fieldRename: FieldRename.snake)
class AWSCredentials with EquatableMixin {
  final String accessKeyId;
  final String secretAccessKey;
  final String? token;

  const AWSCredentials(this.accessKeyId, this.secretAccessKey, [this.token]);

  @override
  List<Object?> get props => [accessKeyId, secretAccessKey, token];

  factory AWSCredentials.fromJson(Map<String, dynamic> json) =>
      _$AWSCredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$AWSCredentialsToJson(this);
}
