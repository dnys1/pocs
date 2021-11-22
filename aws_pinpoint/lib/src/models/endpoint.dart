import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'endpoint.g.dart';

@JsonEnum()
enum ChannelType {
  @JsonValue('PUSH')
  push,
  @JsonValue('GCM')
  gcm,
  @JsonValue('APNS')
  apns,
  @JsonValue('APNS_SANDBOX')
  apnsSandbox,
  @JsonValue('APNS_VOIP')
  apnsVoip,
  @JsonValue('APNS_VOIP_SANDBOX')
  apnsVoipSandbox,
  @JsonValue('ADM')
  adm,
  @JsonValue('SMS')
  sms,
  @JsonValue('VOICE')
  voice,
  @JsonValue('EMAIL')
  email,
  @JsonValue('BAIDU')
  baidu,
  @JsonValue('CUSTOM')
  custom,
  @JsonValue('IN_APP')
  inApp,
}

class UpdateEndpointInput extends EndpointRequest {
  UpdateEndpointInput({
    required this.applicationId,
    required this.endpointId,
    required EndpointRequest request,
  }) : super(
          user: request.user,
          channelType: request.channelType,
        );

  @JsonKey(ignore: true)
  final String applicationId;

  @JsonKey(ignore: true)
  final String endpointId;
}

@awsSerializable
class EndpointRequest {
  const EndpointRequest({
    this.user,
    this.channelType,
  });

  final EndpointUser? user;
  final ChannelType? channelType;

  factory EndpointRequest.fromJson(Map<String, Object?> json) =>
      _$EndpointRequestFromJson(json);

  Map<String, Object?> toJson() => _$EndpointRequestToJson(this);
}

@awsSerializable
class EndpointUser {
  const EndpointUser({
    this.userId,
    this.userAttributes,
  });

  final String? userId;
  final Map<String, List<String>>? userAttributes;

  factory EndpointUser.fromJson(Map<String, Object?> json) =>
      _$EndpointUserFromJson(json);

  Map<String, Object?> toJson() => _$EndpointUserToJson(this);
}

@awsSerializable
class EndpointResponse {
  const EndpointResponse({
    required this.id,
  });

  final String? id;

  factory EndpointResponse.fromJson(Map<String, Object?> json) =>
      _$EndpointResponseFromJson(json);

  Map<String, Object?> toJson() => _$EndpointResponseToJson(this);
}
