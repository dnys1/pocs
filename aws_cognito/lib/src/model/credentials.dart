import 'package:amplify_common/amplify_common.dart';

part 'credentials.g.dart';

@awsSerializable
class Credentials {
  final String? accessKeyId;
  final String? secretKey;
  final String? sessionToken;
  final double? expiration;

  const Credentials({
    this.accessKeyId,
    this.secretKey,
    this.sessionToken,
    this.expiration,
  });

  factory Credentials.fromJson(Map<String, dynamic> json) =>
      _$CredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$CredentialsToJson(this);
}
