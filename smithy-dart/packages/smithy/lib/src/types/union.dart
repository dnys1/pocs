typedef UnionValueBuilder<T extends Union<T>, U extends UnionValue<T>> = U
    Function(dynamic);

abstract class Union<U extends Union<U>> {
  const Union();

  T? when<T>();
}

abstract class UnionValue<T extends Union<T>> {
  String get key;
}
