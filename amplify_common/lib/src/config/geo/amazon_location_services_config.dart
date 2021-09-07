import 'package:amplify_common/src/config/amplify_plugin_config.dart';
import 'package:amplify_common/src/config/amplify_plugin_registry.dart';
import 'package:amplify_common/src/util/serializable.dart';
import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'amazon_location_services_config.g.dart';

class AmazonLocationServicesPluginConfigFactory
    extends AmplifyPluginConfigFactory {
  const AmazonLocationServicesPluginConfigFactory();

  @override
  AmplifyPluginConfig build(Map<String, dynamic> json) {
    return AmazonLocationServicesPluginConfig.fromJson(json);
  }

  @override
  String get name => AmazonLocationServicesPluginConfig.pluginKey;
}

@amplifySerializable
class AmazonLocationServicesPluginConfig
    with AWSEquatable, AWSSerializable
    implements AmplifyPluginConfig {
  const AmazonLocationServicesPluginConfig({
    this.region,
    this.maps,
  });

  factory AmazonLocationServicesPluginConfig.fromJson(
          Map<String, dynamic> json) =>
      _$AmazonLocationServicesPluginConfigFromJson(json);

  static const pluginKey = 'amazon_location_services';

  final String? region;
  final AmazonLocationServicesMaps? maps;

  @override
  String get name => pluginKey;

  @override
  List<Object?> get props => [];

  @override
  Map<String, dynamic> toJson() =>
      _$AmazonLocationServicesPluginConfigToJson(this);
}

@amplifySerializable
class AmazonLocationServicesMaps with AWSEquatable, AWSSerializable {
  const AmazonLocationServicesMaps({
    required this.items,
    required this.$default,
  });

  @override
  List<Object?> get props => [items, $default];

  final Map<String, AmazonLocationServicesMap> items;

  @JsonKey(name: 'default')
  final String $default;

  AmazonLocationServicesMap get defaultMap => items[$default]!;

  factory AmazonLocationServicesMaps.fromJson(Map<String, dynamic> json) =>
      _$AmazonLocationServicesMapsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AmazonLocationServicesMapsToJson(this);
}

@amplifySerializable
class AmazonLocationServicesMap with AWSEquatable, AWSSerializable {
  const AmazonLocationServicesMap({
    required this.style,
  });

  factory AmazonLocationServicesMap.fromJson(Map<String, dynamic> json) =>
      _$AmazonLocationServicesMapFromJson(json);

  final String style;

  @override
  List<Object?> get props => [style];

  @override
  Map<String, dynamic> toJson() => _$AmazonLocationServicesMapToJson(this);
}
