import 'package:json_schema2/json_schema2.dart'
    show ValidationError, JsonSchema;

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

  static const Map<String, dynamic> _schema = {
    "description":
        "Defines acceptable payloads to amplify import auth --headless.",
    "type": "object",
    "properties": {
      "version": {
        "description": "The schema version.",
        "type": "number",
        "enum": [1]
      },
      "userPoolId": {
        "description": "The id of the Cognito User Pool",
        "type": "string"
      },
      "webClientId": {
        "description": "The id of the Cognito Web Client",
        "type": "string"
      },
      "nativeClientId": {
        "description": "The id of the Cognito Native Client",
        "type": "string"
      },
      "identityPoolId": {
        "description": "The id of the Cognito Identity Pool",
        "type": "string"
      }
    },
    "required": ["version", "userPoolId", "webClientId", "nativeClientId"],
    "\$schema": "http://json-schema.org/draft-06/schema#"
  };

  Map<String, dynamic> toJson() => {
        'version': version,
        'userPoolId': userPoolId,
        'webClientId': webClientId,
        'nativeClientId': nativeClientId,
        if (identityPoolId != null) 'identityPoolId': identityPoolId,
      };
  List<ValidationError> validate() {
    final schema = JsonSchema.createSchema(_schema);
    return schema.validateWithErrors(toJson());
  }
}
