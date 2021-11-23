import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:aws_common/aws_common.dart';

part 's3_config.g.dart';

/// {@template amplify_common.config.s3_plugin_config}
/// The AWS S3 plugin configuration.
/// {@endtemplate}
@amplifySerializable
class S3PluginConfig
    with AWSEquatable<S3PluginConfig>, AWSSerializable
    implements AmplifyPluginConfig {
  /// {@macro amplify_common.config.s3_plugin_config}
  const S3PluginConfig({
    required this.bucket,
    required this.region,
    required this.defaultAccessLevel,
  });

  /// The plugin's configuration key.
  static const pluginKey = 'awsS3StoragePlugin';

  @override
  String get name => pluginKey;

  final String bucket;
  final String region;
  final String defaultAccessLevel;

  @override
  List<Object?> get props => [
        bucket,
        region,
        defaultAccessLevel,
      ];

  factory S3PluginConfig.fromJson(Map<String, Object?> json) =>
      _$S3PluginConfigFromJson(json);

  @override
  Map<String, Object?> toJson() => _$S3PluginConfigToJson(this);
}
