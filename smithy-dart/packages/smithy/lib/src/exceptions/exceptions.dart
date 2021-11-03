class SmithyException implements Exception {
  const SmithyException([String? message])
      : message = message ?? 'An unknown error occurred.';

  final String message;
}

class SmithyClientException extends SmithyException {
  const SmithyClientException([String? message]) : super(message);
}

class SmithyServerException extends SmithyException {
  const SmithyServerException([String? message]) : super(message);
}
