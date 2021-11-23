import 'package:aws_common/aws_common.dart';

part 's3_transfer_utility.g.dart';

@awsSerializable
class S3TransferUtility with AWSEquatable<S3TransferUtility>, AWSSerializable {
  const S3TransferUtility({
    required this.bucket,
    required this.region,
  });

  final String bucket;
  final String region;

  @override
  List<Object?> get props => [
        bucket,
        region,
      ];

  factory S3TransferUtility.fromJson(Map<String, Object?> json) =>
      _$S3TransferUtilityFromJson(json);

  @override
  Map<String, Object?> toJson() => _$S3TransferUtilityToJson(this);
}
