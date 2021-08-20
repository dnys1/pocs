import 'package:json_annotation/json_annotation.dart';

/// Global serialization options for Amplify types.
const amplifySerializable = JsonSerializable(anyMap: true);

/// Global serialization options for AWS types.
const awsSerializable = JsonSerializable(
  anyMap: true,
  fieldRename: FieldRename.pascal,
);
