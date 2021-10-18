abstract class SmithyEnum<T extends SmithyEnum<T>> {
  const SmithyEnum(this.index, this.value);
  const SmithyEnum.unknown(this.value) : index = -1;

  final int index;
  final String value;

  bool get isUnknown => index == -1;

  @override
  String toString() => value;
}
