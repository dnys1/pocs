import 'package:smithy/smithy.dart';

abstract class MyUnion implements Union<MyUnion> {
  const MyUnion._();

  Int32? get i32 => null;
  String? get stringA => null;
  String? get stringB => null;

  @override
  T? when<T>({
    T Function(Int32)? i32,
    T Function(String)? stringA,
    T Function(String)? stringB,
  }) {
    if (this is _MyUnionI32) {
      return i32?.call(this.i32!);
    } else if (this is _MyUnionStringA) {
      return stringA?.call(this.stringA!);
    } else if (this is _MyUnionStringB) {
      return stringB?.call(this.stringB!);
    } else {
      throw UnimplementedError();
    }
  }

  const factory MyUnion.i32(Int32 i32) = _MyUnionI32;
  const factory MyUnion.stringA(String stringA) = _MyUnionStringA;
  const factory MyUnion.stringB(String stringB) = _MyUnionStringB;
}

class _MyUnionI32 extends MyUnion implements UnionValue<MyUnion> {
  const _MyUnionI32(this._i32) : super._();

  final Int32 _i32;

  @override
  Int32 get i32 => _i32;

  @override
  String get key => 'i32';
}

class _MyUnionStringA extends MyUnion implements UnionValue<MyUnion> {
  const _MyUnionStringA(this._stringA) : super._();

  final String _stringA;

  @override
  String get stringA => _stringA;

  @override
  String get key => 'stringA';
}

class _MyUnionStringB extends MyUnion implements UnionValue<MyUnion> {
  const _MyUnionStringB(this._stringB) : super._();

  final String _stringB;

  @override
  String get stringB => _stringB;

  @override
  String get key => 'stringB';
}
