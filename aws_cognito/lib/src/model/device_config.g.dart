// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceConfiguration _$DeviceConfigurationFromJson(Map<String, dynamic> json) =>
    DeviceConfiguration(
      challengeRequiredOnNewDevice:
          json['ChallengeRequiredOnNewDevice'] as bool?,
      deviceOnlyRememberedOnUserPrompt:
          json['DeviceOnlyRememberedOnUserPrompt'] as bool?,
    );

Map<String, dynamic> _$DeviceConfigurationToJson(DeviceConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'ChallengeRequiredOnNewDevice', instance.challengeRequiredOnNewDevice);
  writeNotNull('DeviceOnlyRememberedOnUserPrompt',
      instance.deviceOnlyRememberedOnUserPrompt);
  return val;
}
