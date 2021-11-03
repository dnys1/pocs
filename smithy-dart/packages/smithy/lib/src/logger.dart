import 'dart:math' show Random;

abstract class Logger {}

final _random = Random();

/// Censors [o] during logging.
String sensitive(Object? o) {
  return '*' * ((o?.toString() ?? 'null').length + _random.nextInt(4));
}
