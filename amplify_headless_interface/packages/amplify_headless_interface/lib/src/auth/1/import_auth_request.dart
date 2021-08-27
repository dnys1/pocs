/// Defines acceptable payloads to amplify import auth --headless.
class ImportAuthRequestVersion {
  const ImportAuthRequestVersion._(this._value);

  final double _value;

  /// `1`
  static const $1 = ImportAuthRequestVersion._(1);

  static const List<ImportAuthRequestVersion> values = [$1];

  double toJson() => _value;
}

/// Defines acceptable payloads to amplify import auth --headless.
class ImportAuthRequest {
  const ImportAuthRequest(
      {required this.userPoolId,
      required this.webClientId,
      required this.nativeClientId,
      this.identityPoolId});

  /// The schema version.
  final ImportAuthRequestVersion version = ImportAuthRequestVersion.$1;

  /// The id of the Cognito User Pool
  final String userPoolId;

  /// The id of the Cognito Web Client
  final String webClientId;

  /// The id of the Cognito Native Client
  final String nativeClientId;

  /// The id of the Cognito Identity Pool
  final String? identityPoolId;

  Map<String, dynamic> toJson() => {
        'version': version,
        'userPoolId': userPoolId,
        'webClientId': webClientId,
        'nativeClientId': nativeClientId,
        if (identityPoolId != null) 'identityPoolId': identityPoolId,
      };
}
