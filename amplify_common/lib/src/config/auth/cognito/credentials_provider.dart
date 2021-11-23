import 'package:aws_common/aws_common.dart';

part 'credentials_provider.g.dart';

typedef CredentialsProvider = Map<String, Map<String, Object?>>;

extension CredentialsProviderX on CredentialsProvider {
  CognitoCredentialsProviders? get cognitoIdentity {
    final cognitoIdentityMap = this['CognitoIdentity'];
    if (cognitoIdentityMap is! Map<String, Object?>) {
      return null;
    }
    return cognitoIdentityMap.map(
      (key, json) => MapEntry(
        key,
        CognitoIdentityCredentialsProvider.fromJson((json as Map).cast()),
      ),
    );
  }
}

typedef CognitoCredentialsProviders
    = Map<String, CognitoIdentityCredentialsProvider>;

extension CognitoCredentialsProvidersX on CognitoCredentialsProviders {
  CognitoIdentityCredentialsProvider? get default$ => this['Default'];
}

@awsSerializable
class CognitoIdentityCredentialsProvider
    with AWSEquatable<CognitoIdentityCredentialsProvider>, AWSSerializable {
  final String poolId;
  final String region;

  const CognitoIdentityCredentialsProvider({
    required this.poolId,
    required this.region,
  });

  @override
  List<Object> get props => [poolId, region];

  factory CognitoIdentityCredentialsProvider.fromJson(
    Map<String, Object?> json,
  ) =>
      _$CognitoIdentityCredentialsProviderFromJson(json);

  @override
  Map<String, Object?> toJson() =>
      _$CognitoIdentityCredentialsProviderToJson(this);
}
