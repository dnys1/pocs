import 'package:smithy/smithy.dart';

class MyEnum extends SmithyEnum<MyEnum> {
  const MyEnum._(int index, String value) : super(index, value);
  const MyEnum._unknown(String value) : super.unknown(value);

  static const a = MyEnum._(0, 'a');

  static const values = [
    a,
  ];

  factory MyEnum.fromValue(String value) {
    return values.firstWhere(
      (element) => element.value == value,
      orElse: () => MyEnum._unknown(value),
    );
  }
}
