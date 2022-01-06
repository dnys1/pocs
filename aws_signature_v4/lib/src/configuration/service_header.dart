import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/src/configuration/validator.dart';

abstract class ServiceHeader<T extends ServiceHeader<T>> with AWSEquatable<T> {
  /// The header map key.
  final String key;

  /// The validator for values of the header.
  final Validator<String> validator;

  const ServiceHeader(this.key, this.validator);

  @override
  List<Object?> get props => [T, key, validator];

  @override
  String toString() => key;
}
