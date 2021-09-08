import 'dart:convert' show jsonEncode;
import 'dart:io' show Process;

import 'package:json_schema2/json_schema2.dart'
    show ValidationError, JsonSchema;

/// Service configuration for AWS S3 through Amplify
class S3ServiceConfigurationServiceName {
  const S3ServiceConfigurationServiceName._(this._value);

  final String _value;

  /// `s3`
  static const $s3 = S3ServiceConfigurationServiceName._('s3');

  static const List<S3ServiceConfigurationServiceName> values = [$s3];

  String toJson() => _value;
}

/// Service configuration for AWS S3 through Amplify
class S3ServiceConfiguration {
  const S3ServiceConfiguration(
      {required this.bucketName,
      required this.permissions,
      this.lambdaTrigger});

  /// Descriminant used to determine the service config type
  final S3ServiceConfigurationServiceName serviceName =
      S3ServiceConfigurationServiceName.$s3;

  /// Globally unique bucket name
  final String bucketName;

  /// Permissions that should be applied to the bucket
  final S3Permissions permissions;

  /// Lambda function that runs on bucket change
  final LambdaTriggerConfig? lambdaTrigger;

  Map<String, dynamic> toJson() => {
        'serviceName': serviceName,
        'bucketName': bucketName,
        'permissions': permissions,
        if (lambdaTrigger != null) 'lambdaTrigger': lambdaTrigger,
      };
}

/// Permissions for authenticated users
class S3PermissionsAuth {
  const S3PermissionsAuth._(this._value);

  final String _value;

  /// `CREATE`
  static const $create = S3PermissionsAuth._('CREATE');

  /// `DELETE`
  static const $delete = S3PermissionsAuth._('DELETE');

  /// `READ`
  static const $read = S3PermissionsAuth._('READ');

  /// `UPDATE`
  static const $update = S3PermissionsAuth._('UPDATE');

  static const List<S3PermissionsAuth> values = [
    $create,
    $delete,
    $read,
    $update
  ];

  String toJson() => _value;
}

/// Permissions for unauthenticated users
class S3PermissionsGuest {
  const S3PermissionsGuest._(this._value);

  final String _value;

  /// `CREATE`
  static const $create = S3PermissionsGuest._('CREATE');

  /// `DELETE`
  static const $delete = S3PermissionsGuest._('DELETE');

  /// `READ`
  static const $read = S3PermissionsGuest._('READ');

  /// `UPDATE`
  static const $update = S3PermissionsGuest._('UPDATE');

  static const List<S3PermissionsGuest> values = [
    $create,
    $delete,
    $read,
    $update
  ];

  String toJson() => _value;
}

/// Permissions that should be applied to the bucket
class S3Permissions {
  const S3Permissions({required this.auth, this.guest, this.groups});

  /// Permissions for authenticated users
  final List<S3PermissionsAuth> auth;

  /// Permissions for unauthenticated users
  final List<S3PermissionsGuest>? guest;

  /// Permissions for Cognito user groups
  final PermissionGroups? groups;

  Map<String, dynamic> toJson() => {
        'auth': auth,
        if (guest != null) 'guest': guest,
        if (groups != null) 'groups': groups,
      };
}

class PermissionGroupsAdditionalProperties {
  const PermissionGroupsAdditionalProperties._(this._value);

  final String _value;

  /// `CREATE`
  static const $create = PermissionGroupsAdditionalProperties._('CREATE');

  /// `DELETE`
  static const $delete = PermissionGroupsAdditionalProperties._('DELETE');

  /// `READ`
  static const $read = PermissionGroupsAdditionalProperties._('READ');

  /// `UPDATE`
  static const $update = PermissionGroupsAdditionalProperties._('UPDATE');

  static const List<PermissionGroupsAdditionalProperties> values = [
    $create,
    $delete,
    $read,
    $update
  ];

  String toJson() => _value;
}

/// Permissions for Cognito user groups
class PermissionGroups {
  const PermissionGroups({this.additionalProperties});

  final List<PermissionGroupsAdditionalProperties>? additionalProperties;

  Map<String, dynamic> toJson() => {
        if (additionalProperties != null)
          'additionalProperties': additionalProperties,
      };
}

/// Lambda function that runs on bucket change
class LambdaTriggerConfigMode {
  const LambdaTriggerConfigMode._(this._value);

  final String _value;

  /// `existing`
  static const $existing = LambdaTriggerConfigMode._('existing');

  /// `new`
  static const $new = LambdaTriggerConfigMode._('new');

  static const List<LambdaTriggerConfigMode> values = [$existing, $new];

  String toJson() => _value;
}

/// Lambda function that runs on bucket change
class LambdaTriggerConfig {
  const LambdaTriggerConfig({required this.mode, required this.name});

  final LambdaTriggerConfigMode mode;

  final String name;

  Map<String, dynamic> toJson() => {
        'mode': mode,
        'name': name,
      };
}

/// Headless mode for add storage is not yet implemented.
/// This interface is subject to change and should not be used.
class AddStorageRequestVersion {
  const AddStorageRequestVersion._(this._value);

  final double _value;

  /// `1`
  static const $1 = AddStorageRequestVersion._(1);

  static const List<AddStorageRequestVersion> values = [$1];

  double toJson() => _value;
}

/// Headless mode for add storage is not yet implemented.
/// This interface is subject to change and should not be used.
class AddStorageRequest {
  const AddStorageRequest({required this.serviceConfiguration});

  final AddStorageRequestVersion version = AddStorageRequestVersion.$1;

  /// Service configuration for AWS S3 through Amplify
  final S3ServiceConfiguration serviceConfiguration;

  static const Map<String, dynamic> _schema = {
    "description":
        "Headless mode for add storage is not yet implemented.\nThis interface is subject to change and should not be used.",
    "type": "object",
    "properties": {
      "version": {
        "type": "number",
        "enum": [1]
      },
      "serviceConfiguration": {"\$ref": "#/definitions/S3ServiceConfiguration"}
    },
    "required": ["serviceConfiguration", "version"],
    "definitions": {
      "S3ServiceConfiguration": {
        "description": "Service configuration for AWS S3 through Amplify",
        "type": "object",
        "properties": {
          "serviceName": {
            "description":
                "Descriminant used to determine the service config type",
            "type": "string",
            "enum": ["s3"]
          },
          "permissions": {
            "\$ref": "#/definitions/S3Permissions",
            "description":
                "The permissions that should be applied to the bucket"
          },
          "bucketName": {
            "description": "Globally unique bucket name",
            "type": "string"
          },
          "lambdaTrigger": {
            "\$ref": "#/definitions/LambdaTriggerConfig",
            "description":
                "Optional parameter specifying a lambda that should run when the bucket is modified"
          }
        },
        "required": ["bucketName", "permissions", "serviceName"]
      },
      "S3Permissions": {
        "description": "Permissions that should be applied to the bucket",
        "type": "object",
        "properties": {
          "auth": {
            "description": "Permissions for authenticated users",
            "type": "array",
            "items": {
              "enum": ["CREATE", "DELETE", "READ", "UPDATE"],
              "type": "string"
            }
          },
          "guest": {
            "description": "Permissions for unauthenticated users",
            "type": "array",
            "items": {
              "enum": ["CREATE", "DELETE", "READ", "UPDATE"],
              "type": "string"
            }
          },
          "groups": {
            "\$ref": "#/definitions/PermissionGroups",
            "description": "Permissions for Cognito user groups"
          }
        },
        "required": ["auth"]
      },
      "PermissionGroups": {
        "description": "Permissions for Cognito user groups",
        "type": "object",
        "additionalProperties": {
          "type": "array",
          "items": {
            "enum": ["CREATE", "DELETE", "READ", "UPDATE"],
            "type": "string"
          }
        }
      },
      "LambdaTriggerConfig": {
        "description": "Lambda function that runs on bucket change",
        "type": "object",
        "properties": {
          "mode": {
            "enum": ["existing", "new"],
            "type": "string"
          },
          "name": {"type": "string"}
        },
        "required": ["mode", "name"]
      }
    },
    "\$schema": "http://json-schema.org/draft-06/schema#"
  };

  Map<String, dynamic> toJson() => {
        'version': version,
        'serviceConfiguration': serviceConfiguration,
      };
  List<ValidationError> validate() {
    final schema = JsonSchema.createSchema(_schema);
    return schema.validateWithErrors(jsonEncode(toJson()), parseJson: true);
  }

  Future<Process> start(
      {String? workingDirectory,
      Map<String, String>? environment,
      bool runInShell = false}) async {
    final proc = await Process.start(
      'amplify',
      [
        'add',
        'storage',
        '--headless',
      ],
      workingDirectory: workingDirectory,
      environment: environment,
      runInShell: runInShell,
    );
    proc.stdin.writeln(jsonEncode(this));

    return proc;
  }
}
