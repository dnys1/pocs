import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

class JsonSchemaGenerator implements Builder {
  final typeMap = <String, Reference>{};

  @override
  Map<String, List<String>> get buildExtensions => {
        '.schema.json': ['.schema.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final schemaJson = await buildStep.readAsString(buildStep.inputId);
    final schemaMap = jsonDecode(schemaJson) as Map;
    // Remap 7->6 because we do not use v7 changes anyway
    schemaMap['\$schema'] = 'http://json-schema.org/draft-06/schema#';
    final schema = await JsonSchema.createSchemaAsync(schemaMap);
    final assetName = path.basenameWithoutExtension(buildStep.inputId.path);

    final builder = JsonSchemaModelBuilder(assetName, schema, typeMap);
    final modelLibrary = builder.build();

    if (modelLibrary.isEmpty) {
      return;
    }

    // final generatedFile = AssetId.resolve(
    //   Uri(path: ReCase(assetName).snakeCase + '.schema.dart'),
    //   from: buildStep.inputId,
    // );
    final generatedFile = buildStep.inputId.changeExtension('.dart');
    await buildStep.writeAsString(generatedFile, modelLibrary);
  }
}

class JsonSchemaModelBuilder {
  static final _formatter = DartFormatter();

  final String libraryName;
  final JsonSchema schema;
  final Map<String, Reference> typeMap;
  final Map<Reference, Class> customTypes = {};

  JsonSchemaModelBuilder(this.libraryName, this.schema, this.typeMap);

  String build() {
    _buildAll();

    final lib = Library((b) => b.body.addAll(customTypes.values));
    final emitter = DartEmitter(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );
    return _formatter.format('${lib.accept(emitter)}');
  }

  void _buildAll() {
    for (var definition in schema.definitions.values) {
      final typeRef = refer(definition.propertyName!);
      customTypes[typeRef] = _buildClass(definition);
    }

    final className = ReCase(libraryName).pascalCase;
    customTypes[refer(className)] = _buildClass(schema, className);
    typeMap[className] = refer(className);
  }

  Class _buildClass(JsonSchema classSchema, [String? name]) => Class((b) {
        // Create name
        final className = name ?? classSchema.propertyName;
        if (className == null) {
          throw ArgumentError('No property name for schema: $classSchema');
        }
        b.name = ReCase(className).pascalCase;

        // Add docs
        var classDescription = classSchema.description;
        if (classDescription != null) {
          b.docs.add(_formatDocs(classDescription));
        }

        // Add fields
        var fieldsOptional = <String, bool>{};
        for (var field in classSchema.properties.values) {
          final gField = _buildField(field);
          fieldsOptional[gField.name] =
              (gField.type?.type as TypeReference?)?.isNullable ?? false;
          b.fields.add(gField);
        }

        // Create constructor
        b.constructors.add(Constructor(
          (c) => c
            ..constant = true
            ..optionalParameters.addAll([
              for (var field in fieldsOptional.entries)
                Parameter(
                  (p) => p
                    ..required = !field.value
                    ..name = field.key
                    ..toThis = true
                    ..named = true,
                ),
            ]),
        ));
      });

  Field _buildField(JsonSchema fieldSchema, {bool? isOptionalOverride}) =>
      Field((b) {
        b.modifier = FieldModifier.final$;
        b.type = _dartType(
          fieldSchema,
          isOptionalOverride: isOptionalOverride,
        );
        var description = fieldSchema.description;
        if (description != null) {
          b.docs.add(_formatDocs(description));
        }
        b.name = _fieldName(fieldSchema);
      });

  Reference _dartType(JsonSchema value, {bool? isOptionalOverride}) {
    if (value.oneOf.isNotEmpty) {
      return _buildOneOf(value);
    } else if (value.anyOf.isNotEmpty) {
      return _buildAnyOf(value);
    } else if (value.allOf.isNotEmpty) {
      throw UnsupportedError('Should not reach here');
    }

    final type = value.type;
    final isOptional = isOptionalOverride ?? !value.requiredOnParent;

    switch (type) {
      case SchemaType.array:
        final items = value.items;
        assert(items != null, 'Items cannot be empty for array');

        final isEnum = items!.enumValues?.isNotEmpty ?? false;
        if (isEnum) {
          return _buildEnum(value.propertyName!, items);
        }
        return TypeReference(
          (b) => b
            ..symbol = value.uniqueItems ? 'Set' : 'List'
            ..types.add(_dartType(items, isOptionalOverride: false))
            ..isNullable = isOptional,
        );
      case SchemaType.boolean:
        return TypeReference(
          (b) => b
            ..symbol = 'bool'
            ..isNullable = isOptional,
        );
      case SchemaType.integer:
        return TypeReference(
          (b) => b
            ..symbol = 'int'
            ..isNullable = isOptional,
        );
      case SchemaType.number:
        return TypeReference(
          (b) => b
            ..symbol = 'double'
            ..isNullable = isOptional,
        );
      case SchemaType.string:
        return TypeReference(
          (b) => b
            ..symbol = 'String'
            ..isNullable = isOptional,
        );
      case SchemaType.nullValue:
        return TypeReference(
          (b) => b..symbol = 'Null',
        );
      case SchemaType.object:
        final path = schema.path;
        if (path != null) {
          final isSchemaType = value.refMap?.containsKey(path) ?? false;
          if (isSchemaType) {
            final isAnonymous =
                !value.root!.definitions.containsKey(value.propertyName);
            if (isAnonymous) {
              final typeRef = _buildAnonymous(value);
              return typeRef.rebuild((b) => b.isNullable = isOptional);
            }
            return TypeReference(
              (b) => b
                ..symbol = value.propertyName
                ..isNullable = isOptional,
            );
          }
        }
        throw UnsupportedError('Unsupported object type found');
      default:
        throw UnsupportedError('Unsupported schema type: $type');
    }
  }

  TypeReference _buildAnonymous(JsonSchema objectSchema) {
    final className = ReCase(objectSchema.parent!.propertyName!).pascalCase;
    customTypes[refer(className)] = _buildClass(schema, className);
    typeMap[className] = refer(className);

    return TypeReference((b) => b.symbol = className);
  }

  Reference _buildOneOf(JsonSchema property) {
    final types = property.oneOf.map((s) => _dartType(s));
    return _buildTuple(types);
  }

  Reference _buildAnyOf(JsonSchema property) {
    final anyOf = property.anyOf;
    if (anyOf.length == 1) {
      return _dartType(anyOf.single);
    }
    final className = ReCase(property.propertyName!).pascalCase;
    if (typeMap.containsKey(className)) {
      return typeMap[className]!;
    }

    final anyOfClass = Class((b) {
      b.name = className;
      if (property.description != null) {
        b.docs.add(_formatDocs(property.description!));
      }

      final properties = _collect(anyOf);
      for (var property in properties.entries) {
        b.fields.add(_buildField(
          property.key,
          isOptionalOverride: !property.value,
        ));
      }

      b.constructors.add(Constructor(
        (c) => c
          ..optionalParameters.addAll([
            for (var property in properties.entries)
              Parameter((p) => p
                ..name = _fieldName(property.key)
                ..named = true
                ..toThis = true
                ..required = property.value),
          ]),
      ));
    });

    customTypes[refer(className)] = anyOfClass;
    return typeMap[className] = refer(className);
  }

  String _fieldName(JsonSchema fieldSchema) {
    var propertyName = fieldSchema.propertyName;
    if (propertyName == null) {
      throw ArgumentError('No property name for schema: $fieldSchema');
    }
    return ReCase(propertyName).camelCase;
  }

  Map<JsonSchema, bool> _collect(List<JsonSchema> list) {
    return list.fold(<JsonSchema, bool>{}, (previousValue, element) {
      if (element.allOf.isNotEmpty) {
        return previousValue
          ..addAll({
            for (var allOfSchema in element.allOf)
              if (previousValue.containsKey(allOfSchema))
                allOfSchema: true
              else
                allOfSchema: false,
          });
      }
      previousValue[element] = previousValue.containsKey(element);
      return previousValue;
    });
  }

  Reference _buildTuple(Iterable<Reference> types) {
    if (types.length < 2 || types.length > 7) {
      throw ArgumentError('Bad length: ${types.length}. '
          'Tuples are only supported for up to 7 types');
    }
    return TypeReference(
      (b) => b
        ..symbol = 'Tuple'
        ..url = 'package:tuple/tuple.dart'
        ..types.addAll(types),
    );
  }

  Reference _buildEnum(String propertyName, JsonSchema items) {
    final enumName = ReCase(propertyName).pascalCase;
    if (typeMap.containsKey(enumName)) {
      return typeMap[enumName]!;
    }

    final enumType = _dartType(items, isOptionalOverride: false);
    final enumClass = Class((b) {
      b.name = enumName;
      var description = items.parent?.description;
      if (description != null) {
        b.docs.add(_formatDocs(description));
      }

      // Create constructor and private value field.
      b.constructors.add(Constructor(
        (c) => c
          ..constant = true
          ..name = '_'
          ..requiredParameters.add(Parameter(
            (p) => p
              ..toThis = true
              ..name = '_value',
          )),
      ));
      b.fields.add(Field(
        (f) => f
          ..name = '_value'
          ..type = enumType
          ..modifier = FieldModifier.final$,
      ));

      // Create static const getters
      var fieldNames = <String>[];
      for (var item in items.enumValues!) {
        dynamic _quote(dynamic val) => val is String ? "'$val'" : val;
        b.fields.add(Field((f) {
          var fieldName = '\$${ReCase(item.toString()).camelCase}';
          fieldNames.add(fieldName);
          f
            ..static = true
            ..modifier = FieldModifier.constant
            ..name = fieldName
            ..assignment = Code('$enumName._(${_quote(item)})');
        }));
      }

      // Create list of all values
      b.fields.add(Field(
        (f) => f
          ..static = true
          ..modifier = FieldModifier.constant
          ..name = 'values'
          ..type = TypeReference(
            (t) => t
              ..isNullable = false
              ..symbol = 'List'
              ..types.add(refer(enumName)),
          )
          ..assignment = Code('''[
          ${fieldNames.join(',')}
          ]'''),
      ));
    });

    customTypes[refer(enumName)] = enumClass;
    return typeMap[enumName] = enumType;
  }

  String _formatDocs(String value) {
    final lines = value.split('\n');
    return lines.map((s) => '/// $s').join('\n');
  }
}

  // Reference _buildAllOf(JsonSchema property) {
  //   final allOf = property.allOf;
  //   if (allOf.length == 1) {
  //     return _dartType(allOf.single);
  //   }
  //   String className;
  //   if (property.propertyName != null) {
  //     className = ReCase(property.propertyName!).pascalCase;
  //   } else {
  //     var parent = property.parent;
  //     String? parentName;
  //     while (parent != null) {
  //       parentName = parent.propertyName;
  //       if (parentName != null) {
  //         break;
  //       }
  //       parent = parent.parent;
  //     }
  //     if (parentName == null) {
  //       throw Exception('Could not find parent for property');
  //     }
  //     className = parentName + '_${_propertyCounter++}';
  //   }
  //   final allOfClass = Class((b) {
  //     b.name = className;
  //     if (property.description != null) {
  //       b.docs.add(_docPrefix(property.description!));
  //     }
  //     for (var type in allOf) {
  //       b.fields.add(_buildField(type));
  //     }
  //   });

  //   final classRef = refer(className);
  //   customTypes[classRef] = allOfClass;
  //   return typeMap[className] = classRef;
  // }
