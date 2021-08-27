import 'package:aws_common/aws_common.dart';

part 'get_id_request.g.dart';

@awsSerializable
class GetIdRequest {
  final String? accountId;
  final String identityPoolId;
  final Map<String, String>? logins;

  const GetIdRequest({
    this.accountId,
    required this.identityPoolId,
    this.logins,
  });

  factory GetIdRequest.fromJson(Map<String, dynamic> json) =>
      _$GetIdRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetIdRequestToJson(this);
}
