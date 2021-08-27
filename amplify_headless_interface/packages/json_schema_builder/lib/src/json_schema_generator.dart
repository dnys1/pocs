import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

const _reservedNames = [
  'Type',
];

/// A map of types generated throughout the build process, used to share
/// common types between the files.
final _globalMap = <_Class, Uri>{};

class JsonSchemaGenerator implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        '.schema.json': ['.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final schemaJson = await buildStep.readAsString(buildStep.inputId);
    final schemaMap = jsonDecode(schemaJson) as Map;
    // Remap 7->6 because we do not use v7 changes anyway
    schemaMap['\$schema'] = 'http://json-schema.org/draft-06/schema#';
    final schema = JsonSchema.createSchema(schemaMap);
    final assetName = path.basename(buildStep.inputId.path).split('.').first;

    final builder = JsonSchemaModelBuilder(assetName, schema);
    final modelLibrary = builder.build();

    if (modelLibrary.isEmpty) {
      return;
    }

    final outputBasename =
        path.basename(buildStep.inputId.path).split('.').first;
    final generatedFile = AssetId.resolve(
      Uri.parse('$outputBasename.dart'),
      from: buildStep.inputId,
    );
    await buildStep.writeAsString(generatedFile, modelLibrary);

    // _globalMap.addAll({
    //   for (var type in builder.customTypes) type: generatedFile.uri,
    // });
  }
}

class _Field {
  final String name;
  final Reference typeRef;

  const _Field._({
    required this.name,
    required this.typeRef,
  });

  factory _Field(Field field, Reference classType) {
    return _Field._(name: field.name, typeRef: field.type ?? classType);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Field && name == other.name && typeRef == other.typeRef;

  @override
  int get hashCode => name.hashCode ^ typeRef.hashCode;
}

class _Class {
  final Class ref;
  final List<_Field> fields;

  const _Class._({
    required this.ref,
    required this.fields,
  });

  factory _Class(Class $class) {
    if ($class.fields.isEmpty) {
      throw ArgumentError.value($class, 'class', 'has empty `fields` property');
    }
    return _Class._(
      ref: $class,
      fields: $class.fields.map((f) => _Field(f, refer($class.name))).toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Class &&
          const UnorderedIterableEquality().equals(fields, other.fields);

  @override
  int get hashCode => const UnorderedIterableEquality().hash(fields);
}

class JsonSchemaModelBuilder {
  static const jsonSchemaPackage = 'package:json_schema2/json_schema2.dart';
  static final _formatter = DartFormatter();

  final String libraryName;
  final JsonSchema schema;
  final Map<String, TypeReference> typeMap = {};
  final Set<_Class> customTypes = {};
  final Map<Uri, Set<String>> packageImports = {};

  JsonSchemaModelBuilder(this.libraryName, this.schema) {
    packageImports[Uri.parse(jsonSchemaPackage)] = {
      'ValidationError',
      'JsonSchema',
    };
  }

  String _escapeDartString(String string) {
    return string.replaceAll(r'$', r'\$');
  }

  Class _addValidator(Class $class) {
    final schemaMap = schema.schemaMap;
    return $class.rebuild(
      (b) => b
        ..fields.add(Field(
          (f) => f
            ..static = true
            ..modifier = FieldModifier.constant
            ..name = '_schema'
            ..type = TypeReference(
              (t) => t
                ..symbol = 'Map'
                ..types.replace([refer('String'), refer('dynamic')]),
            )
            ..assignment = Code(_escapeDartString(jsonEncode(schemaMap))),
        ))
        ..methods.add(Method(
          (m) => m
            ..name = 'validate'
            ..returns = TypeReference(
              (t) => t
                ..symbol = 'List'
                ..types.add(refer(
                  'ValidationError',
                  jsonSchemaPackage,
                )),
            )
            ..body = Block.of([
              Code(r'final schema = JsonSchema.createSchema(_schema);'),
              Code(r'return schema.validateWithErrors(toJson());'),
            ]),
        )),
    );
  }

  String build() {
    _buildAll();

    final lib = Library(
      (b) => b
        ..directives.addAll([
          for (var import in packageImports.entries)
            Directive.import(
              import.key.toString(),
              show: import.value.toList(),
            )
        ])
        ..body.addAll(customTypes.map((e) => e.ref)),
    );
    final emitter = DartEmitter(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );
    return _formatter.format('${lib.accept(emitter)}');
  }

  void _buildAll() {
    final className = _className(libraryName);

    for (var definition in schema.definitions.values) {
      // Create these classes in context only
      if (definition.propertyName?.startsWith(RegExp('Partial|Pick')) ??
          false) {
        continue;
      }
      if (definition.properties.isNotEmpty ||
          definition.additionalPropertiesSchema != null) {
        customTypes.add(_Class(_buildClass(definition)));
      } else {
        _dartType(definition, parentNameOverride: className);
      }
    }

    final libraryClass = _addValidator(_buildClass(schema, className));
    customTypes.add(_Class(libraryClass));
    typeMap[className] = refer(className).type as TypeReference;
  }

  Class _buildClass(JsonSchema classSchema, [String? name]) => Class((b) {
        // Add name
        final className = name ?? _findPropertyName(classSchema);
        final parentName = classSchema.parent == null
            ? null
            : _findPropertyName(classSchema.parent!);
        b.name = _className(className, parentName);

        // Add docs
        var classDescription = classSchema.description;
        if (classDescription != null) {
          b.docs.add(_formatDocs(classDescription));
        }

        // Add fields
        var properties = <String, _Property>{};
        for (var field in classSchema.properties.values) {
          final gField = _buildField(field, parentNameOverride: b.name);
          properties[field.propertyName!] = _Property(
            name: gField.name,
            property: field,
            isOptional:
                (gField.type?.type as TypeReference?)?.isNullable ?? false,
          );
          b.fields.add(gField);
        }

        // Add additional properties
        var additionalProperties = classSchema.additionalPropertiesSchema;
        if (additionalProperties != null) {
          const name = 'additionalProperties';
          final field = _buildField(
            additionalProperties,
            propertyNameOverride: name,
          );
          properties[name] = _Property(
            name: name,
            property: additionalProperties,
            isOptional: true,
          );
          b.fields.add(field);
        }

        // Create constructor
        b.constructors.add(Constructor((c) {
          var params = <Parameter>[];
          final allProperties = [
            ...classSchema.properties.values,
            if (classSchema.additionalPropertiesSchema != null)
              classSchema.additionalPropertiesSchema!,
          ];
          for (var property in allProperties) {
            if (_isSingleEnum(property)) {
              continue;
            }
            final _property = properties[property.propertyName!]!;
            params.add(Parameter(
              (p) => p
                ..required = !_property.isOptional
                ..name = _property.name
                ..toThis = true
                ..named = true,
            ));
          }
          c
            ..constant = true
            ..optionalParameters.addAll(params);
        }));

        // Add toJson method
        _buildToJson(b);
      });

  bool _isEnum(JsonSchema property) {
    return property.enumValues?.isNotEmpty ?? false;
  }

  bool _isSingleEnum(JsonSchema property) {
    return property.enumValues?.length == 1;
  }

  Field _buildField(
    JsonSchema fieldSchema, {
    bool? isOptionalOverride,
    String? propertyNameOverride,
    String? parentNameOverride,
  }) =>
      Field((b) {
        b.modifier = FieldModifier.final$;
        b.type = _dartType(
          fieldSchema,
          isOptionalOverride: isOptionalOverride,
          propertyNameOverride: propertyNameOverride,
          parentNameOverride: parentNameOverride,
        );
        if (_isSingleEnum(fieldSchema)) {
          final enumName = b.type!.symbol!;
          final value = '\$' + '${fieldSchema.enumValues!.single}'.camelCase;
          b.assignment = refer(enumName).property(value).code;
        }
        var description = fieldSchema.description;
        if (description != null) {
          b.docs.add(_formatDocs(description));
        }
        if (propertyNameOverride != null) {
          b.name = _propertyName(propertyNameOverride);
        } else {
          b.name = _fieldName(fieldSchema);
        }
      });

  String _parentClassName(JsonSchema property) {
    final isRoot = property.parent == null;
    return isRoot ? libraryName : _findPropertyName(property.parent!);
  }

  TypeReference _dartType(
    JsonSchema value, {
    bool? isOptionalOverride,
    String? propertyNameOverride,
    String? parentNameOverride,
  }) {
    final isOptional = isOptionalOverride ?? !value.requiredOnParent;

    TypeReference? collectionType;
    if (value.oneOf.isNotEmpty) {
      collectionType = _buildOneOf(value);
    } else if (value.anyOf.isNotEmpty) {
      collectionType = _buildAnyOf(value);
    } else if (value.allOf.isNotEmpty) {
      collectionType = _buildAllOf(value);
    }
    if (collectionType != null) {
      return collectionType.rebuild((b) => b.isNullable = isOptional);
    }

    final type = value.type;
    final isEnum = value.enumValues?.isNotEmpty ?? false;

    switch (type) {
      case SchemaType.array:
        final items = value.items;
        if (items == null) {
          throw StateError('Items cannot be empty for array');
        }

        return TypeReference(
          (b) => b
            ..symbol = value.uniqueItems ? 'Set' : 'List'
            ..types.add(_dartType(
              items,
              propertyNameOverride: propertyNameOverride ?? value.propertyName,
              parentNameOverride: parentNameOverride,
              isOptionalOverride: false,
            ))
            ..isNullable = isOptional,
        );
      case SchemaType.boolean:
        final boolType = TypeReference((b) => b..symbol = 'bool');
        if (isEnum) {
          return _buildEnum(
            propertyNameOverride,
            parentNameOverride,
            boolType,
            value,
          ).rebuild((b) => b.isNullable = isOptional);
        }
        return boolType.rebuild((b) => b..isNullable = isOptional);
      case SchemaType.integer:
        final intType = TypeReference((b) => b..symbol = 'int');
        if (isEnum) {
          return _buildEnum(
            propertyNameOverride,
            parentNameOverride,
            intType,
            value,
          ).rebuild((b) => b.isNullable = isOptional);
        }
        return intType.rebuild((b) => b..isNullable = isOptional);
      case SchemaType.number:
        final numType = TypeReference((b) => b..symbol = 'double');
        if (isEnum) {
          return _buildEnum(
            propertyNameOverride,
            parentNameOverride,
            numType,
            value,
          ).rebuild((b) => b.isNullable = isOptional);
        }
        return numType.rebuild((b) => b..isNullable = isOptional);
      case SchemaType.string:
        //
        final stringType = TypeReference((b) => b..symbol = 'String');
        if (isEnum) {
          return _buildEnum(
            propertyNameOverride,
            parentNameOverride,
            stringType,
            value,
          ).rebuild((b) => b.isNullable = isOptional);
        }
        return stringType.rebuild((b) => b..isNullable = isOptional);
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
              final typeRef = _buildAnonymous(
                value,
                _parentClassName(value),
              );
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

  String _cleanPartialPick(String name) {
    final prefix = RegExp('Partial|Pick');
    name = Uri.decodeComponent(name);
    if (name.startsWith(prefix)) {
      final start = name.indexOf('<') + 1;
      return name.substring(
          start,
          name.contains(',')
              ? name.indexOf(',', start)
              : name.indexOf('>', start));
    }
    return name;
  }

  String _className(String name, [String? parentClassName]) {
    name = name.pascalCase;
    final needsPrefix = _reservedNames.contains(name) ||
        name.startsWith(RegExp('Partial|Pick'));
    final useParentName =
        RegExp(r'^\d$').hasMatch(name) || name.toLowerCase() == 'items';
    if (needsPrefix) {
      name = '${parentClassName!}_${_cleanPartialPick(name)}';
    } else if (useParentName) {
      name = parentClassName!;
    }
    return _cleanPropertyName(name).pascalCase;
  }

  String _propertyName(String name) {
    return _cleanPropertyName(name).camelCase;
  }

  String _cleanPropertyName(String name) {
    name = Uri.decodeComponent(name);
    name = name.replaceAll(RegExp('[<>"]'), '').replaceAll(RegExp('[,|]'), '_');
    return name;
  }

  TypeReference _buildAnonymous(
    JsonSchema objectSchema,
    String parentClassName,
  ) {
    final className = _className(
      objectSchema.propertyName ?? objectSchema.parent!.propertyName!,
      parentClassName,
    );
    customTypes.add(_Class(_buildClass(objectSchema, className)));
    typeMap[className] = refer(className).type as TypeReference;

    return TypeReference((b) => b.symbol = className);
  }

  TypeReference _buildOneOf(JsonSchema property) {
    final types = property.oneOf.map((s) => _dartType(s));
    return _buildTuple(types);
  }

  TypeReference _buildAnyOf(JsonSchema property) {
    final anyOf = property.anyOf;
    if (anyOf.length == 1) {
      return _dartType(anyOf.single);
    }
    return _buildPartialClass(
      property,
      anyOf,
      isAnyOf: true,
    );
  }

  TypeReference _buildAllOf(JsonSchema property) {
    final allOf = property.allOf;
    if (allOf.length == 1) {
      return _dartType(allOf.single);
    }
    return _buildPartialClass(
      property,
      allOf,
      isAnyOf: false,
    );
  }

  bool _isDartCoreType(TypeReference type) {
    final isSimpleType = [
      'String',
      'double',
      'int',
      'bool',
      'Null',
    ].contains(type.symbol);
    final isCollectionOfSimpleTypes = [
          'List',
          'Set',
          'Map',
        ].contains(type.symbol) &&
        type.types.every(
          (t) => _isDartCoreType(t.type as TypeReference),
        );
    return isSimpleType || isCollectionOfSimpleTypes;
  }

  void _buildToJson(ClassBuilder b) {
    b.methods.removeWhere((m) => m.name == 'toJson');

    final fields = b.fields.build();
    final enumField = fields.firstWhereOrNull((f) => f.name == '_value');
    final isEnum = enumField != null;

    Code buildBody() {
      final instanceProperties = fields.where((f) => f.static == false);

      final sb = StringBuffer();
      sb.writeln('{');
      for (var field in instanceProperties) {
        final type = field.type!.type as TypeReference;
        if (type.isNullable!) {
          sb.write('if (${field.name} != null) ');
        }
        sb.write("'${field.name.camelCase}': ${field.name},");
      }
      sb.write('}');
      return Code(sb.toString());
    }

    b.methods.add(Method(
      (m) => m
        ..name = 'toJson'
        ..body = isEnum ? Code('_value') : buildBody()
        ..lambda = true
        ..returns = isEnum
            ? enumField!.type!
            : TypeReference(
                (r) => r
                  ..symbol = 'Map'
                  ..types.addAll(
                    [
                      TypeReference((s) => s.symbol = 'String'),
                      TypeReference((s) => s.symbol = 'dynamic'),
                    ],
                  ),
              ),
    ));
  }

  TypeReference _buildPartialClass(
    JsonSchema property,
    List<JsonSchema> propertyValues, {
    required bool isAnyOf,
  }) {
    final parentName = _parentClassName(property);
    var className = _className(
      property.propertyName!,
      parentName,
    );

    final partialClass = Class((b) {
      b.name = className;
      if (property.description != null) {
        b.docs.add(_formatDocs(property.description!));
      }

      final properties = _collect(
        propertyValues,
        isAnyOf: isAnyOf,
      );

      for (var property in properties.entries) {
        b.fields.add(_buildField(
          property.value.property,
          isOptionalOverride: property.value.isOptional,
          propertyNameOverride: property.key,
          parentNameOverride: className,
        ));
      }

      b.constructors.add(Constructor(
        (c) => c
          ..optionalParameters.addAll([
            for (var property in properties.entries)
              if (!_isSingleEnum(property.value.property))
                Parameter(
                  (p) => p
                    ..name = _propertyName(property.key)
                    ..named = true
                    ..toThis = true
                    ..required = !property.value.isOptional,
                ),
          ]),
      ));

      // Build toJson
      _buildToJson(b);
    });

    final classType = _addCustomTypeIfNeeded(
      partialClass,
      parentName: parentName,
    );

    // All classes
    if (propertyValues.every((el) =>
        el.propertyName != null &&
        el.typeList != null &&
        el.type == SchemaType.object)) {
      // Implement parent type
      propertyValues.forEach((prop) {
        final propertyTypeName = _className(
          prop.propertyName!,
          partialClass.name,
        );
        final $class = customTypes.firstWhereOrNull(
          (el) => el.ref.name == propertyTypeName,
        );

        final _class = $class?.ref ?? _buildClass(prop);

        final missingFields = partialClass.fields.where((field) {
          return _class.fields.every((f) => f.name != field.name);
        });

        // If already updated, return
        if (_Class(partialClass) == $class ||
            _class.implements.any((ref) => ref == classType) ||
            _class.methods.any(
              (m) => missingFields.any((f) => f.name == m.name),
            )) {
          return;
        }

        for (var field in _class.fields) {
          final fieldType = field.type!.type as TypeReference;

          final inheritedField = partialClass.fields.firstWhereOrNull(
            (f) =>
                f.name == field.name &&
                !_isDartCoreType(fieldType) &&
                (f.type!.symbol != field.type!.symbol ||
                    !const UnorderedIterableEquality().equals(
                      (f.type!.type as TypeReference)
                          .types
                          .map((t) => t.symbol),
                      (field.type!.type as TypeReference)
                          .types
                          .map((t) => t.symbol),
                    )),
          );
          // If true, will be an enum class inherited from parent.
          if (inheritedField != null) {
            var inheritedType = inheritedField.type!.type as TypeReference;
            if (inheritedType.types.isNotEmpty) {
              inheritedType = inheritedType.types.single.type as TypeReference;
            }
            var enumClass = customTypes.firstWhereOrNull(
              (el) =>
                  el.ref.name == fieldType.symbol ||
                  (fieldType.types.isNotEmpty &&
                      el.ref.name == fieldType.types.first.symbol),
            );

            // Ensure we do not update twice
            if (enumClass != null &&
                enumClass.ref.implements.every((ref) => ref != inheritedType)) {
              customTypes.remove(enumClass);

              final updatedEnumClass = enumClass.ref.rebuild(
                (b) => b.implements.add(inheritedType),
              );

              customTypes.add(_Class(updatedEnumClass));
            }
          }
        }

        customTypes.remove($class);
        final updatedClass = _class.rebuild((b) {
          b
            ..implements.add(classType)
            ..methods.addAll(missingFields.map((m) {
              final isNullable = (m.type!.type as TypeReference).isNullable!;
              return Method(
                (f) => f
                  ..name = m.name
                  ..lambda = true
                  ..body = isNullable ? Code('null') : m.assignment
                  ..annotations.add(CodeExpression(Code('override')))
                  ..returns = m.type
                  ..type = MethodType.getter,
              );
            }));

          // Rebuild toJson method.
          _buildToJson(b);
        });
        customTypes.add(_Class(updatedClass));
      });
    }

    return classType;
  }

  TypeReference _addCustomTypeIfNeeded(
    Class $class, {
    required String parentName,
  }) {
    final hashableClass = _Class($class);
    final className = $class.name;
    final existingTypeWithName = typeMap.containsKey(className);
    final existingTypeWithFields = customTypes.contains(hashableClass);

    final globalClass = _globalMap.entries.firstWhereOrNull(
      (el) => el.key == hashableClass,
    );
    if (globalClass != null) {
      final globalClassUri = globalClass.value;
      final globalClassName = globalClass.key.ref.name;
      packageImports.update(
        globalClassUri,
        (value) => value..add(globalClassName),
        ifAbsent: () => {globalClassName},
      );
      final globalTypeRef = refer(
        globalClassName,
        globalClassUri.toString(),
      ).type as TypeReference;
      typeMap[className] = globalTypeRef;
      customTypes.remove(hashableClass);
      customTypes.removeWhere((el) => el.ref.name == globalClassName);
      return globalTypeRef;
    }

    if (existingTypeWithName && existingTypeWithFields) {
      return typeMap[className]!;
    } else if (existingTypeWithName) {
      // final existingClass = customTypes
      //     .firstWhere(
      //       (el) => el.ref.name == className,
      //     )
      //     .ref;
      // final mergedClassFields = <Field>{
      //   ...$class.fields.where(
      //     (f) => existingClass.fields.any((e) => e.name == f.name),
      //   ),
      //   ...$class.fields.where(
      //     (f) => existingClass.fields.every((e) => e.name != f.name),
      //   ),
      //   ...existingClass.fields.where(
      //     (f) => $class.fields.every((e) => e.name != f.name),
      //   ),
      // };

      // // Add back values with all new values
      // if (isEnum) {
      //   mergedClassFields.removeWhere((f) => f.name == 'values');
      //   mergedClassFields.add(Field(
      //     (f) => f
      //       ..static = true
      //       ..modifier = FieldModifier.constant
      //       ..name = 'values'
      //       ..type = TypeReference(
      //         (t) => t
      //           ..isNullable = false
      //           ..symbol = 'List'
      //           ..types.add(refer(className)),
      //       )
      //       ..assignment = Code('''[
      //     ${mergedClassFields.where((f) => f.name != '_value').map((f) => f.name).join(',')}
      //     ]'''),
      //   ));
      // }

      // final mergedClass = $class.rebuild(
      //   (b) => b.fields.replace(mergedClassFields),
      // );

      final rename = _cleanPropertyName('${parentName}_$className').pascalCase;
      $class = $class.rebuild((b) => b.name = rename);
      customTypes.add(_Class($class));
      return typeMap[className]!;
    } else if (existingTypeWithFields) {
      final existingClassName =
          customTypes.firstWhere((el) => el == hashableClass).ref.name;
      return refer(existingClassName).type as TypeReference;
    } else {
      customTypes.add(hashableClass);
      return typeMap[$class.name] = refer($class.name).type as TypeReference;
    }
  }

  String _fieldName(JsonSchema fieldSchema) {
    var propertyName = fieldSchema.propertyName;
    if (propertyName == null) {
      throw ArgumentError('No property name for schema: $fieldSchema');
    }
    return _propertyName(propertyName);
  }

  Map<String, _Property> _collect(
    List<JsonSchema> list, {
    required bool isAnyOf,
  }) {
    return list.fold(<String, _Property>{}, (allProperties, element) {
      void updatePropertyIfNeeded(String propertyName, _Property property) {
        allProperties.update(
          propertyName,
          (value) => value.merge(property),
          ifAbsent: () => property,
        );
      }

      void addProperty(JsonSchema property) {
        final propertyName = property.propertyName!;
        var thisProperty = _Property(
          name: propertyName,
          isOptional: isAnyOf || !property.requiredOnParent,
          property: property,
        );
        updatePropertyIfNeeded(propertyName, thisProperty);
      }

      void collectAndUpdate(List<JsonSchema> sublist) {
        final subproperties = _collect(
          sublist,
          isAnyOf: false,
        );
        for (var property in subproperties.values) {
          updatePropertyIfNeeded(property.name, property);
        }
      }

      if (element.allOf.isNotEmpty) {
        collectAndUpdate(element.allOf);
      } else if (element.properties.isNotEmpty) {
        for (var property in element.properties.values) {
          if (property.propertyName?.startsWith(RegExp('Partial|Pick')) ??
              false) {
            collectAndUpdate([property]);
          } else {
            addProperty(property);
          }
        }
      } else {
        addProperty(element);
      }
      return allProperties;
    });
  }

  TypeReference _buildTuple(Iterable<Reference> types) {
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

  String _findPropertyName(JsonSchema property) {
    if (property.path == '#') {
      return libraryName;
    }
    var _property = property;
    var propertyName = property.propertyName;
    while (propertyName == null && property.parent != null) {
      property = property.parent!;
      if (property.path == '#') {
        propertyName = libraryName;
        break;
      }
      propertyName = property.propertyName;
      if (property == _property) {
        break;
      }
    }
    if (propertyName == null) {
      throw StateError('Could not find property name for: $property');
    }
    return propertyName;
  }

  dynamic _quote(dynamic val) => val is String ? "'$val'" : val;

  TypeReference _buildEnum(
    String? propertyName,
    String? parentName,
    TypeReference enumType,
    JsonSchema items,
  ) {
    propertyName ??= _findPropertyName(items);
    parentName ??= _parentClassName(items.parent!);

    var enumName = _className('${parentName}_$propertyName');

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
        b.fields.add(Field((f) {
          var fieldName = '\$${_propertyName(item.toString())}';
          fieldNames.add(fieldName);
          f
            ..static = true
            ..modifier = FieldModifier.constant
            ..name = fieldName
            ..assignment = Code('$enumName._(${_quote(item)})')
            ..docs.add(_formatDocs('`$item`'));
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

      // Add toJson method
      _buildToJson(b);
    });

    return _addCustomTypeIfNeeded(
      enumClass,
      parentName: parentName,
    );
  }

  String _formatDocs(String value) {
    final lines = value.split('\n');
    return lines.map((s) => '/// $s').join('\n');
  }
}

class _Property {
  final String name;
  final JsonSchema property;
  final bool isOptional;

  const _Property({
    required this.name,
    required this.property,
    required this.isOptional,
  });

  _Property copyWith({
    bool? isOptional,
  }) {
    return _Property(
      name: name,
      property: property,
      isOptional: isOptional ?? this.isOptional,
    );
  }

  _Property merge(_Property other) {
    if (this == other) {
      return this;
    }
    final schemaMap = {...property.schemaMap}.cast<String, dynamic>();

    final isEnum = property.enumValues?.isNotEmpty ?? false;
    final isArray = property.itemsList?.isNotEmpty ?? false;

    if (isEnum) {
      final allValues = {
        ...?property.enumValues,
        ...?other.property.enumValues,
      };
      schemaMap['enum'] = allValues.toList();
      switch (property.type) {
        case SchemaType.boolean:
          if ([true, false].every((el) => allValues.contains(el))) {
            schemaMap.remove('enum');
          }
      }
    }
    //  else if (isArray) {
    //   final allItems = [
    //     ...?property.itemsList,
    //     ...?other.property.itemsList,
    //   ];
    //   schemaMap['items']
    // }

    final newSchema = JsonSchema.createSchema(
      schemaMap,
      schemaVersion: property.schemaVersion,
      refProvider: property.resolvePath,
    );
    return _Property(
      name: name,
      property: newSchema,
      isOptional: isOptional &&
          (!property.requiredOnParent || !other.property.requiredOnParent),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Property &&
          name == other.name &&
          property == other.property &&
          isOptional == other.isOptional;

  @override
  int get hashCode => name.hashCode ^ property.hashCode ^ isOptional.hashCode;
}
