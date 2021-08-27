import 'package:aws_common/aws_common.dart';

part 'device_config.g.dart';

@awsSerializable
class DeviceConfiguration with AWSEquatable {
  /// Indicates whether a challenge is required on a new device. Only applicable to a new device.
  final bool? challengeRequiredOnNewDevice;

  /// If true, a device is only remembered on user prompt.
  final bool? deviceOnlyRememberedOnUserPrompt;

  const DeviceConfiguration({
    required this.challengeRequiredOnNewDevice,
    required this.deviceOnlyRememberedOnUserPrompt,
  });

  @override
  List<Object?> get props => [
        challengeRequiredOnNewDevice,
        deviceOnlyRememberedOnUserPrompt,
      ];

  static DeviceConfiguration? create({
    required RememberUserDevices rememberUserDevices,
    bool? bypassMFA,
  }) {
    if (rememberUserDevices == RememberUserDevices.none) {
      return null;
    }
    return DeviceConfiguration(
      challengeRequiredOnNewDevice: !bypassMFA!,
      deviceOnlyRememberedOnUserPrompt:
          rememberUserDevices == RememberUserDevices.optional,
    );
  }

  factory DeviceConfiguration.fromJson(Map<String, dynamic> json) =>
      _$DeviceConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceConfigurationToJson(this);

  RememberUserDevices get rememberUserDevices {
    switch (deviceOnlyRememberedOnUserPrompt) {
      case true:
        return RememberUserDevices.optional;
      case false:
        return RememberUserDevices.always;
      case null:
      default:
        return RememberUserDevices.none;
    }
  }

  bool get bypassMFA => !challengeRequiredOnNewDevice!;

  @override
  String toString() {
    return 'DeviceConfiguration{challengeRequiredOnNewDevice=$challengeRequiredOnNewDevice, deviceOnlyRememberedOnUserPrompt=$deviceOnlyRememberedOnUserPrompt}';
  }
}

enum RememberUserDevices { always, optional, none }
