import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'button_types.g.dart';

class AmplifyButtonType extends EnumClass {
  @BuiltValueEnumConst(fallback: true)
  static const AmplifyButtonType button = _$button;
  static const AmplifyButtonType submit = _$submit;

  const AmplifyButtonType._(String name) : super(name);

  static BuiltSet<AmplifyButtonType> get values => _$AmplifyButtonTypeValues;
  static AmplifyButtonType valueOf(String name) =>
      _$AmplifyButtonTypeValueOf(name);
}

class AmplifyButtonSize extends EnumClass {
  @BuiltValueEnumConst(fallback: true)
  static const AmplifyButtonSize medium = _$medium;
  static const AmplifyButtonSize small = _$small;
  static const AmplifyButtonSize large = _$large;

  const AmplifyButtonSize._(String name) : super(name);

  static BuiltSet<AmplifyButtonSize> get values => _$AmplifyButtonSizeValues;
  static AmplifyButtonSize valueOf(String name) =>
      _$AmplifyButtonSizeValueOf(name);
}

class AmplifyButtonVariation extends EnumClass {
  @BuiltValueEnumConst(wireName: 'default', fallback: true)
  static const AmplifyButtonVariation default$ = _$default;
  static const AmplifyButtonVariation primary = _$primary;
  static const AmplifyButtonVariation link = _$link;

  const AmplifyButtonVariation._(String name) : super(name);

  static BuiltSet<AmplifyButtonVariation> get values =>
      _$AmplifyButtonVariationValues;
  static AmplifyButtonVariation valueOf(String name) =>
      _$AmplifyButtonVariationValueOf(name);
}

class AmplifyButtonFontWeight extends EnumClass {
  @BuiltValueEnumConst(fallback: true)
  static const AmplifyButtonFontWeight normal = _$normal;
  static const AmplifyButtonFontWeight bold = _$bold;
  static const AmplifyButtonFontWeight lighter = _$lighter;

  const AmplifyButtonFontWeight._(String name) : super(name);

  static BuiltSet<AmplifyButtonFontWeight> get values =>
      _$AmplifyButtonFontWeightValues;
  static AmplifyButtonFontWeight valueOf(String name) =>
      _$AmplifyButtonFontWeightValueOf(name);
}
