import 'package:amplify_common/amplify_common.dart';
import 'package:aws_cognito/src/model/credentials.dart';

part 'get_credentials_for_identity_response.g.dart';

@awsSerializable
class GetCredentialsForIdentityResponse {
  final Credentials credentials;
  final String identityId;

  const GetCredentialsForIdentityResponse({
    required this.credentials,
    required this.identityId,
  });

  factory GetCredentialsForIdentityResponse.fromJson(
          Map<String, dynamic> json) =>
      _$GetCredentialsForIdentityResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetCredentialsForIdentityResponseToJson(this);
}
