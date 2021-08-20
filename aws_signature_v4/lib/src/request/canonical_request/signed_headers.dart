part of 'canonical_request.dart';

class SignedHeaders extends DelegatingIterable<String> {
  SignedHeaders(Map<String, String> headers) : super(headers.keys);

  @override
  String toString() {
    return map((header) => header.toLowerCase()).join(';');
  }
}
