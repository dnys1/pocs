import 'dart:convert';
import 'dart:io';

import 'package:json_schema2/json_schema2.dart';

void main() {
  final schemaFile = File(
    Platform.script.resolve('../lib/AddApiRequest.schema.json').path,
  ).readAsStringSync();
  final schemaJson = jsonDecode(schemaFile) as Map<String, dynamic>;
  schemaJson[r'$schema'] = 'http://json-schema.org/draft-06/schema#';
  final schema = JsonSchema.createSchema(schemaJson);

  print(schemaJson);
  print(schema.schemaMap);
}
