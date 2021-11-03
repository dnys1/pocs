import 'package:smithy/smithy.dart';

class MyEnum extends SmithyEnum<MyEnum> {
  const MyEnum._(int index, String name) : super(index, name);
  const MyEnum._unknown(String name) : super.unknown(name);

  static const a = MyEnum._(0, 'a');

  static const values = [
    a,
  ];

  factory MyEnum.fromString(String name) {
    return values.firstWhere(
      (element) => element.name == name,
      orElse: () => MyEnum._unknown(name),
    );
  }
}
