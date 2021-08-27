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
      {required this.bucketName, this.s3Permissions, this.lambdaTriggerConfig});

  /// Descriminant used to determine the service config type
  final S3ServiceConfigurationServiceName serviceName =
      S3ServiceConfigurationServiceName.$s3;

  /// Globally unique bucket name
  final String bucketName;

  /// Permissions that should be applied to the bucket
  final S3Permissions? s3Permissions;

  /// Lambda function that runs on bucket change
  final LambdaTriggerConfig? lambdaTriggerConfig;

  Map<String, dynamic> toJson() => {
        'serviceName': serviceName,
        'bucketName': bucketName,
        if (s3Permissions != null) 's3Permissions': s3Permissions,
        if (lambdaTriggerConfig != null)
          'lambdaTriggerConfig': lambdaTriggerConfig,
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
  const S3Permissions({required this.auth, this.guest, this.permissionGroups});

  /// Permissions for authenticated users
  final List<S3PermissionsAuth> auth;

  /// Permissions for unauthenticated users
  final List<S3PermissionsGuest>? guest;

  /// Permissions for Cognito user groups
  final PermissionGroups? permissionGroups;

  Map<String, dynamic> toJson() => {
        'auth': auth,
        if (guest != null) 'guest': guest,
        if (permissionGroups != null) 'permissionGroups': permissionGroups,
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
  const AddStorageRequest({this.s3ServiceConfiguration});

  final AddStorageRequestVersion version = AddStorageRequestVersion.$1;

  /// Service configuration for AWS S3 through Amplify
  final S3ServiceConfiguration? s3ServiceConfiguration;

  Map<String, dynamic> toJson() => {
        'version': version,
        if (s3ServiceConfiguration != null)
          's3ServiceConfiguration': s3ServiceConfiguration,
      };
}
