import 'package:amplify_common/amplify_common.dart';
import 'package:json_annotation/json_annotation.dart';

/// Global serialization options for Amplify types.
const amplifySerializable = JsonSerializable(includeIfNull: false);

/// Global serialization options for AWS types.
const awsSerializable = JsonSerializable(
  fieldRename: FieldRename.pascal,
  includeIfNull: false,
);

mixin AmplifySerializable on Object {
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return prettyPrintJson(this);
  }
}
