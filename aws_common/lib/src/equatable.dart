import 'package:collection/collection.dart';

mixin AWSEquatable on Object {
  List<Object?> get props;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AWSEquatable &&
          const DeepCollectionEquality.unordered().equals(props, other.props);

  @override
  int get hashCode => const DeepCollectionEquality.unordered().hash(props);
}
