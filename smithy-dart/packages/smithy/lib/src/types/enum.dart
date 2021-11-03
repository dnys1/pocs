abstract class SmithyEnum<T extends SmithyEnum<T>> {
  const SmithyEnum(this.index, this.name);
  const SmithyEnum.unknown(this.name) : index = -1;

  final int index;
  final String name;

  bool get isUnknown => index == -1;

  @override
  String toString() => name;
}
