import 'package:aws_common/aws_common.dart';

part 'get_credentials_for_identity_request.g.dart';

@awsSerializable
class GetCredentialsForIdentityRequest {
  final String? customRoleArn;
  final String identityId;
  final Map<String, String>? logins;

  const GetCredentialsForIdentityRequest({
    this.customRoleArn,
    required this.identityId,
    this.logins,
  });

  factory GetCredentialsForIdentityRequest.fromJson(
          Map<String, dynamic> json) =>
      _$GetCredentialsForIdentityRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetCredentialsForIdentityRequestToJson(this);
}
