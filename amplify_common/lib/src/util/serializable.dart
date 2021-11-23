import 'package:json_annotation/json_annotation.dart';

/// Global serialization options for Amplify types.
const amplifySerializable = JsonSerializable(
  includeIfNull: false,
  explicitToJson: true,
);
