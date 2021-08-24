import 'package:amplify_common/amplify_common.dart';

part 'get_id_response.g.dart';

@awsSerializable
class GetIdResponse {
  final String identityId;

  const GetIdResponse(this.identityId);

  factory GetIdResponse.fromJson(Map<String, dynamic> json) =>
      _$GetIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetIdResponseToJson(this);
}
