import 'package:collection/collection.dart';

bool deepEquals(Object? a, Object? b) =>
    const DeepCollectionEquality().equals(a, b);

int hash(Object? o) => const DeepCollectionEquality().hash(o);

bool mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) =>
    MapEquality<K, V>().equals(a, b);

int hashMap<K, V>(Map<K, V>? m) => MapEquality<K, V>().hash(m);

bool listEquals<E>(List<E>? a, List<E>? b) => ListEquality<E>().equals(a, b);

int hasList<E>(List<E>? l) => ListEquality<E>().hash(l);
