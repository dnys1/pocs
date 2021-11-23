import 'package:aws_common/aws_common.dart';

part 'identity_manager.g.dart';

typedef CognitoIdentityManagers = Map<String, CognitoIdentityManager>;

extension CognitoIdentityManagersX on CognitoIdentityManagers {
  CognitoIdentityManager? get default$ => this['Default'];
}

@awsSerializable
class CognitoIdentityManager
    with AWSEquatable<CognitoIdentityManager>, AWSSerializable {
  const CognitoIdentityManager();

  @override
  List<Object?> get props => [];

  factory CognitoIdentityManager.fromJson(Map<String, Object?> json) =>
      _$CognitoIdentityManagerFromJson(json);

  @override
  Map<String, Object?> toJson() => _$CognitoIdentityManagerToJson(this);
}
