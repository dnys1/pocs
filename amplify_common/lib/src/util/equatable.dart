import 'package:collection/collection.dart';

mixin AmplifyEquatable on Object {
  List<Object?> get props;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmplifyEquatable &&
          const DeepCollectionEquality.unordered().equals(props, other.props);

  @override
  int get hashCode => const DeepCollectionEquality.unordered().hash(props);
}
