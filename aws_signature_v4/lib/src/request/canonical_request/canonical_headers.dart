part of 'canonical_request.dart';

class CanonicalHeaders extends DelegatingMap<String, String> {
  CanonicalHeaders(Map<String, String> headers) : super(canonicalize(headers));

  /// Lowercases and sorts the headers.
  static Map<String, String> canonicalize(Map<String, String> headers) {
    final lowerCaseHeaders = headers.map(
      (k, v) => MapEntry(
        k.toLowerCase(),
        v.trim().replaceAll(RegExp(r'\s+'), ' '),
      ),
    );
    return LinkedHashMap.fromEntries(
      lowerCaseHeaders.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  /// Returns the lowercased and sorted headers string.
  @override
  String toString() {
    return entries.map((e) => '${e.key}:${e.value}\n').join();
  }
}
